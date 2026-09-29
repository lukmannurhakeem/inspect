// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_agent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetAgentModel _$GetAgentModelFromJson(Map<String, dynamic> json) =>
    _GetAgentModel(
      agents:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Agent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      message: json['message'] as String?,
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetAgentModelToJson(_GetAgentModel instance) =>
    <String, dynamic>{
      'data': instance.agents,
      'message': instance.message,
      'pagination': instance.pagination,
    };

_Agent _$AgentFromJson(Map<String, dynamic> json) => _Agent(
  agentid: json['agentid'] as String?,
  agentname: json['agentname'] as String?,
  accountcode: json['accountcode'] as String?,
  notes: json['notes'] as String?,
  address: json['address'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$AgentToJson(_Agent instance) => <String, dynamic>{
  'agentid': instance.agentid,
  'agentname': instance.agentname,
  'accountcode': instance.accountcode,
  'notes': instance.notes,
  'address': instance.address,
  'status': instance.status,
};

_Pagination _$PaginationFromJson(Map<String, dynamic> json) => _Pagination(
  limit: (json['limit'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(_Pagination instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
    };
