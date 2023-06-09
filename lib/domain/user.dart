import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stalker/alien/alien_encription.dart';
import 'package:stalker/domain/has_id.dart';
import 'package:stalker/user/user_icon_provider.dart';

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

  Future<String> getIconPath(UserIconSize size) async {
    final dir = await getApplicationSupportDirectory();
    return '${dir.path}/${token.hashCode}-${size.suffix}';
  }

  @ignore
  String get displayName => name?.isNotEmpty ?? false ? name! : token!.encrypt;

  @ignore
  bool get hasLocation =>
      lastLocationLongitude != null && lastLocationLatitude != null;
}
