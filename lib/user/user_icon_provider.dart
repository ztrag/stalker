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
  final bool grayScale;

  UserIconProps({
    required this.user,
    this.size = UserIconSize.original,
    this.grayScale = false,
  });

  UserIconProps copyWith({User? user, UserIconSize? size, bool? grayScale}) {
    return UserIconProps(
      user: user ?? this.user,
      size: size ?? this.size,
      grayScale: grayScale ?? this.grayScale,
    );
  }

  @override
  int get hashCode =>
      user.id * UserIconSize.values.length +
      UserIconSize.values.indexOf(size) +
      user.token.hashCode * (grayScale ? 7 : 11);

  @override
  bool operator ==(Object other) {
    return other is UserIconProps &&
        other.user.id == user.id &&
        other.size == size &&
        other.grayScale == grayScale;
  }
}

class UserIconProvider extends ChangeNotifier {
  static final UserIconProvider _instance = UserIconProvider._();
  final Map<UserIconProps, Uint8List?> _cache = {};
  final Map<String, Future?> _processingQueue = {};

  UserIconProvider._();

  factory UserIconProvider() => _instance;

  void cache(User user, Uint8List data) {
    _cache.removeWhere((key, value) => key.user.id == user.id);
    _cache[UserIconProps(user: user)] = data;
    notifyListeners();
  }

  Future<Uint8List?> fetch(UserIconProps props) async {
    final path = '${await props.user.getIconPath(props.size)}'
        '${props.grayScale ? '-g' : ''}';
    final task = _processingQueue[path] ??= _fetch(props);
    final result = await task;
    _processingQueue[path] = null;
    return result;
  }

  Future<Uint8List?> _fetch(UserIconProps props) async {
    if (_cache[props] != null) {
      return _cache[props];
    }

    if (props.grayScale) {
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
    final original = await fetch(props.copyWith(grayScale: false));
    if (original == null) {
      return null;
    }

    final decodePng = img.decodePng(original);
    final grayscale = img.grayscale(decodePng!);
    final encodePng = img.encodePng(grayscale);
    return encodePng;
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
