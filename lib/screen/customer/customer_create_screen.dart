
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/agent_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

class CustomerCreateNewScreen extends StatefulWidget {
  const CustomerCreateNewScreen({super.key});

  @override
  State<CustomerCreateNewScreen> createState() =>
      _CustomerCreateNewScreenState();
}

class _CustomerCreateNewScreenState extends State<CustomerCreateNewScreen> {
  final FileUploadController _logoController = FileUploadController();

  bool _isEditMode = false;
  bool _isInitialised = false;
  bool _isSaving = false;
  Customer? _editCustomer;

  String? _selectedAgentId;
  String? _selectedDivisionId;
  String? _existingLogoUrl;

  CustomerProvider get _customerProvider =>
      Provider.of<CustomerProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromArguments());
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  void _initFromArguments() {
    if (_isInitialised) return;
    _isInitialised = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isEditMode = args?['isEdit'] == true;
    _editCustomer = args?['customerData'] as Customer?;

    final agentProvider = Provider.of<AgentProvider>(context, listen: false);
    final systemProvider = Provider.of<SystemProvider>(context, listen: false);

    if (agentProvider.agents.isEmpty) agentProvider.fetchAgents(context);
    if (systemProvider.divisions.isEmpty) systemProvider.fetchDivision();

    if (_isEditMode && _editCustomer != null) {
      _populateFields(agentProvider, systemProvider);
    } else {
      _clearAllFields();
    }
  }

  void _clearAllFields() {
    final provider = _customerProvider;
    for (final controller in [
      provider.customerNameController,
      provider.customerCodeController,
      provider.addressController,
      provider.notesController,
      provider.agentController,
      provider.divisionController,
      provider.siteCodeController,
      provider.logoController,
    ]) {
      controller.clear();
    }
    setState(() {
      _selectedAgentId = null;
      _selectedDivisionId = null;
      _existingLogoUrl = null;
    });
  }

  void _populateFields(
    AgentProvider agentProvider,
    SystemProvider systemProvider,
  ) {
    final customer = _editCustomer!;
    final provider = _customerProvider;

    provider.customerNameController.text = customer.customername ?? '';
    provider.customerCodeController.text = customer.accountCode ?? '';
    provider.addressController.text = customer.address ?? '';
    provider.notesController.text = customer.notes ?? '';

    final logo = customer.logo;
    if (logo != null && logo.isNotEmpty) {
      setState(() => _existingLogoUrl = logo);
    }

    final agent = customer.agent;
    if (agent != null && agent.isNotEmpty) {
      if (agentProvider.agents.isEmpty) {
        _setAgent(agent);
      } else {
        _syncAgentSelection(agentProvider);
      }
    }

    final divisionId = customer.divisionid;
    if (divisionId != null && divisionId.isNotEmpty) {
      if (systemProvider.divisions.isEmpty) {
        _setDivision(divisionId);
      } else {
        _syncDivisionSelection(systemProvider);
      }
    }
  }

  void _setAgent(String? id) {
    setState(() => _selectedAgentId = id);
    _customerProvider.agentController.text = id ?? '';
  }

  void _setDivision(String? id) {
    setState(() => _selectedDivisionId = id);
    _customerProvider.divisionController.text = id ?? '';
  }

  void _syncAgentSelection(AgentProvider provider) {
    final stored = _editCustomer?.agent;
    if (stored == null || stored.isEmpty) return;

    final agents = provider.agents;
    final id =
        agents.where((a) => a.agentid == stored).firstOrNull?.agentid ??
        agents.where((a) => a.agentname == stored).firstOrNull?.agentid;
    if (id != null) _setAgent(id);
  }

  void _syncDivisionSelection(SystemProvider provider) {
    final customer = _editCustomer;
    if (customer == null ||
        (customer.divisionid == null && customer.divisionname == null)) {
      return;
    }

    final id =
        provider.divisions
            .where(
              (d) =>
                  d.divisionid == customer.divisionid ||
                  d.divisionname == customer.divisionname,
            )
            .firstOrNull
            ?.divisionid;
    if (id != null) _setDivision(id);
  }

  Future<void> _saveCustomer() async {
    final provider = _customerProvider;
    if (provider.customerNameController.text.trim().isEmpty) {
      _showError('Please enter customer name');
      return;
    }

    setState(() => _isSaving = true);
    try {
      if (_isEditMode) {
        await provider.updateCustomer(
          context,
          customerId: _editCustomer!.customerid ?? '',
          logoFile: _logoController.pickedFile,
        );
      } else {
        await provider.createCustomer(
          context,
          logoFile: _logoController.pickedFile,
        );
      }
    } catch (error) {
      if (mounted) _showError('Error: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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

  TextStyle? get _fieldStyle => context.topology.textTheme.bodySmall?.copyWith(
    color: context.colors.primary,
  );

  Widget _textField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) => CommonTextField(
    hintText: hint,
    controller: controller,
    maxLines: maxLines,
    style: _fieldStyle,
  );

  Widget _sectionHeader(String title, IconData icon) {
    final primary = context.colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: primary, width: 3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formRow(
    String title,
    Widget child, {
    bool isRequired = false,
    IconData? icon,
  }) {
    final primary = context.colors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: primary.withOpacity(0.7)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    isRequired ? '$title *' : title,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: primary,
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

  Widget _loadingIndicator() => const Center(
    child: SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );

  Widget _logoField() {
    final primary = context.colors.primary;
    final existingLogo = _existingLogoUrl;
    final showExisting =
        _isEditMode && existingLogo != null && _logoController.pickedFile == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFileUploadInput(
          controller: _logoController,
          allowedExtensions: const ['jpg', 'jpeg', 'png', 'gif', 'svg'],
        ),
        if (showExisting) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  existingLogo,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: primary,
                          size: 20,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Current logo — pick a new file to replace',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: primary.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _agentDropdown() {
    return _formRow(
      'Agent',
      Consumer<AgentProvider>(
        builder: (context, agentProvider, _) {
          if (agentProvider.isLoading) return _loadingIndicator();

          if (_isEditMode &&
              _editCustomer?.agent != null &&
              _selectedAgentId == null &&
              agentProvider.agents.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _syncAgentSelection(agentProvider);
            });
          }

          return CommonDropdown<String>(
            value: _selectedAgentId,
            items:
                agentProvider.agents
                    .map(
                      (agent) => DropdownMenuItem<String>(
                        value: agent.agentid,
                        child: Text(
                          agent.agentname ?? 'Unknown',
                          style: context.topology.textTheme.bodySmall,
                        ),
                      ),
                    )
                    .toList(),
            onChanged: _setAgent,
            borderColor: context.colors.primary,
            textStyle: _fieldStyle,
          );
        },
      ),
      icon: Icons.person,
    );
  }

  Widget _divisionDropdown() {
    return _formRow(
      'Division',
      Consumer<SystemProvider>(
        builder: (context, systemProvider, _) {
          if (systemProvider.isLoading) return _loadingIndicator();

          if (_isEditMode &&
              _selectedDivisionId == null &&
              systemProvider.divisions.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _syncDivisionSelection(systemProvider);
            });
          }

          return CommonDropdown<String>(
            value: _selectedDivisionId,
            items:
                systemProvider.divisions
                    .map(
                      (division) => DropdownMenuItem<String>(
                        value: division.divisionid,
                        child: Text(
                          division.divisionname ?? 'Unknown',
                          style: context.topology.textTheme.bodySmall,
                        ),
                      ),
                    )
                    .toList(),
            onChanged: _setDivision,
            borderColor: context.colors.primary,
            textStyle: _fieldStyle,
          );
        },
      ),
      icon: Icons.business,
    );
  }

  Widget _basicSection(CustomerProvider provider) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionHeader('Basic Information', Icons.business_outlined),
      context.vM,
      _formRow(
        'Customer Name',
        _textField('Enter Customer Name', provider.customerNameController),
        isRequired: true,
        icon: Icons.person_outline,
      ),
      context.vS,
      _formRow(
        'Account Code',
        _textField('Enter Account Code', provider.customerCodeController),
        icon: Icons.tag,
      ),
    ],
  );

  Widget _assignmentSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionHeader('Assignment & Organization', Icons.group_outlined),
      context.vM,
      _agentDropdown(),
      context.vS,
      _divisionDropdown(),
    ],
  );

  Widget _detailsSection(CustomerProvider provider) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionHeader('Additional Details', Icons.description_outlined),
      context.vM,
      _formRow(
        'Notes',
        _textField('Enter Notes', provider.notesController, maxLines: 3),
        icon: Icons.notes,
      ),
      context.vS,
      _formRow(
        'Address',
        _textField('Enter Address', provider.addressController, maxLines: 2),
        icon: Icons.location_on_outlined,
      ),
      context.vS,
      _formRow('Logo', _logoField(), icon: Icons.image_outlined),
    ],
  );

  Widget _saveButton() => CommonButton(
    text:
        _isSaving
            ? (_isEditMode ? 'Updating...' : 'Saving...')
            : (_isEditMode ? 'Update Customer' : 'Save Customer'),
    onPressed: _isSaving ? null : _saveCustomer,
  );

  Widget _mobileLayout(CustomerProvider provider) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.vM,
          _basicSection(provider),
          context.vL,
          _assignmentSection(),
          context.vL,
          _detailsSection(provider),
          context.vL,
          _saveButton(),
          context.vL,
        ],
      ),
    );
  }

  Widget _tabletLayout(CustomerProvider provider) {
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
                      children: [
                        _basicSection(provider),
                        context.vL,
                        _assignmentSection(),
                        context.vS,
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [_detailsSection(provider), context.vS],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          Center(child: SizedBox(width: 200, child: _saveButton())),
          context.vM,
        ],
      ),
    );
  }

  Widget _savingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          const SizedBox(height: 16),
          Text(
            _isEditMode ? 'Updating customer...' : 'Saving customer...',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = _customerProvider;
    final primary = context.colors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isEditMode ? Icons.edit : Icons.person_add,
              color: primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditMode ? 'Edit Customer' : 'Create Customer',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationService().goBack(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child:
            _isSaving
                ? _savingState()
                : (context.isTablet
                    ? _tabletLayout(provider)
                    : _mobileLayout(provider)),
      ),
    );
  }
}
