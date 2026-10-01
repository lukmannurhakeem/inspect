
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/screen/categories/add_field_dialog.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class CategoriesCreateScreen extends StatefulWidget {
  final String? categoryId;
  final String? parentCategoryId;
  final String? parentCategoryName;

  const CategoriesCreateScreen({
    super.key,
    this.categoryId,
    this.parentCategoryId,
    this.parentCategoryName,
  });

  @override
  State<CategoriesCreateScreen> createState() => _CategoriesCreateScreenState();
}

class _CategoriesCreateScreenState extends State<CategoriesCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _categoryCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionTemplateController = TextEditingController();
  final _instructionController = TextEditingController();
  final _noteController = TextEditingController();

  int _replacementPeriodValue = 0;
  String _replacementPeriodUnit = 'days';

  static const List<String> _periodUnits = ['days', 'weeks', 'months', 'years'];

  bool _isEditMode = false;
  bool _hasPopulatedFields = false;
  bool _canHaveChild = false;
  bool _isWithdrawn = false;
  String? _selectedParentCategoryId;
  bool _isCreatingSubCategory = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = (widget.categoryId != null && widget.categoryId != '');
    _isCreatingSubCategory =
        (widget.parentCategoryId != null && widget.parentCategoryId != '');

    if (_isCreatingSubCategory) {
      _selectedParentCategoryId = widget.parentCategoryId;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoryProvider>();
      provider.fetchCategories();

      if (_isEditMode) {
        provider.resetFormState();
        provider.clearCategoryById();
        provider.fetchCategoryById(widget.categoryId!);
      }
    });
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryCodeController.dispose();
    _descriptionController.dispose();
    _descriptionTemplateController.dispose();
    _instructionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _populateFieldsFromCategory() {
    final provider = context.read<CategoryProvider>();

    // ── FIX 2: Guard — only populate when the loaded data belongs to THIS
    // category.  Without this, stale data from a previous edit screen
    // populates the controllers before the correct response arrives.
    final loadedId = provider.categoryById?.data?.categoryId?.toString() ?? '';
    if (loadedId.isEmpty || loadedId != widget.categoryId) return;

    if (provider.categoryById?.data != null && !_hasPopulatedFields) {
      final data = provider.categoryById!.data;

      _categoryNameController.text = data?.categoryName?.toString() ?? '';
      _categoryCodeController.text = data?.categoryCode?.toString() ?? '';
      _descriptionController.text = data?.description?.toString() ?? '';
      _descriptionTemplateController.text =
          data?.descriptionTemplate?.toString() ?? '';
      _instructionController.text = data?.instructions?.toString() ?? '';
      _selectedParentCategoryId = data?.parentId?.toString();
      _noteController.text = data?.notes?.toString() ?? '';

      final rawPeriod = data?.replacementPeriod?.toString() ?? '';
      _parseReplacementPeriod(rawPeriod);

      // ── FIX 3: Use setState so checkboxes re-render with the loaded values.
      setState(() {
        _hasPopulatedFields = true;
        _canHaveChild = data?.canHaveChildItems ?? false;
        _isWithdrawn = data?.isWithdrawn ?? false;
      });
    }
  }

  void _parseReplacementPeriod(String raw) {
    if (raw.isEmpty) return;
    final parts = raw.trim().split(RegExp(r'\s+'));
    if (parts.length == 2) {
      final val = int.tryParse(parts[0]);
      final unit = parts[1].toLowerCase();
      if (val != null) {
        setState(() {
          _replacementPeriodValue = val < 0 ? 0 : val;
          _replacementPeriodUnit = _periodUnits.firstWhere(
            (u) => unit.startsWith(u.replaceAll('s', '')),
            orElse: () => 'days',
          );
        });
        return;
      }
    }
    final val = int.tryParse(parts[0]);
    if (val != null) {
      setState(() {
        _replacementPeriodValue = val < 0 ? 0 : val;
        _replacementPeriodUnit = 'days';
      });
    }
  }

  String get _replacementPeriodString =>
      '$_replacementPeriodValue $_replacementPeriodUnit';

  void toggleCanHaveChild() {
    setState(() {
      _canHaveChild = !_canHaveChild;
    });
  }

  void toggleIsWithdrawn() {
    setState(() {
      print('🚀 isWithdrawn value: $_isWithdrawn');
      _isWithdrawn = !_isWithdrawn;
    });
  }

  Future<void> _handleSaveCategory() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CategoryProvider>();

      final instructionsText = _instructionController.text.trim();
      final notesText = _noteController.text.trim();

      bool success = false;
      try {
        success = await provider.createCategory(
          categoryId: _isEditMode ? widget.categoryId : null,
          categoryName: _categoryNameController.text.trim(),
          categoryCode: _categoryCodeController.text.trim(),
          description: _descriptionController.text.trim(),
          descriptionTemplate: _descriptionTemplateController.text.trim(),
          replacementPeriod: _replacementPeriodValue,
          canHaveChildItems: _canHaveChild,
          isWithdrawn: _isWithdrawn,
          instructions: instructionsText.isNotEmpty ? instructionsText : null,
          notes: notesText.isNotEmpty ? notesText : null,
          parentId: _selectedParentCategoryId,
          saveFieldsToStorage: true,
        );
      } catch (e) {
        success = false;
      }

      if (provider.createErrorMessage != null &&
          provider.createErrorMessage!.isNotEmpty) {
        success = false;
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEditMode
                          ? 'Category updated successfully!'
                          : _isCreatingSubCategory
                          ? 'Sub-category created successfully!'
                          : 'Category created successfully!',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          provider.resetFormState();
          NavigationService().goBack();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.createErrorMessage ??
                          'Failed to ${_isEditMode ? 'update' : 'create'} category',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

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

  Widget _buildErrorBanner(String message, VoidCallback onDismiss) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _widgetForm(
    String text, {
    TextEditingController? controller,
    bool required = false,
    IconData? icon,
    int maxLines = 1,
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
              if (required)
                const Text(
                  '* ',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    text,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          required ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonTextField(
            controller: controller,
            maxLines: maxLines,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
            validator:
                required
                    ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$text is required';
                      }
                      return null;
                    }
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _widgetReplacementPeriod() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Replacement Period',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Row(
            children: [
              _CounterButton(
                icon: Icons.remove,
                onPressed:
                    _replacementPeriodValue > 0
                        ? () => setState(() => _replacementPeriodValue--)
                        : null,
                primaryColor: context.colors.primary,
              ),
              const SizedBox(width: 4),
              Container(
                width: 48,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.primary.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_replacementPeriodValue',
                  style: context.topology.textTheme.bodyMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _CounterButton(
                icon: Icons.add,
                onPressed: () => setState(() => _replacementPeriodValue++),
                primaryColor: context.colors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _replacementPeriodUnit,
                  items:
                      _periodUnits
                          .map(
                            (unit) => DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                unit[0].toUpperCase() + unit.substring(1),
                                style: context.topology.textTheme.bodySmall
                                    ?.copyWith(color: context.colors.primary),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null)
                      setState(() => _replacementPeriodUnit = value);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: context.colors.primary.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: context.colors.primary.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _widgetFormCheckList(
    String text, {
    bool value = false,
    bool required = false,
    ValueChanged<bool?>? onChanged,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              if (required)
                const Text(
                  '* ',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              Expanded(
                child: Text(
                  text,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsTable(BuildContext context, CategoryProvider provider) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: context.colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Custom Fields',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: provider.showArchived,
                      onChanged: (_) => provider.toggleShowArchived(),
                      activeColor: context.colors.primary,
                    ),
                    Text(
                      'Show Archived',
                      style: context.topology.textTheme.bodyMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 150,
                      child: CommonButton(
                        icon: Icons.add,
                        text: 'Add Field',
                        onPressed: () => _showAddFieldDialog(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Table Content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth:
                    MediaQuery.of(context).size.width -
                    (context.paddingHorizontal.horizontal),
              ),
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(
                  context.colors.primary.withOpacity(0.03),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Label Text',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Field Type',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Default Value',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Create/Edit',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'View',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                rows:
                    provider.fields.isEmpty
                        ? [
                          DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    'No fields added yet',
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ),
                              ),
                              const DataCell(SizedBox()),
                              const DataCell(SizedBox()),
                              const DataCell(SizedBox()),
                              const DataCell(SizedBox()),
                              const DataCell(SizedBox()),
                            ],
                          ),
                        ]
                        : provider.fields.map((field) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    if (field.required)
                                      const Text(
                                        '* ',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    Text(
                                      field.labelText,
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.colors.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.primary.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    field.fieldType,
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  field.defaultValue ?? '',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                ),
                              ),
                              DataCell(
                                Text(
                                  field.permissions['create'] ?? 'Any',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                ),
                              ),
                              DataCell(
                                Text(
                                  field.permissions['view'] ?? 'Any',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDeleteConfirmation(
                                      context,
                                      field.id,
                                      field.labelText,
                                    );
                                  },
                                  tooltip: 'Delete field',
                                ),
                              ),
                            ],
                          );
                        }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isEditMode ? Icons.edit : Icons.add_circle_outline,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditMode
                  ? 'Edit Category'
                  : _isCreatingSubCategory
                  ? 'Create Sub-Category'
                  : 'Create Category',
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
          onPressed: () {
            NavigationService().goBack();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          // ── FIX 4: Only attempt to populate when loading is complete AND
          // the loaded record matches this screen's categoryId.
          // Using addPostFrameCallback avoids calling setState during build.
          if (_isEditMode &&
              !provider.isLoadingById &&
              provider.categoryById != null &&
              !_hasPopulatedFields) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _populateFieldsFromCategory();
            });
          }

          return SingleChildScrollView(
            padding: context.paddingHorizontal,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.vM,

                  // Loading indicator
                  if (provider.isCreating ||
                      (_isEditMode && provider.isLoadingById))
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: LinearProgressIndicator(
                        color: context.colors.primary,
                        backgroundColor: context.colors.primary.withOpacity(
                          0.2,
                        ),
                      ),
                    ),

                  // Error banners
                  if (provider.createErrorMessage != null)
                    _buildErrorBanner(
                      provider.createErrorMessage!,
                      provider.clearCreateError,
                    ),

                  if (_isEditMode && provider.errorMessageById != null)
                    _buildErrorBanner(
                      provider.errorMessageById!,
                      provider.clearCategoryById,
                    ),

                  // Basic Information Section
                  _buildSectionHeader(
                    context,
                    'Basic Information',
                    Icons.info_outline,
                  ),
                  context.vM,
                  _widgetForm(
                    'Category Name',
                    controller: _categoryNameController,
                    required: true,
                    icon: Icons.category,
                  ),
                  context.vS,
                  _widgetForm(
                    'Code',
                    controller: _categoryCodeController,
                    icon: Icons.tag,
                  ),
                  context.vS,

                  if (_isCreatingSubCategory)
                    _buildParentCategoryLabel(context),

                  context.vL,

                  // Description Section
                  _buildSectionHeader(
                    context,
                    'Description & Templates',
                    Icons.description_outlined,
                  ),
                  context.vM,
                  _widgetForm(
                    'Description',
                    controller: _descriptionController,
                    icon: Icons.text_fields,
                    maxLines: 3,
                  ),
                  context.vS,
                  _widgetForm(
                    'Description Template',
                    controller: _descriptionTemplateController,
                    icon: Icons.article_outlined,
                    maxLines: 3,
                  ),
                  context.vL,

                  // Custom Fields Section
                  _buildFieldsTable(context, provider),
                  context.vL,

                  // Additional Settings Section
                  _buildSectionHeader(
                    context,
                    'Additional Settings',
                    Icons.settings_outlined,
                  ),
                  context.vM,
                  _widgetReplacementPeriod(),
                  context.vS,
                  _widgetForm(
                    'Instructions',
                    controller: _instructionController,
                    icon: Icons.list_alt,
                    maxLines: 3,
                  ),
                  context.vS,
                  _widgetForm(
                    'Note',
                    controller: _noteController,
                    icon: Icons.note,
                    maxLines: 3,
                  ),
                  context.vL,

                  // Options Section
                  _buildSectionHeader(context, 'Options', Icons.tune),
                  context.vM,
                  _widgetFormCheckList(
                    'Can Have Child Item',
                    value: _canHaveChild,
                    onChanged: (val) => toggleCanHaveChild(),
                    icon: Icons.subdirectory_arrow_right,
                  ),
                  context.vS,
                  _widgetFormCheckList(
                    'Withdraw',
                    value: _isWithdrawn,
                    onChanged: (val) => toggleIsWithdrawn(),
                    icon: Icons.block,
                  ),
                  context.vXl,

                  // Save Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 200,
                      child: CommonButton(
                        icon: _isEditMode ? Icons.update : Icons.save,
                        text:
                            provider.isCreating
                                ? (_isEditMode ? 'Updating...' : 'Saving...')
                                : (_isEditMode ? 'Update' : 'Save'),
                        onPressed:
                            provider.isCreating ? null : _handleSaveCategory,
                      ),
                    ),
                  ),
                  context.vXxl,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParentCategoryLabel(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.account_tree,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Parent Category',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              widget.parentCategoryName ?? '',
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddFieldDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddFieldDialog());
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String fieldId,
    String fieldName,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Delete Field',
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to delete "$fieldName"? This action cannot be undone.',
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.colors.primary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CategoryProvider>().removeField(fieldId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text('Field deleted successfully!'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

// ─── Reusable counter icon-button ─────────────────────────────────────────────

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.primaryColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color:
            enabled
                ? primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
