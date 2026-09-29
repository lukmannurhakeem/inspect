
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personnel_team_member_model.freezed.dart';
part 'personnel_team_member_model.g.dart';

@freezed
abstract class PersonnelTeamMemberModel with _$PersonnelTeamMemberModel {
const factory PersonnelTeamMemberModel({
@JsonKey(name: 'personnel_members_id')
required String personnelMembersId,
@JsonKey(name: 'team_personnel_id')
required String teamPersonnelId,
@JsonKey(name: 'personnel_id')
required String personnelId,
@JsonKey(name: 'is_team_leader')
required bool isTeamLeader,
@JsonKey(name: 'is_primary_leader')
required bool isPrimaryLeader,
@JsonKey(name: 'created_at')
required DateTime createdAt,
@JsonKey(name: 'updated_at')
required DateTime updatedAt,
}) = _PersonnelTeamMemberModel;

factory PersonnelTeamMemberModel.fromJson(Map<String, dynamic> json) =>
_$PersonnelTeamMemberModelFromJson(json);
}

@freezed
abstract class AddMemberResponse with _$AddMemberResponse {
const factory AddMemberResponse({
required PersonnelTeamMemberModel data,
required String message,
}) = _AddMemberResponse;

factory AddMemberResponse.fromJson(Map<String, dynamic> json) =>
_$AddMemberResponseFromJson(json);
}

