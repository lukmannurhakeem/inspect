import 'package:inspect/data/model/get_agent_model/get_agent_model.dart';

abstract class AgentRepository {
  Future<GetAgentModel> fetchAgents();

  Future<void> createAgent({
    required String agentname,
    required String accountcode,
    String? notes,
    String? address,
  });

  Future<void> updateAgent({
    required String agentId,
    required String agentname,
    required String accountcode,
    String? notes,
    String? address,
  });

  Future<void> deleteAgent({required String agentId});
}
