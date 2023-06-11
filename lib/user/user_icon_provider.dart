import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

enum UserIconSize {
  small('s', 64),
  medium('m', 128),
  map('ma', 192),
  large('l', 256),
  original('o', 512);

  const UserIconSize(this.suffix, this.size);

  final String suffix;
  final int size;
}

class UserIconProps {
  final User user;
  final UserIconSize size;
  final double grayScale;
  final double opacity;

  UserIconProps({
    required this.user,
    this.size = UserIconSize.original,
    this.grayScale = 0,
    this.opacity = 1.0,
  });

  UserIconProps copyWith(
      {User? user, UserIconSize? size, double? grayScale, double? opacity}) {
    return UserIconProps(
      user: user ?? this.user,
      size: size ?? this.size,
      grayScale: grayScale ?? this.grayScale,
      opacity: opacity ?? this.opacity,
    );
  }

  UserIconProps get forCache => UserIconProps(user: user, size: size);

  @override
  int get hashCode =>
      user.id *
      UserIconSize.values.length *
      UserIconSize.values.indexOf(size) *
      user.token.hashCode *
      (grayScale + 1000).toInt() *
      (opacity + 4000).toInt();

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
  final Map<UserIconProps, Image?> _cache = {};
  final Map<UserIconProps, Future<Image?>?> _processingQueue = {};

  UserIconProvider._();

  factory UserIconProvider() => _instance;

  void cache(User user, Image? data) async {
    for (final entry in _cache.entries) {
      if (entry.key.user.id == user.id) {
        await entry.value?.image.evict();
      }
    }
    _cache.removeWhere((key, value) => key.user.id == user.id);
    _cache[UserIconProps(user: user).forCache] = data;
    notifyListeners();
  }

  Future<Image> fetch(UserIconProps requestProps) async {
    final props = requestProps.forCache;
    if (_cache[props] != null) {
      return _cache[props]!;
    }

    final task = _processingQueue[props] ??= _fetch(props);
    final result = await task;
    _processingQueue[props] = null;
    return result ??
        Image.asset(
          'assets/images/skull.png',
          width: 1.0 * props.size.size,
          height: 1.0 * props.size.size,
          cacheWidth: props.size.size,
          cacheHeight: props.size.size,
        );
  }

  Future<Image?> _fetch(UserIconProps props) async {
    if (_cache[props] != null) {
      return _cache[props];
    }

    final fromMemory = _fetchFromOriginalInMemory(props);
    if (fromMemory != null) {
      return _cache[props] ??= fromMemory;
    }

    final propsForOriginalImage = props.copyWith(size: UserIconSize.original);
    if (_cache[propsForOriginalImage]?.image is MemoryImage) {
      return _cache[props] ??= Image.memory(
        (_cache[propsForOriginalImage]?.image as MemoryImage).bytes,
        width: 1.0 * props.size.size,
        height: 1.0 * props.size.size,
      );
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
    await db.writeTxn(() async {
      final saved = await db.users.get(props.user.id);
      saved!.hasLocalIcon = networkImage != null;
      saved.didAttemptDownload = true;
      db.users.put(saved);
      return saved;
    });

    if (networkImage == null) {
      return null;
    }

    return _cache[props] ??= Image.memory(
      networkImage,
      width: 1.0 * props.size.size,
      height: 1.0 * props.size.size,
    );
  }

  Image? _fetchFromOriginalInMemory(UserIconProps props) {
    final propsForOriginalImage = props.copyWith(size: UserIconSize.original);
    if (_cache[propsForOriginalImage]?.image is MemoryImage) {
      return Image.memory(
        (_cache[propsForOriginalImage]?.image as MemoryImage).bytes,
        width: 1.0 * props.size.size,
        height: 1.0 * props.size.size,
      );
    }
    return null;
  }

  Future<Image?> _fetchFromDisk(UserIconProps props) async {
    final dir = await getApplicationSupportDirectory();

    // Todo read resized images in disk
    // final resizedPath =
    //     '${dir.path}/${props.user.token.hashCode}-${props.size.suffix}';
    // final resizedFile = File(resizedPath);
    // if (await resizedFile.exists()) {
    //   return Image.file(resizedFile);
    // }

    // TODO save the resized images to disk
    // ...
    final originalPath = '${dir.path}/${props.user.token.hashCode}'
        '-${UserIconSize.original.suffix}';
    return Image.file(
      File(originalPath),
      width: 1.0 * props.size.size,
      height: 1.0 * props.size.size,
      cacheWidth: props.size.size,
      cacheHeight: props.size.size,
    );
  }

  // Future<Image?> _resizeFromOriginal(UserIconProps props) async {
  //   if (props.size == UserIconSize.original) {
  //     return null;
  //   }
  //
  //   final original = await _fetchFromDisk(UserIconProps(user: props.user));
  //   if (original == null) {
  //     return null;
  //   }
  //
  //   final baseSizeImage = img.decodeImage(original);
  //   final resized = img.copyResize(
  //     baseSizeImage!,
  //     width: props.size.size,
  //     height: props.size.size,
  //   );
  //   final result = img.encodePng(resized);
  //
  //   final file = File(await props.user.getIconPath(props.size));
  //   file.writeAsBytes(result);
  //   return result;
  // }

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
