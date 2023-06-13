// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transmission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransmissionCollection on Isar {
  IsarCollection<Transmission> get transmissions => this.collection();
}

const TransmissionSchema = CollectionSchema(
  name: r'Transmission',
  id: -8334212708930721435,
  properties: {
    r'stalkerId': PropertySchema(
      id: 0,
      name: r'stalkerId',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 1,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'state': PropertySchema(
      id: 2,
      name: r'state',
      type: IsarType.byte,
      enumMap: _TransmissionstateEnumValueMap,
    ),
    r'targetId': PropertySchema(
      id: 3,
      name: r'targetId',
      type: IsarType.long,
    )
  },
  estimateSize: _transmissionEstimateSize,
  serialize: _transmissionSerialize,
  deserialize: _transmissionDeserialize,
  deserializeProp: _transmissionDeserializeProp,
  idName: r'id',
  indexes: {
    r'stalkerId': IndexSchema(
      id: -4816815527070786923,
      name: r'stalkerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stalkerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'targetId': IndexSchema(
      id: -7400732725972739031,
      name: r'targetId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'targetId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _transmissionGetId,
  getLinks: _transmissionGetLinks,
  attach: _transmissionAttach,
  version: '3.1.0+1',
);

int _transmissionEstimateSize(
  Transmission object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _transmissionSerialize(
  Transmission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.stalkerId);
  writer.writeDateTime(offsets[1], object.startTime);
  writer.writeByte(offsets[2], object.state.index);
  writer.writeLong(offsets[3], object.targetId);
}

Transmission _transmissionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Transmission();
  object.id = id;
  object.stalkerId = reader.readLong(offsets[0]);
  object.startTime = reader.readDateTime(offsets[1]);
  object.state =
      _TransmissionstateValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          TransmissionState.started;
  object.targetId = reader.readLong(offsets[3]);
  return object;
}

P _transmissionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_TransmissionstateValueEnumMap[reader.readByteOrNull(offset)] ??
          TransmissionState.started) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransmissionstateEnumValueMap = {
  'started': 0,
  'stopped': 1,
  'interrupted': 2,
};
const _TransmissionstateValueEnumMap = {
  0: TransmissionState.started,
  1: TransmissionState.stopped,
  2: TransmissionState.interrupted,
};

Id _transmissionGetId(Transmission object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transmissionGetLinks(Transmission object) {
  return [];
}

void _transmissionAttach(
    IsarCollection<dynamic> col, Id id, Transmission object) {
  object.id = id;
}

extension TransmissionQueryWhereSort
    on QueryBuilder<Transmission, Transmission, QWhere> {
  QueryBuilder<Transmission, Transmission, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhere> anyStalkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'stalkerId'),
      );
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhere> anyTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'targetId'),
      );
    });
  }
}

extension TransmissionQueryWhere
    on QueryBuilder<Transmission, Transmission, QWhereClause> {
  QueryBuilder<Transmission, Transmission, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> stalkerIdEqualTo(
      int stalkerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'stalkerId',
        value: [stalkerId],
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause>
      stalkerIdNotEqualTo(int stalkerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stalkerId',
              lower: [],
              upper: [stalkerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stalkerId',
              lower: [stalkerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stalkerId',
              lower: [stalkerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stalkerId',
              lower: [],
              upper: [stalkerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause>
      stalkerIdGreaterThan(
    int stalkerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stalkerId',
        lower: [stalkerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> stalkerIdLessThan(
    int stalkerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stalkerId',
        lower: [],
        upper: [stalkerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> stalkerIdBetween(
    int lowerStalkerId,
    int upperStalkerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stalkerId',
        lower: [lowerStalkerId],
        includeLower: includeLower,
        upper: [upperStalkerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> targetIdEqualTo(
      int targetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'targetId',
        value: [targetId],
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause>
      targetIdNotEqualTo(int targetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [],
              upper: [targetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [targetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [targetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [],
              upper: [targetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause>
      targetIdGreaterThan(
    int targetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [targetId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> targetIdLessThan(
    int targetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [],
        upper: [targetId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterWhereClause> targetIdBetween(
    int lowerTargetId,
    int upperTargetId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [lowerTargetId],
        includeLower: includeLower,
        upper: [upperTargetId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransmissionQueryFilter
    on QueryBuilder<Transmission, Transmission, QFilterCondition> {
  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      stalkerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stalkerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      stalkerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stalkerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      stalkerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stalkerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      stalkerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stalkerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> stateEqualTo(
      TransmissionState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      stateGreaterThan(
    TransmissionState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> stateLessThan(
    TransmissionState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition> stateBetween(
    TransmissionState lower,
    TransmissionState upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      targetIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      targetIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      targetIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterFilterCondition>
      targetIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransmissionQueryObject
    on QueryBuilder<Transmission, Transmission, QFilterCondition> {}

extension TransmissionQueryLinks
    on QueryBuilder<Transmission, Transmission, QFilterCondition> {}

extension TransmissionQuerySortBy
    on QueryBuilder<Transmission, Transmission, QSortBy> {
  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByStalkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stalkerId', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByStalkerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stalkerId', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> sortByTargetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.desc);
    });
  }
}

extension TransmissionQuerySortThenBy
    on QueryBuilder<Transmission, Transmission, QSortThenBy> {
  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByStalkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stalkerId', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByStalkerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stalkerId', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.asc);
    });
  }

  QueryBuilder<Transmission, Transmission, QAfterSortBy> thenByTargetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.desc);
    });
  }
}

extension TransmissionQueryWhereDistinct
    on QueryBuilder<Transmission, Transmission, QDistinct> {
  QueryBuilder<Transmission, Transmission, QDistinct> distinctByStalkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stalkerId');
    });
  }

  QueryBuilder<Transmission, Transmission, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<Transmission, Transmission, QDistinct> distinctByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state');
    });
  }

  QueryBuilder<Transmission, Transmission, QDistinct> distinctByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetId');
    });
  }
}

extension TransmissionQueryProperty
    on QueryBuilder<Transmission, Transmission, QQueryProperty> {
  QueryBuilder<Transmission, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Transmission, int, QQueryOperations> stalkerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stalkerId');
    });
  }

  QueryBuilder<Transmission, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<Transmission, TransmissionState, QQueryOperations>
      stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<Transmission, int, QQueryOperations> targetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetId');
    });
  }
}
