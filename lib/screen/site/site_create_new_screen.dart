import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/site/area_picker_dialog.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

class SiteCreateNewScreen extends StatefulWidget {
  const SiteCreateNewScreen({super.key});

  @override
  State<SiteCreateNewScreen> createState() => _SiteCreateNewScreenState();
}

class _SiteCreateNewScreenState extends State<SiteCreateNewScreen> {
  final _logoController = FileUploadController();
  final _areaController = TextEditingController();

  bool _isEditMode = false;
  bool _isLoading = false;
  bool _isInitialised = false;
  Site? _editSiteData;
  String? _selectedDivisionId;
  String? _existingLogoUrl;

  SiteProvider get _siteProvider => context.read<SiteProvider>();

  Color _fade([double opacity = 1]) => context.colors.primary.withOpacity(opacity);

  TextTheme get _textTheme => context.topology.textTheme;

  TextStyle? get _fieldStyle =>
      _textTheme.bodySmall?.copyWith(color: context.colors.primary);

  @override
  void initState() {
    super.initState();
    _logoController.addListener(() {
      if (_logoController.pickedFile != null && mounted) {
        setState(() => _existingLogoUrl = null);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromArguments());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _initFromArguments() {
    if (_isInitialised) return;
    _isInitialised = true;

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isEditMode = args?['isEdit'] == true;
    _editSiteData = args?['siteData'] as Site?;

    final systemProvider = context.read<SystemProvider>();
    context.read<CustomerProvider>().fetchCustomers(context);
    if (systemProvider.divisions.isEmpty) systemProvider.fetchDivision();

    final site = _editSiteData;
    if (_isEditMode && site != null) _populateFields(site, systemProvider);
  }

  void _populateFields(Site site, SystemProvider systemProvider) {
    final provider = _siteProvider;

    provider.nameController.text = site.siteName ?? '';
    provider.siteCodeController.text = site.siteCode ?? '';
    provider.addressController.text = site.address ?? '';
    provider.descriptionController.text = site.description ?? '';
    provider.notesController.text = site.notes ?? '';
    provider.statusController.text =
    site.archived == true
        ? SiteStatus.InActive.label
        : SiteStatus.Active.label;
    provider.areaController.text = site.area ?? '';
    provider.setSelectedCustomer(site.customerId);
    _areaController.text = site.area ?? '';

    if (site.logo?.isNotEmpty ?? false) {
      setState(() => _existingLogoUrl = site.logo);
    }

    final divisionId = _resolveDivisionId(systemProvider);
    if (divisionId != null) _applyDivision(divisionId);
  }

  String? _resolveDivisionId(SystemProvider systemProvider) {
    final name = _editSiteData?.divisionName;
    if (name == null) return null;

    for (final division in systemProvider.divisions) {
      if (division.divisionname == name) return division.divisionid;
    }
    return null;
  }

  void _applyDivision(String? divisionId) {
    setState(() => _selectedDivisionId = divisionId);
    _siteProvider.divisionController.text = divisionId ?? '';
  }

  String? _validate(SiteProvider provider) {
    if (provider.nameController.text.trim().isEmpty) {
      return 'Please enter site name';
    }
    if (provider.siteCodeController.text.trim().isEmpty) {
      return 'Please enter site code';
    }
    if (provider.selectedCustomerId?.isEmpty ?? true) {
      return 'Please select a customer';
    }
    if (_selectedDivisionId?.isEmpty ?? true) {
      return 'Please select a division';
    }
    return null;
  }

  Future<void> _saveSite() async {
    final provider = _siteProvider;

    final error = _validate(provider);
    if (error != null) {
      _showError(error);
      return;
    }

    provider.areaController.text = _areaController.text;
    setState(() => _isLoading = true);

    try {
      if (_isEditMode) {
        await provider.updateSite(
          context,
          siteId: _editSiteData!.siteid ?? '',
          logoFile: _logoController.pickedFile,
        );
      } else {
        await provider.createSite(context, logoFile: _logoController.pickedFile);
      }
    } catch (e) {
      if (mounted) _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  OutlineInputBorder _border({double opacity = 1, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _fade(opacity), width: width),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: _textTheme.bodySmall?.copyWith(color: Colors.grey),
      border: _border(),
      enabledBorder: _border(opacity: 0.3),
      focusedBorder: _border(width: 2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _spinner() {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: _fade(0.05),
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
            style: _textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _fade(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _fade(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            _isEditMode ? Icons.edit_note : Icons.info_outline,
            color: context.colors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditMode
                  ? 'Edit the details below and save to update the site'
                  : 'This is used for creating Sites belonging to a Customer',
              style: _textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
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
                Icon(icon, size: 16, color: _fade(0.7)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    isRequired ? '$title *' : title,
                    style: _textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: isRequired ? FontWeight.w600 : null,
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

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return CommonTextField(
      hintText: hint,
      controller: controller,
      maxLines: maxLines,
      style: _fieldStyle,
    );
  }

  Widget _buildLogoField() {
    final showExisting =
        _isEditMode &&
            _existingLogoUrl != null &&
            _logoController.pickedFile == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFileUploadInput(
          controller: _logoController,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'svg'],
        ),
        if (showExisting) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  _existingLogoUrl!,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: _fade(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: context.colors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Current logo — pick a new file to replace',
                  style: _textTheme.bodySmall?.copyWith(color: _fade(0.6)),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAreaPicker() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _areaController,
      builder: (context, value, _) {
        final hasValue = value.text.isNotEmpty;

        return GestureDetector(
          onTap:
              () => showAreaPickerDialog(
            context: context,
            controller: _areaController,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: hasValue ? _fade(0.04) : Colors.transparent,
              border: Border.all(
                color: hasValue ? context.colors.primary : _fade(0.3),
                width: hasValue ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 16,
                  color: hasValue ? context.colors.primary : _fade(0.35),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasValue ? value.text : 'Select or enter area',
                    style: _textTheme.bodySmall?.copyWith(
                      color: hasValue ? context.colors.primary : _fade(0.4),
                      fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValue)
                  GestureDetector(
                    onTap: _areaController.clear,
                    child: Icon(Icons.close, size: 16, color: _fade(0.5)),
                  )
                else
                  Icon(Icons.arrow_drop_down, size: 20, color: _fade(0.4)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerDropdown() {
    return Consumer2<CustomerProvider, SiteProvider>(
      builder: (context, customerProvider, siteProvider, _) {
        if (customerProvider.isLoading) return _spinner();

        return DropdownButtonFormField<String>(
          value: siteProvider.selectedCustomerId,
          decoration: _inputDecoration(hint: 'Select Customer'),
          items: [
            for (final customer in customerProvider.customers)
              DropdownMenuItem<String>(
                value: customer.customerid,
                child: Text(customer.customername ?? '-', style: _fieldStyle),
              ),
          ],
          onChanged: siteProvider.setSelectedCustomer,
        );
      },
    );
  }

  Widget _buildDivisionDropdown() {
    return Consumer<SystemProvider>(
      builder: (context, systemProvider, _) {
        if (systemProvider.isLoading) return _spinner();

        if (_isEditMode &&
            _selectedDivisionId == null &&
            systemProvider.divisions.isNotEmpty) {
          final divisionId = _resolveDivisionId(systemProvider);
          if (divisionId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _applyDivision(divisionId);
            });
          }
        }

        return CommonDropdown<String>(
          value: _selectedDivisionId,
          items: [
            for (final division in systemProvider.divisions)
              DropdownMenuItem<String>(
                value: division.divisionid,
                child: Text(
                  division.divisionname ?? 'Unknown',
                  style: _textTheme.bodySmall,
                ),
              ),
          ],
          onChanged: _applyDivision,
          borderColor: context.colors.primary,
          textStyle: _fieldStyle,
        );
      },
    );
  }

  Widget _buildStatusDropdown() {
    return Consumer<SiteProvider>(
      builder: (context, siteProvider, _) {
        final status = siteProvider.statusController.text;

        return DropdownButtonFormField<String>(
          value: status.isEmpty ? null : status,
          decoration: _inputDecoration(),
          items: [
            for (final status in SiteStatus.values)
              DropdownMenuItem<String>(
                value: status.label,
                child: Text(status.label, style: _fieldStyle),
              ),
          ],
          onChanged:
              (value) => siteProvider.statusController.text = value ?? '',
        );
      },
    );
  }

  List<Widget> _basicInfoSection(SiteProvider provider) {
    return [
      _buildSectionHeader('Basic Information', Icons.business_outlined),
      context.vM,
      _buildRow(
        'Name',
        _buildTextField('Enter Site Name', provider.nameController),
        isRequired: true,
        icon: Icons.apartment,
      ),
      context.vS,
      _buildRow(
        'Site Code',
        _buildTextField('Enter Site Code', provider.siteCodeController),
        isRequired: true,
        icon: Icons.tag,
      ),
      context.vS,
      _buildRow(
        'Customer',
        _buildCustomerDropdown(),
        isRequired: true,
        icon: Icons.business,
      ),
      context.vS,
      _buildRow('Area', _buildAreaPicker(), icon: Icons.map_outlined),
      context.vS,
      _buildRow('Status', _buildStatusDropdown(), icon: Icons.info_outline),
    ];
  }

  List<Widget> _locationSection(SiteProvider provider) {
    return [
      _buildSectionHeader('Location & Organization', Icons.location_on_outlined),
      context.vM,
      _buildRow(
        'Address',
        _buildTextField(
          'Enter Address',
          provider.addressController,
          maxLines: 2,
        ),
        icon: Icons.home_outlined,
      ),
      context.vS,
      _buildRow(
        'Division',
        _buildDivisionDropdown(),
        isRequired: true,
        icon: Icons.business_center,
      ),
    ];
  }

  List<Widget> _detailsSection(SiteProvider provider) {
    return [
      _buildSectionHeader('Additional Details', Icons.description_outlined),
      context.vM,
      _buildRow(
        'Description',
        _buildTextField(
          'Enter Description',
          provider.descriptionController,
          maxLines: 3,
        ),
        icon: Icons.description,
      ),
      context.vS,
      _buildRow(
        'Notes',
        _buildTextField('Enter Notes', provider.notesController, maxLines: 3),
        icon: Icons.notes,
      ),
      context.vS,
      _buildRow('Logo', _buildLogoField(), icon: Icons.image_outlined),
    ];
  }

  Widget _buildSubmitButton() {
    final label =
    _isLoading
        ? (_isEditMode ? 'Updating...' : 'Saving...')
        : (_isEditMode ? 'Update Site' : 'Save Site');

    return CommonButton(
      text: label,
      onPressed: _isLoading ? null : _saveSite,
    );
  }

  Widget _buildMobileLayout(SiteProvider provider) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.vM,
          _buildInfoBanner(),
          context.vL,
          ..._basicInfoSection(provider),
          context.vL,
          ..._locationSection(provider),
          context.vL,
          ..._detailsSection(provider),
          context.vL,
          _buildSubmitButton(),
          context.vL,
        ],
      ),
    );
  }

  Widget _buildTabletLayout(SiteProvider provider) {
    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          _buildInfoBanner(),
          context.vM,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._basicInfoSection(provider),
                        context.vL,
                        ..._locationSection(provider),
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
                      children: [..._detailsSection(provider), context.vS],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          SizedBox(width: 200, child: _buildSubmitButton()),
          context.vM,
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          const SizedBox(height: 16),
          Text(
            _isEditMode ? 'Updating site...' : 'Saving site...',
            style: _textTheme.bodyMedium?.copyWith(color: context.colors.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = _siteProvider;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isEditMode ? Icons.edit_location_alt : Icons.add_location_alt,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditMode ? 'Edit Site' : 'Create Site',
              style: _textTheme.titleMedium?.copyWith(
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
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child:
        _isLoading
            ? _buildLoadingView()
            : (context.isTablet
            ? _buildTabletLayout(provider)
            : _buildMobileLayout(provider)),
      ),
    );
  }
}