import 'package:flutter/material.dart';
import 'package:inspect/data/model/get_agent_model/get_agent_model.dart';
import 'package:inspect/data/repository/agent/agent_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/widget/common_snackbar.dart';

class AgentProvider extends ChangeNotifier {
  final AgentRepository _repository = ServiceLocator().agentRepository;

  final agentnameController = TextEditingController();
  final accountcodeController = TextEditingController();
  final notesController = TextEditingController();
  final addressController = TextEditingController();

  late final List<TextEditingController> _controllers = [
    agentnameController,
    accountcodeController,
    notesController,
    addressController,
  ];

  GetAgentModel? _model;
  List<Agent> _agents = [];
  bool _isFetching = false;
  bool _isSaving = false;

  GetAgentModel? get model => _model;

  List<Agent> get agents => _agents;

  bool get isFetching => _isFetching;

  bool get isSaving => _isSaving;

  bool get isLoading => _isFetching || _isSaving;

  Future<void> fetchAgents(BuildContext context) async {
    _isFetching = true;
    notifyListeners();
    try {
      final result = await _repository.fetchAgents();
      _model = result;
      _agents = result.agents;
    } catch (e) {
      _showError(context, e);
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

  Future<void> updateAgent(BuildContext context, {required String agentId}) =>
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
      _showError(context, e);
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
      _showError(context, e);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, Object error) {
    if (context.mounted) CommonSnackbar.showError(context, error.toString());
  }

  String? _nullIfEmpty(String value) => value.isEmpty ? null : value;

  void clearControllers() {
    for (final controller in _controllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
