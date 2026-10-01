
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/provider/planner_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPlanSheet extends StatefulWidget {
  const EditPlanSheet({super.key, required this.plan});

  final InspectionPlanModel plan;

  /// Opens the sheet and returns `true` if the plan was saved.
  static Future<bool?> show(BuildContext context, InspectionPlanModel plan) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditPlanSheet(plan: plan),
    );
  }

  @override
  State<EditPlanSheet> createState() => _EditPlanSheetState();
}

class _EditPlanSheetState extends State<EditPlanSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // ── Controllers ────────────────────────────────────────────────────────────
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _estimatedDurationCtrl;
  late final TextEditingController _plannedStartCtrl;
  late final TextEditingController _plannedEndCtrl;

  // ── Dropdown / selected values ─────────────────────────────────────────────
  late String _priority;
  late String _status;
  late String _eventType;
  late String _assignmentType;

  // ── Assignment ─────────────────────────────────────────────────────────────
  String? _selectedAssignedToId;

  // ── Checklist ──────────────────────────────────────────────────────────────
  late List<String> _checklistTasks;
  final _taskCtrl = TextEditingController();

  // ── Date/time ──────────────────────────────────────────────────────────────
  DateTime? _plannedStartDate;
  DateTime? _plannedEndDate;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final p = widget.plan;

    _titleCtrl = TextEditingController(text: p.planTitle);
    _descriptionCtrl = TextEditingController(text: p.description);
    _notesCtrl = TextEditingController(text: p.notes ?? '');
    _estimatedDurationCtrl = TextEditingController(
      text: p.estimatedDuration?.toString() ?? '',
    );

    _priority = p.priority;
    _status = p.status;
    _eventType = p.eventType;
    _assignmentType =
        (p.assignmentType?.isNotEmpty == true)
            ? p.assignmentType!
            : 'personnel';

    _selectedAssignedToId = p.assignedTo;

    _plannedStartDate = p.plannedStartDate?.toLocal();
    _plannedEndDate = p.plannedEndDate?.toLocal();

    _plannedStartCtrl = TextEditingController(
      text:
          _plannedStartDate != null
              ? DateFormat('MMM dd, yyyy - HH:mm').format(_plannedStartDate!)
              : '',
    );
    _plannedEndCtrl = TextEditingController(
      text:
          _plannedEndDate != null
              ? DateFormat('MMM dd, yyyy - HH:mm').format(_plannedEndDate!)
              : '',
    );

    _checklistTasks = List<String>.from(p.checklistItems?.tasks ?? []);

    // Ensure providers are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonnelProvider>().fetchPersonnel();
      context.read<PersonnelProvider>().fetchTeamPersonnel();
      context.read<SystemProvider>().fetchDivision();
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _notesCtrl.dispose();
    _estimatedDurationCtrl.dispose();
    _taskCtrl.dispose();
    _plannedStartCtrl.dispose();
    _plannedEndCtrl.dispose();
    super.dispose();
  }

  // ── Assignment options (mirrors TeamPlannerScreen) ─────────────────────────

  List<Map<String, String>> _assignmentOptions() {
    final personnelProvider = context.read<PersonnelProvider>();
    final systemProvider = context.read<SystemProvider>();

    switch (_assignmentType) {
      case 'personnel':
        return personnelProvider.activePersonnel
            .map(
              (p) => {
                'id': p.personnel.personnelID,
                'name': p.displayName,
                'sub': p.company.jobTitle,
              },
            )
            .toList();

      case 'team':
        return personnelProvider.teamPersonnelList
            .map(
              (t) => {
                'id': t.teamPersonnelId ?? '',
                'name': t.name ?? 'Unnamed Team',
                'sub': t.type ?? 'No Type',
              },
            )
            .toList();

      case 'department':
        return systemProvider.divisions
            .map(
              (d) => {
                'id': d.divisionid ?? '',
                'name': d.divisionname ?? 'Unnamed Division',
                'sub': d.divisioncode ?? 'No Code',
              },
            )
            .toList();

      default:
        return [];
    }
  }

  // ── Date pickers ───────────────────────────────────────────────────────────

  Future<void> _selectDate(bool isStart) async {
    final initial =
        isStart
            ? (_plannedStartDate ?? DateTime.now())
            : (_plannedEndDate ?? DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    final dt =
        pickedTime == null
            ? DateTime(pickedDate.year, pickedDate.month, pickedDate.day)
            : DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

    setState(() {
      if (isStart) {
        _plannedStartDate = dt;
        _plannedStartCtrl.text = DateFormat('MMM dd, yyyy - HH:mm').format(dt);
      } else {
        _plannedEndDate = dt;
        _plannedEndCtrl.text = DateFormat('MMM dd, yyyy - HH:mm').format(dt);
      }
    });
  }

  // ── Checklist helpers ──────────────────────────────────────────────────────

  void _addTask() {
    final t = _taskCtrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _checklistTasks.add(t);
      _taskCtrl.clear();
    });
  }

  void _removeTask(int i) => setState(() => _checklistTasks.removeAt(i));

  // ── Save ───────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAssignedToId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an assignment')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final planData = <String, dynamic>{
      'planTitle': _titleCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'priority': _priority,
      'status': _status,
      'eventType': _eventType,
      'plannedStartDate': _plannedStartDate?.toUtc().toIso8601String(),
      'plannedEndDate': _plannedEndDate?.toUtc().toIso8601String(),
      'estimatedDuration': int.tryParse(_estimatedDurationCtrl.text) ?? 0,
      'assignedTo': _selectedAssignedToId,
      'assignmentType': _assignmentType,
      'checklistItems': {'tasks': List<String>.from(_checklistTasks)},
      'notes': _notesCtrl.text.trim(),
    };

    final success = await context.read<PlannerProvider>().updateInspectionPlan(
      widget.plan.id,
      planData,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Plan updated successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final err =
          context.read<PlannerProvider>().errorMessage ?? 'Update failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Field builders ─────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: context.colors.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelledField({
    required String label,
    required Widget field,
    IconData? icon,
    bool required = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15,
                    color: context.colors.primary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 5),
                ],
                Expanded(
                  child: Text(
                    label + (required ? ' *' : ''),
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          required ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 3, child: field),
      ],
    );
  }

  Widget _textField(
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return CommonTextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: context.topology.textTheme.bodySmall?.copyWith(
        color: context.colors.primary,
      ),
    );
  }

  Widget _dropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return CommonDropdown<String>(
      value: value,
      items:
          items
              .map(
                (it) => DropdownMenuItem<String>(
                  value: it,
                  child: Text(
                    it.toUpperCase().replaceAll('_', ' '),
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
      borderColor: context.colors.primary,
      textStyle: context.topology.textTheme.bodySmall?.copyWith(
        color: context.colors.primary,
      ),
    );
  }

  Widget _dateField(TextEditingController ctrl, bool isStart) {
    return InkWell(
      onTap: () => _selectDate(isStart),
      child: AbsorbPointer(
        child: CommonDatePickerInput(label: '', controller: ctrl),
      ),
    );
  }

  // ── Assigned-to dropdown (mirrors TeamPlannerScreen) ──────────────────────

  Widget _assignedToDropdown() {
    return _labelledField(
      label: 'Assigned To',
      required: true,
      icon:
          _assignmentType == 'personnel'
              ? Icons.person
              : _assignmentType == 'team'
              ? Icons.group
              : Icons.business,
      field: Consumer2<PersonnelProvider, SystemProvider>(
        builder: (context, personnelProv, systemProv, _) {
          final isLoading = personnelProv.isLoading || systemProv.isLoading;
          final options = _assignmentOptions();

          // Loading skeleton
          if (isLoading && options.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Loading...',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (options.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Text(
                'No ${_assignmentType}s available',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
            );
          }

          // Ensure the stored id is still valid for the current type;
          // if not, clear it so the hint shows.
          final validId =
              options.any((o) => o['id'] == _selectedAssignedToId)
                  ? _selectedAssignedToId
                  : null;
          if (validId != _selectedAssignedToId) {
            // schedule reset outside build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedAssignedToId = validId);
            });
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    validId != null
                        ? context.colors.primary
                        : Colors.grey.shade300,
                width: validId != null ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: validId,
                hint: Text(
                  'Select $_assignmentType',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: context.colors.primary,
                ),
                items:
                    options.map((opt) {
                      final isSelected = opt['id'] == validId;
                      return DropdownMenuItem<String>(
                        value: opt['id'],
                        child: Row(
                          children: [
                            // Avatar / icon circle
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? context.colors.primary
                                        : context.colors.primary.withOpacity(
                                          0.1,
                                        ),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  _assignmentType == 'team'
                                      ? Icon(
                                        Icons.group,
                                        size: 14,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : context.colors.primary,
                                      )
                                      : _assignmentType == 'department'
                                      ? Icon(
                                        Icons.business,
                                        size: 14,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : context.colors.primary,
                                      )
                                      : Center(
                                        child: Text(
                                          (opt['name']!.isNotEmpty
                                                  ? opt['name']![0]
                                                  : '?')
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : context.colors.primary,
                                          ),
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    opt['name']!,
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if ((opt['sub'] ?? '').isNotEmpty)
                                    Text(
                                      opt['sub']!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (id) {
                  if (id == null) return;
                  setState(() => _selectedAssignedToId = id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Checklist section ──────────────────────────────────────────────────────

  Widget _checklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Checklist', Icons.checklist),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _taskCtrl,
                hintText: 'Add task...',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
                onTap: _addTask,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addTask,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        if (_checklistTasks.isNotEmpty) ...[
          const SizedBox(height: 10),
          ..._checklistTasks.asMap().entries.map(
            (e) => Card(
              margin: const EdgeInsets.only(bottom: 6),
              elevation: 1,
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.task_alt,
                  size: 18,
                  color: context.colors.primary,
                ),
                title: Text(
                  e.value,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () => _removeTask(e.key),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        expand: false,
        builder:
            (_, scrollCtrl) => Column(
              children: [
                // ── Handle ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Header ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EDIT PLAN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              widget.plan.planTitle,
                              style: context.topology.textTheme.titleSmall
                                  ?.copyWith(color: context.colors.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // ── Scrollable form ─────────────────────────────────────
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        // ── Basic info ────────────────────────────────
                        _sectionHeader('Plan Information', Icons.event_note),
                        const SizedBox(height: 12),
                        _labelledField(
                          label: 'Plan Title',
                          required: true,
                          icon: Icons.title,
                          field: _textField(_titleCtrl),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'Description',
                          icon: Icons.notes,
                          field: _textField(_descriptionCtrl, maxLines: 3),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'Event Type',
                          icon: Icons.category,
                          field: _dropdown(
                            _eventType,
                            ['test', 'inspection', 'maintenance', 'audit'],
                            (v) => setState(() => _eventType = v ?? _eventType),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'Priority',
                          icon: Icons.flag,
                          field: _dropdown(
                            _priority,
                            ['low', 'normal', 'high', 'critical'],
                            (v) => setState(() => _priority = v ?? _priority),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'Status',
                          icon: Icons.info_outline,
                          field: _dropdown(_status, [
                            'pending',
                            'in_progress',
                            'completed',
                            'cancelled',
                          ], (v) => setState(() => _status = v ?? _status)),
                        ),

                        const SizedBox(height: 20),

                        // ── Schedule ──────────────────────────────────
                        _sectionHeader('Schedule', Icons.schedule),
                        const SizedBox(height: 12),
                        _labelledField(
                          label: 'Start Date',
                          icon: Icons.event,
                          field: _dateField(_plannedStartCtrl, true),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'End Date',
                          icon: Icons.event_available,
                          field: _dateField(_plannedEndCtrl, false),
                        ),
                        const SizedBox(height: 10),
                        _labelledField(
                          label: 'Duration (min)',
                          icon: Icons.timer_outlined,
                          field: _textField(
                            _estimatedDurationCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Assignment ────────────────────────────────
                        _sectionHeader('Assignment', Icons.assignment_ind),
                        const SizedBox(height: 12),
                        _labelledField(
                          label: 'Type',
                          icon: Icons.group,
                          field: _dropdown(
                            _assignmentType,
                            ['personnel', 'team', 'department'],
                            (v) {
                              setState(() {
                                _assignmentType = v ?? _assignmentType;
                                // Reset selection when type changes
                                _selectedAssignedToId = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Inline populated assigned-to dropdown
                        _assignedToDropdown(),

                        const SizedBox(height: 20),

                        // ── Checklist ─────────────────────────────────
                        _checklistSection(),

                        const SizedBox(height: 20),

                        // ── Notes ─────────────────────────────────────
                        _sectionHeader('Notes', Icons.note_alt),
                        const SizedBox(height: 12),
                        _labelledField(
                          label: 'Notes',
                          icon: Icons.edit_note,
                          field: _textField(_notesCtrl, maxLines: 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Footer ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon:
                              _isSaving
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(Icons.save_outlined, size: 16),
                          label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
