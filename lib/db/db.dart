import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/domain/user.dart';

class Db {
  static final Future<Isar> db = _open();

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [UserSchema],
      directory: dir.path,
    );
  }
}
