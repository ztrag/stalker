import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

class ActiveUser extends ValueNotifier<User?> {
  static ActiveUser instance = ActiveUser._();

  final Completer _completer = Completer();

  bool hasLoaded = false;

  factory ActiveUser() => instance;

  ActiveUser._() : super(null) {
    _init();
  }

  void _init() async {
    final db = await Db.db;
    final query = db.users.where();

    final v = await query.findFirst();
    hasLoaded = true;
    _completer.complete();

    if (v == null) {
      notifyListeners();
    }
    value = v;

    query.watch().listen((event) {
      value = event.isEmpty ? null : event.first;
    });
  }

  Future<void> load() => _completer.future;
}
