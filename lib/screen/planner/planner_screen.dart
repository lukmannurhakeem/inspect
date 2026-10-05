import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';
import 'package:inspect/provider/planner_provider.dart';
import 'package:inspect/screen/planner/edit_plan_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

final _dateFmt = DateFormat('MMM dd, yyyy');
final _dateTimeFmt = DateFormat('MMM dd, yyyy  HH:mm');
final _timeFmt = DateFormat('HH:mm');

String _calcDuration(DateTime? start, DateTime? end) {
  if (start == null || end == null) return '0 min';
  final diff = end.difference(start).inMinutes;
  if (diff <= 0) return '0 min';
  if (diff < 60) return '$diff min';
  final h = diff ~/ 60;
  final m = diff % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

bool _isCompleted(InspectionPlanModel plan) =>
    plan.status.toLowerCase() == 'completed';

bool _isOverdue(InspectionPlanModel plan) {
  final end = plan.plannedEndDate;
  if (end == null || _isCompleted(plan)) return false;
  return end.isBefore(DateTime.now());
}

String _overdueLabel(InspectionPlanModel plan) {
  final end = plan.plannedEndDate;
  if (end == null) return '';
  final diff = DateTime.now().difference(end);
  if (diff.inDays > 0) return 'Overdue by ${diff.inDays}d';
  if (diff.inHours > 0) return 'Overdue by ${diff.inHours}h';
  return 'Overdue by <1h';
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return Colors.green;
    case 'in_progress':
      return Colors.blue;
    case 'pending':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Color _priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'critical':
      return Colors.red;
    case 'high':
      return Colors.orange;
    case 'normal':
      return Colors.blue;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _dateOnly(DateTime.now());
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlannerProvider>().fetchInspectionPlans();
    });
  }

  DateTime get _activeDay => _selectedDay ?? _focusedDay;

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      final day = _dateOnly(picked);
      setState(() {
        _focusedDay = day;
        _selectedDay = day;
      });
    }
  }

  List<InspectionPlanModel> _plansForDay(
      DateTime date,
      List<InspectionPlanModel> plans,
      ) {
    return plans
        .where(
          (p) =>
      p.plannedStartDate != null &&
          isSameDay(p.plannedStartDate!.toLocal(), date),
    )
        .toList()
      ..sort((a, b) => a.plannedStartDate!.compareTo(b.plannedStartDate!));
  }

  Future<void> _markCompleted(
      InspectionPlanModel plan,
      PlannerProvider provider,
      ) async {
    final primary = context.colors.primary;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: primary),
            const SizedBox(width: 8),
            Text(
              'Mark as Completed',
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: primary,
              ),
            ),
          ],
        ),
        content: Text(
          'Mark "${plan.planTitle}" as completed?',
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await provider.updatePlanStatus(plan.id, 'completed');
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                success
                    ? 'Plan marked as completed'
                    : provider.errorMessage ?? 'Failed to update status',
              ),
            ),
          ],
        ),
        backgroundColor: success ? primary : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showOverdueWarning(InspectionPlanModel plan) {
    final primary = context.colors.primary;
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              'Overdue Plan',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${plan.planTitle}" has passed its end date.',
              style: TextStyle(fontSize: 14, color: primary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _overdueLabel(plan),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please update the plan or contact the assignee.',
              style: TextStyle(fontSize: 13, color: primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Dismiss',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              EditPlanSheet.show(context, plan);
            },
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Edit Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlanDetails(InspectionPlanModel plan, PlannerProvider provider) {
    showDialog(
      context: context,
      builder:
          (ctx) => _PlanDetailDialog(
        plan: plan,
        onEdit: (p) async {
          Navigator.of(ctx).pop();
          await EditPlanSheet.show(context, p);
        },
        onMarkCompleted: (p) async {
          Navigator.of(ctx).pop();
          await _markCompleted(p, provider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlannerProvider>(
        builder: (context, provider, _) {
          final plansForDay = _plansForDay(_activeDay, provider.plans);
          final sidePadding = context.paddingAll.copyWith(top: 0);

          Widget? stateWidget;
          if (provider.isLoading && provider.plans.isEmpty) {
            stateWidget = const _LoadingState();
          } else if (provider.hasError) {
            stateWidget = _ErrorState(provider: provider);
          } else if (plansForDay.isEmpty) {
            stateWidget = _EmptyState(day: _activeDay);
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingAll,
                  child: _buildHeader(provider),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: sidePadding,
                  child: _buildCalendar(provider),
                ),
              ),
              if (stateWidget != null)
                SliverFillRemaining(child: stateWidget)
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: sidePadding,
                    child: _buildPlansHeader(plansForDay),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == plansForDay.length) {
                      return const SizedBox(height: 24);
                    }
                    return Padding(
                      padding: context.paddingAll.copyWith(top: 0, bottom: 0),
                      child: _buildPlanCard(plansForDay[index], provider),
                    );
                  }, childCount: plansForDay.length + 1),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(PlannerProvider provider) {
    final primary = context.colors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _pickMonthYear,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16, color: primary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            if (provider.pendingSyncCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sync_problem,
                      size: 14,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.pendingSyncCount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              icon:
              provider.isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primary,
                ),
              )
                  : Icon(Icons.refresh, color: primary),
              onPressed:
              provider.isLoading ? null : provider.fetchInspectionPlans,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar(PlannerProvider provider) {
    final primary = context.colors.primary;
    final planDays = <DateTime>{};
    final overdueDays = <DateTime>{};
    for (final p in provider.plans) {
      final start = p.plannedStartDate?.toLocal();
      if (start == null) continue;
      final key = _dateOnly(start);
      planDays.add(key);
      if (_isOverdue(p)) overdueDays.add(key);
    }

    Widget cell(DateTime day, {bool selected = false, bool today = false}) {
      final key = _dateOnly(day);
      return _DayCell(
        day: day,
        hasPlans: planDays.contains(key),
        hasOverdue: overdueDays.contains(key),
        isSelected: selected,
        isToday: today,
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          daysOfWeekHeight: 40,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          availableGestures: AvailableGestures.horizontalSwipe,
          onPageChanged: (focusedDay) {
            final day = _dateOnly(focusedDay);
            setState(() {
              _focusedDay = day;
              _selectedDay = day;
            });
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            weekendStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (_, day, __) => cell(day),
            todayBuilder: (_, day, __) => cell(day, today: true),
            selectedBuilder: (_, day, __) => cell(day, selected: true),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            cellMargin: EdgeInsets.all(2),
          ),
        ),
      ),
    );
  }

  Widget _buildPlansHeader(List<InspectionPlanModel> plansForDay) {
    final primary = context.colors.primary;
    final overdueCount = plansForDay.where(_isOverdue).length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, size: 20, color: primary),
              const SizedBox(width: 8),
              Text(
                'Plans for ${_dateFmt.format(_activeDay)}',
                style: context.topology.textTheme.titleMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${plansForDay.length}',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (overdueCount > 0) ...[
            const SizedBox(height: 8),
            _AlertBanner(
              text:
              '$overdueCount overdue plan${overdueCount > 1 ? 's' : ''} — action required',
              radius: 10,
              fontSize: 13,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanCard(InspectionPlanModel plan, PlannerProvider provider) {
    final primary = context.colors.primary;
    final overdue = _isOverdue(plan);
    final completed = _isCompleted(plan);
    final isUpdating = provider.updatingPlanId == plan.id;

    final startTime =
    plan.plannedStartDate != null
        ? _timeFmt.format(plan.plannedStartDate!.toLocal())
        : '--:--';
    final endTime =
    plan.plannedEndDate != null
        ? _timeFmt.format(plan.plannedEndDate!.toLocal())
        : '--:--';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: overdue ? 3 : 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showPlanDetails(plan, provider),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: overdue ? Colors.red.shade400 : _statusColor(plan.status),
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (overdue)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AlertBanner(
                    text: _overdueLabel(plan),
                    radius: 8,
                    fontSize: 12,
                    iconSize: 14,
                    trailing: GestureDetector(
                      onTap: () => _showOverdueWarning(plan),
                      child: Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.planTitle,
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  _StatusChip(status: plan.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    '$startTime - $endTime',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _calcDuration(plan.plannedStartDate, plan.plannedEndDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              if (plan.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  plan.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    text: plan.priority,
                    color: _priorityColor(plan.priority),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _InfoChip(
                      icon: Icons.category_outlined,
                      text: plan.eventType,
                      color: primary,
                    ),
                  ),
                  const Spacer(),
                  if (!completed)
                    overdue
                        ? _buildOverdueButton(plan)
                        : _buildCompleteButton(plan, provider, isUpdating),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton(
      InspectionPlanModel plan,
      PlannerProvider provider,
      bool isUpdating,
      ) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: isUpdating ? null : () => _markCompleted(plan, provider),
        icon:
        isUpdating
            ? const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.check, size: 14),
        label: Text(
          isUpdating ? 'Updating...' : 'Complete Now',
          style: const TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildOverdueButton(InspectionPlanModel plan) {
    return SizedBox(
      height: 32,
      child: OutlinedButton.icon(
        onPressed: () => _showOverdueWarning(plan),
        icon: Icon(
          Icons.warning_amber_rounded,
          size: 14,
          color: Colors.red.shade600,
        ),
        label: Text(
          'Overdue',
          style: TextStyle(fontSize: 12, color: Colors.red.shade600),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          side: BorderSide(color: Colors.red.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.hasPlans,
    required this.hasOverdue,
    required this.isSelected,
    required this.isToday,
  });

  final DateTime day;
  final bool hasPlans;
  final bool hasOverdue;
  final bool isSelected;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    Color? bg;
    Color border = Colors.grey.shade200;
    Color text = Colors.black87;
    FontWeight weight = FontWeight.normal;

    if (isSelected) {
      bg = primary;
      border = primary;
      text = Colors.white;
      weight = FontWeight.bold;
    } else if (isToday) {
      bg = primary.withOpacity(0.1);
      border = primary;
      text = primary;
      weight = FontWeight.bold;
    } else if (hasOverdue) {
      bg = Colors.red.withOpacity(0.05);
      border = Colors.red.shade300;
      weight = FontWeight.w600;
    } else if (hasPlans) {
      bg = primary.withOpacity(0.05);
      border = primary.withOpacity(0.3);
      weight = FontWeight.w600;
    }

    Color? dot;
    if (hasOverdue) {
      dot = isSelected ? Colors.white : Colors.red.shade400;
    } else if (hasPlans) {
      dot = isSelected ? Colors.white : primary;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: isToday ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow:
        isSelected
            ? [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}', style: TextStyle(color: text, fontWeight: weight)),
          if (dot != null)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({
    required this.text,
    required this.radius,
    required this.fontSize,
    this.iconSize = 16,
    this.trailing,
  });

  final String text;
  final double radius;
  final double fontSize;
  final double iconSize;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: iconSize,
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase().replaceAll('_', ' '),
        style: context.topology.textTheme.bodySmall?.copyWith(
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary),
          const SizedBox(height: 16),
          Text(
            'Loading plans...',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.provider});

  final PlannerProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: provider.fetchInspectionPlans,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No plans for ${_dateFmt.format(day)}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _PlanDetailDialog extends StatelessWidget {
  const _PlanDetailDialog({
    required this.plan,
    required this.onEdit,
    required this.onMarkCompleted,
  });

  final InspectionPlanModel plan;
  final void Function(InspectionPlanModel) onEdit;
  final void Function(InspectionPlanModel) onMarkCompleted;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final overdue = _isOverdue(plan);
    final completed = _isCompleted(plan);
    final notes = plan.notes;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INSPECTION PLAN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.planTitle,
                          style: context.topology.textTheme.titleMedium
                              ?.copyWith(color: primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _StatusChip(status: plan.status),
                  const SizedBox(width: 8),
                  _CircleAction(
                    icon: Icons.edit_outlined,
                    color: primary,
                    fill: primary.withOpacity(0.1),
                    borderColor: primary.withOpacity(0.2),
                    onTap: () => onEdit(plan),
                  ),
                  const SizedBox(width: 6),
                  _CircleAction(
                    icon: Icons.close,
                    color: Colors.grey.shade600,
                    borderColor: Colors.grey.shade200,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            if (overdue)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: _AlertBanner(
                  text:
                  '${_overdueLabel(plan)} — this plan has not been completed',
                  radius: 10,
                  fontSize: 12,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3,
                children: [
                  _StatCard(
                    label: 'Priority',
                    value: plan.priority,
                    dot: _priorityColor(plan.priority),
                  ),
                  _StatCard(label: 'Event type', value: plan.eventType),
                  _StatCard(
                    label: 'Duration',
                    value: _calcDuration(
                      plan.plannedStartDate,
                      plan.plannedEndDate,
                    ),
                  ),
                  if (plan.createdBy != null)
                    _StatCard(label: 'Created by', value: plan.createdBy!),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.plannedStartDate != null ||
                        plan.plannedEndDate != null) ...[
                      const _SectionHeader(
                        label: 'Schedule',
                        icon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 8),
                      _KVCard(
                        rows: [
                          if (plan.plannedStartDate != null)
                            _KVRow(
                              'Start',
                              _dateTimeFmt.format(
                                plan.plannedStartDate!.toLocal(),
                              ),
                            ),
                          if (plan.plannedEndDate != null)
                            _KVRow(
                              'End',
                              _dateTimeFmt.format(
                                plan.plannedEndDate!.toLocal(),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (plan.description.isNotEmpty) ...[
                      const _SectionHeader(
                        label: 'Description',
                        icon: Icons.notes_outlined,
                      ),
                      const SizedBox(height: 8),
                      _BodyCard(text: plan.description),
                      const SizedBox(height: 14),
                    ],
                    if (plan.checklistItems != null &&
                        plan.checklistItems!.tasks.isNotEmpty) ...[
                      _ChecklistSection(tasks: plan.checklistItems!.tasks),
                      const SizedBox(height: 14),
                    ],
                    if (notes != null && notes.isNotEmpty && notes != '-') ...[
                      const _SectionHeader(
                        label: 'Notes',
                        icon: Icons.edit_note_outlined,
                      ),
                      const SizedBox(height: 8),
                      _BodyCard(text: notes),
                      const SizedBox(height: 14),
                    ],
                    const _SectionHeader(
                      label: 'Metadata',
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 8),
                    _KVCard(
                      rows: [
                        if (plan.createdAt != null)
                          _KVRow(
                            'Created at',
                            _dateTimeFmt.format(plan.createdAt!.toLocal()),
                          ),
                        if (plan.completedBy != null)
                          _KVRow('Completed by', plan.completedBy!),
                        if (plan.completedAt != null)
                          _KVRow(
                            'Completed at',
                            _dateTimeFmt.format(plan.completedAt!.toLocal()),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  if (!completed && !overdue) ...[
                    Expanded(
                      child: _FooterButton(
                        icon: Icons.check_circle_outline,
                        label: 'Complete Now',
                        color: primary,
                        onPressed: () => onMarkCompleted(plan),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: _FooterButton(
                      icon:
                      overdue ? Icons.build_outlined : Icons.edit_outlined,
                      label: overdue ? 'Fix Plan' : 'Edit',
                      color: overdue ? Colors.orange.shade700 : primary,
                      onPressed: () => onEdit(plan),
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
                        'Close',
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

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
    this.fill,
  });

  final IconData icon;
  final Color color;
  final Color borderColor;
  final Color? fill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.dot});

  final String label;
  final String value;
  final Color? dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              if (dot != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: primary),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primary,
          ),
        ),
      ],
    );
  }
}

class _KVRow {
  const _KVRow(this.label, this.value);

  final String label;
  final String value;
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border:
                i == children.length - 1
                    ? null
                    : Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: children[i],
            ),
        ],
      ),
    );
  }
}

class _KVCard extends StatelessWidget {
  const _KVCard({required this.rows});

  final List<_KVRow> rows;

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      children: [
        for (final r in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Flexible(
                child: Text(
                  r.value,
                  textAlign: TextAlign.end,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _BodyCard extends StatelessWidget {
  const _BodyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.6),
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  const _ChecklistSection({required this.tasks});

  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: _SectionHeader(
                label: 'Checklist',
                icon: Icons.checklist_outlined,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${tasks.length} items',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _ListCard(
          children: [
            for (final task in tasks)
              Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}