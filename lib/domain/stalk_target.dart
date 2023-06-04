import 'package:isar/isar.dart';

part 'stalk_target.g.dart';

@collection
class StalkTarget {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? name;

  @Index(type: IndexType.value)
  String? token;

  @Index(type: IndexType.value)
  String? profilePictureUrl;

  double? lastLocationLatitude;

  double? lastLocationLongitude;

  DateTime? lastLocationTimestamp;

  double? lastLocationAccuracy;
}
