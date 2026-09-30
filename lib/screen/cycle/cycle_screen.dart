import 'package:INSPECT/core/extension/theme_extension.dart';
import 'package:INSPECT/core/service/navigation_service.dart';
import 'package:INSPECT/model/cycle_model.dart';
import 'package:INSPECT/providers/cycle_provider.dart';
import 'package:INSPECT/route/route.dart';
import 'package:INSPECT/widget/common_button.dart';
import 'package:INSPECT/widget/common_dialog.dart';
import 'package:INSPECT/widget/common_dropdown.dart';
import 'package:INSPECT/widget/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CycleSearchColumn {
  cycleLength('Cycle Length'),
  categoryName('Category Name'),
  customerSite('Customer/Site'),
  dataType('Data Type');

  const CycleSearchColumn(this.label);

  final String label;

  String? valueOf(CycleData cycle) => switch (this) {
    CycleSearchColumn.cycleLength => cycle.cycleLength,
    CycleSearchColumn.categoryName => cycle.categoryName,
    CycleSearchColumn.customerSite => cycle.customerSite,
    CycleSearchColumn.dataType => cycle.dataType,
  };
}

final _pageBackground = Colors.grey.shade50;

extension _CycleStyle on BuildContext {
  TextTheme get textStyles => topology.textTheme;

  TextStyle? primaryStyle(
    TextStyle? base, {
    FontWeight? weight,
    double? size,
    double opacity = 1,
  }) => base?.copyWith(
    color: colors.primary.withOpacity(opacity),
    fontWeight: weight,
    fontSize: size,
  );

  LinearGradient softGradient([double start = 0.12, double end = 0.06]) =>
      LinearGradient(
        colors: [
          colors.primary.withOpacity(start),
          colors.primary.withOpacity(end),
        ],
      );

