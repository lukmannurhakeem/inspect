
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personnel_team_model.freezed.dart';
part 'personnel_team_model.g.dart';

@freezed
abstract class PersonnelTeamModel with _$PersonnelTeamModel {
const factory PersonnelTeamModel({
@JsonKey(name: 'team_personnel_id') String? teamPersonnelId,
String? name,
@JsonKey(name: 'parent_team') String? parentTeam,
String? type,
String? description,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
}) = _PersonnelTeamModel;

factory PersonnelTeamModel.fromJson(Map<String, dynamic> json) =>
_$PersonnelTeamModelFromJson(json);
}

