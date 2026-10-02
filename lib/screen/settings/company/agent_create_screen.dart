import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_agent_model/get_agent_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/agent_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class AgentCreateScreen extends StatefulWidget {
  const AgentCreateScreen({super.key});

  @override
  State<AgentCreateScreen> createState() => _AgentCreateScreenState();
}

class _AgentCreateScreenState extends State<AgentCreateScreen> {
  bool _isEditMode = false;
  Agent? _editAgentData;
  bool _isInitialised = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFromArguments();
    });
  }

  void _initFromArguments() {
    if (_isInitialised) return;
    _isInitialised = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _isEditMode = args?['isEdit'] == true;
    _editAgentData = args?['agentData'] as Agent?;

    final provider = Provider.of<AgentProvider>(context, listen: false);

    if (_isEditMode && _editAgentData != null) {
      _populateFields();
    } else {
      // Clear any stale values from a previous edit session
      provider.agentnameController.clear();
      provider.accountcodeController.clear();
      provider.notesController.clear();
      provider.addressController.clear();
    }
  }

  void _populateFields() {
    final provider = Provider.of<AgentProvider>(context, listen: false);
    final a = _editAgentData!;
    provider.agentnameController.text = a.agentname ?? '';
    provider.accountcodeController.text = a.accountcode ?? '';
    provider.notesController.text = a.notes ?? '';
    provider.addressController.text = a.address ?? '';
  }

  @override
  void dispose() {
    // Clear controllers so stale values don't bleed into next navigation
    final provider = Provider.of<AgentProvider>(context, listen: false);
    provider.agentnameController.clear();
    provider.accountcodeController.clear();
    provider.notesController.clear();
    provider.addressController.clear();
    super.dispose();
  }

  // ─── Save / Update ────────────────────────────────────────────────────────

  void _saveAgent(AgentProvider provider) {
    if (provider.agentnameController.text.trim().isEmpty) {
      _showError('Please enter agent name');
      return;
    }
    if (provider.accountcodeController.text.trim().isEmpty) {
      _showError('Please enter account code');
      return;
    }

    setState(() => _isLoading = true);

    final future =
        _isEditMode
            ? provider.updateAgent(
              context,
              agentId: _editAgentData!.agentid ?? '',
            )
            : provider.createAgent(context);

    future
        .then((_) {
          if (mounted) setState(() => _isLoading = false);
        })
        .catchError((error) {
          if (mounted) {
            setState(() => _isLoading = false);
            _showError('Error: ${error.toString()}');
          }
        });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: context.colors.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String title,
    Widget child, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    title + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(flex: 3, child: child),
      ],
    );
  }

  // ─── Mobile layout ────────────────────────────────────────────────────────

  Widget _buildMobileLayout(BuildContext context, AgentProvider provider) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.vM,
          _buildSectionHeader(
            context,
            'Basic Information',
            Icons.person_outlined,
          ),
          context.vM,
          _buildRow(
            context,
            'Agent Name',
            CommonTextField(
              hintText: 'Enter Agent Name',
              controller: provider.agentnameController,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            isRequired: true,
            icon: Icons.person_outline,
          ),
          context.vS,
          _buildRow(
            context,
            'Account Code',
            CommonTextField(
              hintText: 'Enter Account Code',
              controller: provider.accountcodeController,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            isRequired: true,
            icon: Icons.tag,
          ),
          context.vL,
          _buildSectionHeader(
            context,
            'Additional Details',
            Icons.description_outlined,
          ),
          context.vM,
          _buildRow(
            context,
            'Notes',
            CommonTextField(
              hintText: 'Enter Notes',
              controller: provider.notesController,
              maxLines: 3,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.notes,
          ),
          context.vS,
          _buildRow(
            context,
            'Address',
            CommonTextField(
              hintText: 'Enter Address',
              controller: provider.addressController,
              maxLines: 2,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.location_on_outlined,
          ),
          context.vL,
          CommonButton(
            text:
                _isLoading
                    ? (_isEditMode ? 'Updating...' : 'Saving...')
                    : (_isEditMode ? 'Update Agent' : 'Save Agent'),
            onPressed: _isLoading ? null : () => _saveAgent(provider),
          ),
          context.vL,
        ],
      ),
    );
  }

  // ─── Tablet layout ────────────────────────────────────────────────────────

  Widget _buildTabletLayout(BuildContext context, AgentProvider provider) {
    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          context,
                          'Basic Information',
                          Icons.person_outlined,
                        ),
                        context.vM,
                        _buildRow(
                          context,
                          'Agent Name',
                          CommonTextField(
                            hintText: 'Enter Agent Name',
                            controller: provider.agentnameController,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          isRequired: true,
                          icon: Icons.person_outline,
                        ),
                        context.vS,
                        _buildRow(
                          context,
                          'Account Code',
                          CommonTextField(
                            hintText: 'Enter Account Code',
                            controller: provider.accountcodeController,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          isRequired: true,
                          icon: Icons.tag,
                        ),
                        context.vS,
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          context,
                          'Additional Details',
                          Icons.description_outlined,
                        ),
                        context.vM,
                        _buildRow(
                          context,
                          'Notes',
                          CommonTextField(
                            hintText: 'Enter Notes',
                            controller: provider.notesController,
                            maxLines: 3,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.notes,
                        ),
                        context.vS,
                        _buildRow(
                          context,
                          'Address',
                          CommonTextField(
                            hintText: 'Enter Address',
                            controller: provider.addressController,
                            maxLines: 2,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.location_on_outlined,
                        ),
                        context.vS,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: CommonButton(
                  text:
                      _isLoading
                          ? (_isEditMode ? 'Updating...' : 'Saving...')
                          : (_isEditMode ? 'Update Agent' : 'Save Agent'),
                  onPressed: _isLoading ? null : () => _saveAgent(provider),
                ),
              ),
            ],
          ),
          context.vM,
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isEditMode ? Icons.edit : Icons.person_add,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditMode ? 'Edit Agent' : 'Create Agent',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationService().goBack(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: context.colors.primary),
                      const SizedBox(height: 16),
                      Text(
                        _isEditMode ? 'Updating agent...' : 'Saving agent...',
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                )
                : (context.isTablet
                    ? _buildTabletLayout(context, provider)
                    : _buildMobileLayout(context, provider)),
      ),
    );
  }
}
