// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_location_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobLocationItemModel _$JobLocationItemModelFromJson(
  Map<String, dynamic> json,
) => _JobLocationItemModel(
  count: (json['count'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => JobLocationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JobLocationItemModelToJson(
  _JobLocationItemModel instance,
) => <String, dynamic>{'count': instance.count, 'items': instance.items};

_JobLocationItem _$JobLocationItemFromJson(Map<String, dynamic> json) =>
    _JobLocationItem(
      locationId: json['locationID'] as String?,
      itemId: json['itemID'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      parentId: json['parentID'] as String?,
    );

Map<String, dynamic> _$JobLocationItemToJson(_JobLocationItem instance) =>
    <String, dynamic>{
      'locationID': instance.locationId,
      'itemID': instance.itemId,
      'name': instance.name,
      'code': instance.code,
      'parentID': instance.parentId,
    };
