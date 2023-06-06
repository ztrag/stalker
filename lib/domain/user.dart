import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/domain/has_id.dart';

part 'user.g.dart';

@collection
class User with HasId {
  @override
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? name;

  @Index(type: IndexType.value)
  String? token;

  bool? didAttemptDownload;

  bool? hasLocalIcon;

  double? lastLocationLatitude;

  double? lastLocationLongitude;

  DateTime? lastLocationTimestamp;

  double? lastLocationAccuracy;

  bool isEnabled = true;

  @ignore
  Future<String?> get iconPath async {
    if (token == null) {
      return null;
    }
    final dir = await getApplicationSupportDirectory();
    return '${dir.path}/${token.hashCode}';
  }

  @ignore
  String get displayName => (name?.isEmpty ?? true ? token : name) ?? '';

  @ignore
  bool get hasLocation =>
      lastLocationLongitude != null && lastLocationLatitude != null;
}
