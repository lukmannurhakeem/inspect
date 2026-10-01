
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/cycle_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class CreateCycleScreen extends StatefulWidget {
  const CreateCycleScreen({super.key, this.cycleId});

  final String? cycleId;

  @override
  State<CreateCycleScreen> createState() => _CreateCycleScreenState();
}

class _CreateCycleScreenState extends State<CreateCycleScreen> {
  static const _units = ['Day', 'Week', 'Months', 'Year'];

  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _lengthController = TextEditingController(text: '0');
  final _minLengthController = TextEditingController(text: '0');
  final _maxLengthController = TextEditingController(text: '0');

  String? _reportTypeId;
  String? _categoryId;
  String? _unit;
  bool _isLoading = false;

  bool get _isEditMode => widget.cycleId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _lengthController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<CustomerProvider>().fetchCustomers(context);
    context.read<CategoryProvider>().fetchCategories();
    context.read<SystemProvider>().fetchReportType();
    if (_isEditMode) _prefillForEdit();
  }

  void _prefillForEdit() {
    final cycle = context.read<CycleProvider>().getCycleById(widget.cycleId!);
    if (cycle == null) return;

    final rawUnit = (cycle.unit ?? '').toLowerCase();

    setState(() {
      _unit = _units.where((u) => u.toLowerCase() == rawUnit).firstOrNull;
      _lengthController.text = (cycle.length ?? 0).toString();
      _minLengthController.text = (cycle.minLength ?? 0).toString();
      _maxLengthController.text = (cycle.maxLength ?? 0).toString();
      _reportTypeId = cycle.reportTypeId;
      _categoryController.text = cycle.categoryName ?? '';
      _categoryId = cycle.categoryId;
    });

    final customerId = cycle.customerId;
    if (customerId == null) return;

    final siteProvider = context.read<SiteProvider>();
    siteProvider.setSelectedCustomer(customerId);
    siteProvider.fetchSiteByCustomerId(context, customerId).then((_) {
      final siteId = cycle.siteId;
      if (siteId != null) siteProvider.setSelectedCustomerById(siteId);
    });
  }

  String? _validationError(SiteProvider siteProvider) {
    if (siteProvider.selectedCustomerId == null) {
      return 'Please select a customer';
    }
    if (_reportTypeId == null) return 'Please select a report type';
    if (_unit == null) return 'Please select a unit';
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final siteProvider = context.read<SiteProvider>();
    final error = _validationError(siteProvider);
    if (error != null) {
      CommonSnackbar.showError(context, error);
      return;
    }

    final cycleProvider = context.read<CycleProvider>();
    final length = int.tryParse(_lengthController.text) ?? 0;
    final minLength = int.tryParse(_minLengthController.text);
    final maxLength = int.tryParse(_maxLengthController.text);

    setState(() => _isLoading = true);

    try {
      if (_isEditMode) {
        await cycleProvider.updateCycle(
          context,
          cycleId: widget.cycleId!,
          reportTypeId: _reportTypeId!,
          categoryId: _categoryId,
          customerId: siteProvider.selectedCustomerId,
          siteId: siteProvider.selectedCustomerIdSite,
          unit: _unit!,
          length: length,
          minLength: minLength,
          maxLength: maxLength,
        );
      } else {
        await cycleProvider.createCycle(
          context,
          reportTypeId: _reportTypeId!,
          categoryId: _categoryId,
          customerId: siteProvider.selectedCustomerId,
          siteId: siteProvider.selectedCustomerIdSite,
          unit: _unit!,
          length: length,
          minLength: minLength,
          maxLength: maxLength,
        );
      }

      if (mounted && cycleProvider.errorMessage == null) {
        NavigationService().goBack();
      }
    } catch (e) {
      if (mounted) {
        CommonSnackbar.showError(
          context,
          '${_isEditMode ? 'Update' : 'Create'} failed: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearCategory() => setState(() {
    _categoryController.clear();
    _categoryId = null;
  });

  void _showCategoryPicker() {
    showDialog(
      context: context,
      builder:
          (_) => _CategoryPickerDialog(
            onSelected:
                (id, name) => setState(() {
                  _categoryController.text = name;
                  _categoryId = id;
                }),
          ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.info_outline, color: context.colors.primary),
                const SizedBox(width: 8),
                const Text('Help'),
              ],
            ),
            content: Text(
              _isEditMode
                  ? 'Update the fields below to modify this cycle. Fields marked with * are mandatory.'
                  : 'Fill in the required fields to create a new cycle. Fields marked with * are mandatory.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  TextStyle? get _fieldStyle =>
      context.primaryStyle(context.topology.textTheme.bodySmall);

  DropdownMenuItem<String> _menuItem(String value, String label) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        label,
        style: context.topology.textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _dropdown({
    String? value,
    List<DropdownMenuItem<String>> items = const [],
    ValueChanged<String?>? onChanged,
  }) {
    final enabled = onChanged != null;
    return CommonDropdown<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      borderColor: context.colors.primary.withOpacity(enabled ? 1 : 0.3),
      textStyle: context.primaryStyle(
        context.topology.textTheme.bodySmall,
        opacity: enabled ? 1 : 0.5,
      ),
    );
  }

  Widget _buildReportTypeField() {
    return Consumer<SystemProvider>(
      builder: (context, systemProvider, _) {
        if (systemProvider.isLoading) return const _Spinner();
        if (!systemProvider.hasReport) return _dropdown();

        final reportTypes = systemProvider.getReportTypeModel!.data!;
        return _dropdown(
          value: _reportTypeId,
          items: [
            for (final type in reportTypes)
              if (type.reportType?.reportTypeId != null)
                _menuItem(
                  type.reportType!.reportTypeId!,
                  type.reportType?.reportName ?? 'Unknown',
                ),
          ],
          onChanged: (value) => setState(() => _reportTypeId = value),
        );
      },
    );
  }

  Widget _buildCategoryField() {
    final primary = context.colors.primary;

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        return Row(
          children: [
            Expanded(
              child:
                  categoryProvider.isLoading
                      ? const _Spinner()
                      : CommonTextField(
                        controller: _categoryController,
                        style: _fieldStyle,
                        enabled: false,
                      ),
            ),
            const SizedBox(width: 8),
            _SquareIconButton(
              icon: Icons.edit_outlined,
              color: primary,
              onPressed: _showCategoryPicker,
            ),
            const SizedBox(width: 8),
            _SquareIconButton(
              icon: Icons.close,
              color: Colors.red,
              onPressed: _clearCategory,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerSiteField() {
    return Consumer2<CustomerProvider, SiteProvider>(
      builder: (context, customerProvider, siteProvider, _) {
        final sites = siteProvider.sitesCustomerList;
        final hasSites = siteProvider.selectedCustomerId != null && sites.isNotEmpty;

        return Row(
          children: [
            Expanded(
              child:
                  customerProvider.isFetching
                      ? const _Spinner()
                      : _dropdown(
                        value: siteProvider.selectedCustomerId,
                        items: [
                          for (final customer in customerProvider.customers)
                            if (customer.customerid != null)
                              _menuItem(
                                customer.customerid!,
                                customer.customername ?? 'Unknown',
                              ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          siteProvider.setSelectedCustomer(value);
                          siteProvider.fetchSiteByCustomerId(context, value);
                        },
                      ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  hasSites
                      ? _dropdown(
                        value: siteProvider.selectedCustomerIdSite,
                        items: [
                          for (final site in sites)
                            if (site.siteid != null)
                              _menuItem(site.siteid!, site.siteName ?? 'Unknown'),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            siteProvider.setSelectedCustomerById(value);
                          }
                        },
                      )
                      : _dropdown(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final titleStyle = context.primaryStyle(
      context.topology.textTheme.titleMedium,
      weight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isEditMode ? Icons.edit_rounded : Icons.add_circle_outline,
              color: primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(_isEditMode ? 'Edit Cycle' : 'Create Cycle', style: titleStyle),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: _showHelp,
            icon: Icon(Icons.help_outline, color: primary),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.paddingHorizontal,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.vM,
                const _SectionHeader('Cycle Information', Icons.refresh_outlined),
                context.vM,
                _FormRow(
                  icon: Icons.calendar_today,
                  label: const _FieldLabel(
                    'Report Type',
                    isRequired: true,
                    showInfo: true,
                  ),
                  field: _buildReportTypeField(),
                ),
                context.vS,
                _FormRow(
                  icon: Icons.category_outlined,
                  label: const _FieldLabel('Category', showInfo: true),
                  field: _buildCategoryField(),
                ),
                context.vS,
                _FormRow(
                  icon: Icons.business_outlined,
                  label: const _FieldLabel('Customer/Site'),
                  field: _buildCustomerSiteField(),
                ),
                context.vL,
                const _SectionHeader('Time Period', Icons.schedule_outlined),
                context.vM,
                _FormRow(
                  icon: Icons.access_time,
                  label: const _FieldLabel(
                    'Unit',
                    isRequired: true,
                    showInfo: true,
                  ),
                  field: _dropdown(
                    value: _unit,
                    items: [for (final unit in _units) _menuItem(unit, unit)],
                    onChanged: (value) => setState(() => _unit = value),
                  ),
                ),
                context.vS,
                _FormRow(
                  icon: Icons.timer_outlined,
                  label: const _FieldLabel(
                    'Duration',
                    isRequired: true,
                    showInfo: true,
                  ),
                  field: _NumberStepper(controller: _lengthController),
                ),
                context.vS,
                _FormRow(
                  icon: Icons.arrow_downward,
                  label: const _FieldLabel('Min Length'),
                  field: _NumberStepper(controller: _minLengthController),
                ),
                context.vS,
                _FormRow(
                  icon: Icons.arrow_upward,
                  label: const _FieldLabel('Max Length'),
                  field: _NumberStepper(controller: _maxLengthController),
                ),
                context.vXl,
                CommonButton(
                  text:
                      _isLoading
                          ? (_isEditMode ? 'Updating...' : 'Saving...')
                          : (_isEditMode ? 'Update Cycle' : 'Save Cycle'),
                  onPressed: _isLoading ? null : _save,
                ),
                context.vL,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _CycleFormStyle on BuildContext {
  TextStyle? primaryStyle(
    TextStyle? base, {
    FontWeight? weight,
    double opacity = 1,
  }) => base?.copyWith(
    color: colors.primary.withOpacity(opacity),
    fontWeight: weight,
  );
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, this.icon);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
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
            style: context.primaryStyle(
              context.topology.textTheme.titleMedium,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.isRequired = false, this.showInfo = false});

  final String text;
  final bool isRequired;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isRequired)
          const Text('* ', style: TextStyle(color: Colors.red, fontSize: 16)),
        Flexible(
          child: Text(
            text,
            style: context.primaryStyle(
              context.topology.textTheme.titleSmall,
              weight: isRequired ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        if (showInfo) ...[
          const SizedBox(width: 6),
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.colors.primary.withOpacity(0.6),
          ),
        ],
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.label, required this.field, this.icon});

  final Widget label;
  final Widget field;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.only(top: 12),
                  child: label,
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(flex: 3, child: field),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.iconSize,
    this.padding,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double? iconSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: iconSize),
      style: IconButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _NumberStepper extends StatelessWidget {
  const _NumberStepper({required this.controller});

  final TextEditingController controller;

  void _step(int delta) {
    final next = (int.tryParse(controller.text) ?? 0) + delta;
    if (next >= 0) controller.text = next.toString();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    const buttonPadding = EdgeInsets.all(8);

    return Row(
      children: [
        _SquareIconButton(
          icon: Icons.remove,
          iconSize: 18,
          color: primary,
          padding: buttonPadding,
          onPressed: () => _step(-1),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: context.primaryStyle(context.topology.textTheme.bodySmall),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        _SquareIconButton(
          icon: Icons.add,
          iconSize: 18,
          color: primary,
          padding: buttonPadding,
          onPressed: () => _step(1),
        ),
      ],
    );
  }
}

class _CategoryPickerDialog extends StatelessWidget {
  const _CategoryPickerDialog({required this.onSelected});

  final void Function(String? id, String name) onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.topology.textTheme;

    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Select Category',
            style: context.primaryStyle(
              textTheme.titleMedium,
              weight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 400,
            height: 400,
            child:
                provider.isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: context.colors.primary,
                      ),
                    )
                    : provider.filteredCategories.isEmpty
                    ? Center(
                      child: Text(
                        'No categories available',
                        style: context.primaryStyle(
                          textTheme.bodyMedium,
                          opacity: 0.6,
                        ),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.totalItemCount,
                      itemBuilder: (context, index) {
                        final category = provider.getCategoryByIndex(index);
                        if (category == null) return const SizedBox.shrink();

                        return Padding(
                          padding: EdgeInsets.only(left: category.level * 20.0),
                          child: ListTile(
                            leading:
                                category.children.isEmpty
                                    ? const SizedBox(width: 40)
                                    : IconButton(
                                      icon: Icon(
                                        category.isExpanded
                                            ? Icons.expand_more
                                            : Icons.chevron_right,
                                        color: context.colors.primary,
                                      ),
                                      onPressed:
                                          () => provider.toggleExpansion(category),
                                    ),
                            title: Text(
                              category.name,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    category.level == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            subtitle:
                                category.categoryCode == null
                                    ? null
                                    : Text(
                                      'Code: ${category.categoryCode}',
                                      style: context.primaryStyle(
                                        textTheme.bodySmall,
                                        opacity: 0.6,
                                      ),
                                    ),
                            onTap: () {
                              onSelected(category.id, category.name);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: context.colors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
