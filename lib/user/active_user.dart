import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

class ActiveUser extends ChangeNotifier {
  static ActiveUser instance = ActiveUser._();
  User? value;
  bool hasLoaded = false;

  factory ActiveUser() => instance;

  ActiveUser._() {
    _init();
  }

  void _init() async {
    final db = await Db.db;
    final query = db.users.where();

    value = await query.findFirst();
    hasLoaded = true;
    notifyListeners();

    query.watch().listen((event) {
      value = event.isEmpty ? null : event.first;
      notifyListeners();
    });
  }
}
