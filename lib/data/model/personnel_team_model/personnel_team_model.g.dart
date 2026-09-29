// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonnelTeamModel _$PersonnelTeamModelFromJson(Map<String, dynamic> json) =>
    _PersonnelTeamModel(
      teamPersonnelId: json['team_personnel_id'] as String?,
      name: json['name'] as String?,
      parentTeam: json['parent_team'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PersonnelTeamModelToJson(_PersonnelTeamModel instance) =>
    <String, dynamic>{
      'team_personnel_id': instance.teamPersonnelId,
      'name': instance.name,
      'parent_team': instance.parentTeam,
      'type': instance.type,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
