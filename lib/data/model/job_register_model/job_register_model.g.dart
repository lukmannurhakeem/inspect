// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  itemId: json['itemId'] as String?,
  itemNo: json['itemNo'] as String?,
  description: json['description'] as String?,
  archived: json['archived'] as bool?,
  rfidNo: json['rfidNo'] as String?,
  categoryId: json['categoryId'] as String?,
  locationId: json['locationId'] as String?,
  detailedLocation: json['detailedLocation'] as String?,
  internalNotes: json['internalNotes'] as String?,
  manufacturer: json['manufacturer'] as String?,
  manufacturerAddress: json['manufacturerAddress'] as String?,
  manufacturerDate: json['manufacturerDate'] == null
      ? null
      : DateTime.parse(json['manufacturerDate'] as String),
  firstUseDate: json['firstUseDate'] == null
      ? null
      : DateTime.parse(json['firstUseDate'] as String),
  expiryDateTimeStamp: json['expiryDateTimeStamp'] == null
      ? null
      : DateTime.parse(json['expiryDateTimeStamp'] as String),
  status: json['status'] as String?,
  swl: json['swl'] as String?,
  photoReference: json['photoReference'] as String?,
  standardReference: json['standardReference'] as String?,
  customFields: json['customFields'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'itemNo': instance.itemNo,
  'description': instance.description,
  'archived': instance.archived,
  'rfidNo': instance.rfidNo,
  'categoryId': instance.categoryId,
  'locationId': instance.locationId,
  'detailedLocation': instance.detailedLocation,
  'internalNotes': instance.internalNotes,
  'manufacturer': instance.manufacturer,
  'manufacturerAddress': instance.manufacturerAddress,
  'manufacturerDate': instance.manufacturerDate?.toIso8601String(),
  'firstUseDate': instance.firstUseDate?.toIso8601String(),
  'expiryDateTimeStamp': instance.expiryDateTimeStamp?.toIso8601String(),
  'status': instance.status,
  'swl': instance.swl,
  'photoReference': instance.photoReference,
  'standardReference': instance.standardReference,
  'customFields': instance.customFields,
};

_JobRegisterModel _$JobRegisterModelFromJson(Map<String, dynamic> json) =>
    _JobRegisterModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobId: json['jobId'] as String?,
      jobName: json['jobName'] as String?,
    );

Map<String, dynamic> _$JobRegisterModelToJson(_JobRegisterModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'jobId': instance.jobId,
      'jobName': instance.jobName,
    };
