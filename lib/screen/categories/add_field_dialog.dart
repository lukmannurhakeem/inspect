
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/field_model/field_model.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/widget/common__checklist_tile.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class AddFieldDialog extends StatefulWidget {
  const AddFieldDialog({Key? key}) : super(key: key);

  @override
  State<AddFieldDialog> createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<AddFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelTextController = TextEditingController();
  final _nameController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  final _conditionalSourceController = TextEditingController();
  final _conditionalValueController = TextEditingController();
  final _minValueController = TextEditingController();
  final _maxValueController = TextEditingController();
  final _stepValueController = TextEditingController();
  final _decimalPlacesController = TextEditingController();

  String _selectedFieldType = 'Text';
  bool _isReadOnly = false;
  bool _isRequired = false;
  String _selectedSection = '';
  String _conditionalOperator = 'equals';

  // Tracks whether the user has manually edited the Name field
  bool _nameManuallyEdited = false;

  // For dropdown options
  final List<String> _dropdownOptions = [];
  final _dropdownOptionController = TextEditingController();

  // For location options
  final List<String> _locationOptions = [];
  final _locationOptionController = TextEditingController();

  // For applicable code options
  final List<String> _applicableCodeOptions = [];
  final _applicableCodeOptionController = TextEditingController();

  // For checklist options
  final List<String> _checklistOptions = [];
  final _checklistOptionController = TextEditingController();

  // ─── Auto-populate helpers ───────────────────────────────────────────────

  /// Converts "Item No" → "ItemNo", "detailed location" → "DetailedLocation"
  String _toLabelCase(String input) {
    return input
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }

  void _onLabelTextChanged() {
    if (!_nameManuallyEdited) {
      final autoName = _toLabelCase(_labelTextController.text);
      // Only update if the value actually changed to avoid cursor jumps
      if (_nameController.text != autoName) {
        _nameController.text = autoName;
        // Move cursor to end
        _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _nameController.text.length),
        );
      }
    }
  }

  void _onNameChanged() {
    // If the user types something that doesn't match the auto-generated value,
    // stop overwriting their input.
    final autoName = _toLabelCase(_labelTextController.text);
    if (_nameController.text != autoName) {
      _nameManuallyEdited = true;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _labelTextController.addListener(_onLabelTextChanged);
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _labelTextController.removeListener(_onLabelTextChanged);
    _nameController.removeListener(_onNameChanged);
    _labelTextController.dispose();
    _nameController.dispose();
    _defaultValueController.dispose();
    _fileExtensionController.dispose();
    _conditionalSourceController.dispose();
    _conditionalValueController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _stepValueController.dispose();
    _decimalPlacesController.dispose();
    _dropdownOptionController.dispose();
    _locationOptionController.dispose();
    _applicableCodeOptionController.dispose();
    _checklistOptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // For Location type, validate at least one location is added
      if (_selectedFieldType == 'Location' && _locationOptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one location option.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // For Checklist Item type, validate at least one item is added
      if (_selectedFieldType == 'Checklist Item' && _checklistOptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one checklist item.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // ApplicableCode: options are optional (user can type custom codes at runtime)
      // No mandatory validation needed.

      final field = FieldModel(
        id: '',
        labelText: _labelTextController.text.trim(),
        name: _nameController.text.trim(),
        fieldType: _selectedFieldType,
        defaultValue: _defaultValueController.text.trim(),
        isReadOnly: _isReadOnly,
        required: _isRequired,
        section: _selectedSection,
        dropdownOptions:
            _selectedFieldType == 'Location'
                ? (_locationOptions.isNotEmpty
                    ? List.from(_locationOptions)
                    : null)
                : _selectedFieldType == 'ApplicableCode'
                ? (_applicableCodeOptions.isNotEmpty
                    ? List.from(_applicableCodeOptions)
                    : null)
                : _selectedFieldType == 'Checklist Item'
                ? (_checklistOptions.isNotEmpty
                    ? List.from(_checklistOptions)
                    : null)
                : (_dropdownOptions.isNotEmpty
                    ? List.from(_dropdownOptions)
                    : null),
        fileExtension:
            _fileExtensionController.text.trim().isNotEmpty
                ? _fileExtensionController.text.trim()
                : null,
        conditionalSource:
            _conditionalSourceController.text.trim().isNotEmpty
                ? _conditionalSourceController.text.trim()
                : null,
        conditionalOperator: _conditionalOperator,
        conditionalValue:
            _conditionalValueController.text.trim().isNotEmpty
                ? _conditionalValueController.text.trim()
                : null,
        minValue: double.tryParse(_minValueController.text.trim()),
        maxValue: double.tryParse(_maxValueController.text.trim()),
        stepValue: double.tryParse(_stepValueController.text.trim()),
        decimalPlaces: int.tryParse(_decimalPlacesController.text.trim()),
      );

      context.read<CategoryProvider>().addField(field);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildFieldTypeSpecificOptions() {
    switch (_selectedFieldType) {
      case 'Dropdown':
      case 'Override Dropdown':
        return _buildDropdownOptions();

      case 'Conditional Dropdown':
        return _buildConditionalDropdownOptions();

      case 'File':
        return _buildFileOptions();

      case 'Numeric':
        return _buildNumericOptions();

      case 'Decimal':
        return _buildDecimalOptions();

      case 'Checklist Item':
        return _buildChecklistOptions();

      case 'Location':
        return _buildLocationOptions();

      case 'ApplicableCode':
        return _buildApplicableCodeOptions();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDropdownOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.vS,
        Text(
          'Dropdown Options',
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _dropdownOptionController,
                hintText: 'Enter option',
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (_dropdownOptionController.text.trim().isNotEmpty) {
                  setState(() {
                    _dropdownOptions.add(_dropdownOptionController.text.trim());
                    _dropdownOptionController.clear();
                  });
                }
              },
            ),
          ],
        ),
        if (_dropdownOptions.isNotEmpty) ...[
          context.vXs,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _dropdownOptions.map((option) {
                  return Chip(
                    label: Text(option),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _dropdownOptions.remove(option);
                      });
                    },
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionalDropdownOptions() {
    return Column(
      children: [
        context.vS,
        CommonTextField(
          controller: _conditionalSourceController,
          hintText: 'Condition Source Field',
        ),
        context.vS,
        CommonDropdown(
          value: _conditionalOperator,
          items: const [
            DropdownMenuItem(value: 'equals', child: Text('Equals')),
            DropdownMenuItem(value: 'not_equals', child: Text('Not Equals')),
            DropdownMenuItem(value: 'contains', child: Text('Contains')),
            DropdownMenuItem(
              value: 'greater_than',
              child: Text('Greater Than'),
            ),
            DropdownMenuItem(value: 'less_than', child: Text('Less Than')),
          ],
          onChanged: (value) {
            setState(() {
              _conditionalOperator = value!;
            });
          },
        ),
        context.vS,
        CommonTextField(
          controller: _conditionalValueController,
          hintText: 'Condition Value',
        ),
        _buildDropdownOptions(),
      ],
    );
  }

  Widget _buildFileOptions() {
    return Column(
      children: [
        context.vS,
        CommonTextField(
          controller: _fileExtensionController,
          hintText: 'File Extension (e.g., .pdf, .jpg)',
        ),
      ],
    );
  }

  Widget _buildNumericOptions() {
    return Column(
      children: [
        context.vS,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _minValueController,
                hintText: 'Min Value',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextField(
                controller: _maxValueController,
                hintText: 'Max Value',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        context.vS,
        CommonTextField(
          controller: _stepValueController,
          hintText: 'Step Value',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildDecimalOptions() {
    return Column(
      children: [
        context.vS,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _minValueController,
                hintText: 'Min Value',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextField(
                controller: _maxValueController,
                hintText: 'Max Value',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),
        context.vS,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _stepValueController,
                hintText: 'Step Value',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextField(
                controller: _decimalPlacesController,
                hintText: 'Decimal Places',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Checklist Options — each item is a named checkbox value (like dropdown)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildChecklistOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.vS,
        Text(
          'Checklist Items',
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,

        // Input row
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _checklistOptionController,
                hintText: 'Enter checklist item (e.g. Valve OK)',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.add_task_outlined,
                color: context.colors.primary,
              ),
              tooltip: 'Add item',
              onPressed: _addChecklistOption,
            ),
          ],
        ),

        if (_checklistOptions.isNotEmpty) ...[
          context.vXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.primary.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.checklist_outlined,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_checklistOptions.length} item${_checklistOptions.length == 1 ? '' : 's'} added',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _checklistOptions.clear());
                        },
                        icon: const Icon(
                          Icons.delete_sweep,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Clear all',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable list
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _checklistOptions.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          color: context.colors.primary.withOpacity(0.1),
                        ),
                    itemBuilder: (context, index) {
                      final item = _checklistOptions[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: context.colors.primary.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.check_box_outline_blank,
                            size: 16,
                            color: context.colors.primary,
                          ),
                        ),
                        title: Text(
                          item,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Move up
                            if (index > 0)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move up',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final el = _checklistOptions.removeAt(
                                      index,
                                    );
                                    _checklistOptions.insert(index - 1, el);
                                  });
                                },
                              ),
                            // Move down
                            if (index < _checklistOptions.length - 1)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move down',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final el = _checklistOptions.removeAt(
                                      index,
                                    );
                                    _checklistOptions.insert(index + 1, el);
                                  });
                                },
                              ),
                            // Delete
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              onPressed: () {
                                setState(
                                  () => _checklistOptions.removeAt(index),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          context.vXs,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.03),
              border: Border.all(
                color: context.colors.primary.withOpacity(0.15),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'No items added yet. Add at least one checklist item.',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _addChecklistOption() {
    final val = _checklistOptionController.text.trim();
    if (val.isEmpty) return;

    final isDuplicate = _checklistOptions.any(
      (c) => c.toLowerCase() == val.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$val" is already in the list.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _checklistOptions.add(val);
      _checklistOptionController.clear();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Location Options
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLocationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.vS,
        Text(
          'Location Options',
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,

        // Input row
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _locationOptionController,
                hintText: 'Enter location (e.g. Warehouse A)',
                onTap: () => _addLocation(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.add_location_alt_outlined,
                color: context.colors.primary,
              ),
              tooltip: 'Add location',
              onPressed: _addLocation,
            ),
          ],
        ),

        // Location list
        if (_locationOptions.isNotEmpty) ...[
          context.vXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.primary.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // List header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.list, size: 16, color: context.colors.primary),
                      const SizedBox(width: 6),
                      Text(
                        '${_locationOptions.length} location${_locationOptions.length == 1 ? '' : 's'} added',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // Clear all button
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _locationOptions.clear());
                        },
                        icon: const Icon(
                          Icons.delete_sweep,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Clear all',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable list of locations
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _locationOptions.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          color: context.colors.primary.withOpacity(0.1),
                        ),
                    itemBuilder: (context, index) {
                      final location = _locationOptions[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: context.colors.primary.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: context.colors.primary,
                          ),
                        ),
                        title: Text(
                          location,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Move up
                            if (index > 0)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move up',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final item = _locationOptions.removeAt(
                                      index,
                                    );
                                    _locationOptions.insert(index - 1, item);
                                  });
                                },
                              ),
                            // Move down
                            if (index < _locationOptions.length - 1)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move down',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final item = _locationOptions.removeAt(
                                      index,
                                    );
                                    _locationOptions.insert(index + 1, item);
                                  });
                                },
                              ),
                            // Delete
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              onPressed: () {
                                setState(
                                  () => _locationOptions.removeAt(index),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Empty state hint
          context.vXs,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.03),
              border: Border.all(
                color: context.colors.primary.withOpacity(0.15),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'No locations added yet. Add at least one.',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Applicable Code Options
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildApplicableCodeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.vS,
        Text(
          'Predefined Codes (optional)',
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        Text(
          'Add standard codes (e.g. API 510, ASME B31.3). '
          'Users can also type custom codes at runtime.',
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary.withOpacity(0.55),
            fontSize: 11,
          ),
        ),
        context.vXs,

        // Input row
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _applicableCodeOptionController,
                hintText: 'Enter code (e.g. API 510)',
                onTap: () => _addApplicableCode(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add, color: context.colors.primary),
              tooltip: 'Add code',
              onPressed: _addApplicableCode,
            ),
          ],
        ),

        if (_applicableCodeOptions.isNotEmpty) ...[
          context.vXs,
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.primary.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.gavel_outlined,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_applicableCodeOptions.length} code${_applicableCodeOptions.length == 1 ? '' : 's'} added',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed:
                            () =>
                                setState(() => _applicableCodeOptions.clear()),
                        icon: const Icon(
                          Icons.delete_sweep,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Clear all',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable list
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _applicableCodeOptions.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          color: context.colors.primary.withOpacity(0.1),
                        ),
                    itemBuilder: (context, index) {
                      final code = _applicableCodeOptions[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: context.colors.primary.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.gavel_outlined,
                            size: 14,
                            color: context.colors.primary,
                          ),
                        ),
                        title: Text(
                          code,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (index > 0)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move up',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed:
                                    () => setState(() {
                                      final item = _applicableCodeOptions
                                          .removeAt(index);
                                      _applicableCodeOptions.insert(
                                        index - 1,
                                        item,
                                      );
                                    }),
                              ),
                            if (index < _applicableCodeOptions.length - 1)
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  size: 16,
                                  color: context.colors.primary.withOpacity(
                                    0.6,
                                  ),
                                ),
                                tooltip: 'Move down',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                onPressed:
                                    () => setState(() {
                                      final item = _applicableCodeOptions
                                          .removeAt(index);
                                      _applicableCodeOptions.insert(
                                        index + 1,
                                        item,
                                      );
                                    }),
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              onPressed:
                                  () => setState(
                                    () =>
                                        _applicableCodeOptions.removeAt(index),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          context.vXs,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.03),
              border: Border.all(
                color: context.colors.primary.withOpacity(0.15),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No predefined codes yet — users can still type custom codes at runtime.',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _addApplicableCode() {
    final val = _applicableCodeOptionController.text.trim();
    if (val.isEmpty) return;

    final isDuplicate = _applicableCodeOptions.any(
      (c) => c.toLowerCase() == val.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$val" is already in the list.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _applicableCodeOptions.add(val);
      _applicableCodeOptionController.clear();
    });
  }

  void _addLocation() {
    final val = _locationOptionController.text.trim();
    if (val.isEmpty) return;

    // Prevent duplicates (case-insensitive)
    final isDuplicate = _locationOptions.any(
      (loc) => loc.toLowerCase() == val.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$val" is already in the list.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _locationOptions.add(val);
      _locationOptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fieldTypes = context.read<CategoryProvider>().availableFieldTypes;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Field',
                    style: context.topology.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  CommonButton.iconOnly(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.close,
                  ),
                ],
              ),
              context.vM,

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Label Text ──────────────────────────────────────
                      CommonTextField(
                        controller: _labelTextController,
                        hintText: 'Label Text',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Label Text is required';
                          }
                          return null;
                        },
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                      context.vS,

                      // ── Name (auto-populated from Label Text) ───────────
                      // CommonTextField(
                      //   controller: _nameController,
                      //   hintText: 'Name',
                      //   validator: (value) {
                      //     if (value == null || value.trim().isEmpty) {
                      //       return 'Name is required';
                      //     }
                      //     return null;
                      //   },
                      //   style: context.topology.textTheme.bodyMedium?.copyWith(
                      //     color: context.colors.primary,
                      //   ),
                      // ),
                      // context.vS,
                      CommonDropdown(
                        value: _selectedFieldType,
                        items:
                            fieldTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFieldType = value!;
                          });
                        },
                      ),

                      // Field type specific options
                      _buildFieldTypeSpecificOptions(),

                      // Only show default value for non-specialized fields
                      if (![
                        'Dropdown',
                        'Override Dropdown',
                        'Conditional Dropdown',
                        'Checklist Item',
                        'Location',
                        'ApplicableCode',
                      ].contains(_selectedFieldType)) ...[
                        context.vS,
                        CommonTextField(
                          controller: _defaultValueController,
                          hintText: 'Default Value',
                        ),
                      ],

                      context.vS,
                      CommonChecklistTile(
                        title: 'Is Read Only',
                        value: _isReadOnly,
                        onChanged: (value) {
                          setState(() {
                            _isReadOnly = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CommonChecklistTile(
                        title: 'Required',
                        value: _isRequired,
                        onChanged: (value) {
                          setState(() {
                            _isRequired = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
