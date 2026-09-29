// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegulationModel _$RegulationModelFromJson(Map<String, dynamic> json) =>
    _RegulationModel(
      regulationId: json['regulationId'] as String?,
      regulationName: json['regulationName'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RegulationModelToJson(_RegulationModel instance) =>
    <String, dynamic>{
      'regulationId': instance.regulationId,
      'regulationName': instance.regulationName,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
