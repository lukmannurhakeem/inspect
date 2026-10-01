
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';
import 'package:inspect/provider/planner_provider.dart';
import 'package:inspect/screen/planner/edit_plan_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

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
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlannerProvider>().fetchInspectionPlans();
    });
  }

  void _pickMonthYear() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _focusedDay = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  // ── Duration helper ────────────────────────────────────────────────────────

  String _calcDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '0 min';
    final diff = end.difference(start).inMinutes;
    if (diff <= 0) return '0 min';
    if (diff < 60) return '$diff min';
    final h = diff ~/ 60;
    final m = diff % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  // ── Overdue helper ─────────────────────────────────────────────────────────

  bool _isOverdue(InspectionPlanModel plan) {
    if (plan.plannedEndDate == null) return false;
    if (plan.status.toLowerCase() == 'completed') return false;
    return plan.plannedEndDate!.isBefore(DateTime.now());
  }

  String _overdueLabel(InspectionPlanModel plan) {
    if (plan.plannedEndDate == null) return '';
    final diff = DateTime.now().difference(plan.plannedEndDate!);
    if (diff.inDays > 0) return 'Overdue by ${diff.inDays}d';
    final h = diff.inHours;
    if (h > 0) return 'Overdue by ${h}h';
    return 'Overdue by <1h';
  }

  // ── Mark completed ─────────────────────────────────────────────────────────

  Future<void> _markCompleted(
    BuildContext context,
    InspectionPlanModel plan,
    PlannerProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle_outline, color: context.colors.primary),
                const SizedBox(width: 8),
                Text(
                  'Mark as Completed',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            content: Text(
              'Mark "${plan.planTitle}" as completed?',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
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
            Text(
              success
                  ? 'Plan marked as completed'
                  : provider.errorMessage ?? 'Failed to update status',
            ),
          ],
        ),
        backgroundColor: success ? context.colors.primary : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Overdue warning dialog ─────────────────────────────────────────────────

  void _showOverdueWarning(BuildContext context, InspectionPlanModel plan) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
                    color: context.colors.primary,
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
                  style: TextStyle(fontSize: 14, color: context.colors.primary),
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
                  style: TextStyle(fontSize: 13, color: context.colors.primary),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Dismiss',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlannerProvider>(
        builder: (context, provider, _) {
          final plansForDay = _getPlansForDay(
            _selectedDay ?? _focusedDay,
            provider.plans,
          );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingAll,
                  child: _buildHeader(context, provider),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingAll.copyWith(top: 0),
                  child: _buildCalendar(context, provider),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingAll.copyWith(top: 0),
                  child: _buildPlansHeader(context, provider, plansForDay),
                ),
              ),
              if (provider.isLoading && provider.plans.isEmpty)
                SliverFillRemaining(child: _buildLoadingState(context))
              else if (provider.hasError)
                SliverFillRemaining(child: _buildErrorState(context, provider))
              else if (plansForDay.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(context))
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == plansForDay.length) {
                      return const SizedBox(height: 24);
                    }
                    return Padding(
                      padding: context.paddingAll.copyWith(top: 0, bottom: 0),
                      child: _buildPlanCard(
                        context,
                        plansForDay[index],
                        provider,
                      ),
                    );
                  }, childCount: plansForDay.length + 1),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, PlannerProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _pickMonthYear,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
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
                          color: context.colors.primary,
                        ),
                      )
                      : Icon(Icons.refresh, color: context.colors.primary),
              onPressed:
                  provider.isLoading
                      ? null
                      : () => provider.fetchInspectionPlans(),
            ),
          ],
        ),
      ],
    );
  }

  // ── Calendar ───────────────────────────────────────────────────────────────

  Widget _buildCalendar(BuildContext context, PlannerProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          daysOfWeekHeight: 40.0,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          availableGestures: AvailableGestures.horizontalSwipe,
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
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
              color: context.colors.primary,
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
            defaultBuilder: (context, day, focusedDay) {
              final hasPlans = _hasPlansOnDay(day, provider.plans);
              final hasOverdue = _hasOverduePlansOnDay(day, provider.plans);
              return _buildDayCell(
                context,
                day,
                hasPlans: hasPlans,
                hasOverdue: hasOverdue,
                isSelected: false,
                isToday: false,
              );
            },
            todayBuilder: (context, day, focusedDay) {
              final hasPlans = _hasPlansOnDay(day, provider.plans);
              final hasOverdue = _hasOverduePlansOnDay(day, provider.plans);
              return _buildDayCell(
                context,
                day,
                hasPlans: hasPlans,
                hasOverdue: hasOverdue,
                isSelected: false,
                isToday: true,
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              final hasPlans = _hasPlansOnDay(day, provider.plans);
              final hasOverdue = _hasOverduePlansOnDay(day, provider.plans);
              return _buildDayCell(
                context,
                day,
                hasPlans: hasPlans,
                hasOverdue: hasOverdue,
                isSelected: true,
                isToday: false,
              );
            },
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            cellMargin: EdgeInsets.all(2),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day, {
    required bool hasPlans,
    required bool hasOverdue,
    required bool isSelected,
    required bool isToday,
  }) {
    Color? bgColor;
    Color borderColor;
    Color textColor;
    FontWeight fontWeight;

    if (isSelected) {
      bgColor = context.colors.primary;
      borderColor = context.colors.primary;
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (isToday) {
      bgColor = context.colors.primary.withOpacity(0.1);
      borderColor = context.colors.primary;
      textColor = context.colors.primary;
      fontWeight = FontWeight.bold;
    } else if (hasOverdue) {
      bgColor = Colors.red.withOpacity(0.05);
      borderColor = Colors.red.shade300;
      textColor = Colors.black87;
      fontWeight = FontWeight.w600;
    } else if (hasPlans) {
      bgColor = context.colors.primary.withOpacity(0.05);
      borderColor = context.colors.primary.withOpacity(0.3);
      textColor = Colors.black87;
      fontWeight = FontWeight.w600;
    } else {
      bgColor = null;
      borderColor = Colors.grey.shade200;
      textColor = Colors.black87;
      fontWeight = FontWeight.normal;
    }

    // Dot color: overdue = red, plans = primary, selected = white
    Color? dotColor;
    if (hasOverdue) {
      dotColor = isSelected ? Colors.white : Colors.red.shade400;
    } else if (hasPlans) {
      dotColor = isSelected ? Colors.white : context.colors.primary;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: isToday ? borderColor : borderColor,
          width: isToday ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: context.colors.primary.withOpacity(0.3),
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
          Text(
            '${day.day}',
            style: TextStyle(color: textColor, fontWeight: fontWeight),
          ),
          if (dotColor != null)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  // ── Plans header ───────────────────────────────────────────────────────────

  Widget _buildPlansHeader(
    BuildContext context,
    PlannerProvider provider,
    List<InspectionPlanModel> plansForDay,
  ) {
    if (provider.isLoading && provider.plans.isEmpty)
      return const SizedBox.shrink();
    if (provider.hasError) return const SizedBox.shrink();
    if (plansForDay.isEmpty) return const SizedBox.shrink();

    final overdueCount = plansForDay.where(_isOverdue).length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, size: 20, color: context.colors.primary),
              const SizedBox(width: 8),
              Text(
                'Plans for ${DateFormat('MMM dd, yyyy').format(_selectedDay ?? _focusedDay)}',
                style: context.topology.textTheme.titleMedium?.copyWith(
                  color: context.colors.primary,
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
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${plansForDay.length}',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // ── Overdue banner ───────────────────────────────────────────
          if (overdueCount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$overdueCount overdue plan${overdueCount > 1 ? 's' : ''} — action required',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── States ─────────────────────────────────────────────────────────────────

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          const SizedBox(height: 16),
          Text(
            'Loading plans...',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PlannerProvider provider) {
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
            onPressed: () => provider.fetchInspectionPlans(),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No plans for ${DateFormat('MMM dd, yyyy').format(_selectedDay ?? _focusedDay)}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ── Plan card ──────────────────────────────────────────────────────────────

  Widget _buildPlanCard(
    BuildContext context,
    InspectionPlanModel plan,
    PlannerProvider provider,
  ) {
    final overdue = _isOverdue(plan);
    final isCompleted = plan.status.toLowerCase() == 'completed';
    final isUpdating = provider.updatingPlanId == plan.id;

    final startTime =
        plan.plannedStartDate != null
            ? DateFormat('HH:mm').format(plan.plannedStartDate!.toLocal())
            : '--:--';
    final endTime =
        plan.plannedEndDate != null
            ? DateFormat('HH:mm').format(plan.plannedEndDate!.toLocal())
            : '--:--';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: overdue ? 3 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showPlanDetails(context, plan, provider),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color:
                    overdue
                        ? Colors.red.shade400
                        : _getColorByStatus(plan.status),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Overdue banner ───────────────────────────────────
                if (overdue) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _overdueLabel(plan),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _showOverdueWarning(context, plan),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Title row ────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.planTitle,
                        style: context.topology.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                    _buildStatusChip(plan.status),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Time row ─────────────────────────────────────────
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
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

                // ── Bottom row: chips + action button ────────────────
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.flag_outlined,
                      plan.priority,
                      _getColorByPriority(plan.priority),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.category_outlined,
                      plan.eventType,
                      context.colors.primary,
                    ),
                    const Spacer(),

                    // ── Mark Complete / Overdue Warning button ────────
                    if (!isCompleted)
                      overdue
                          ? _buildOverdueActionButton(context, plan, isUpdating)
                          : _buildMarkCompleteButton(
                            context,
                            plan,
                            provider,
                            isUpdating,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkCompleteButton(
    BuildContext context,
    InspectionPlanModel plan,
    PlannerProvider provider,
    bool isUpdating,
  ) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed:
            isUpdating ? null : () => _markCompleted(context, plan, provider),
        icon:
            isUpdating
                ? SizedBox(
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

  Widget _buildOverdueActionButton(
    BuildContext context,
    InspectionPlanModel plan,
    bool isUpdating,
  ) {
    return SizedBox(
      height: 32,
      child: OutlinedButton.icon(
        onPressed: () => _showOverdueWarning(context, plan),
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

  // ── Chips ──────────────────────────────────────────────────────────────────

  Widget _buildStatusChip(String status) {
    final color = _getColorByStatus(status);
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

  Widget _buildInfoChip(IconData icon, String text, Color color) {
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
          Text(
            text.toUpperCase(),
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool _hasPlansOnDay(DateTime day, List<InspectionPlanModel> plans) {
    return plans.any((plan) {
      if (plan.plannedStartDate == null) return false;
      return isSameDay(plan.plannedStartDate!.toLocal(), day);
    });
  }

  bool _hasOverduePlansOnDay(DateTime day, List<InspectionPlanModel> plans) {
    return plans.any((plan) {
      if (plan.plannedStartDate == null) return false;
      if (!isSameDay(plan.plannedStartDate!.toLocal(), day)) return false;
      return _isOverdue(plan);
    });
  }

  List<InspectionPlanModel> _getPlansForDay(
    DateTime date,
    List<InspectionPlanModel> plans,
  ) {
    return plans.where((plan) {
        if (plan.plannedStartDate == null) return false;
        return isSameDay(plan.plannedStartDate!.toLocal(), date);
      }).toList()
      ..sort((a, b) {
        if (a.plannedStartDate == null || b.plannedStartDate == null) return 0;
        return a.plannedStartDate!.compareTo(b.plannedStartDate!);
      });
  }

  Color _getColorByStatus(String status) {
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

  Color _getColorByPriority(String priority) {
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

  // ── Detail dialog ──────────────────────────────────────────────────────────

  void _showPlanDetails(
    BuildContext context,
    InspectionPlanModel plan,
    PlannerProvider provider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => _PlanDetailDialog(
            plan: plan,
            isOverdue: _isOverdue(plan),
            overdueLabel: _overdueLabel(plan),
            getColorByStatus: _getColorByStatus,
            getColorByPriority: _getColorByPriority,
            buildStatusChip: _buildStatusChip,
            onEdit: (planToEdit) async {
              Navigator.of(context).pop();
              await EditPlanSheet.show(context, planToEdit);
            },
            onMarkCompleted: (planToComplete) async {
              Navigator.of(context).pop();
              await _markCompleted(context, planToComplete, provider);
            },
          ),
    );
  }
}

// ── Detail dialog ─────────────────────────────────────────────────────────────

class _PlanDetailDialog extends StatelessWidget {
  const _PlanDetailDialog({
    required this.plan,
    required this.isOverdue,
    required this.overdueLabel,
    required this.getColorByStatus,
    required this.getColorByPriority,
    required this.buildStatusChip,
    required this.onEdit,
    required this.onMarkCompleted,
  });

  final InspectionPlanModel plan;
  final bool isOverdue;
  final String overdueLabel;
  final Color Function(String) getColorByStatus;
  final Color Function(String) getColorByPriority;
  final Widget Function(String) buildStatusChip;
  final void Function(InspectionPlanModel) onEdit;
  final void Function(InspectionPlanModel) onMarkCompleted;

  bool get _isCompleted => plan.status.toLowerCase() == 'completed';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────
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
                              ?.copyWith(color: context.colors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      buildStatusChip(plan.status),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onEdit(plan),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.primary.withOpacity(0.1),
                            border: Border.all(
                              color: context.colors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
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
                ],
              ),
            ),

            // ── Overdue alert ────────────────────────────────────────
            if (isOverdue) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$overdueLabel — this plan has not been completed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Stat grid ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3.0,
                children: [
                  _StatCard(
                    label: 'Priority',
                    value: plan.priority,
                    dot: getColorByPriority(plan.priority),
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

            // ── Scrollable body ───────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.plannedStartDate != null ||
                        plan.plannedEndDate != null) ...[
                      _SectionHeader(
                        label: 'Schedule',
                        icon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 8),
                      _KVCard(
                        rows: [
                          if (plan.plannedStartDate != null)
                            _KVRow(
                              label: 'Start',
                              value: DateFormat(
                                'MMM dd, yyyy  HH:mm',
                              ).format(plan.plannedStartDate!.toLocal()),
                            ),
                          if (plan.plannedEndDate != null)
                            _KVRow(
                              label: 'End',
                              value: DateFormat(
                                'MMM dd, yyyy  HH:mm',
                              ).format(plan.plannedEndDate!.toLocal()),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (plan.description.isNotEmpty) ...[
                      _SectionHeader(
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
                    if (plan.notes != null &&
                        plan.notes!.isNotEmpty &&
                        plan.notes != '-') ...[
                      _SectionHeader(
                        label: 'Notes',
                        icon: Icons.edit_note_outlined,
                      ),
                      const SizedBox(height: 8),
                      _BodyCard(text: plan.notes!),
                      const SizedBox(height: 14),
                    ],
                    _SectionHeader(label: 'Metadata', icon: Icons.info_outline),
                    const SizedBox(height: 8),
                    _KVCard(
                      rows: [
                        if (plan.createdAt != null)
                          _KVRow(
                            label: 'Created at',
                            value: DateFormat(
                              'MMM dd, yyyy  HH:mm',
                            ).format(plan.createdAt!.toLocal()),
                          ),
                        if (plan.completedBy != null)
                          _KVRow(
                            label: 'Completed by',
                            value: plan.completedBy!,
                          ),
                        if (plan.completedAt != null)
                          _KVRow(
                            label: 'Completed at',
                            value: DateFormat(
                              'MMM dd, yyyy  HH:mm',
                            ).format(plan.completedAt!.toLocal()),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Footer buttons ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  // Show "Mark Complete" only if not completed and NOT overdue
                  if (!_isCompleted && !isOverdue) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onMarkCompleted(plan),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Complete Now'),
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
                  ],
                  // Show "Edit Plan" — always visible; labeled as fix if overdue
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onEdit(plan),
                      icon: Icon(
                        isOverdue ? Icons.build_outlined : Icons.edit_outlined,
                        size: 16,
                      ),
                      label: Text(isOverdue ? 'Fix Plan' : 'Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOverdue
                                ? Colors.orange.shade700
                                : context.colors.primary,
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

  String _calcDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '0 min';
    final diff = end.difference(start).inMinutes;
    if (diff <= 0) return '0 min';
    if (diff < 60) return '$diff min';
    final h = diff ~/ 60;
    final m = diff % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

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
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
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
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: context.colors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: context.colors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }
}

class _KVRow {
  const _KVRow({required this.label, required this.value});

  final String label;
  final String value;
}

class _KVCard extends StatelessWidget {
  const _KVCard({required this.rows});

  final List<_KVRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children:
            rows.asMap().entries.map((e) {
              final isLast = e.key == rows.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border:
                      isLast
                          ? null
                          : Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.value.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      e.value.value,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
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
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  const _ChecklistSection({required this.tasks});

  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist_outlined,
                size: 13,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Checklist',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colors.primary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${tasks.length} items',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children:
                tasks.asMap().entries.map((e) {
                  final isLast = e.key == tasks.length - 1;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border:
                          isLast
                              ? null
                              : Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
