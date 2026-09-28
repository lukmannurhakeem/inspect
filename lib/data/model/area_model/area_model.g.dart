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
