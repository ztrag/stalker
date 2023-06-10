import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

enum UserIconSize {
  small('s', 64),
  medium('m', 128),
  large('l', 256),
  original('o', 512);

  const UserIconSize(this.suffix, this.size);

  final String suffix;
  final int size;
}

class UserIconProps {
  final User user;
  final UserIconSize size;
  final num grayScale;
  final double opacity;

  UserIconProps({
    required this.user,
    this.size = UserIconSize.original,
    this.grayScale = 0,
    this.opacity = 1.0,
  });

  UserIconProps copyWith(
      {User? user, UserIconSize? size, num? grayScale, double? opacity}) {
    return UserIconProps(
      user: user ?? this.user,
      size: size ?? this.size,
      grayScale: grayScale ?? this.grayScale,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  int get hashCode =>
      user.id * UserIconSize.values.length +
      UserIconSize.values.indexOf(size) +
      user.token.hashCode *
          (grayScale + 1000).toInt() *
          (opacity + 1000).toInt();

  @override
  bool operator ==(Object other) {
    return other is UserIconProps &&
        other.user.id == user.id &&
        other.size == size &&
        other.grayScale == grayScale &&
        other.opacity == opacity;
  }
}

class UserIconProvider extends ChangeNotifier {
  static final UserIconProvider _instance = UserIconProvider._();
  final Map<UserIconProps, Uint8List?> _cache = {};
  final Map<UserIconProps, Future?> _processingQueue = {};

  UserIconProvider._();

  factory UserIconProvider() => _instance;

  void cache(User user, Uint8List data) {
    _cache.removeWhere((key, value) => key.user.id == user.id);
    _cache[UserIconProps(user: user)] = data;
    notifyListeners();
  }

  Future<Uint8List?> fetch(UserIconProps props) async {
    if (_cache[props] != null) {
      return _cache[props];
    }

    final task = _processingQueue[props] ??= _fetch(props);
    final result = await task;
    _processingQueue[props] = null;
    return result;
  }

  Future<Uint8List?> _fetch(UserIconProps props) async {
    if (_cache[props] != null) {
      return _cache[props];
    }

    if (props.grayScale > 0 || props.opacity < 1) {
      return _cache[props] ??= await _fetchGrayscale(props);
    }

    if (props.user.hasLocalIcon!) {
      return _cache[props] ??= await _fetchFromDisk(props);
    }

    if (props.user.didAttemptDownload!) {
      return null;
    }

    final networkImage = await _fetchFromNetwork(props.user);
    if (networkImage != null) {
      final file = File(await props.user.getIconPath(UserIconSize.original));
      await file.writeAsBytes(networkImage);
    }

    final db = await Db.db;
    final savedUser = await db.writeTxn(() async {
      final saved = await db.users.get(props.user.id);
      saved!.hasLocalIcon = networkImage != null;
      saved.didAttemptDownload = true;
      db.users.put(saved);
      return saved;
    });

    if (networkImage == null) {
      return null;
    }

    if (props.size == UserIconSize.original) {
      return _cache[props] ??= networkImage;
    }

    return _fetch(props.copyWith(user: savedUser));
  }

  Future<Uint8List?> _fetchGrayscale(UserIconProps props) async {
    final original = await fetch(props.copyWith(grayScale: 0, opacity: 1));
    if (original == null) {
      return null;
    }

    var processed = img.decodePng(original);
    if (props.grayScale > 0) {
      processed = img.grayscale(processed!, amount: props.grayScale);
    }
    if (props.opacity < 1) {
      processed =
          img.colorOffset(processed!, alpha: -255 * (1 - props.opacity));
    }
    return img.encodePng(processed!);
  }

  Future<Uint8List?> _fetchFromDisk(UserIconProps props) async {
    final dir = await getApplicationSupportDirectory();
    final filepath =
        '${dir.path}/${props.user.token.hashCode}-${props.size.suffix}';
    final file = File(filepath);
    if (await file.exists()) {
      return file.readAsBytes();
    }

    return _resizeFromOriginal(props);
  }

  Future<Uint8List?> _resizeFromOriginal(UserIconProps props) async {
    if (props.size == UserIconSize.original) {
      return null;
    }

    final original = await _fetchFromDisk(UserIconProps(user: props.user));
    if (original == null) {
      return null;
    }

    final baseSizeImage = img.decodeImage(original);
    final resized = img.copyResize(
      baseSizeImage!,
      width: props.size.size,
      height: props.size.size,
    );
    final result = img.encodePng(resized);

    final file = File(await props.user.getIconPath(props.size));
    file.writeAsBytes(result);
    return result;
  }

  Future<Uint8List?> _fetchFromNetwork(User user) async {
    try {
      final data = await FirebaseStorage.instance
          .ref('${user.token.hashCode}')
          .getData();
      return data;
    } catch (_) {}
    return null;
  }
}
