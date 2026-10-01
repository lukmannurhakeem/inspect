import 'dart:convert';
import 'dart:developer' as dev;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/provider/planner_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TeamPlannerScreen extends StatefulWidget {
  const TeamPlannerScreen({super.key});

  @override
  State<TeamPlannerScreen> createState() => _TeamPlannerScreenState();
}

class _TeamPlannerScreenState extends State<TeamPlannerScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Form controllers ───────────────────────────────────────────────────────
  final _planTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _estimatedDurationController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  final _plannedStartController = TextEditingController();
  final _plannedEndController = TextEditingController();

  // ── Dropdown / selection state ─────────────────────────────────────────────
  String _selectedPriority = 'normal';
  String _selectedStatus = 'pending';
  String _selectedEventType = 'test';
  String _selectedAssignmentType = 'personnel';
  String? _selectedAssignedToId;
  String _selectedAssignedToName = 'Select Assignment';
  String? _selectedJobId;
  String _selectedJobName = 'Select Job';

  DateTime? _plannedStartDate;
  DateTime? _plannedEndDate;

  final List<String> _checklistTasks = [];
  final List<String> _tags = [];

  PlatformFile? _attachmentFile;
  bool _isSubmitting = false;

  // ── Debug state ────────────────────────────────────────────────────────────
  static const bool _kDebugMode = true;

  Map<String, dynamic>? _debugRequest;
  dynamic _debugResponse;
  int? _debugStatusCode;
  bool _debugIsError = false;
  int? _debugDurationMs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonnelProvider>().fetchPersonnel();
      context.read<PersonnelProvider>().fetchTeamPersonnel();
      context.read<SystemProvider>().fetchDivision();
      context.read<JobProvider>().fetchJobModel(context);
    });
  }

  @override
  void dispose() {
    _planTitleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _estimatedDurationController.dispose();
    _taskController.dispose();
    _tagController.dispose();
    _plannedStartController.dispose();
    _plannedEndController.dispose();
    super.dispose();
  }

  // ── Date helpers ───────────────────────────────────────────────────────────

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_plannedStartDate ?? DateTime.now())
          : (_plannedEndDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    final dt = pickedTime == null
        ? DateTime(pickedDate.year, pickedDate.month, pickedDate.day)
        : DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
    _applyPickedDate(dt, isStart);
  }

  void _applyPickedDate(DateTime dt, bool isStart) {
    setState(() {
      if (isStart) {
        _plannedStartDate = dt;
        _plannedStartController.text = DateFormat(
          'MMM dd, yyyy - HH:mm',
        ).format(dt);
      } else {
        _plannedEndDate = dt;
        _plannedEndController.text = DateFormat(
          'MMM dd, yyyy - HH:mm',
        ).format(dt);
      }
    });
  }

  // ── Checklist / tag helpers ────────────────────────────────────────────────

  void _addTask() {
    final t = _taskController.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _checklistTasks.add(t);
      _taskController.clear();
    });
  }

  void _removeTask(int i) => setState(() => _checklistTasks.removeAt(i));

  void _addTag() {
    final t = _tagController.text.trim();
    if (t.isEmpty || _tags.contains(t)) return;
    setState(() {
      _tags.add(t);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) => setState(() => _tags.remove(tag));

  // ── Pickers ────────────────────────────────────────────────────────────────

  void _showJobPicker() {
    final jobProvider = context.read<JobProvider>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dlgCtx) {
        final jobs = jobProvider.jobModel?.data ?? [];
        return _GenericPickerDialog(
          title: 'Select Job',
          subtitle: 'Job',
          icon: Icons.work_outline,
          emptyIcon: Icons.work_off,
          emptyLabel: 'No jobs available',
          isLoading: jobProvider.isLoading,
          items: jobs
              .map(
                (job) => _PickerTile(
                  initial: (job.jobId ?? 'J')[0].toUpperCase(),
                  label: job.jobId ?? 'Unknown Job',
                  sublabel:
                      '${job.clientName ?? 'No Client'} · ${job.siteName ?? 'No Site'}',
                  isSelected: _selectedJobId == job.jobId,
                  onTap: () {
                    setState(() {
                      _selectedJobId = job.jobId;
                      _selectedJobName = '${job.jobId} - ${job.clientName}';
                    });
                    Navigator.pop(dlgCtx);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  // ── NEW: Assignment dropdown driven by _selectedAssignmentType ────────────
  // Returns list of {id, name} objects for the active assignment type.

  List<Map<String, String>> _assignmentOptions() {
    final personnelProvider = context.read<PersonnelProvider>();
    final systemProvider = context.read<SystemProvider>();

    switch (_selectedAssignmentType) {
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

  bool _isAssignmentLoading() {
    final personnel = context.read<PersonnelProvider>();
    final system = context.read<SystemProvider>();
    return personnel.isLoading || system.isLoading;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedJobId == null) {
      _snack('Please select a job');
      return;
    }
    if (_plannedStartDate == null || _plannedEndDate == null) {
      _snack('Please select start and end date/time');
      return;
    }
    if (_plannedEndDate!.isBefore(_plannedStartDate!)) {
      _snack('End date must be after start date');
      return;
    }
    if (_selectedAssignedToId == null) {
      _snack('Please select an assignment');
      return;
    }

    final plannerProvider = context.read<PlannerProvider>();

    final planData = <String, dynamic>{
      'eventType': _selectedEventType,
      'jobId': _selectedJobId,
      'planTitle': _planTitleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'priority': _selectedPriority,
      'plannedStartDate': _plannedStartDate?.toUtc().toIso8601String(),
      'plannedEndDate': _plannedEndDate?.toUtc().toIso8601String(),
      'estimatedDuration': int.tryParse(_estimatedDurationController.text) ?? 0,
      'status': _selectedStatus,
      'assignedTo': _selectedAssignedToId,
      'assignmentType': _selectedAssignmentType,
      'checklistItems': {'tasks': List<String>.from(_checklistTasks)},
      'attendees': {},
      'notes': _notesController.text.trim(),
      'tags': {'categories': List<String>.from(_tags)},
    };

    if (_kDebugMode) {
      setState(() {
        _debugRequest = planData;
        _debugResponse = null;
        _debugStatusCode = null;
        _debugIsError = false;
        _debugDurationMs = null;
      });
      dev.log(
        '📤 CREATE PLAN REQUEST\n${_prettyJson(planData)}',
        name: 'ApiDebug',
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: context.colors.primary),
                const SizedBox(height: 16),
                Text(
                  'Creating plan...',
                  style: context.topology.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    setState(() => _isSubmitting = true);
    final sw = Stopwatch()..start();
    final success = await plannerProvider.createInspectionPlan(planData);
    sw.stop();

    if (mounted) Navigator.of(context).pop();
    setState(() => _isSubmitting = false);

    if (_kDebugMode && mounted) {
      final responseBody = success
          ? {
              'success': true,
              'message': 'Inspection plan created successfully',
              'data': plannerProvider.plans.isNotEmpty
                  ? plannerProvider.plans.first.toJson()
                  : null,
            }
          : {
              'success': false,
              'message': plannerProvider.errorMessage ?? 'Unknown error',
            };

      dev.log(
        '📥 CREATE PLAN RESPONSE [${success ? 201 : 422}] ${sw.elapsedMilliseconds}ms\n'
        '${_prettyJson(responseBody)}',
        name: 'ApiDebug',
      );

      setState(() {
        _debugDurationMs = sw.elapsedMilliseconds;
        _debugIsError = !success;
        _debugStatusCode = success ? 201 : 422;
        _debugResponse = responseBody;
      });
    }

    if (success) {
      _resetForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  plannerProvider.pendingSyncCount > 0
                      ? 'Plan queued for sync (offline)'
                      : 'Plan created successfully!',
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plannerProvider.errorMessage ?? 'Failed to create plan',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _submitForm,
            ),
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    for (final c in [
      _planTitleController,
      _descriptionController,
      _notesController,
      _estimatedDurationController,
      _taskController,
      _tagController,
      _plannedStartController,
      _plannedEndController,
    ]) {
      c.clear();
    }
    setState(() {
      _checklistTasks.clear();
      _tags.clear();
      _plannedStartDate = null;
      _plannedEndDate = null;
      _selectedPriority = 'normal';
      _selectedStatus = 'pending';
      _selectedEventType = 'test';
      _selectedAssignmentType = 'personnel';
      _selectedAssignedToId = null;
      _selectedAssignedToName = 'Select Assignment';
      _selectedJobId = null;
      _selectedJobName = 'Select Job';
    });
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  static String _prettyJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  // ── Section / field builders ───────────────────────────────────────────────

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
    String title, {
    TextEditingController? controller,
    bool isRequired = false,
    IconData? icon,
    TextInputType? keyboardType,
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
              Expanded(
                child: Text(
                  title + (isRequired ? ' *' : ''),
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: isRequired
                        ? FontWeight.w600
                        : FontWeight.normal,
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
            keyboardType: keyboardType,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
    required bool isStart,
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
                child: Text(
                  label,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () => _selectDate(context, isStart),
            child: AbsorbPointer(
              absorbing: true,
              child: CommonDatePickerInput(label: '', controller: controller),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items, {
    required ValueChanged<String?> onChanged,
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
                child: Text(
                  label,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonDropdown<String>(
            value: value,
            items: items
                .map(
                  (it) => DropdownMenuItem<String>(
                    value: it,
                    child: Text(
                      it.toUpperCase(),
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
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String selectedName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$label *',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedName,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? context.colors.primary
                            : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: context.colors.primary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── NEW: Inline assignment dropdown ────────────────────────────────────────
  // Replaces the picker dialog for assignedTo. Shows a searchable list
  // directly in the form, driven by _selectedAssignmentType.

  Widget _buildAssignedToDropdown(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label column
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                _selectedAssignmentType == 'personnel'
                    ? Icons.person
                    : _selectedAssignmentType == 'team'
                    ? Icons.group
                    : Icons.business,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Assigned To *',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        // Dropdown column — watches both providers so it rebuilds on data load
        Expanded(
          flex: 3,
          child: Consumer2<PersonnelProvider, SystemProvider>(
            builder: (context, personnelProv, systemProv, _) {
              final isLoading = personnelProv.isLoading || systemProv.isLoading;
              final options = _assignmentOptions();

              if (isLoading && options.isEmpty) {
                // Show a subtle loading tile while data fetches
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
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

              if (options.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Text(
                    'No ${_selectedAssignmentType}s available',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                  ),
                );
              }

              // Build a DropdownButton from the live options list
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedAssignedToId != null
                        ? context.colors.primary
                        : Colors.grey.shade300,
                    width: _selectedAssignedToId != null ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedAssignedToId,
                    hint: Text(
                      'Select ${_selectedAssignmentType}',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: context.colors.primary,
                    ),
                    items: options.map((opt) {
                      final isSelected = opt['id'] == _selectedAssignedToId;
                      return DropdownMenuItem<String>(
                        value: opt['id'],
                        child: Row(
                          children: [
                            // Avatar circle
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: _selectedAssignmentType == 'team'
                                  ? Icon(
                                      Icons.group,
                                      size: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : context.colors.primary,
                                    )
                                  : _selectedAssignmentType == 'department'
                                  ? Icon(
                                      Icons.business,
                                      size: 14,
                                      color: isSelected
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
                                          color: isSelected
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
                      final opt = options.firstWhere(
                        (o) => o['id'] == id,
                        orElse: () => {'id': id, 'name': id},
                      );
                      setState(() {
                        _selectedAssignedToId = id;
                        _selectedAssignedToName = opt['name'] ?? id;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Card sections ──────────────────────────────────────────────────────────

  Widget _buildPlannerInfoCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Planner Information', Icons.event_note),
        context.vM,
        _buildSelectorField(
          context: context,
          label: 'Select Job',
          icon: Icons.work,
          selectedName: _selectedJobName,
          isSelected: _selectedJobId != null,
          onTap: _showJobPicker,
        ),
        context.vS,
        _buildRow(
          context,
          'Plan Title',
          controller: _planTitleController,
          isRequired: true,
          icon: Icons.title,
        ),
        context.vS,
        _buildRow(
          context,
          'Description',
          controller: _descriptionController,
          icon: Icons.notes,
          maxLines: 3,
        ),
        context.vS,
        _buildDropdown(
          context,
          'Event Type',
          _selectedEventType,
          ['test', 'inspection', 'maintenance', 'audit'],
          onChanged: (v) => setState(() => _selectedEventType = v ?? 'test'),
          icon: Icons.category,
        ),
        context.vS,
        _buildDropdown(
          context,
          'Priority',
          _selectedPriority,
          ['low', 'normal', 'high', 'critical'],
          onChanged: (v) => setState(() => _selectedPriority = v ?? 'normal'),
          icon: Icons.flag,
        ),
        context.vS,
        _buildDropdown(
          context,
          'Status',
          _selectedStatus,
          ['pending', 'in_progress', 'completed', 'cancelled'],
          onChanged: (v) => setState(() => _selectedStatus = v ?? 'pending'),
          icon: Icons.info,
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Duration & Schedule', Icons.schedule),
        context.vM,
        _buildDateField(
          context,
          'Planned Start Date',
          _plannedStartController,
          icon: Icons.event,
          isStart: true,
        ),
        context.vS,
        _buildDateField(
          context,
          'Planned End Date',
          _plannedEndController,
          icon: Icons.event_available,
          isStart: false,
        ),
      ],
    );
  }

  Widget _buildAssignmentCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Assignment', Icons.assignment_ind),
        context.vM,
        // Assignment type selector — resetting assignedTo when it changes
        _buildDropdown(
          context,
          'Assignment Type',
          _selectedAssignmentType,
          ['personnel', 'team', 'department'],
          onChanged: (v) {
            setState(() {
              _selectedAssignmentType = v ?? 'personnel';
              _selectedAssignedToId = null; // reset selection
              _selectedAssignedToName = 'Select Assignment';
            });
          },
          icon: Icons.group,
        ),
        context.vS,
        // Inline populated dropdown
        _buildAssignedToDropdown(context),
      ],
    );
  }

  Widget _buildChecklistCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Checklist Tasks', Icons.checklist),
        context.vM,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
                controller: _taskController,
                hintText: 'Enter task...',
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
          const SizedBox(height: 12),
          ..._checklistTasks.asMap().entries.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1,
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.task_alt,
                  size: 20,
                  color: context.colors.primary,
                ),
                title: Text(
                  entry.value,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeTask(entry.key),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTagsCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Tags', Icons.local_offer),
        context.vM,
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
                controller: _tagController,
                hintText: 'Enter tag...',
                onTap: _addTag,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addTag,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags
                .map(
                  (tag) => Chip(
                    shadowColor: context.colors.primary,
                    label: Text(
                      tag,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeTag(tag),
                    backgroundColor: context.colors.primary.withOpacity(0.1),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Additional Notes', Icons.note_alt),
        context.vM,
        _buildRow(
          context,
          'Notes',
          controller: _notesController,
          icon: Icons.edit_note,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildPendingSyncBanner(PlannerProvider p, {bool mobile = false}) {
    if (p.pendingSyncCount == 0) return const SizedBox.shrink();
    return Column(
      children: [
        Card(
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.sync_problem, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Sync: ${p.pendingSyncCount} request(s)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      Text(
                        'Will sync when connection is restored',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                mobile
                    ? IconButton(
                        onPressed: () async {
                          final ok = await p.syncPendingPlans();
                          if (mounted && ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync completed!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.sync, size: 18),
                      )
                    : TextButton.icon(
                        onPressed: () async {
                          final ok = await p.syncPendingPlans();
                          if (mounted && ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync completed successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Sync Now'),
                      ),
              ],
            ),
          ),
        ),
        context.vM,
      ],
    );
  }

  // ── Layouts ────────────────────────────────────────────────────────────────

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Consumer<PlannerProvider>(
            builder: (context, p, _) => _buildPendingSyncBanner(p),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlannerInfoCard(context),
                        context.vL,
                        _buildChecklistCard(context),
                        context.vL,
                        _buildTagsCard(context),
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
                        _buildScheduleCard(context),
                        context.vL,
                        _buildAssignmentCard(context),
                        context.vL,
                        _buildNotesCard(context),
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
                  text: _isSubmitting ? 'Creating...' : 'Create Planner',
                  onPressed: _isSubmitting ? null : _submitForm,
                ),
              ),
            ],
          ),
          context.vM,
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          Consumer<PlannerProvider>(
            builder: (context, p, _) =>
                _buildPendingSyncBanner(p, mobile: true),
          ),
          _buildPlannerInfoCard(context),
          context.vL,
          _buildScheduleCard(context),
          context.vL,
          _buildAssignmentCard(context),
          context.vL,
          _buildChecklistCard(context),
          context.vL,
          _buildTagsCard(context),
          context.vL,
          _buildNotesCard(context),
          context.vL,
          CommonButton(
            text: _isSubmitting ? 'Creating...' : 'Create Planner',
            onPressed: _isSubmitting ? null : _submitForm,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'New Planner',
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
      ),
      body: Form(
        key: _formKey,
        child: _isSubmitting
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: context.colors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Creating plan...',
                      style: context.topology.textTheme.bodyMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              )
            : (context.isTablet
                  ? _buildTabletLayout(context)
                  : _buildMobileLayout(context)),
      ),
    );
    return scaffold;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Picker Dialogs  (kept for job picker — assignment now uses inline dropdown)
// ════════════════════════════════════════════════════════════════════════════

class _GenericPickerDialog extends StatelessWidget {
  const _GenericPickerDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emptyIcon,
    required this.emptyLabel,
    required this.items,
    this.isLoading = false,
  });

  final String title, subtitle, emptyLabel;
  final IconData icon, emptyIcon;
  final List<Widget> items;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 17, color: context.colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          title,
                          style: context.topology.textTheme.titleSmall
                              ?.copyWith(color: context.colors.primary),
                        ),
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
                        Icons.close,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: context.colors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Loading jobs...',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    )
                  : items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              emptyIcon,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              emptyLabel,
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, i) => items[i],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.initial,
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
    this.useGroupIcon = false,
    this.useBusinessIcon = false,
  });

  final String initial, label, sublabel;
  final bool isSelected, useGroupIcon, useBusinessIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? context.colors.primary.withOpacity(0.4)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: useGroupIcon
                  ? Icon(
                      Icons.group,
                      size: 18,
                      color: isSelected ? Colors.white : context.colors.primary,
                    )
                  : useBusinessIcon
                  ? Icon(
                      Icons.business,
                      size: 18,
                      color: isSelected ? Colors.white : context.colors.primary,
                    )
                  : Center(
                      child: Text(
                        initial,
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sublabel,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            isSelected
                ? Icon(
                    Icons.check_circle,
                    size: 20,
                    color: context.colors.primary,
                  )
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
