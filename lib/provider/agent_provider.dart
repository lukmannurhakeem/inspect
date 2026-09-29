import 'package:flutter/material.dart';
import 'package:inspect/data/model/get_agent_model/get_agent_model.dart';
import 'package:inspect/repository/agent/agent_repository.dart';
import 'package:inspect/widget/common_snackbar.dart';

class AgentProvider extends ChangeNotifier {
  AgentProvider(this._repository);

  final AgentRepository _repository;

  final agentnameController = TextEditingController();
  final accountcodeController = TextEditingController();
  final notesController = TextEditingController();
  final addressController = TextEditingController();

  GetAgentModel? _model;
  List<Agent> _agents = [];
  bool _isFetching = false;
  bool _isSaving = false;

  GetAgentModel? get model => _model;
  List<Agent> get agents => _agents;
  bool get isFetching => _isFetching;
  bool get isSaving => _isSaving;

  Future<void> fetchAgents(BuildContext context) async {
    _isFetching = true;
    notifyListeners();
    try {
      _model = await _repository.fetchAgents();
      _agents = _model!.agents;
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e.toString());
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> createAgent(BuildContext context) => _save(
    context,
    successMessage: 'Agent created successfully',
    action: () => _repository.createAgent(
      agentname: agentnameController.text,
      accountcode: accountcodeController.text,
      notes: _nullIfEmpty(notesController.text),
      address: _nullIfEmpty(addressController.text),
    ),
  );

  Future<void> updateAgent(
      BuildContext context, {
        required String agentId,
      }) =>
      _save(
        context,
        successMessage: 'Agent updated successfully',
        action: () => _repository.updateAgent(
          agentId: agentId,
          agentname: agentnameController.text,
          accountcode: accountcodeController.text,
          notes: _nullIfEmpty(notesController.text),
          address: _nullIfEmpty(addressController.text),
        ),
      );

  Future<void> deleteAgent(BuildContext context, String agentId) async {
    try {
      await _repository.deleteAgent(agentId: agentId);
      _agents = _agents.where((a) => a.agentid != agentId).toList();
      notifyListeners();
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, 'Agent deleted successfully');
      }
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e.toString());
    }
  }

  Future<void> _save(
      BuildContext context, {
        required Future<void> Function() action,
        required String successMessage,
      }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await action();
      await fetchAgents(context);
      clearControllers();
      if (context.mounted) {
        Navigator.of(context).pop();
        CommonSnackbar.showSuccess(context, successMessage);
      }
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e.toString());
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String? _nullIfEmpty(String value) => value.isEmpty ? null : value;

  void clearControllers() {
    agentnameController.clear();
    accountcodeController.clear();
    notesController.clear();
    addressController.clear();
  }

  @override
  void dispose() {
    agentnameController.dispose();
    accountcodeController.dispose();
    notesController.dispose();
    addressController.dispose();
    super.dispose();
  }
}