  ButtonStyle primaryButtonStyle({
    required EdgeInsets padding,
    double elevation = 0,
  }) => ElevatedButton.styleFrom(
    backgroundColor: colors.primary,
    foregroundColor: Colors.white,
    padding: padding,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: elevation,
  );
}

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen>
    with SingleTickerProviderStateMixin {
  static const _tabletBreakpoint = 768.0;
  static const _desktopBreakpoint = 1024.0;

  final _searchController = TextEditingController();

  late final AnimationController _fadeController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeOutCubic,
  );

  CycleSearchColumn? _selectedColumn;
  String? _selectedValue;

  bool get _hasActiveFilter => _selectedColumn != null && _selectedValue != null;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await context.read<CycleProvider>().fetchCycles(context);
    if (mounted) _fadeController.forward();
  }

  void _openCreate() => NavigationService().navigateTo(AppRoutes.createCycle);

  void _openEdit(CycleData cycle) => NavigationService().navigateTo(
    AppRoutes.createCycle,
    arguments: {'cycleId': cycle.cycleId},
  );

  void _clearFilter() => setState(() {
    _selectedColumn = null;
    _selectedValue = null;
  });

  void _clearSearchAndFilter() {
    _searchController.clear();
    _clearFilter();
  }

  List<String> _columnValues(CycleProvider provider, CycleSearchColumn column) {
    return (provider.cycleModel?.data ?? [])
        .map(column.valueOf)
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<CycleData> _filteredCycles(CycleProvider provider) {
    final search = _searchController.text.toLowerCase().trim();
    final column = _selectedColumn;

    return (provider.cycleModel?.data ?? []).where((cycle) {
      final matchesSearch =
          search.isEmpty ||
          CycleSearchColumn.values.any(
            (col) => (col.valueOf(cycle) ?? '').toLowerCase().contains(search),
          );
      final matchesFilter =
          !_hasActiveFilter || column!.valueOf(cycle) == _selectedValue;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showFilterDialog(CycleProvider provider) {
    CommonDialog.show(
      context,
      widget: _FilterDialogContent(
        initialColumn: _selectedColumn,
        initialValue: _selectedValue,
        valuesFor: (column) => _columnValues(provider, column),
        onApply:
            (column, value) => setState(() {
              _selectedColumn = column;
              _selectedValue = value;
            }),
        onClear: _clearFilter,
      ),
    );
  }

  void _confirmDelete(CycleData cycle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => _DeleteCycleDialog(
            cycle: cycle,
            onConfirm:
                () => context.read<CycleProvider>().deleteCycle(
                  context,
                  cycle.cycleId,
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, provider, _) {
        final isEmpty = (provider.cycleModel?.data ?? []).isEmpty;

        if (provider.isLoading && provider.cycleModel == null) {
          return const _LoadingState();
        }
        if (!provider.isLoading && isEmpty) {
          return _EmptyState(onCreate: _openCreate);
        }
        return _buildMainLayout(context, provider);
      },
    );
  }

  Widget _buildMainLayout(BuildContext context, CycleProvider provider) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _desktopBreakpoint;
    final pagePadding =
        isDesktop
            ? 32.0
            : width >= _tabletBreakpoint
            ? 24.0
            : 16.0;
    final cycles = _filteredCycles(provider);

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(showCreateButton: isDesktop, onCreate: _openCreate),
                      const SizedBox(height: 24),
                      _SearchBar(
                        controller: _searchController,
                        isDesktop: isDesktop,
                        hasActiveFilter: _hasActiveFilter,
                        onFilterPressed: () => _showFilterDialog(provider),
                      ),
                      const SizedBox(height: 16),
                      if (_hasActiveFilter)
                        _ActiveFilterChip(
                          label: '${_selectedColumn!.label}: $_selectedValue',
                          onTap: _clearFilter,
                        ),
                      const SizedBox(height: 16),
                      _ResultsCount(
                        count: cycles.length,
                        isLoading: provider.isLoading,
                        onRefresh: () => provider.fetchCycles(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (cycles.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NoResultsState(onClear: _clearSearchAndFilter),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pagePadding, 0, pagePadding, 100),
                  sliver: SliverToBoxAdapter(
                    child: _buildTable(provider, cycles),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          isDesktop
              ? null
              : FloatingActionButton.extended(
                onPressed: _openCreate,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create'),
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
              ),
    );
  }

  Widget _buildTable(CycleProvider provider, List<CycleData> cycles) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchCycles(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
                  child: DataTable(
                    sortColumnIndex: provider.sortColumnIndex,
                    showCheckboxColumn: false,
                    columnSpacing: 20,
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 60,
                    columns: _buildColumns(provider),
                    rows: [
                      for (final (index, cycle) in cycles.indexed)
                        _buildRow(cycle, index, provider.isLoading),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(CycleProvider provider) {
    final labels = [...CycleSearchColumn.values.map((c) => c.label), 'Actions'];

    return [
      for (final (index, label) in labels.indexed)
        DataColumn(
          label: Expanded(
            child: Text(
              label,
              style: context.primaryStyle(context.textStyles.titleSmall),
            ),
          ),
          onSort:
              index < labels.length - 1
                  ? (i, _) => provider.sortColumnIndex = i
                  : null,
        ),
    ];
  }

  Text _cellText(String? value) => Text(
    value ?? '-',
    style: context.primaryStyle(context.textStyles.bodySmall),
  );

  DataRow _buildRow(CycleData cycle, int index, bool isLoading) {
    final dataType = cycle.dataType;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (_) => index.isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CycleAvatar(cycle),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cycle.cycleLength ?? '-',
                    style: context.primaryStyle(
                      context.textStyles.bodySmall,
                      weight: FontWeight.w600,
                    ),
                  ),
                  if (cycle.cycleId != null) ...[
                    const SizedBox(height: 3),
                    _Badge(
                      '# ${cycle.cycleId}',
                      fontSize: 10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        DataCell(_cellText(cycle.categoryName)),
        DataCell(_cellText(cycle.customerSite)),
        DataCell(
          dataType == null
              ? _cellText(null)
              : _Badge(
                dataType,
                backgroundOpacity: 0.08,
                textOpacity: 0.85,
                radius: 12,
                weight: FontWeight.w500,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionIcon(
                icon: Icons.edit_rounded,
                color: context.colors.primary,
                tooltip: 'Edit Cycle',
                onPressed: () => _openEdit(cycle),
              ),
              const SizedBox(width: 4),
              _ActionIcon(
                icon: Icons.delete_rounded,
                color: Colors.red,
                tooltip: 'Delete Cycle',
                onPressed: isLoading ? null : () => _confirmDelete(cycle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 18),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    this.fontSize = 11,
    this.backgroundOpacity = 0.1,
    this.textOpacity = 1,
    this.radius = 6,
    this.weight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  });

  final String text;
  final double fontSize;
  final double backgroundOpacity;
  final double textOpacity;
  final double radius;
  final FontWeight weight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        text,
        style: context.primaryStyle(
          context.textStyles.bodySmall,
          weight: weight,
          size: fontSize,
          opacity: textOpacity,
        ),
      ),
    );
  }
}

class _CycleAvatar extends StatelessWidget {
  const _CycleAvatar(this.cycle, {this.size = 34});

  final CycleData cycle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final label = cycle.cycleLength ?? '';
    final initial = label.isEmpty ? 'C' : label.substring(0, 1).toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.47,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.showCreateButton, required this.onCreate});

  final bool showCreateButton;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Container(
      padding: EdgeInsets.all(showCreateButton ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.08), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.loop_rounded, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycles',
                  style: context.primaryStyle(
                    context.textStyles.titleLarge,
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your inspection cycles',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (showCreateButton) ...[
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Cycle'),
              style: context.primaryButtonStyle(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.isDesktop,
    required this.hasActiveFilter,
    required this.onFilterPressed,
  });

  final TextEditingController controller;
  final bool isDesktop;
  final bool hasActiveFilter;
  final VoidCallback onFilterPressed;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Focus(
      onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focused ? primary : Colors.grey.shade200,
            width: _focused ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _focused
                      ? primary.withOpacity(0.1)
                      : Colors.black.withOpacity(0.02),
              blurRadius: _focused ? 12 : 8,
              offset: Offset(0, _focused ? 4 : 2),
            ),
          ],
        ),
        child: CommonTextField(
          controller: widget.controller,
          hintText:
              widget.isDesktop
                  ? 'Search by cycle length, category, customer, or data type...'
                  : 'Search cycles...',
          style: context.primaryStyle(context.textStyles.bodyMedium),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primary.withOpacity(0.6),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear_rounded, color: primary),
                  onPressed: () {
                    widget.controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                  tooltip: 'Clear search',
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      widget.hasActiveFilter
                          ? primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: primary.withOpacity(widget.hasActiveFilter ? 1 : 0.5),
                  ),
                  onPressed: widget.onFilterPressed,
                  tooltip: 'Filter cycles',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: context.softGradient(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_alt_rounded, size: 18, color: primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: context.primaryStyle(
                    context.textStyles.bodySmall,
                    weight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, size: 14, color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsCount extends StatelessWidget {
  const _ResultsCount({
    required this.count,
    required this.isLoading,
    required this.onRefresh,
  });

  final int count;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: context.softGradient(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.loop_rounded, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                '$count ${count == 1 ? 'cycle' : 'cycles'}',
                style: context.primaryStyle(
                  context.textStyles.bodySmall,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: primary),
          onPressed: isLoading ? null : onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }
}

class _FilterDialogContent extends StatefulWidget {
  const _FilterDialogContent({
    required this.initialColumn,
    required this.initialValue,
    required this.valuesFor,
    required this.onApply,
    required this.onClear,
  });

  final CycleSearchColumn? initialColumn;
  final String? initialValue;
  final List<String> Function(CycleSearchColumn column) valuesFor;
  final void Function(CycleSearchColumn? column, String? value) onApply;
  final VoidCallback onClear;

  @override
  State<_FilterDialogContent> createState() => _FilterDialogContentState();
}

class _FilterDialogContentState extends State<_FilterDialogContent> {
  late CycleSearchColumn? _column = widget.initialColumn;
  late String? _value = widget.initialValue;

  Widget _row(String label, Widget field) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.primaryStyle(
              context.textStyles.bodySmall,
              weight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(flex: 2, child: field),
      ],
    );
  }

  DropdownMenuItem<T> _item<T>(
    T? value,
    String text, {
    double opacity = 1,
    bool ellipsis = false,
  }) {
    return DropdownMenuItem<T>(
      value: value,
      child: Text(
        text,
        style: context.primaryStyle(
          context.textStyles.bodySmall,
          opacity: opacity,
        ),
        overflow: ellipsis ? TextOverflow.ellipsis : null,
      ),
    );
  }

  Widget _buildValueField(CycleSearchColumn? column) {
    if (column == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.colors.primary.withOpacity(0.3)),
        ),
        child: Text(
          'Select a column first',
          style: context.primaryStyle(
            context.textStyles.bodySmall,
            opacity: 0.5,
          ),
        ),
      );
    }

    return CommonDropdown<String>(
      value: _value,
      items: [
        _item<String>(null, 'All', opacity: 0.6),
        for (final value in widget.valuesFor(column))
          _item<String>(value, value, ellipsis: true),
      ],
      onChanged: (value) => setState(() => _value = value),
    );
  }

  void _finish(VoidCallback action) {
    action();
    NavigationService().goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.screenHeight * 0.5,
        minHeight: context.screenHeight * 0.3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(
            'Filter By',
            CommonDropdown<CycleSearchColumn>(
              value: _column,
              items: [
                _item<CycleSearchColumn>(null, 'Select Column', opacity: 0.6),
                for (final column in CycleSearchColumn.values)
                  _item<CycleSearchColumn>(column, column.label),
              ],
              onChanged:
                  (column) => setState(() {
                    _column = column;
                    _value = null;
                  }),
            ),
          ),
          context.vS,
          _row('Value', _buildValueField(_column)),
          context.vL,
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  text: 'Clear',
                  onPressed: () => _finish(widget.onClear),
                ),
              ),
              context.hS,
              Expanded(
                child: CommonButton(
                  text: 'Apply',
                  onPressed: () => _finish(() => widget.onApply(_column, _value)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeleteCycleDialog extends StatelessWidget {
  const _DeleteCycleDialog({required this.cycle, required this.onConfirm});

  final CycleData cycle;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final categoryName = cycle.categoryName;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.orange.shade100],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.orange.shade700,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Delete Cycle?',
              style: context.primaryStyle(
                context.textStyles.titleLarge,
                weight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete this cycle? This action cannot be undone.',
              style: context.textStyles.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  _CycleAvatar(cycle, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cycle.cycleLength ?? 'Unknown',
                          style: context.primaryStyle(
                            context.textStyles.titleSmall,
                            weight: FontWeight.bold,
                          ),
                        ),
                        if (categoryName != null) ...[
                          const SizedBox(height: 4),
                          _Badge(categoryName),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This action is permanent and cannot be reversed',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Selector<CycleProvider, bool>(
                    selector: (_, provider) => provider.isLoading,
                    builder:
                        (context, isLoading, _) => ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    Navigator.of(context).pop();
                                    onConfirm();
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_rounded, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading cycles...',
              style: context.textStyles.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: context.textStyles.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/bg_4.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  height: context.screenHeight * 0.60,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: context.softGradient(0.1, 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.loop_rounded,
                        size: 80,
                        color: primary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No cycles yet',
                      style: context.primaryStyle(
                        context.textStyles.headlineSmall,
                        weight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first cycle to get started',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: onCreate,
                      icon: const Icon(Icons.add_rounded, size: 24),
                      label: const Text('Create Cycle'),
                      style: context.primaryButtonStyle(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade100, Colors.grey.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No cycles found',
              style: context.primaryStyle(
                context.textStyles.titleLarge,
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear Filters'),
              style: context.primaryButtonStyle(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
