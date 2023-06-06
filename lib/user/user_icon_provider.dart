import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

class UserIconProvider {
  static UserIconProvider instance = UserIconProvider._();
  final Map<Id, Uint8List?> cache = {};

  UserIconProvider._();

  factory UserIconProvider() => instance;

  Future<Uint8List?> fetch(User user) async {
    if (cache[user.id] != null) {
      return cache[user.id];
    }

    if (user.hasLocalIcon!) {
      return cache[user.id] ??= await _fetchFromDisk(user);
    }

    if (user.didAttemptDownload!) {
      return null;
    }

    final networkImage = await _fetchFromNetwork(user);
    final db = await Db.db;
    db.writeTxn(() async {
      final dbUser =
          await db.users.where().idEqualTo(user.id).limit(1).findFirst();
      dbUser!.hasLocalIcon = networkImage != null;
      dbUser.didAttemptDownload = true;
      db.users.put(dbUser);
    });

    return cache[user.id] ??= networkImage;
  }

  Future<Uint8List?> _fetchFromDisk(User user) async {
    final dir = await getApplicationSupportDirectory();
    final filepath = '${dir.path}/${user.token.hashCode}';
    final file = File(filepath);
    if (await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }

  Future<Uint8List?> _fetchFromNetwork(User user) async {
    // TODO firebase
    return null;
  }
}
