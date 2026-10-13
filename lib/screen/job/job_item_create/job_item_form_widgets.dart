import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_item_create_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/screen/job/job_item_create/applicable_code_dialog.dart';
import 'package:inspect/screen/job/job_item_create/category_selection_dialog.dart';
import 'package:inspect/screen/job/job_item_create/job_form_style.dart';
import 'package:inspect/screen/job/job_item_create/job_item_form_models.dart';
import 'package:inspect/screen/job/job_item_create/job_item_mapper.dart';
import 'package:inspect/screen/job/job_item_create/job_location_picker_dialog.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

const _fieldIcons = <String, IconData>{
  'Text': Icons.text_fields,
  'Multi-Line Textbox': Icons.text_fields,
  'Numeric': Icons.pin,
  'Decimal': Icons.pin,
  'Date': Icons.calendar_today,
  'Boolean': Icons.check_box_outlined,
  'Checklist Item': Icons.checklist_outlined,
  'Dropdown': Icons.arrow_drop_down_circle,
  'Override Dropdown': Icons.arrow_drop_down_circle,
  'Conditional Dropdown': Icons.arrow_drop_down_circle,
  'Site Dropdown': Icons.arrow_drop_down_circle,
  'File': Icons.attach_file,
  'Signature': Icons.edit,
  'Colour Picker': Icons.palette,
  'ItemNo': Icons.tag,
  'ItemDescription': Icons.description,
  'Customer': Icons.person,
  'SiteID': Icons.location_city,
  'ItemCategory': Icons.category,
  'ItemLocation': Icons.location_on_outlined,
  'Location': Icons.location_on_outlined,
  'DetailedLocation': Icons.my_location,
  'RFIDNo': Icons.nfc,
  'LatestPhoto': Icons.photo_camera,
  'ApplicableCode': Icons.gavel_outlined,
};

class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader(this.title, this.icon, {super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.tint(0.05),
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
}

class FormFieldRow extends StatelessWidget {
  const FormFieldRow({
    super.key,
    required this.label,
    required this.child,
    this.icon,
    this.isRequired = false,
    this.centered = false,
  });

  final String label;
  final Widget child;
  final IconData? icon;
  final bool isRequired;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: context.tint(0.7)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: centered ? 0 : 12),
                  child: Text(
                    isRequired ? '$label *' : label,
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
}

class JobItemFormHeader extends StatelessWidget {
  const JobItemFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ItemNoSection(),
        context.vL,
        const FormSectionHeader('Category', Icons.category),
        context.vM,
        const CategoryRow(),
        context.vL,
      ],
    );
  }
}

