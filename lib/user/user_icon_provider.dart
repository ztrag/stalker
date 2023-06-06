import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

class UserIconProvider extends ChangeNotifier {
  static final UserIconProvider _instance = UserIconProvider._();
  final Map<Id, Uint8List?> _cache = {};

  UserIconProvider._();

  factory UserIconProvider() => _instance;

  void store(User user, Uint8List data) {
    _cache[user.id] = data;
    notifyListeners();
  }

  Future<Uint8List?> fetch(User user) async {
    if (_cache[user.id] != null) {
      return _cache[user.id];
    }

    if (user.hasLocalIcon!) {
      return _cache[user.id] ??= await _fetchFromDisk(user);
    }

    if (user.didAttemptDownload!) {
      return null;
    }

    final networkImage = await _fetchFromNetwork(user);
    final db = await Db.db;
    db.writeTxn(() async {
      final saved = await db.users.get(user.id);
      saved!.hasLocalIcon = networkImage != null;
      saved.didAttemptDownload = true;
      db.users.put(saved);
    });

    return _cache[user.id] ??= networkImage;
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
    try {
      final data = await FirebaseStorage.instance
          .ref('${user.token.hashCode}')
          .getData();
      return data;
    } catch (_) {}
    return null;
  }
}
