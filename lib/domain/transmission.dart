import 'package:isar/isar.dart';
import 'package:stalker/domain/has_id.dart';

part 'transmission.g.dart';

@collection
class Transmission with HasId {
  @override
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late int stalkerId;

  @Index(type: IndexType.value)
  late int targetId;

  @enumerated
  late TransmissionState state;

  late DateTime startTime;
}

enum TransmissionState { started, stopped, interrupted }
