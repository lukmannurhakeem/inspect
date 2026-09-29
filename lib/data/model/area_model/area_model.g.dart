// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AreaModel _$AreaModelFromJson(Map<String, dynamic> json) => _AreaModel(
  areaid: json['areaid'] as String?,
  personnelid: json['personnelid'] as String?,
  areaname: json['areaname'] as String?,
  areacode: json['areacode'] as String?,
);

Map<String, dynamic> _$AreaModelToJson(_AreaModel instance) =>
    <String, dynamic>{
      'areaid': instance.areaid,
      'personnelid': instance.personnelid,
      'areaname': instance.areaname,
      'areacode': instance.areacode,
    };

_GetAreaModel _$GetAreaModelFromJson(Map<String, dynamic> json) =>
    _GetAreaModel(
      areas:
          (json['areas'] as List<dynamic>?)
              ?.map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$GetAreaModelToJson(_GetAreaModel instance) =>
    <String, dynamic>{
      'areas': instance.areas,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };
