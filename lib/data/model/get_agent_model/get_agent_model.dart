
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_agent_model.freezed.dart';
part 'get_agent_model.g.dart';

@freezed
abstract class GetAgentModel with _$GetAgentModel {
const factory GetAgentModel({
@JsonKey(name: 'data')
@Default([])
List<Agent> agents,

String? message,

Pagination? pagination,
}) = _GetAgentModel;

factory GetAgentModel.fromJson(Map<String, dynamic> json) =>
_$GetAgentModelFromJson(json);
}

@freezed
abstract class Agent with _$Agent {
const factory Agent({
String? agentid,
String? agentname,
String? accountcode,
String? notes,
String? address,
String? status,
}) = _Agent;

factory Agent.fromJson(Map<String, dynamic> json) =>
_$AgentFromJson(json);
}

@freezed
abstract class Pagination with _$Pagination {
const factory Pagination({
int? limit,
int? page,
int? total,
}) = _Pagination;

factory Pagination.fromJson(Map<String, dynamic> json) =>
_$PaginationFromJson(json);
}

