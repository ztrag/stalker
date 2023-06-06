// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserCollection on Isar {
  IsarCollection<User> get users => this.collection();
}

const UserSchema = CollectionSchema(
  name: r'User',
  id: -7838171048429979076,
  properties: {
    r'didAttemptDownload': PropertySchema(
      id: 0,
      name: r'didAttemptDownload',
      type: IsarType.bool,
    ),
    r'hasLocalIcon': PropertySchema(
      id: 1,
      name: r'hasLocalIcon',
      type: IsarType.bool,
    ),
    r'lastLocationAccuracy': PropertySchema(
      id: 2,
      name: r'lastLocationAccuracy',
      type: IsarType.double,
    ),
    r'lastLocationLatitude': PropertySchema(
      id: 3,
      name: r'lastLocationLatitude',
      type: IsarType.double,
    ),
    r'lastLocationLongitude': PropertySchema(
      id: 4,
      name: r'lastLocationLongitude',
      type: IsarType.double,
    ),
    r'lastLocationTimestamp': PropertySchema(
      id: 5,
      name: r'lastLocationTimestamp',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'token': PropertySchema(
      id: 7,
      name: r'token',
      type: IsarType.string,
    )
  },
  estimateSize: _userEstimateSize,
  serialize: _userSerialize,
  deserialize: _userDeserialize,
  deserializeProp: _userDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'token': IndexSchema(
      id: -5898650166254967271,
      name: r'token',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'token',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userGetId,
  getLinks: _userGetLinks,
  attach: _userAttach,
  version: '3.1.0+1',
);

int _userEstimateSize(
  User object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.token;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userSerialize(
  User object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.didAttemptDownload);
  writer.writeBool(offsets[1], object.hasLocalIcon);
  writer.writeDouble(offsets[2], object.lastLocationAccuracy);
  writer.writeDouble(offsets[3], object.lastLocationLatitude);
  writer.writeDouble(offsets[4], object.lastLocationLongitude);
  writer.writeDateTime(offsets[5], object.lastLocationTimestamp);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.token);
}

User _userDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = User();
  object.didAttemptDownload = reader.readBoolOrNull(offsets[0]);
  object.hasLocalIcon = reader.readBoolOrNull(offsets[1]);
  object.id = id;
  object.lastLocationAccuracy = reader.readDoubleOrNull(offsets[2]);
  object.lastLocationLatitude = reader.readDoubleOrNull(offsets[3]);
  object.lastLocationLongitude = reader.readDoubleOrNull(offsets[4]);
  object.lastLocationTimestamp = reader.readDateTimeOrNull(offsets[5]);
  object.name = reader.readStringOrNull(offsets[6]);
  object.token = reader.readStringOrNull(offsets[7]);
  return object;
}

P _userDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userGetId(User object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userGetLinks(User object) {
  return [];
}

void _userAttach(IsarCollection<dynamic> col, Id id, User object) {
  object.id = id;
}

extension UserQueryWhereSort on QueryBuilder<User, User, QWhere> {
  QueryBuilder<User, User, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<User, User, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<User, User, QAfterWhere> anyToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'token'),
      );
    });
  }
}

