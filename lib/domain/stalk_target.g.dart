// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stalk_target.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStalkTargetCollection on Isar {
  IsarCollection<StalkTarget> get stalkTargets => this.collection();
}

const StalkTargetSchema = CollectionSchema(
  name: r'StalkTarget',
  id: -5723879998545436765,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'profilePictureUrl': PropertySchema(
      id: 1,
      name: r'profilePictureUrl',
      type: IsarType.string,
    ),
    r'token': PropertySchema(
      id: 2,
      name: r'token',
      type: IsarType.string,
    )
  },
  estimateSize: _stalkTargetEstimateSize,
  serialize: _stalkTargetSerialize,
  deserialize: _stalkTargetDeserialize,
  deserializeProp: _stalkTargetDeserializeProp,
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
    ),
    r'profilePictureUrl': IndexSchema(
      id: 2981216276836067500,
      name: r'profilePictureUrl',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profilePictureUrl',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _stalkTargetGetId,
  getLinks: _stalkTargetGetLinks,
  attach: _stalkTargetAttach,
  version: '3.1.0+1',
);

int _stalkTargetEstimateSize(
  StalkTarget object,
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
    final value = object.profilePictureUrl;
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

void _stalkTargetSerialize(
  StalkTarget object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.profilePictureUrl);
  writer.writeString(offsets[2], object.token);
}

StalkTarget _stalkTargetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StalkTarget();
  object.id = id;
  object.name = reader.readStringOrNull(offsets[0]);
  object.profilePictureUrl = reader.readStringOrNull(offsets[1]);
  object.token = reader.readStringOrNull(offsets[2]);
  return object;
}

P _stalkTargetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stalkTargetGetId(StalkTarget object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stalkTargetGetLinks(StalkTarget object) {
  return [];
}

void _stalkTargetAttach(
    IsarCollection<dynamic> col, Id id, StalkTarget object) {
  object.id = id;
}

extension StalkTargetQueryWhereSort
    on QueryBuilder<StalkTarget, StalkTarget, QWhere> {
  QueryBuilder<StalkTarget, StalkTarget, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhere> anyToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'token'),
      );
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhere> anyProfilePictureUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'profilePictureUrl'),
      );
    });
  }
}

extension StalkTargetQueryWhere
    on QueryBuilder<StalkTarget, StalkTarget, QWhereClause> {
  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> idBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameNotEqualTo(
      String? name) {
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameGreaterThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameLessThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> nameIsNotEmpty() {
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [null],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenEqualTo(
      String? token) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [token],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenNotEqualTo(
      String? token) {
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenGreaterThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenLessThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenStartsWith(
      String TokenPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'token',
        lower: [TokenPrefix],
        upper: ['$TokenPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [''],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause> tokenIsNotEmpty() {
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profilePictureUrl',
        value: [null],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'profilePictureUrl',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlEqualTo(String? profilePictureUrl) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profilePictureUrl',
        value: [profilePictureUrl],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlNotEqualTo(String? profilePictureUrl) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profilePictureUrl',
              lower: [],
              upper: [profilePictureUrl],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profilePictureUrl',
              lower: [profilePictureUrl],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profilePictureUrl',
              lower: [profilePictureUrl],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profilePictureUrl',
              lower: [],
              upper: [profilePictureUrl],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlGreaterThan(
    String? profilePictureUrl, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'profilePictureUrl',
        lower: [profilePictureUrl],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlLessThan(
    String? profilePictureUrl, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'profilePictureUrl',
        lower: [],
        upper: [profilePictureUrl],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlBetween(
    String? lowerProfilePictureUrl,
    String? upperProfilePictureUrl, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'profilePictureUrl',
        lower: [lowerProfilePictureUrl],
        includeLower: includeLower,
        upper: [upperProfilePictureUrl],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlStartsWith(String ProfilePictureUrlPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'profilePictureUrl',
        lower: [ProfilePictureUrlPrefix],
        upper: ['$ProfilePictureUrlPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profilePictureUrl',
        value: [''],
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterWhereClause>
      profilePictureUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'profilePictureUrl',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'profilePictureUrl',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'profilePictureUrl',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'profilePictureUrl',
              upper: [''],
            ));
      }
    });
  }
}

extension StalkTargetQueryFilter
    on QueryBuilder<StalkTarget, StalkTarget, QFilterCondition> {
  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePictureUrl',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePictureUrl',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePictureUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePictureUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePictureUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePictureUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      profilePictureUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePictureUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'token',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      tokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'token',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenEqualTo(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      tokenGreaterThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenLessThan(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenBetween(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenStartsWith(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenEndsWith(
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

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'token',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition> tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'token',
        value: '',
      ));
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterFilterCondition>
      tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'token',
        value: '',
      ));
    });
  }
}

extension StalkTargetQueryObject
    on QueryBuilder<StalkTarget, StalkTarget, QFilterCondition> {}

extension StalkTargetQueryLinks
    on QueryBuilder<StalkTarget, StalkTarget, QFilterCondition> {}

extension StalkTargetQuerySortBy
    on QueryBuilder<StalkTarget, StalkTarget, QSortBy> {
  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy>
      sortByProfilePictureUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePictureUrl', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy>
      sortByProfilePictureUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePictureUrl', Sort.desc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> sortByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> sortByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension StalkTargetQuerySortThenBy
    on QueryBuilder<StalkTarget, StalkTarget, QSortThenBy> {
  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy>
      thenByProfilePictureUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePictureUrl', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy>
      thenByProfilePictureUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePictureUrl', Sort.desc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QAfterSortBy> thenByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension StalkTargetQueryWhereDistinct
    on QueryBuilder<StalkTarget, StalkTarget, QDistinct> {
  QueryBuilder<StalkTarget, StalkTarget, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QDistinct> distinctByProfilePictureUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePictureUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StalkTarget, StalkTarget, QDistinct> distinctByToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'token', caseSensitive: caseSensitive);
    });
  }
}

extension StalkTargetQueryProperty
    on QueryBuilder<StalkTarget, StalkTarget, QQueryProperty> {
  QueryBuilder<StalkTarget, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StalkTarget, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<StalkTarget, String?, QQueryOperations>
      profilePictureUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePictureUrl');
    });
  }

  QueryBuilder<StalkTarget, String?, QQueryOperations> tokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'token');
    });
  }
}
