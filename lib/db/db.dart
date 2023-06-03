import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/domain/stalk_target.dart';

class Db {
  static final Future<Isar> db = _open();

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [StalkTargetSchema],
      directory: dir.path,
    );
  }
}
