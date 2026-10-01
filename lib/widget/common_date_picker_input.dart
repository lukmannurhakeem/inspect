
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:intl/intl.dart';

class CommonDatePickerInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const CommonDatePickerInput({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    super.key,
  });

  @override
  State<CommonDatePickerInput> createState() => _CommonDatePickerInputState();
}

class _CommonDatePickerInputState extends State<CommonDatePickerInput> {
  Future<void> _selectDate() async {
    if (!widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: widget.lastDate ?? DateTime(2101),
    );
    if (picked != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            widget.label + (widget.isRequired ? '*' : ''),
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: widget.enabled ? _selectDate : null,
            child: AbsorbPointer(
              child: TextField(
                controller: widget.controller,
                readOnly: true,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: 'Select date',
                  hintStyle: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color:
                        widget.enabled ? context.colors.primary : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: widget.enabled ? context.colors.primary : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