class EmptyFields extends StatelessWidget {
  const EmptyFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'No fields available. Please select a category.',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class FormFieldSections extends StatelessWidget {
  const FormFieldSections(this.sections, {super.key});

  final Iterable<MapEntry<String, List<JobFormField>>> sections;

  static const _icons = <String, IconData>{
    'Basic Information': Icons.info_outline,
    'Location Details': Icons.location_on,
    'Manufacturer Information': Icons.factory,
    'Other': Icons.extension,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in sections) ...[
          FormSectionHeader(entry.key, _icons[entry.key] ?? Icons.info_outline),
          context.vM,
          for (final field in entry.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DynamicField(field),
            ),
          context.vL,
        ],
      ],
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JobItemCreateProvider>();
    return FormFieldRow(
      label: 'Category',
      icon: Icons.category,
      isRequired: true,
      child: GestureDetector(
        onTap:
            () => showDialog<void>(
              context: context,
              builder:
                  (_) => CategorySelectionDialog(
                    selectedCategory: p.selectedCategory,
                    onCategorySelected: p.selectCategory,
                  ),
            ),
        child: AbsorbPointer(
          child: CommonTextField(
            controller: p.categoryController,
            hintText: 'Select a category',
            style: context.fieldStyle,
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: context.colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class ItemNoSection extends StatelessWidget {
  const ItemNoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JobItemCreateProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionHeader('Item No', Icons.tag),
        context.vM,
        _ModeTabs(selected: p.itemNoMode, onSelected: p.setItemNoMode),
        context.vM,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(
            key: ValueKey(p.itemNoMode),
            child: switch (p.itemNoMode) {
              ItemNoCreationMode.singleItem => _ItemNoInput(
                controller: p.singleItemNoController,
                generate: p.generateItemNo,
                onGenerateChanged: p.setGenerateItemNo,
              ),
              ItemNoCreationMode.batchCreation => _BatchFields(p),
              ItemNoCreationMode.batchCreationManual => _ItemNoInput(
                controller: p.manualItemNoController,
                generate: p.manualGenerateItemNo,
                onGenerateChanged: p.setManualGenerateItemNo,
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.selected, required this.onSelected});

  final ItemNoCreationMode selected;
  final ValueChanged<ItemNoCreationMode> onSelected;

  static const _labels = {
    ItemNoCreationMode.singleItem: 'Single Item',
    ItemNoCreationMode.batchCreation: 'Batch Creation',
    ItemNoCreationMode.batchCreationManual: 'Batch Creation (Manual)',
  };

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in _labels.entries)
            GestureDetector(
              onTap: () => onSelected(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: entry.key == selected ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: entry.key == selected ? primary : context.tint(0.3),
                    width: entry.key == selected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: context.topology.textTheme.labelMedium?.copyWith(
                    color:
                        entry.key == selected ? Colors.white : context.tint(0.7),
                    fontWeight:
                        entry.key == selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemNoInput extends StatelessWidget {
  const _ItemNoInput({
    required this.controller,
    required this.generate,
    required this.onGenerateChanged,
  });

  final TextEditingController controller;
  final bool generate;
  final ValueChanged<bool> onGenerateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        CommonTextField(
          controller: controller,
          hintText: '',
          enabled: !generate,
          style: context.fieldStyle,
          suffixIcon:
              generate
                  ? Icon(Icons.auto_fix_high, size: 16, color: context.tint(0.4))
                  : null,
        ),
        _GenerateCheckbox(value: generate, onChanged: onGenerateChanged),
      ],
    );
  }
}

class _BatchFields extends StatelessWidget {
  const _BatchFields(this.p);

  final JobItemCreateProvider p;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _LabeledInput('Numbering Template', p.batchTemplateController),
        _LabeledInput(
          'Create From',
          p.batchFromController,
          keyboardType: TextInputType.number,
        ),
        _LabeledInput(
          'To',
          p.batchToController,
          keyboardType: TextInputType.number,
        ),
        Row(
          spacing: 20,
          children: [
            _GenerateCheckbox(
              value: p.batchGenerateItemNo,
              onChanged: p.setBatchGenerateItemNo,
            ),
            Expanded(
              child: _LabeledInput(
                'Number to Generate',
                p.batchCountController,
                keyboardType: TextInputType.number,
                enabled: p.batchGenerateItemNo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LabeledInput extends StatelessWidget {
  const _LabeledInput(
    this.label,
    this.controller, {
    this.keyboardType,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.tint(0.8),
          ),
        ),
        CommonTextField(
          controller: controller,
          hintText: '',
          enabled: enabled,
          keyboardType: keyboardType,
          style: context.fieldStyle,
        ),
      ],
    );
  }
}

class _GenerateCheckbox extends StatelessWidget {
  const _GenerateCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: context.colors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Generate Item No',
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Tooltip(
          message:
              'When checked, an Item No will be automatically generated '
              'based on the configured numbering template.',
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(Icons.help_outline, size: 16, color: context.tint(0.55)),
        ),
      ],
    );
  }
}

class DynamicField extends StatelessWidget {
  const DynamicField(this.field, {super.key});

  final JobFormField field;

  @override
  Widget build(BuildContext context) {
    if (field.isItemNo) return const SizedBox.shrink();

    final p = context.watch<JobItemCreateProvider>();
    final input = _input(context, p);
    if (input == null) return const SizedBox.shrink();

    return FormFieldRow(
      label: field.label,
      icon:
          field.isApplicableCode
              ? Icons.gavel_outlined
              : _fieldIcons[field.type] ?? Icons.input,
      isRequired: field.isRequired,
      centered:
          field.type == 'Boolean' || field.isLocation || field.isApplicableCode,
      child: input,
    );
  }

  Widget? _input(BuildContext context, JobItemCreateProvider p) {
    if (field.isFile) {
      final controller = p.fileControllers[field.id];
      return controller == null
          ? null
          : CommonFileUploadInput(
            controller: controller,
            isRequired: field.isRequired,
            enableCamera: true,
          );
    }

    final c = p.fieldControllers[field.id];
    if (c == null) return null;

    if (field.isApplicableCode) {
      return _PickerInput(
        controller: c,
        icon: Icons.gavel_outlined,
        hint: 'Select or enter applicable code',
        onTap:
            () => showApplicableCodeDialog(
              context: context,
              controller: c,
              codes: field.options,
            ),
      );
    }

    if (field.isLocation) {
      return _PickerInput(
        controller: c,
        icon: Icons.location_on_outlined,
        hint: 'Select or add location',
        onTap:
            () => showJobLocationPickerDialog(
              context: context,
              controller: c,
              jobItemId: p.jobId,
            ),
      );
    }

    if (JobFormField.dropdownTypes.contains(field.type)) {
      return _StringDropdown(
        value: c.text,
        items:
            field.options.isEmpty
                ? const ['Option 1', 'Option 2', 'Option 3']
                : field.options,
        onChanged: (v) => p.setFieldText(c, v),
      );
    }

    switch (field.type) {
      case 'Customer':
        return Consumer<JobProvider>(
          builder:
              (_, jobProvider, __) => _StringDropdown(
                value: c.text,
                items:
                    jobProvider.customers
                        .map((e) => e.customername)
                        .whereType<String>()
                        .where((name) => name.isNotEmpty)
                        .toList(),
                onChanged: (v) => p.setFieldText(c, v),
              ),
        );
      case 'SiteID':
        return Consumer<SiteProvider>(
          builder:
              (_, siteProvider, __) => _StringDropdown(
                value: c.text,
                items:
                    siteProvider.sites
                        .map((e) => e.siteName)
                        .whereType<String>()
                        .where((name) => name.isNotEmpty)
                        .toList(),
                onChanged: (v) => p.setFieldText(c, v),
              ),
        );
      case 'ItemCategory':
        return Consumer<CategoryProvider>(
          builder:
              (_, categoryProvider, __) => _StringDropdown(
                value: c.text,
                items:
                    _flatten(
                      categoryProvider.filteredCategories,
                    ).map((e) => e.name).toList(),
                onChanged: (v) => p.setFieldText(c, v),
              ),
        );
      case 'Date':
        return CommonDatePickerInput(
          label: '',
          controller: c,
          isRequired: field.isRequired,
        );
      case 'Boolean':
        return Align(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            value: c.text.toLowerCase() == 'true',
            onChanged: (v) => p.setFieldText(c, '${v ?? false}'),
            activeColor: context.colors.primary,
          ),
        );
      case 'Checklist Item':
        return _ChecklistInput(controller: c, options: field.options);
      default:
        return CommonTextField(
          controller: c,
          maxLines: field.type == 'Multi-Line Textbox' ? 3 : 1,
          style: context.fieldStyle,
        );
    }
  }
}

Iterable<CategoryItem> _flatten(List<CategoryItem> items) sync* {
  for (final item in items) {
    yield item;
    yield* _flatten(item.children);
  }
}

class _StringDropdown extends StatelessWidget {
  const _StringDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CommonDropdown<String>(
      value: items.contains(value) ? value : null,
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: context.fieldStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
      onChanged: (v) => onChanged(v ?? ''),
      borderColor: context.tint(0.3),
      borderWidth: 1.0,
      borderRadius: 8.0,
    );
  }
}

class _PickerInput extends StatelessWidget {
  const _PickerInput({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.onTap,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (_, value, __) {
          final hasValue = value.text.trim().isNotEmpty;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: hasValue ? primary : context.tint(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: hasValue ? context.tint(0.05) : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: hasValue ? primary : context.tint(0.4),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasValue ? value.text : hint,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: hasValue ? primary : context.tint(0.4),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValue)
                  GestureDetector(
                    onTap: controller.clear,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.close, size: 15, color: context.tint(0.5)),
                    ),
                  )
                else
                  Icon(Icons.arrow_drop_down, color: context.tint(0.6)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChecklistInput extends StatelessWidget {
  const _ChecklistInput({required this.controller, required this.options});

  final TextEditingController controller;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return CommonTextField(controller: controller, style: context.fieldStyle);
    }

    final p = context.read<JobItemCreateProvider>();
    final checked = JobItemMapper.checkedOptions(controller.text);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.tint(0.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          children: [
            for (final (index, option) in options.indexed) ...[
              if (index > 0) Divider(height: 1, color: context.tint(0.1)),
              _ChecklistTile(
                option: option,
                isChecked: checked.contains(option),
                onTap: () => p.toggleChecklistOption(controller, option),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.option,
    required this.isChecked,
    required this.onTap,
  });

  final String option;
  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isChecked ? primary : Colors.transparent,
                border: Border.all(
                  color: isChecked ? primary : context.tint(0.35),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  isChecked
                      ? const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      )
                      : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option,
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: isChecked ? primary : context.tint(0.7),
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
