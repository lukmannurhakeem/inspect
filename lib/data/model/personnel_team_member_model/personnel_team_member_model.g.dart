// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_team_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonnelTeamMemberModel _$PersonnelTeamMemberModelFromJson(
  Map<String, dynamic> json,
) => _PersonnelTeamMemberModel(
  personnelMembersId: json['personnel_members_id'] as String,
  teamPersonnelId: json['team_personnel_id'] as String,
  personnelId: json['personnel_id'] as String,
  isTeamLeader: json['is_team_leader'] as bool,
  isPrimaryLeader: json['is_primary_leader'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PersonnelTeamMemberModelToJson(
  _PersonnelTeamMemberModel instance,
) => <String, dynamic>{
  'personnel_members_id': instance.personnelMembersId,
  'team_personnel_id': instance.teamPersonnelId,
  'personnel_id': instance.personnelId,
  'is_team_leader': instance.isTeamLeader,
  'is_primary_leader': instance.isPrimaryLeader,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_AddMemberResponse _$AddMemberResponseFromJson(Map<String, dynamic> json) =>
    _AddMemberResponse(
      data: PersonnelTeamMemberModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
      message: json['message'] as String,
    );

Map<String, dynamic> _$AddMemberResponseToJson(_AddMemberResponse instance) =>
    <String, dynamic>{'data': instance.data, 'message': instance.message};
