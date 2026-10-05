import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/report_dropdwon_options_service.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/report_form_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/settings/report_setup/report_template_importer.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_confirm_dialog.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

const _batchReportTypeOptions = [
  'Multiple Report Batch',
  'No Batch',
  'Single Report Batch',
];

const _statusOptions = [
  'Accepted',
  'Rejected',
  'CAR',
  'Fit for use at time of inspection',
  'Pass',
  'Quarantine',
  'Satisfactory',
  'Unsatisfactory',
];

const _permissionOptions = ['customer', 'administration', 'engineer'];

const _operatorOptions = [
  '==',
  '!=',
  '>',
  '<',
  '>=',
  '<=',
  'contains',
  'not_contains',
];

const _applyCycleOptions = [
  'daily',
  'weekly',
  'monthly',
  'quarterly',
  'yearly',
  'custom',
];

class _FieldTypeStyle {
  final Color color;
  final IconData icon;

  const _FieldTypeStyle(this.color, this.icon);
}

const _fieldTypeStyles = <String, _FieldTypeStyle>{
  'text': _FieldTypeStyle(Color(0xFF3B82F6), Icons.text_fields_rounded),
  'number': _FieldTypeStyle(Color(0xFFF59E0B), Icons.numbers_rounded),
  'decimal': _FieldTypeStyle(Color(0xFFF59E0B), Icons.calculate_outlined),
  'date': _FieldTypeStyle(Color(0xFF8B5CF6), Icons.calendar_today_rounded),
  'checkbox': _FieldTypeStyle(Color(0xFF10B981), Icons.check_box_outlined),
  'checkbox_list': _FieldTypeStyle(Color(0xFF059669), Icons.checklist_rounded),
  'dropdown': _FieldTypeStyle(
    Color(0xFF6366F1),
    Icons.arrow_drop_down_circle_outlined,
  ),
  'textarea': _FieldTypeStyle(Color(0xFF06B6D4), Icons.notes_rounded),
  'file': _FieldTypeStyle(Color(0xFF78716C), Icons.attach_file_rounded),
  'label': _FieldTypeStyle(Color(0xFFEC4899), Icons.label_outline_rounded),
  'section': _FieldTypeStyle(Color(0xFF14B8A6), Icons.view_agenda_outlined),
};

const _defaultFieldTypeStyle = _FieldTypeStyle(
  Color(0xFF6B7280),
  Icons.input_rounded,
);

_FieldTypeStyle _fieldTypeStyle(String type) =>
    _fieldTypeStyles[type] ?? _defaultFieldTypeStyle;

const _fieldTypeAliases = <String, String>{
  'text': 'text',
  'number': 'number',
  'integer': 'number',
  'int': 'number',
  'decimal': 'decimal',
  'float': 'decimal',
  'double': 'decimal',
  'date': 'date',
  'datetime': 'date',
  'checkbox': 'checkbox',
  'bool': 'checkbox',
  'boolean': 'checkbox',
  'checkbox_list': 'checkbox_list',
  'checklist': 'checkbox_list',
  'multi_checkbox': 'checkbox_list',
  'dropdown': 'dropdown',
  'select': 'dropdown',
  'enum': 'dropdown',
  'textarea': 'textarea',
  'text_area': 'textarea',
  'multiline': 'textarea',
  'file': 'file',
  'upload': 'file',
  'attachment': 'file',
  'label': 'label',
  'section': 'section',
};

String _normaliseFieldType(dynamic raw) =>
    _fieldTypeAliases[raw?.toString().toLowerCase().trim()] ?? 'text';

const _statusBadgeColors = <String, Color>{
  'Accepted': Color(0xFF10B981),
  'Rejected': Color(0xFFEF4444),
  'CAR': Color(0xFFF59E0B),
  'Fit for use at time of inspection': Color(0xFF3B82F6),
  'Pass': Color(0xFF059669),
  'Quarantine': Color(0xFFEC4899),
  'Satisfactory': Color(0xFF6366F1),
  'Unsatisfactory': Color(0xFFEF4444),
  'draft': Color(0xFF6B7280),
  'pending': Color(0xFFF59E0B),
  'approved': Color(0xFF10B981),
  'rejected': Color(0xFFEF4444),
  'in_progress': Color(0xFF3B82F6),
  'completed': Color(0xFF8B5CF6),
};

Color _statusBadgeColor(String status) =>
    _statusBadgeColors[status] ?? const Color(0xFF6B7280);

const _dateColor = Color(0xFF8B5CF6);
const _checkboxColor = Color(0xFF10B981);
const _checkboxListColor = Color(0xFF059669);

List<String> _splitCsv(String? raw) =>
    (raw ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

String _joinCsv(Iterable<dynamic> items) =>
    items.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).join(',');

String _safeOption(dynamic raw, List<String> options) {
  final value = raw?.toString() ?? '';
  return options.contains(value) ? value : options.first;
}

List<CategoryItem> _flattenCategories(List<CategoryItem> items) => [
  for (final item in items) ...[item, ..._flattenCategories(item.children)],
];

Color _fade(BuildContext context, [double opacity = 1]) =>
    context.colors.primary.withOpacity(opacity);

TextStyle? _bodySmall(
    BuildContext context, {
      double opacity = 1,
      Color? color,
      FontWeight? weight,
      double? size,
      String? fontFamily,
      FontStyle? fontStyle,
      double? letterSpacing,
    }) => context.topology.textTheme.bodySmall?.copyWith(
  color: color ?? _fade(context, opacity),
  fontWeight: weight,
  fontSize: size,
  fontFamily: fontFamily,
  fontStyle: fontStyle,
  letterSpacing: letterSpacing,
);

TextStyle? _bold(BuildContext context, TextStyle? base) => base?.copyWith(
  color: context.colors.primary,
  fontWeight: FontWeight.bold,
);

class ReportCreateScreen extends StatelessWidget {
  const ReportCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ReportFormProvider(ctx.read<SystemProvider>()),
      child: const _ReportCreateView(),
    );
  }
}

