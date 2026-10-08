import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/file_export_stub.dart'
if (dart.library.html) 'package:inspect/core/utils/file_export_web.dart'
if (dart.library.io) 'package:inspect/core/utils/file_export_mobile.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/item_register_provider.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/screen/job/job_register/item_register_widget.dart';
import 'package:provider/provider.dart';

typedef _Item = Map<String, dynamic>;

class ItemRegisterTab extends StatelessWidget {
  final String jobId;

  const ItemRegisterTab({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => ItemRegisterProvider(jobId),
    child: const _ItemRegisterView(),
  );
}

class _ItemRegisterView extends StatefulWidget {
  const _ItemRegisterView();

  @override
  State<_ItemRegisterView> createState() => _ItemRegisterViewState();
}

class _ItemRegisterViewState extends State<_ItemRegisterView>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  ItemRegisterProvider get _provider => context.read<ItemRegisterProvider>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
          () => _provider.setQuery(_searchController.text),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final provider = _provider;
    await provider.loadLocal();
    if (mounted) await provider.sync(context);
  }

  Future<void> _syncNow() async {
    final provider = _provider;
    final ok = await provider.sync(context);
    if (!mounted) return;

    if (!ok) {
      CommonSnackbar.showWarning(context, 'Sync failed — showing cached data');
      return;
    }

    final failed = provider.failCount > 0;
    final message = [
      if (provider.uploadCount > 0) 'Uploaded ${provider.uploadCount} item(s).',
      failed
          ? '${provider.failCount} failed: ${provider.uploadError ?? 'unknown error'}'
          : 'Synced at ${provider.lastSyncLabel}',
    ].join(' ');

    CommonSnackbar.show(
      context: context,
      message: message,
      type: failed ? SnackbarType.warning : SnackbarType.success,
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> _openForm(Map<String, dynamic> args) async {
    final jobId = _provider.jobId;
    await NavigationService().navigateTo(
      NavigationRoutes.jobItemCreateScreen,
      arguments: {'jobId': jobId, ...args},
    );
    if (mounted) await _refresh();
  }

  Future<void> _createItem() async {
    final categories = context.read<CategoryProvider>();
    try {
      await categories.fetchCategories();
    } catch (_) {}
    if (!mounted) return;

    if (categories.totalItemCount == 0) {
      CommonSnackbar.show(
        context: context,
        message: categories.errorMessage ?? 'No categories available',
        type: SnackbarType.warning,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final category = await showDialog<CategoryItem>(
      context: context,
      builder: (_) => const CategoryDialog(),
    );
    categories.searchCategories('');
    if (category == null || !mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: LoadingFieldsDialog(label: category.name),
      ),
    );

    try {
      await categories.loadFieldsFromLocalStorage(category.id);
      navigator.pop();
    } catch (e) {
      navigator.pop();
      if (mounted) CommonSnackbar.showError(context, 'Failed to load fields: $e');
      return;
    }

    await _openForm({
      'selectedCategory': category,
      'preloadedFields': categories.getFieldsAsJson(),
    });
  }

  Future<void> _openReport(String typeId, String name, _Item data) async {
    if (ItemRegisterProvider.idOf(data).isEmpty) {
      CommonSnackbar.showWarning(
        context,
        'Item ID is missing. Please sync first then try again.',
      );
      return;
    }

    final provider = _provider;
    await NavigationService().navigateTo(
      NavigationRoutes.reportFieldsScreen,
      arguments: {
        'reportTypeId': typeId,
        'reportName': name,
        'item': ItemRegisterProvider.toItem(data),
      },
    );
    await provider.loadLocal();
  }

  Future<void> _export() async {
    try {
      await exportCSV(_provider.buildCsv(), context);
      if (mounted) {
        CommonSnackbar.showSuccess(context, 'CSV file exported successfully!');
      }
    } catch (e) {
      if (mounted) CommonSnackbar.showError(context, 'Error exporting file: $e');
    }
  }

  void _showExportDialog() {
    final provider = _provider;
    if (provider.selectedRows.isEmpty) {
      CommonSnackbar.showInfo(context, 'Select rows to export');
      return;
    }

    final primary = context.colors.primary;
    final text = context.topology.textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: dialogShape,
        title: Text(
          'Export Data',
          style: text.titleSmall?.copyWith(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Export ${provider.selectedRows.length} selected rows to CSV file?',
          style: text.bodySmall?.copyWith(color: primary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: TextStyle(color: primary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _export();
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Export'),
            style: filledStyle(primary),
          ),
        ],
      ),
    );
  }

  void _showColumnDialog() {
    final provider = _provider;
    final primary = context.colors.primary;

    showDialog(
      context: context,
      builder: (dialogContext) => ListenableBuilder(
        listenable: provider,
        builder: (_, __) => AlertDialog(
          shape: dialogShape,
          title: Text(
            'Select Columns',
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final e in ItemRegisterProvider.columnLabels.entries)
                  CheckboxListTile(
                    title: Text(e.value),
                    value: provider.isColumnVisible(e.key),
                    activeColor: primary,
                    onChanged: (v) =>
                        provider.setColumnVisible(e.key, v ?? false),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: filledStyle(primary),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemOptions(_Item item) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;
    final itemNo = ItemRegisterProvider.text(item, ['itemNo', 'item_no']);
    final description = ItemRegisterProvider.value(item, 'description');

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: dialogShape,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.06),
                    border: Border(
                      bottom: BorderSide(color: primary.withValues(alpha: 0.12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemNo.isNotEmpty ? itemNo : 'Item',
                              style: text.titleMedium?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (description != '-')
                              Text(
                                description,
                                style: text.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: primary),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ReportTableBody(
                    item: item,
                    onSelected: (typeId, name) {
                      Navigator.of(dialogContext).pop();
                      _openReport(typeId, name, item);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<ItemRegisterProvider>();
    final list = provider.filteredItems;

    if (provider.isLoading && !provider.hasItems) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: context.colors.primary,
        ),
      );
    }
    if (list.isEmpty) {
      return provider.query.isEmpty
          ? ItemEmptyState(onCreate: _createItem)
          : _buildSearchEmpty(context);
    }
    return context.isTablet
        ? _buildTablet(context, provider, list)
        : _buildMobile(context, provider, list);
  }

  Widget _buildTablet(
      BuildContext context,
      ItemRegisterProvider provider,
      List<_Item> list,
      ) {
    final primary = context.colors.primary;

    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          ItemSearchBar(
            controller: _searchController,
            hint: 'Search by item, description, category or location...',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                ItemResultsCount(
                  count: list.length,
                  selectedCount: provider.selectedRows.length,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ItemActionButton(
                          label: 'Create Item',
                          icon: Icons.add_rounded,
                          color: primary,
                          onPressed: _createItem,
                        ),
                        const SizedBox(width: 8),
                        ItemActionButton(
                          label: 'Export Grid',
                          icon: Icons.download_rounded,
                          color: primary,
                          onPressed: _showExportDialog,
                        ),
                        const SizedBox(width: 8),
                        ItemActionButton(
                          label: 'Columns',
                          icon: Icons.view_column_rounded,
                          color: Colors.teal.shade600,
                          onPressed: _showColumnDialog,
                        ),
                        const SizedBox(width: 8),
                        ItemSyncButton(provider: provider, onSync: _syncNow),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ItemSyncBanner(provider: provider, bottomSpacing: 8),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: IntrinsicWidth(
              stepWidth: double.infinity,
              child: _buildTable(context, provider, list),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(
      BuildContext context,
      ItemRegisterProvider provider,
      List<_Item> list,
      ) {
    final primary = context.colors.primary;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: ItemSearchBar(
                  controller: _searchController,
                  hint: 'Search items',
                ),
              ),
              const SizedBox(width: 8),
              ItemSyncButton(provider: provider, onSync: _syncNow),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              ItemResultsCount(
                count: list.length,
                selectedCount: provider.selectedRows.length,
              ),
              const Spacer(),
              ItemActionButton(
                label: 'Add',
                icon: Icons.add_rounded,
                color: primary,
                onPressed: _createItem,
              ),
              const SizedBox(width: 6),
              ItemActionButton(
                label: 'Export',
                icon: Icons.download_rounded,
                color: primary,
                onPressed: _showExportDialog,
              ),
            ],
          ),
        ),
        ItemSyncBanner(provider: provider),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildTable(context, provider, list),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchEmpty(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ItemSearchBar(
          controller: _searchController,
          hint: 'Search items',
        ),
      ),
      Expanded(
        child: ItemStateMessage(
          icon: Icons.search_off_rounded,
          color: Colors.grey,
          title: 'No items found',
          subtitle: 'Try adjusting your search',
          action: ElevatedButton.icon(
            onPressed: _searchController.clear,
            icon: const Icon(Icons.clear_all_rounded, size: 16),
            label: const Text('Clear Search'),
            style: filledStyle(
              context.colors.primary,
              radius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildTable(
      BuildContext context,
      ItemRegisterProvider provider,
      List<_Item> list,
      ) {
    final primary = context.colors.primary;
    final columns = provider.activeColumns;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        showCheckboxColumn: true,
        columnSpacing: 20,
        dataRowMinHeight: 60,
        dataRowMaxHeight: 60,
        onSelectAll: (v) => provider.toggleAll(v ?? false, list.length),
        columns: [
          for (final k in columns)
            _column(context, ItemRegisterProvider.columnLabels[k]!),
          _column(context, 'Actions'),
        ],
        rows: [
          for (var i = 0; i < list.length; i++)
            DataRow(
              selected: provider.selectedRows.contains(i),
              onSelectChanged: (v) => provider.toggleRow(i, v ?? false),
              color: i.isEven
                  ? WidgetStatePropertyAll(primary.withValues(alpha: 0.05))
                  : null,
              cells: [
                for (final k in columns)
                  DataCell(_buildCell(context, k, list[i])),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: primary, size: 18),
                    tooltip: 'Options',
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: () => _showItemOptions(list[i]),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  DataColumn _column(BuildContext context, String label) => DataColumn(
    label: Text(
      label,
      style: context.topology.textTheme.titleSmall?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildCell(BuildContext context, String key, _Item data) {
    final style = context.topology.textTheme.bodySmall?.copyWith(
      color: context.colors.primary,
    );
    final value = ItemRegisterProvider.cellValue(data, key);

    return switch (key) {
      'item' => InkWell(
        onTap: () => NavigationService().navigateTo(
          NavigationRoutes.jobItemDetails,
          arguments: {'itemMap': data},
        ),
        child: Text(value, style: style?.copyWith(fontWeight: FontWeight.w600)),
      ),
      'status' => ItemStatusChip(status: value),
      'description' || 'category' || 'location' => Text(
        value,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      _ => Text(value, style: style),
    };
  }
}