extension UserQueryWhere on QueryBuilder<User, User, QWhereClause> {
  QueryBuilder<User, User, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<User, User, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> idBetween(
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

  QueryBuilder<User, User, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameEqualTo(String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameNotEqualTo(String? name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameGreaterThan(
    String? name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [name],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameLessThan(
    String? name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [],
        upper: [name],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameBetween(
    String? lowerName,
    String? upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [lowerName],
        includeLower: includeLower,
        upper: [upperName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [null],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenEqualTo(String? token) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [token],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenNotEqualTo(String? token) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [],
              upper: [token],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [token],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [token],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [],
              upper: [token],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenGreaterThan(
    String? token, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [token],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenLessThan(
    String? token, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [],
        upper: [token],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenBetween(
    String? lowerToken,
    String? upperToken, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [lowerToken],
        includeLower: includeLower,
        upper: [upperToken],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenStartsWith(
      String TokenPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [TokenPrefix],
        upper: ['$TokenPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [''],
      ));
    });
  }

  QueryBuilder<User, User, QAfterWhereClause> tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'token',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'token',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'token',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'token',
              upper: [''],
            ));
      }
    });
  }
}

extension UserQueryFilter on QueryBuilder<User, User, QFilterCondition> {
  QueryBuilder<User, User, QAfterFilterCondition> didAttemptDownloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'didAttemptDownload',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      didAttemptDownloadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'didAttemptDownload',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> didAttemptDownloadEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'didAttemptDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> hasLocalIconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hasLocalIcon',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> hasLocalIconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hasLocalIcon',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> hasLocalIconEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasLocalIcon',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<User, User, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<User, User, QAfterFilterCondition> idBetween(
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

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationAccuracyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLocationAccuracy',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationAccuracyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLocationAccuracy',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationAccuracyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLocationAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationAccuracyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLocationAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationAccuracyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLocationAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationAccuracyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLocationAccuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLatitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLocationLatitude',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationLatitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLocationLatitude',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLatitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLocationLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationLatitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLocationLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLatitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLocationLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLatitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLocationLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationLongitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLocationLongitude',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationLongitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLocationLongitude',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLongitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLocationLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationLongitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLocationLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLongitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLocationLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationLongitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLocationLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLocationTimestamp',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLocationTimestamp',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationTimestampEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLocationTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition>
      lastLocationTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLocationTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLocationTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> lastLocationTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLocationTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'token',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'token',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'token',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'token',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'token',
        value: '',
      ));
    });
  }

  QueryBuilder<User, User, QAfterFilterCondition> tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'token',
        value: '',
      ));
    });
  }
}

extension UserQueryObject on QueryBuilder<User, User, QFilterCondition> {}

extension UserQueryLinks on QueryBuilder<User, User, QFilterCondition> {}

extension UserQuerySortBy on QueryBuilder<User, User, QSortBy> {
  QueryBuilder<User, User, QAfterSortBy> sortByDidAttemptDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didAttemptDownload', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByDidAttemptDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didAttemptDownload', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByHasLocalIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocalIcon', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByHasLocalIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocalIcon', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationAccuracy', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationAccuracy', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLatitude', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLatitude', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLongitude', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLongitude', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationTimestamp', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByLastLocationTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationTimestamp', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> sortByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension UserQuerySortThenBy on QueryBuilder<User, User, QSortThenBy> {
  QueryBuilder<User, User, QAfterSortBy> thenByDidAttemptDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didAttemptDownload', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByDidAttemptDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didAttemptDownload', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByHasLocalIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocalIcon', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByHasLocalIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocalIcon', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationAccuracy', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationAccuracy', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLatitude', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLatitude', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLongitude', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationLongitude', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationTimestamp', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByLastLocationTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLocationTimestamp', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<User, User, QAfterSortBy> thenByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension UserQueryWhereDistinct on QueryBuilder<User, User, QDistinct> {
  QueryBuilder<User, User, QDistinct> distinctByDidAttemptDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'didAttemptDownload');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByHasLocalIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasLocalIcon');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByLastLocationAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLocationAccuracy');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByLastLocationLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLocationLatitude');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByLastLocationLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLocationLongitude');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByLastLocationTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLocationTimestamp');
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<User, User, QDistinct> distinctByToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'token', caseSensitive: caseSensitive);
    });
  }
}

extension UserQueryProperty on QueryBuilder<User, User, QQueryProperty> {
  QueryBuilder<User, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<User, bool?, QQueryOperations> didAttemptDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'didAttemptDownload');
    });
  }

  QueryBuilder<User, bool?, QQueryOperations> hasLocalIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasLocalIcon');
    });
  }

  QueryBuilder<User, double?, QQueryOperations> lastLocationAccuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLocationAccuracy');
    });
  }

  QueryBuilder<User, double?, QQueryOperations> lastLocationLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLocationLatitude');
    });
  }

  QueryBuilder<User, double?, QQueryOperations>
      lastLocationLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLocationLongitude');
    });
  }

  QueryBuilder<User, DateTime?, QQueryOperations>
      lastLocationTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLocationTimestamp');
    });
  }

  QueryBuilder<User, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<User, String?, QQueryOperations> tokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'token');
    });
  }
}