class _ReportCreateView extends StatefulWidget {
  const _ReportCreateView();

  @override
  State<_ReportCreateView> createState() => _ReportCreateViewState();
}

class _ReportCreateViewState extends State<_ReportCreateView> {
  ReportFormProvider get _form => context.read<ReportFormProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final categories = context.read<CategoryProvider>();
    if (categories.allCategories.isEmpty) categories.fetchCategories();

    final form = _form;
    final draft = await form.init(
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
    );
    if (!mounted) return;

    final error = form.loadError;
    if (error != null) _showSnackBar(error, color: Colors.red);
    if (draft != null) await _offerDraft(draft);
  }

  Future<void> _offerDraft(ReportDraft draft) async {
    final resume = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
        title: const Text('Resume draft?'),
        content: Text(
          'A saved draft "${draft.name}" was found${draft.savedAt.isNotEmpty ? ' (saved ${draft.savedAt})' : ''}.\n\nWould you like to continue editing it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Resume'),
          ),
        ],
      ),
    );

    if (resume == true) {
      _form.applyDraft(draft.data);
    } else {
      _form.clearDraft();
    }
  }

  void _showSnackBar(String message, {Color? color, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: duration ?? const Duration(milliseconds: 4000),
      ),
    );
  }

  Future<void> _saveDraft() async {
    await _form.saveDraft();
    if (mounted) {
      _showSnackBar('Draft saved', duration: const Duration(seconds: 2));
    }
  }

  Future<void> _submit() async {
    final form = _form;
    final error = await form.submit();
    if (!mounted) return;

    if (error != null) return _showSnackBar(error, color: Colors.red);

    _showSnackBar(
      form.isEditMode
          ? 'Report updated successfully!'
          : 'Report created successfully!',
      color: Colors.green,
    );
    NavigationService().goBack();
  }

  Future<void> _editField([int? index]) async {
    final form = _form;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder:
          (_) => _AddFieldDialog(
        initialData: form.fieldAt(index),
        availableSections: form.availableSections,
        availableFieldNames: form.availableFieldNames,
        isEdit: index != null,
      ),
    );
    if (result != null) form.saveField(index, result);
  }

  Future<void> _editDate([int? index]) async {
    final form = _form;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder:
          (_) => _AddDateDialog(
        initialData: form.dateAt(index),
        isEdit: index != null,
      ),
    );
    if (result != null) form.saveDate(index, result);
  }

  void _deleteField(int index) {
    final form = _form;
    _confirmDelete(
      title: 'Delete Field?',
      itemLabel:
      form.fields[index]['labelText']?.toString() ?? 'Field ${index + 1}',
      onConfirm: () => form.removeField(index),
    );
  }

  void _deleteDate(int index) {
    final form = _form;
    final name = form.dates[index]['name']?.toString() ?? '';
    _confirmDelete(
      title: 'Delete Date?',
      itemLabel: name.isNotEmpty ? name : 'Date ${index + 1}',
      onConfirm: () => form.removeDate(index),
    );
  }

  void _confirmDelete({
    required String title,
    required String itemLabel,
    required VoidCallback onConfirm,
  }) {
    CommonConfirmDialog.show(
      context: context,
      title: title,
      message: 'Are you sure you want to delete "$itemLabel"?',
      warningNote: 'This action is permanent and cannot be reversed.',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: onConfirm,
    );
  }

  Future<void> _pickMulti(
      ReportMulti multi,
      String label,
      List<String> options,
      ) async {
    final result = await showDialog<List<String>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder:
          (_) => _SelectionDialog(
        title: 'Select $label',
        icon: Icons.checklist_rounded,
        choices: [
          for (final option in options)
            _Choice(
              id: option,
              label: option,
              color: _statusBadgeColor(option),
            ),
        ],
        selected: _form.multi(multi),
      ),
    );
    if (result != null) _form.setMulti(multi, result);
  }

  Future<void> _pickCategories(List<CategoryItem> flat) async {
    final result = await showDialog<List<String>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder:
          (_) => _SelectionDialog(
        title: 'Select Categories',
        icon: Icons.category_outlined,
        choices: [
          for (final cat in flat)
            _Choice(
              id: cat.id,
              label: cat.name,
              code: cat.categoryCode,
              level: cat.level,
            ),
        ],
        selected: _form.categoryIds,
        searchable: true,
      ),
    );
    if (result != null) _form.setCategoryIds(result);
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ReportFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          form.isEditMode ? 'Edit Report Template' : 'Create Report Template',
          style: context.topology.textTheme.titleLarge?.copyWith(
            color: context.colors.primary,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        leading: IconButton(
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.chevron_left),
        ),
        actions:
        form.isEditMode
            ? null
            : [
          IconButton(
            onPressed:
                () => ReportTemplateImporter.pickAndImport(context),
            icon: const Icon(Icons.upload_file_rounded),
            tooltip: 'Import from Excel',
          ),
          IconButton(
            onPressed: _saveDraft,
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save draft',
          ),
        ],
      ),
      body: form.isLoading ? _buildLoadingView() : _buildContent(form),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
          ),
          context.vM,
          Text(
            'Loading report details...',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ReportFormProvider form) {
    return Container(
      padding: context.paddingAll,
      child: Column(
        children: [
          _buildStepIndicator(form.step),
          context.vL,
          Expanded(child: _buildStepContent(form)),
          _buildNavigationButtons(form),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int current) {
    const steps = ReportFormProvider.steps;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _buildStep(i, current),
            if (i != steps.length - 1)
              Container(
                width: 40,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color:
                i < current
                    ? context.colors.primary
                    : context.colors.secondary,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(int index, int current) {
    final isActive = current == index;
    final isCompleted = index < current;

    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
          isCompleted
              ? context.colors.primary
              : (isActive ? context.colors.secondary : Colors.grey),
          child: Text(
            '${index + 1}',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        context.vS,
        Text(
          ReportFormProvider.steps[index],
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(ReportFormProvider form) {
    final width = context.screenWidth / 2.5;
    final submitLabel =
    form.isSubmitting
        ? (form.isEditMode ? 'Updating...' : 'Creating...')
        : (form.isEditMode ? 'Update Report' : 'Create Report');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: CommonButton(
            text: 'Back',
            onPressed: form.step > 0 ? form.back : null,
          ),
        ),
        context.hM,
        SizedBox(
          width: width,
          child: CommonButton(
            text: form.isLastStep ? submitLabel : 'Next',
            onPressed:
            !form.isLastStep
                ? form.next
                : (form.isSubmitting ? null : _submit),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(ReportFormProvider form) {
    switch (form.step) {
      case 0:
        return _buildOverviewStep(form);
      case 1:
        return _buildFieldsStep(form);
      case 2:
        return _buildDatesStep(form);
      default:
        return const Text('Unknown Step');
    }
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: _bold(context, context.topology.textTheme.titleMedium),
  );

  List<Widget> _section(String title) => [
    _sectionTitle(title),
    context.divider,
    context.vM,
  ];

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return _labeled(
      label,
      CommonTextField(
        controller: controller,
        style: _bodySmall(context),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildFlag(ReportFormProvider form, ReportFlag flag) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: form.flag(flag),
            onChanged: (v) => form.setFlag(flag, v ?? flag.initial),
            activeColor: context.colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              flag.label,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField(
      ReportFormProvider form,
      ReportMulti multi,
      String label,
      List<String> options,
      ) {
    final selected = form.multi(multi);

    return _labeled(
      label,
      _PickerBox(
        onTap: () => _pickMulti(multi, label, options),
        child:
        selected.isEmpty
            ? Text('Tap to select…', style: _bodySmall(context, opacity: 0.35))
            : Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final value in selected)
              _RemovableChip(
                label: value.toUpperCase(),
                onRemove:
                    () => form.setMulti(multi, [...selected]..remove(value)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryField(ReportFormProvider form) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        final flat = _flattenCategories(provider.allCategories);
        final names = {for (final cat in flat) cat.id: cat.name};
        final ids = form.categoryIds;

        final Widget content;
        if (provider.isLoading || (flat.isEmpty && ids.isNotEmpty)) {
          content = Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(context.colors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text('Loading categories…', style: _bodySmall(context, opacity: 0.4)),
            ],
          );
        } else if (ids.isEmpty) {
          content = Text(
            'Tap to select categories…',
            style: _bodySmall(context, opacity: 0.35),
          );
        } else {
          content = Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final id in ids)
                _RemovableChip(
                  label: names[id] ?? id,
                  icon: Icons.category_outlined,
                  tinted: true,
                  onRemove: () => form.removeCategory(id),
                ),
            ],
          );
        }

        return _labeled(
          'Category',
          _PickerBox(
            onTap: provider.isLoading ? null : () => _pickCategories(flat),
            child: content,
          ),
        );
      },
    );
  }

  Widget _buildOverviewStep(ReportFormProvider form) {
    final batchType =
    _batchReportTypeOptions.contains(form.batchReportType)
        ? form.batchReportType
        : 'No Batch';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._section('Basic Information'),
          _buildTextField('Report Name *', form.nameController),
          context.vS,
          _buildTextField('Description', form.descriptionController, maxLines: 3),
          context.vS,
          _buildTextField('Document Code', form.documentCodeController),
          context.vS,
          _labeled(
            'Batch Report Type',
            _DropdownBox(
              value: batchType,
              items: _batchReportTypeOptions,
              onChanged: form.setBatchReportType,
            ),
          ),
          context.vL,
          ..._section('Report Settings'),
          for (final flag in ReportFlag.values.where(
                (f) => f != ReportFlag.isStatusRequired,
          ))
            _buildFlag(form, flag),
          context.vL,
          ..._section('Status Configuration'),
          _buildFlag(form, ReportFlag.isStatusRequired),
          context.vS,
          _buildMultiSelectField(
            form,
            ReportMulti.possibleStatus,
            'Possible Statuses',
            _statusOptions,
          ),
          context.vS,
          _buildMultiSelectField(
            form,
            ReportMulti.possibleBatchStatus,
            'Possible Batch Statuses',
            _statusOptions,
          ),
          context.vL,
          ..._section('Permissions'),
          _buildMultiSelectField(
            form,
            ReportMulti.permission,
            'Permissions',
            _permissionOptions,
          ),
          context.vL,
          ..._section('Associations'),
          _buildCategoryField(form),
          context.vL,
        ],
      ),
    );
  }

  Widget _buildListHeader({
    required IconData icon,
    required String title,
    required int count,
    required String countLabel,
    required String buttonLabel,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _fade(context, 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: context.colors.primary),
        ),
        context.hS,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _bold(context, context.topology.textTheme.titleMedium),
              ),
              Text(
                '$count $countLabel${count == 1 ? '' : 's'} configured',
                style: _bodySmall(context, opacity: 0.5),
              ),
            ],
          ),
        ),
        _AddButton(label: buttonLabel, onPressed: onAdd, compact: true),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onAdd,
  }) {
    return Center(
      child: Padding(
        padding: context.paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _fade(context, 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: _fade(context, 0.4)),
            ),
            context.vM,
            Text(
              title,
              style: _bold(context, context.topology.textTheme.titleMedium),
            ),
            context.vS,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: _bodySmall(context, opacity: 0.5),
            ),
            context.vL,
            _AddButton(label: buttonLabel, onPressed: onAdd),
          ],
        ),
      ),
    );
  }

  BoxDecoration _rowDecoration(int index, {bool indented = false}) {
    return BoxDecoration(
      color: index.isEven ? Colors.transparent : _fade(context, 0.02),
      border: Border(
        left:
        indented
            ? BorderSide(color: _fade(context, 0.15), width: 2)
            : BorderSide.none,
        bottom: BorderSide(color: _fade(context, 0.07)),
      ),
    );
  }

  Widget _buildFieldsStep(ReportFormProvider form) {
    final fields = form.fields;

    final rows = <Widget>[];
    final seenSections = <String>{};
    for (var i = 0; i < fields.length; i++) {
      final section = fields[i]['section']?.toString().trim() ?? '';
      if (section.isNotEmpty && seenSections.add(section)) {
        rows.add(_buildSectionGroupHeader(fields, section));
      }
      rows.add(_buildFieldRow(i, fields[i], indented: section.isNotEmpty));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListHeader(
          icon: Icons.view_list_rounded,
          title: 'Report Fields',
          count: fields.length,
          countLabel: 'field',
          buttonLabel: 'New Field',
          onAdd: _editField,
        ),
        context.vM,
        Expanded(
          child:
          fields.isEmpty
              ? _buildEmptyState(
            icon: Icons.view_list_outlined,
            title: 'No Fields Yet',
            subtitle: 'Click "New Field" to add your first field',
            buttonLabel: 'Add First Field',
            onAdd: _editField,
          )
              : ListView(children: rows),
        ),
      ],
    );
  }

  Widget _buildSectionGroupHeader(
      List<Map<String, dynamic>> fields,
      String sectionName,
      ) {
    final count =
        fields
            .where((f) => f['section']?.toString().trim() == sectionName)
            .length;

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _fade(context, 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: context.colors.primary, width: 3)),
      ),
      child: Row(
        children: [
          Icon(Icons.view_agenda_outlined, size: 14, color: context.colors.primary),
          const SizedBox(width: 8),
          Text(
            sectionName,
            style: _bodySmall(context, weight: FontWeight.w700, letterSpacing: 0.4),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: _fade(context, 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count field${count == 1 ? '' : 's'}',
              style: _bodySmall(context, size: 10, weight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(
      int index,
      Map<String, dynamic> field, {
        bool indented = false,
      }) {
    final type = field['fieldType']?.toString() ?? 'text';
    final label = field['labelText']?.toString() ?? '';
    final name = field['name']?.toString() ?? '';
    final isRequired = field['isRequired'] == true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (indented)
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  margin: const EdgeInsets.only(left: 13),
                  color: _fade(context, 0.18),
                ),
                Container(
                  width: 12,
                  height: 2,
                  margin: const EdgeInsets.only(left: 13),
                  color: _fade(context, 0.18),
                ),
              ],
            ),
          ),
        Expanded(
          child: InkWell(
            onTap: () => _editField(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: _rowDecoration(index, indented: indented),
              child: Row(
                children: [
                  SizedBox(width: 28, child: _IndexBadge(index: index)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      label.isNotEmpty ? label : '—',
                      style: _bodySmall(context, weight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      name.isNotEmpty ? name : '—',
                      style: _bodySmall(
                        context,
                        opacity: 0.5,
                        size: 11,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _TypeBadge(
                      label: type,
                      color: _fieldTypeStyle(type).color,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: Icon(
                        isRequired
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color:
                        isRequired
                            ? Colors.green.shade500
                            : _fade(context, 0.2),
                      ),
                    ),
                  ),
                  _RowActions(
                    onEdit: () => _editField(index),
                    onDelete: () => _deleteField(index),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatesStep(ReportFormProvider form) {
    final dates = form.dates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListHeader(
          icon: Icons.calendar_today_outlined,
          title: 'Report Type Dates',
          count: dates.length,
          countLabel: 'date',
          buttonLabel: 'New Date',
          onAdd: _editDate,
        ),
        context.vM,
        Expanded(
          child:
          dates.isEmpty
              ? _buildEmptyState(
            icon: Icons.calendar_today_outlined,
            title: 'No Date Configurations Yet',
            subtitle: 'Click "New Date" to add date tracking',
            buttonLabel: 'Add First Date',
            onAdd: _editDate,
          )
              : ListView.builder(
            itemCount: dates.length,
            itemBuilder: (_, index) => _buildDateRow(index, dates[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(int index, Map<String, dynamic> date) {
    final name = date['name']?.toString() ?? '';
    final cycle = date['applyCycle']?.toString() ?? '';

    return InkWell(
      onTap: () => _editDate(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: _rowDecoration(index),
        child: Row(
          children: [
            _IndexBadge(index: index),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                name.isNotEmpty ? name : '—',
                style: _bodySmall(context, weight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                cycle.isNotEmpty ? cycle : '—',
                style: _bodySmall(
                  context,
                  opacity: 0.5,
                  size: 11,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: _TypeBadge(label: cycle, color: _dateColor),
            ),
            if (date['isRequired'] == true) ...[
              const SizedBox(width: 6),
              _MiniBadge(label: 'Required', color: Colors.green),
            ],
            _RowActions(
              onEdit: () => _editDate(index),
              onDelete: () => _deleteDate(index),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice {
  final String id;
  final String label;
  final String? code;
  final int level;
  final Color? color;

  const _Choice({
    required this.id,
    required this.label,
    this.code,
    this.level = 0,
    this.color,
  });
}

class _SelectionDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<_Choice> choices;
  final List<String> selected;
  final bool searchable;

  const _SelectionDialog({
    required this.title,
    required this.icon,
    required this.choices,
    required this.selected,
    this.searchable = false,
  });

  @override
  State<_SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<_SelectionDialog> {
  late final List<String> _current = List<String>.from(widget.selected);
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Choice> get _visibleChoices {
    if (_query.isEmpty) return widget.choices;
    return widget.choices
        .where(
          (c) =>
      c.label.toLowerCase().contains(_query) ||
          (c.code?.toLowerCase().contains(_query) ?? false),
    )
        .toList();
  }

  void _toggle(String id) {
    setState(() {
      if (!_current.remove(id)) _current.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final choices = _visibleChoices;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.searchable ? 420 : 400,
          maxHeight: widget.searchable ? 560 : 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            if (widget.searchable) _buildSearch(context),
            Flexible(
              child:
              choices.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No categories found',
                  textAlign: TextAlign.center,
                  style: _bodySmall(context, opacity: 0.4),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: choices.length,
                itemBuilder: (_, i) => _buildChoice(context, choices[i]),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 20, color: context.colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: CommonTextField(
        controller: _searchController,
        hintText: 'Search categories…',
        style: _bodySmall(context),
        onChanged: (value) => setState(() => _query = value.toLowerCase()),
      ),
    );
  }

  Widget _buildChoice(BuildContext context, _Choice choice) {
    final isSelected = _current.contains(choice.id);

    return InkWell(
      onTap: () => _toggle(choice.id),
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0 + choice.level * 16.0,
          right: 16,
          top: 11,
          bottom: 11,
        ),
        color: isSelected ? _fade(context, 0.06) : Colors.transparent,
        child: Row(
          children: [
            _CheckMark(value: isSelected),
            const SizedBox(width: 12),
            if (choice.color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: choice.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (choice.level > 0) ...[
              Icon(
                Icons.subdirectory_arrow_right,
                size: 14,
                color: _fade(context, 0.3),
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    choice.label,
                    style: _bodySmall(
                      context,
                      color: context.colors.primary,
                      weight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (choice.code?.isNotEmpty ?? false)
                    Text(
                      choice.code!,
                      style: _bodySmall(context, opacity: 0.4, size: 11),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Text(
            '${_current.length} selected',
            style: _bodySmall(context, opacity: 0.5),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => setState(_current.clear),
            child: Text(
              'Clear all',
              style: _bodySmall(context, color: Colors.red.shade400),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_current),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _AddDateDialog extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final bool isEdit;

  const _AddDateDialog({required this.initialData, required this.isEdit});

  @override
  State<_AddDateDialog> createState() => _AddDateDialogState();
}

class _AddDateDialogState extends State<_AddDateDialog> {
  late final _nameCtrl = TextEditingController(
    text: widget.initialData['name']?.toString() ?? '',
  );
  late String _applyCycle = _safeOption(
    widget.initialData['applyCycle'],
    _applyCycleOptions,
  );
  late bool _isRequired = widget.initialData['isRequired'] == true;
  late bool _disableFreeType = widget.initialData['disableFreeType'] == true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Date name is required')));
      return;
    }

    Navigator.of(context).pop({
      'name': _nameCtrl.text.trim(),
      'applyCycle': _applyCycle,
      'isRequired': _isRequired,
      'disableFreeType': _disableFreeType,
    });
  }

  @override
  Widget build(BuildContext context) {
    return _DialogShell(
      maxWidth: 460,
      maxHeight: 440,
      header: _DialogHeader(
        title:
        widget.isEdit ? 'Edit Date Configuration' : 'Add Date Configuration',
        subtitle: 'Configure date tracking and apply cycles',
        icon: Icons.calendar_today_outlined,
        color: _dateColor,
      ),
      footer: _DialogFooter(
        previewSource: _nameCtrl,
        previewText: () => _nameCtrl.text,
        untitled: 'Untitled',
        isEdit: widget.isEdit,
        addLabel: 'Add',
        onSave: _save,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Date Details'),
          const SizedBox(height: 12),
          _DialogField(
            label: 'Date Name',
            required: true,
            child: _DialogInput(controller: _nameCtrl, hint: 'e.g. Inspection Date'),
          ),
          const SizedBox(height: 12),
          _DialogField(
            label: 'Apply Cycle',
            child: _DropdownBox(
              value: _applyCycle,
              items: _applyCycleOptions,
              dense: true,
              onChanged: (v) {
                if (v != null) setState(() => _applyCycle = v);
              },
            ),
          ),
          const SizedBox(height: 20),
          const _DialogDivider(),
          const _SectionLabel('Behaviour'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CheckChip(
                label: 'Required',
                value: _isRequired,
                onChanged: (v) => setState(() => _isRequired = v),
              ),
              _CheckChip(
                label: 'Disable Free Type',
                value: _disableFreeType,
                onChanged: (v) => setState(() => _disableFreeType = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AddFieldDialog extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final List<String> availableSections;
  final List<String> availableFieldNames;
  final bool isEdit;

  const _AddFieldDialog({
    required this.initialData,
    required this.availableSections,
    required this.availableFieldNames,
    required this.isEdit,
  });

  @override
  State<_AddFieldDialog> createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<_AddFieldDialog> {
  static const _noDefaultTextTypes = {
    'label',
    'section',
    'dropdown',
    'file',
    'checkbox',
    'checkbox_list',
  };

  late final Map<String, dynamic> _data = widget.initialData;

  late final _labelCtrl = _controller('labelText');
  late final _nameCtrl = _controller('name');
  late final _defaultValueCtrl = _controller('defaultValue');
  late final _infoTextCtrl = _controller('infoText');
  late final _permissionCtrl = _controller('permissionField');
  late final _onlyAvailableValueCtrl = _controller('onlyAvailableValue');
  late final _fileExtCtrl = _controller('fileExtensions');
  late final List<TextEditingController> _optionCtrls;

  late String _fieldType = _data['fieldType']?.toString() ?? 'text';
  late String _section = _data['section']?.toString() ?? '';
  late String _onlyAvailableField =
      _data['onlyAvailableField']?.toString() ?? '';
  late String _onlyAvailableOperator =
      _data['onlyAvailableOperator']?.toString() ?? _operatorOptions.first;
  late bool _isRequired = _data['isRequired'] == true;
  late bool _isReadOnly = _data['isReadOnly'] == true;
  late bool _doNotCopy = _data['doNotCopy'] == true;
  late bool _isArchive = _data['isArchive'] == true;
  late bool _appendPDF = _data['appendPDF'] == true;
  late bool _nameLocked = _nameCtrl.text.isNotEmpty;
  late String _checkboxDefault = _initialCheckboxDefault();

  @override
  void initState() {
    super.initState();
    final options = _initialOptions();
    _optionCtrls =
    options.isNotEmpty
        ? options.map((v) => TextEditingController(text: v)).toList()
        : [TextEditingController()];

    if (!widget.isEdit) _labelCtrl.addListener(_autoFillName);
  }

  @override
  void dispose() {
    for (final ctrl in [
      _labelCtrl,
      _nameCtrl,
      _defaultValueCtrl,
      _infoTextCtrl,
      _permissionCtrl,
      _onlyAvailableValueCtrl,
      _fileExtCtrl,
      ..._optionCtrls,
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String key) =>
      TextEditingController(text: _data[key]?.toString() ?? '');

  String _initialCheckboxDefault() {
    final raw = _data['defaultValue']?.toString().toLowerCase().trim() ?? '';
    return (raw == 'true' || raw == '1') ? 'true' : 'false';
  }

  List<String> _initialOptions() {
    var raw = _data['options']?.toString() ?? '';
    if (raw.isEmpty) {
      final dv = _data['defaultValue'];
      if (dv is Map && dv['options'] is List) raw = _joinCsv(dv['options']);
    }
    return _splitCsv(raw);
  }

  void _autoFillName() {
    if (_nameLocked) return;

    final suggested = _labelCtrl.text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s_]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    _nameCtrl.value = TextEditingValue(
      text: suggested,
      selection: TextSelection.collapsed(offset: suggested.length),
    );
  }

  bool get _hasOptions =>
      _fieldType == 'dropdown' || _fieldType == 'checkbox_list';

  void _addOption() =>
      setState(() => _optionCtrls.add(TextEditingController()));

  void _removeOption(int index) =>
      setState(() => _optionCtrls.removeAt(index).dispose());

  void _moveOption(int from, int to) {
    setState(() => _optionCtrls.insert(to, _optionCtrls.removeAt(from)));
  }

  Map<String, dynamic> _buildResult() {
    final onlyAvailableValue = _onlyAvailableValueCtrl.text.trim();

    return {
      'labelText': _labelCtrl.text.trim(),
      'name': _nameCtrl.text.trim(),
      'fieldType': _fieldType,
      'defaultValue':
      _fieldType == 'checkbox'
          ? _checkboxDefault
          : _defaultValueCtrl.text.trim(),
      'section': _section,
      'onlyAvailable':
      _onlyAvailableField.isNotEmpty
          ? '$_onlyAvailableField$_onlyAvailableOperator$onlyAvailableValue'
          : '',
      'onlyAvailableField': _onlyAvailableField,
      'onlyAvailableOperator': _onlyAvailableOperator,
      'onlyAvailableValue': onlyAvailableValue,
      'isRequired': _isRequired,
      'isReadOnly': _isReadOnly,
      'permissionField': _permissionCtrl.text.trim(),
      'doNotCopy': _doNotCopy,
      'infoText': _infoTextCtrl.text.trim(),
      'isArchive': _isArchive,
      'appendPDF': _appendPDF,
      'fileExtensions': _fileExtCtrl.text.trim(),
      'options': _hasOptions ? _joinCsv(_optionCtrls.map((c) => c.text)) : '',
    };
  }

  void _save() {
    String? error;
    if (_labelCtrl.text.trim().isEmpty) {
      error = 'Label Text is required';
    } else if (_nameCtrl.text.trim().isEmpty) {
      error = 'Name is required';
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pop(_buildResult());
  }

  @override
  Widget build(BuildContext context) {
    final typeStyle = _fieldTypeStyle(_fieldType);
    final showDefaultText = !_noDefaultTextTypes.contains(_fieldType);

    return _DialogShell(
      maxWidth: 680,
      maxHeight: 700,
      header: _DialogHeader(
        title: widget.isEdit ? 'Edit Field' : 'Add Field',
        subtitle: '$_fieldType field',
        icon: typeStyle.icon,
        color: typeStyle.color,
      ),
      footer: _DialogFooter(
        previewSource: _labelCtrl,
        previewText: () => _labelCtrl.text,
        untitled: 'Untitled field',
        isEdit: widget.isEdit,
        addLabel: 'Add Field',
        onSave: _save,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Basic Info'),
          const SizedBox(height: 12),
          _buildBasicInfoRow(context),
          const SizedBox(height: 16),
          _DialogField(label: 'Field Type', child: _buildTypePills()),
          const SizedBox(height: 20),
          const _DialogDivider(),
          const _SectionLabel('Visibility'),
          const SizedBox(height: 12),
          _buildVisibilityRow(),
          if (_onlyAvailableField.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildConditionPreview(context),
          ],
          const SizedBox(height: 20),
          const _DialogDivider(),
          const _SectionLabel('Behaviour'),
          const SizedBox(height: 12),
          _buildBehaviourChips(),
          const SizedBox(height: 20),
          const _DialogDivider(),
          const _SectionLabel('Details'),
          const SizedBox(height: 12),
          _buildDetailsRow(showDefaultText),
          if (_hasOptions) ...[
            const SizedBox(height: 20),
            const _DialogDivider(),
            _SectionLabel(
              _fieldType == 'dropdown' ? 'Dropdown Options' : 'Checkbox Items',
            ),
            const SizedBox(height: 12),
            _buildOptionsEditor(context),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBasicInfoRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DialogField(
            label: 'Label Text',
            required: true,
            child: _DialogInput(
              controller: _labelCtrl,
              hint: 'e.g. Customer Name',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DialogField(
            label: 'Field Name',
            required: true,
            trailing: GestureDetector(
              onTap: () => setState(() => _nameLocked = !_nameLocked),
              child: Tooltip(
                message: _nameLocked ? 'Unlock auto-fill' : 'Lock name',
                child: Icon(
                  _nameLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                  size: 14,
                  color:
                  _nameLocked ? context.colors.primary : Colors.grey.shade400,
                ),
              ),
            ),
            child: _DialogInput(
              controller: _nameCtrl,
              hint: 'customer_name',
              monospace: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypePills() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final entry in _fieldTypeStyles.entries)
          _buildTypePill(entry.key, entry.value),
      ],
    );
  }

  Widget _buildTypePill(String type, _FieldTypeStyle style) {
    final isOn = _fieldType == type;

    return GestureDetector(
      onTap: () => setState(() => _fieldType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isOn ? style.color.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOn ? style.color.withOpacity(0.4) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(style.icon, size: 12, color: style.color),
            const SizedBox(width: 5),
            Text(
              type,
              style: TextStyle(
                fontSize: 12,
                color: isOn ? style.color : Colors.grey.shade600,
                fontWeight: isOn ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityRow() {
    final sections = ['', ...widget.availableSections];
    final fieldNames = ['', ...widget.availableFieldNames];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DialogField(
            label: 'Section',
            child: _DropdownBox(
              value: sections.contains(_section) ? _section : '',
              items: sections,
              dense: true,
              displayLabel: (s) => s.isEmpty ? '(none)' : s,
              onChanged: (v) {
                if (v != null) setState(() => _section = v);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _DialogField(
            label: 'Only Available If',
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _DropdownBox(
                    value: fieldNames.contains(_onlyAvailableField)
                        ? _onlyAvailableField
                        : '',
                    items: fieldNames,
                    dense: true,
                    displayLabel: (s) => s.isEmpty ? 'Field…' : s,
                    onChanged: (v) {
                      if (v != null) setState(() => _onlyAvailableField = v);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _DropdownBox(
                    value: _safeOption(_onlyAvailableOperator, _operatorOptions),
                    items: _operatorOptions,
                    dense: true,
                    onChanged: (v) {
                      if (v != null) setState(() => _onlyAvailableOperator = v);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: _DialogInput(
                    controller: _onlyAvailableValueCtrl,
                    hint: 'Value…',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionPreview(BuildContext context) {
    final value = _onlyAvailableValueCtrl.text;
    const bold = TextStyle(fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _fade(context, 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fade(context, 0.12)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 13,
            color: context.colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: _bodySmall(context, opacity: 0.7, fontFamily: 'monospace'),
                children: [
                  const TextSpan(text: 'Show when '),
                  TextSpan(text: _onlyAvailableField, style: bold),
                  TextSpan(text: ' $_onlyAvailableOperator '),
                  TextSpan(text: value.isNotEmpty ? value : '…', style: bold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviourChips() {
    final chips = <(String, bool, ValueChanged<bool>)>[
      ('Required', _isRequired, (v) => setState(() => _isRequired = v)),
      ('Read Only', _isReadOnly, (v) => setState(() => _isReadOnly = v)),
      ('Do Not Copy', _doNotCopy, (v) => setState(() => _doNotCopy = v)),
      ('Archive', _isArchive, (v) => setState(() => _isArchive = v)),
      if (_fieldType == 'file')
        ('Append PDF', _appendPDF, (v) => setState(() => _appendPDF = v)),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final chip in chips)
          _CheckChip(label: chip.$1, value: chip.$2, onChanged: chip.$3),
      ],
    );
  }

  Widget _buildDetailsRow(bool showDefaultText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DialogField(
            label: 'Permission Groups',
            child: _DialogInput(
              controller: _permissionCtrl,
              hint: 'Default (usergroup)',
            ),
          ),
        ),
        if (_fieldType == 'checkbox')
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _DialogField(
                label: 'Default Value',
                child: _buildCheckboxDefaultToggle(),
              ),
            ),
          ),
        if (showDefaultText)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _DialogField(
                label: 'Default Value',
                child: _DialogInput(controller: _defaultValueCtrl, hint: 'e.g. N/A'),
              ),
            ),
          ),
        if (_fieldType == 'file')
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _DialogField(
                label: 'File Extensions',
                child: _DialogInput(controller: _fileExtCtrl, hint: 'pdf,jpg,png'),
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _DialogField(
              label: 'Info / Help Text',
              child: _DialogInput(
                controller: _infoTextCtrl,
                maxLines: 3,
                hint: 'Help text shown to users…',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxDefaultToggle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _checkboxColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          children: [
            _buildCheckboxDefaultTile(
              'Unchecked (false)',
              'false',
              Icons.check_box_outline_blank,
            ),
            Divider(height: 1, color: _checkboxColor.withOpacity(0.12)),
            _buildCheckboxDefaultTile(
              'Checked (true)',
              'true',
              Icons.check_box_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxDefaultTile(String label, String value, IconData icon) {
    final selected = _checkboxDefault == value;

    return InkWell(
      onTap: () => setState(() => _checkboxDefault = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        color: selected ? _checkboxColor.withOpacity(0.06) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? _checkboxColor : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: _bodySmall(
                  context,
                  opacity: 0.5,
                  color: selected ? _checkboxColor : null,
                  weight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 16,
              color: selected ? _checkboxColor : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsEditor(BuildContext context) {
    final isList = _fieldType == 'checkbox_list';
    final accent = isList ? _checkboxListColor : context.colors.primary;
    final count = _optionCtrls.length;
    final noun = isList ? 'item' : 'option';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$count $noun${count == 1 ? '' : 's'}',
              style: _bodySmall(context, opacity: 0.5),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addOption,
              icon: Icon(
                isList ? Icons.add_task_outlined : Icons.add_rounded,
                size: 14,
                color: accent,
              ),
              label: Text(
                isList ? 'Add Item' : 'Add Option',
                style: _bodySmall(context, color: accent, weight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_optionCtrls.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.03),
              border: Border.all(color: accent.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 15, color: accent.withOpacity(0.5)),
                const SizedBox(width: 8),
                Text(
                  'No items yet. Add at least one checkbox item.',
                  style: _bodySmall(
                    context,
                    color: accent.withOpacity(0.55),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          )
        else
          for (var i = 0; i < _optionCtrls.length; i++)
            _buildOptionRow(context, i, isList: isList, accent: accent),
      ],
    );
  }

  Widget _buildOptionRow(
      BuildContext context,
      int index, {
        required bool isList,
        required Color accent,
      }) {
    final canRemove = isList || _optionCtrls.length > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              shape: isList ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isList ? BorderRadius.circular(4) : null,
              border: isList ? Border.all(color: accent.withOpacity(0.3)) : null,
            ),
            child:
            isList
                ? Icon(Icons.check_box_outline_blank, size: 14, color: accent)
                : Text(
              '${index + 1}',
              style: _bodySmall(
                context,
                color: accent,
                size: 10,
                weight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DialogInput(
              controller: _optionCtrls[index],
              hint: isList ? 'Item label ${index + 1}' : 'Option ${index + 1}',
            ),
          ),
          const SizedBox(width: 6),
          if (isList && index > 0)
            _MiniIconButton(
              icon: Icons.arrow_upward,
              color: _fade(context, 0.4),
              onTap: () => _moveOption(index, index - 1),
            ),
          if (isList && index < _optionCtrls.length - 1)
            _MiniIconButton(
              icon: Icons.arrow_downward,
              color: _fade(context, 0.4),
              onTap: () => _moveOption(index, index + 1),
            ),
          if (canRemove)
            _MiniIconButton(
              icon: Icons.close_rounded,
              color: Colors.red.shade400,
              onTap: () => _removeOption(index),
            ),
        ],
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PickerBox({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _fade(context, 0.25)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: _fade(context, 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  final IconData? icon;
  final bool tinted;

  const _RemovableChip({
    required this.label,
    required this.onRemove,
    this.icon,
    this.tinted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 6, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: tinted ? _fade(context, 0.08) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: tinted ? _fade(context, 0.25) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: _fade(context, 0.6)),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: _bodySmall(
              context,
              color: context.colors.primary,
              size: 11,
              weight: FontWeight.w600,
              letterSpacing: tinted ? null : 0.3,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(10),
            child: Icon(Icons.close_rounded, size: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String Function(String)? displayLabel;
  final bool dense;

  const _DropdownBox({
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayLabel,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = _bodySmall(context, color: context.colors.primary);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _fade(context, 0.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          isDense: dense,
          style: style,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: dense ? 16 : 18,
            color: _fade(context, 0.5),
          ),
          items: [
            for (final item in items)
              DropdownMenuItem<String>(
                value: item,
                child: Text(
                  displayLabel?.call(item) ?? item,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool compact;

  const _AddButton({
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add_rounded, size: compact ? 16 : 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding:
        compact
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  final bool value;
  final double size;
  final double radius;
  final double iconSize;

  const _CheckMark({
    required this.value,
    this.size = 18,
    this.radius = 4,
    this.iconSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value ? primary : Colors.transparent,
        border: Border.all(color: value ? primary : Colors.grey.shade400),
        borderRadius: BorderRadius.circular(radius),
      ),
      child:
      value
          ? Icon(Icons.check_rounded, size: iconSize, color: Colors.white)
          : null,
    );
  }
}

class _CheckChip extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? primary.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value ? primary.withOpacity(0.35) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CheckMark(value: value, size: 14, radius: 3, iconSize: 9),
            const SizedBox(width: 7),
            Text(
              label,
              style: _bodySmall(
                context,
                color: value ? primary : Colors.grey.shade600,
                weight: value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              label.isNotEmpty ? label : '—',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  final int index;

  const _IndexBadge({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _fade(context, 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '${index + 1}',
        style: _bodySmall(
          context,
          color: context.colors.primary,
          size: 10,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RowActions({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: 'Edit',
            child: _MiniIconButton(
              icon: Icons.edit_outlined,
              color: context.colors.primary,
              onTap: onEdit,
              padding: 5,
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          Tooltip(
            message: 'Delete',
            child: _MiniIconButton(
              icon: Icons.delete_outline_rounded,
              color: Colors.red,
              onTap: onDelete,
              padding: 5,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double padding;
  final double size;

  const _MiniIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.padding = 4,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}

class _DialogShell extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final double maxWidth;
  final double maxHeight;

  const _DialogShell({
    required this.header,
    required this.body,
    required this.footer,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      elevation: 16,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Column(
          children: [
            header,
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: body,
              ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: _bodySmall(context, opacity: 0.45)),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogFooter extends StatelessWidget {
  final Listenable previewSource;
  final String Function() previewText;
  final String untitled;
  final bool isEdit;
  final String addLabel;
  final VoidCallback onSave;

  const _DialogFooter({
    required this.previewSource,
    required this.previewText,
    required this.untitled,
    required this.isEdit,
    required this.addLabel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: previewSource,
              builder: (_, __) {
                final text = previewText();
                return Text(
                  text.isNotEmpty ? text : untitled,
                  style: _bodySmall(context, opacity: 0.35),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancel',
              style: _bodySmall(
                context,
                color: Colors.grey.shade600,
                weight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onSave,
            icon: Icon(isEdit ? Icons.check_rounded : Icons.add_rounded, size: 15),
            label: Text(
              isEdit ? 'Save' : addLabel,
              style: _bodySmall(
                context,
                color: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.topology.textTheme.labelLarge?.copyWith(
            color: primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _DialogDivider extends StatelessWidget {
  const _DialogDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFF0F0F0),
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}

class _DialogField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;
  final Widget? trailing;

  const _DialogField({
    required this.label,
    required this.child,
    this.required = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: _bodySmall(
                  context,
                  opacity: 0.7,
                  weight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _DialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final bool monospace;

  const _DialogInput({
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: hint,
      maxLines: maxLines,
      style: _bodySmall(
        context,
        color: context.colors.primary,
        fontFamily: monospace ? 'monospace' : null,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 11,
        vertical: maxLines > 1 ? 10 : 9,
      ),
    );
  }
}