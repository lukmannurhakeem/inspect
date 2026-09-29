import 'package:inspect/data/model/get_agent_model/get_agent_model.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/repository/agent/agent_repository.dart';

class AgentImpl implements AgentRepository {
  final ApiClient _api;

  AgentImpl(this._api);

  @override
  Future<GetAgentModel> fetchAgents() => _api.get(
    ApiEndpoint.agent,
    parser: (data) => GetAgentModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> createAgent({
    required String agentname,
    required String accountcode,
    String? notes,
    String? address,
  }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createAgent,
      data: {
        'agentname': agentname,
        'accountcode': accountcode,
        if (notes != null) 'notes': notes,
        if (address != null) 'address': address,
      },
    );

    if (data is Map && data['queued'] == true) {
      throw Exception('Agent saved locally. Will sync when online.');
    }
  }

  @override
  Future<void> updateAgent({
    required String agentId,
    required String agentname,
    required String accountcode,
    String? notes,
    String? address,
  }) => _api.patch<dynamic>(
    ApiEndpoint.agentUpdate(agentId),
    data: {
      'agentname': agentname,
      'accountcode': accountcode,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (address != null && address.isNotEmpty) 'address': address,
    },
  );

  @override
  Future<void> deleteAgent({required String agentId}) =>
      _api.delete<dynamic>(ApiEndpoint.agentDelete(agentId));
}