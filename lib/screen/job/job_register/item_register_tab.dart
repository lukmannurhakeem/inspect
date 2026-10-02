import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:inspect/core/extension/date_time_extension.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/file_export_stub.dart'
    if (dart.library.html) 'package:inspect/core/utils/file_export_web.dart'
    if (dart.library.io) 'package:inspect/core/utils/file_export_mobile.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ItemRegisterTab extends StatefulWidget {
  final String jobId;

  const ItemRegisterTab({super.key, required this.jobId});

  @override
  State<ItemRegisterTab> createState() => _ItemRegisterTabState();
}

class _ItemRegisterTabState extends State<ItemRegisterTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchFocused = false;
  Set<int> selectedRows = <int>{};
  bool selectAll = false;
  int sortColumnIndex = 0;

  List<Map<String, dynamic>> _localItems = [];
  bool _isLoadingLocalItems = false;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  bool _isLoadedFromCache = false;
  int _lastUploadCount = 0;

  int _localItemsVersion = 0;

  // ── Column config ──────────────────────────────────────────────────────────
  static const _allColumnKeys = [
    'item',
    'description',
    'category',
    'location',
    'status',
    'inspectedOn',
    'expiryDate',
  ];

  static const _columnLabels = <String, String>{
    'item': 'Item',
    'description': 'Description',
    'category': 'Category',
    'location': 'Location',
    'status': 'Status',
    'inspectedOn': 'inspected On',
    'expiryDate': 'Expiry Date',
  };

  Map<String, bool> selectedColumns = {
    'item': true,
    'description': true,
    'category': true,
    'location': true,
    'status': true,
    'inspectedOn': true,
    'expiryDate': true,
  };

  List<String> get _activeColumns =>
      _allColumnKeys.where((k) => selectedColumns[k] == true).toList();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialLoad());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── _initialLoad ───────────────────────────────────────────────────────────

  Future<void> _initialLoad() async {
    await _loadLocalItems();
    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity.any((r) => r != ConnectivityResult.none);
    if (isOnline) {
      await _syncFromApi(silent: true);
    }
  }

  // ── _loadLocalItems ────────────────────────────────────────────────────────

  Future<void> _loadLocalItems() async {
    if (!mounted) return;
    setState(() => _isLoadingLocalItems = true);

    try {
      final results = await Future.wait([
        JobItemStorage.getJobItems(widget.jobId),
        JobItemStorage.getPendingItems(widget.jobId),
        JobItemStorage.getJobDrafts(widget.jobId),
      ]);

      final submitted = results[0];
      final pending = results[1];
      final drafts = results[2];

      debugPrint(
        '📦 _loadLocalItems: ${submitted.length} submitted, '
        '${pending.length} pending, ${drafts.length} drafts',
      );

      final serverIds =
          submitted
              .map((m) => _strFromMap(m, ['itemId', 'itemID', 'item_id']))
              .where((id) => id.isNotEmpty)
              .toSet();

      final seen = <String>{};
      final allItems = <Map<String, dynamic>>[];

      void addItem(Map<String, dynamic> item) {
        final id = _strFromMap(item, ['itemId', 'itemID', 'item_id']);
        if (id.isEmpty || seen.add(id)) allItems.add(item);
      }

      for (final item in submitted) addItem(item);

      for (final item in [...pending, ...drafts]) {
        final id = _strFromMap(item, ['itemId', 'itemID', 'item_id']);
        if (id.isEmpty || !serverIds.contains(id)) {
          addItem(item);
        }
      }

      if (mounted) {
        _localItemsVersion++;
        setState(() {
          _localItems = allItems;
          _isLoadingLocalItems = false;
          _isLoadedFromCache = true;
        });
      }
    } catch (e) {
      debugPrint('❌ _loadLocalItems error: $e');
      if (mounted) {
        _localItemsVersion++;
        setState(() {
          _localItems = [];
          _isLoadingLocalItems = false;
          _isLoadedFromCache = true;
        });
      }
    }
  }

  // ── _getItemsToUpload ──────────────────────────────────────────────────────

  List<Map<String, dynamic>> _getItemsToUpload() {
    return _localItems.where((item) {
      final status = (item['status'] ?? '').toString().toLowerCase();
      return status == 'draft' ||
          status == 'pending_submission' ||
          item['isPending'] == true;
    }).toList();
  }

  // ── _uploadPendingItems ────────────────────────────────────────────────────

  Future<int> _uploadPendingItems(
    List<Map<String, dynamic>> items,
    Map<String, Map<String, dynamic>> justUploadedMaps,
  ) async {
    if (items.isEmpty) return 0;
    final jobProvider = context.read<JobProvider>();
    int uploaded = 0;

    for (final itemMap in items) {
      try {
        final result = await jobProvider.submitJobItemFromMap(
          context,
          widget.jobId,
          itemMap,
        );
        final success = result['success'] == true;
        final queued = result['queued'] == true;

        if (success && !queued) {
          final itemId = _strFromMap(itemMap, ['itemId', 'itemID', 'item_id']);
          if (itemId.isNotEmpty) {
            await JobItemStorage.markItemAsSubmitted(widget.jobId, itemId);
            justUploadedMaps[itemId] = {
              ...itemMap,
              'status': 'submitted',
              'isPending': false,
            };
          }
          uploaded++;
        }
      } catch (e) {
        debugPrint(
          '⚠️ Upload exception for '
          '${_strFromMap(itemMap, ['itemId', 'itemID', 'item_id'])}: $e',
        );
      }
    }
    return uploaded;
  }

  // ── _syncFromApi ───────────────────────────────────────────────────────────

  Future<void> _syncFromApi({bool silent = false}) async {
    if (!mounted) return;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity.any((r) => r != ConnectivityResult.none);

    if (!isOnline) {
      await _loadLocalItems();
      return;
    }

    final versionAtStart = _localItemsVersion;

    if (mounted) setState(() => _isSyncing = true);
    _lastUploadCount = 0;

    try {
      final freshLocal = await Future.wait([
        JobItemStorage.getPendingItems(widget.jobId),
        JobItemStorage.getJobDrafts(widget.jobId),
      ]);
      final toUpload = <Map<String, dynamic>>[];
      final seenUpload = <String>{};
      for (final list in freshLocal) {
        for (final item in list) {
          final id = _strFromMap(item, ['itemId', 'itemID', 'item_id']);
          final status = (item['status'] ?? '').toString().toLowerCase();
          final isPending =
              status == 'draft' ||
              status == 'pending_submission' ||
              item['isPending'] == true;
          if (isPending && (id.isEmpty || seenUpload.add(id))) {
            toUpload.add(item);
          }
        }
      }

      // Build justUploadedMaps AFTER upload so only truly-uploaded items
      // are marked as submitted. Building it before caused failed uploads
      // to be optimistically marked submitted and then silently filtered out.
      final justUploadedMaps = <String, Map<String, dynamic>>{};

      final uploaded = await _uploadPendingItems(toUpload, justUploadedMaps);
      _lastUploadCount = uploaded;

      final jobProvider = context.read<JobProvider>();

      List<Map<String, dynamic>> serverMaps = [];
      try {
        await jobProvider.fetchJobRegisterModel(context, widget.jobId);
        final serverItems = jobProvider.jobItems;
        serverMaps = serverItems.map(_itemToMap).toList();
      } catch (e) {
        debugPrint('⚠️ _syncFromApi: server fetch failed (offline?): $e');
      }

      if (serverMaps.isNotEmpty) {
        final serverIds =
            serverMaps
                .map((m) => _strFromMap(m, ['itemId', 'itemID', 'item_id']))
                .where((id) => id.isNotEmpty)
                .toSet();

        final mergedForStorage = [
          ...serverMaps,
          for (final entry in justUploadedMaps.entries)
            if (!serverIds.contains(entry.key)) entry.value,
        ];

        await JobItemStorage.saveJobItems(
          widget.jobId,
          mergedForStorage,
        );
        debugPrint(
          '✅ _syncFromApi: saved ${mergedForStorage.length} items from server',
        );
      } else {
        debugPrint(
          '⚠️ _syncFromApi: server returned no items — keeping local cache intact',
        );
      }

      final allBuckets = await Future.wait([
        JobItemStorage.getJobItems(widget.jobId),
        JobItemStorage.getPendingItems(widget.jobId),
        JobItemStorage.getJobDrafts(widget.jobId),
      ]);

      final submitted = allBuckets[0];
      final pending = allBuckets[1];
      final drafts = allBuckets[2];

      final submittedIds =
          submitted
              .map((m) => _strFromMap(m, ['itemId', 'itemID', 'item_id']))
              .where((id) => id.isNotEmpty)
              .toSet();

      final seen = <String>{};
      final merged = <Map<String, dynamic>>[];

      void addItem(Map<String, dynamic> item) {
        final id = _strFromMap(item, ['itemId', 'itemID', 'item_id']);
        if (id.isEmpty || seen.add(id)) merged.add(item);
      }

      for (final item in submitted) addItem(item);

      for (final item in [...pending, ...drafts]) {
        final id = _strFromMap(item, ['itemId', 'itemID', 'item_id']);
        final stillPending =
            item['isPending'] == true ||
            (item['status'] ?? '').toString().toLowerCase() == 'draft' ||
            (item['status'] ?? '').toString().toLowerCase() ==
                'pending_submission';
        // Always show items that are still pending/draft even if their
        // local ID somehow collides with a submitted ID.
        if (id.isEmpty || !submittedIds.contains(id) || stillPending) {
          addItem(item);
        }
      }

      if (mounted) {
        setState(() {
          if (_localItemsVersion == versionAtStart) _localItems = merged;
          _lastSyncTime = DateTime.now();
          _isLoadedFromCache = false;
          _isSyncing = false;
        });
      }
    } catch (e) {
      debugPrint('❌ _syncFromApi failed: $e');
      await _loadLocalItems();
      if (mounted) {
        setState(() => _isSyncing = false);
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Sync failed — showing cached data'),
                ],
              ),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _strFromMap(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k]?.toString().trim() ?? '';
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  /// Parses the `reports` array from an itemData map into a typed list.
  List<Map<String, dynamic>> _parseReports(Map<String, dynamic> itemData) {
    final raw = itemData['reports'];
    if (raw == null) return [];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }

  // ── FIX: _itemToMap now flattens nested itemData fields ───────────────────
  Map<String, dynamic> _itemToMap(Item item) {
    final map = <String, dynamic>{
      'itemId': item.itemId ?? '',
      'itemID': item.itemId ?? '',
      'item_id': item.itemId ?? '',
      'itemNo': item.itemNo ?? '',
      'description': item.description ?? '',
      'archived': (item.archived ?? false).toString(),
      'status': item.status ?? 'submitted',
      'categoryId': item.categoryId ?? '',
      'categoryID': item.categoryId ?? '',
      'category_id': item.categoryId ?? '',
      'categoryName':
          (item.customFields?['categoryName']?.toString().isNotEmpty == true)
              ? item.customFields!['categoryName'].toString()
              : item.categoryId ?? '',
      'locationId': item.locationId ?? '',
      'locationID': item.locationId ?? '',
      'location_id': item.locationId ?? '',
      'detailedLocation': item.detailedLocation ?? '',
      'detailed_location': item.detailedLocation ?? '',
      'ItemLocation': item.detailedLocation ?? '',
      'rfidNo': item.rfidNo ?? '',
      'RFIDNo': item.rfidNo ?? '',
      'rfid_no': item.rfidNo ?? '',
      'manufacturer': item.manufacturer ?? '',
      'manufacturerAddress': item.manufacturerAddress ?? '',
      'manufacturer_address': item.manufacturerAddress ?? '',
      'manufacturerDate':
          item.manufacturerDate?.toIso8601String().split('T').first ?? '',
      'manufacture_date':
          item.manufacturerDate?.toIso8601String().split('T').first ?? '',
      'firstUseDate':
          item.firstUseDate?.toIso8601String().split('T').first ?? '',
      'first_use_date':
          item.firstUseDate?.toIso8601String().split('T').first ?? '',
      'expiryDateTimeStamp':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',
      'expiryDate':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',
      'expiry_date':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',
      'swl': item.swl ?? '',
      'photoReference': item.photoReference ?? '',
      'photo_reference': item.photoReference ?? '',
      'standardReference': item.standardReference ?? '',
      'standard_reference': item.standardReference ?? '',
      'internalNotes': item.internalNotes ?? '',
      'internal_notes': item.internalNotes ?? '',
      'customerName':
          item.customFields?['customerName']?.toString() ??
          item.customFields?['customer']?.toString() ??
          '',
      'siteName':
          item.customFields?['siteName']?.toString() ??
          item.customFields?['site']?.toString() ??
          '',
      'applicableCode':
          item.customFields?['applicableCode']?.toString() ??
          item.customFields?['ApplicableCode']?.toString() ??
          '',
      // Preserve the reports array from the server response
      'reports': item.customFields?['reports'] ?? [],
    };

    // Spread all top-level customFields (skipping known nested maps)
    if (item.customFields != null) {
      for (final entry in item.customFields!.entries) {
        if (entry.key == 'itemData') continue; // handled separately below
        if (!map.containsKey(entry.key)) {
          map[entry.key] = entry.value?.toString() ?? '';
        }
      }

      // FIX: Flatten nested itemData map into the top-level map so that
      // dynamic category fields (Dimension, Tare Weight, Pay Load,
      // Max Gross Weight, Comment, etc.) are available on the detail screen
      // without requiring an additional API fetch.
      final itemData = item.customFields!['itemData'];
      if (itemData is Map<String, dynamic>) {
        itemData.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            // Only set if not already set by a top-level field
            if (!map.containsKey(key) || (map[key] ?? '').toString().isEmpty) {
              map[key] = value.toString();
            }
          }
        });
        debugPrint(
          '✅ _itemToMap: spread ${itemData.length} itemData fields '
          'for item ${item.itemId}',
        );
      }
    }

    return map;
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  List<Map<String, dynamic>> _getFilteredLocalItems() {
    if (_searchQuery.isEmpty) return _localItems;
    final q = _searchQuery.toLowerCase();
    return _localItems.where((item) {
      return (item['itemNo'] ?? '').toString().toLowerCase().contains(q) ||
          (item['description'] ?? '').toString().toLowerCase().contains(q) ||
          (item['categoryName'] ?? '').toString().toLowerCase().contains(q) ||
          (item['detailedLocation'] ?? '').toString().toLowerCase().contains(q);
    }).toList();
  }

  String _getItemValue(Map<String, dynamic> item, String key) {
    final v = item[key];
    if (v == null || v.toString().isEmpty) return '-';
    return v.toString();
  }

  String _getItemStatus(Map<String, dynamic> item) =>
      (item['status'] ?? 'draft').toString().toLowerCase();

  // ── Navigation ─────────────────────────────────────────────────────────────

  Future<void> _navigateToCreateItem(
    BuildContext context, {
    required CategoryItem selectedCategory,
    required List<Map<String, dynamic>> preloadedFields,
  }) async {
    await NavigationService().navigateTo(
      NavigationRoutes.jobItemCreateScreen,
      arguments: {
        'jobId': widget.jobId,
        'selectedCategory': selectedCategory,
        'preloadedFields': preloadedFields,
      },
    );
    // Always reload local items first so offline drafts appear immediately,
    // then attempt a server sync if online.
    if (!mounted) return;
    await _loadLocalItems();
    if (mounted) await _syncFromApi(silent: true);
  }

  Future<void> _navigateToEditItem(
    BuildContext context,
    Map<String, dynamic> itemData,
  ) async {
    await NavigationService().navigateTo(
      NavigationRoutes.jobItemCreateScreen,
      arguments: {
        'jobId': widget.jobId,
        'existingItem': itemData,
        'isEditMode': true,
      },
    );
    // Always reload local items first so offline edits appear immediately,
    // then attempt a server sync if online.
    if (!mounted) return;
    await _loadLocalItems();
    if (mounted) await _syncFromApi(silent: true);
  }

  // ── Category selection ─────────────────────────────────────────────────────

  void _showCategorySelectionBeforeCreate(BuildContext context) async {
    try {
      await context.read<CategoryProvider>().fetchCategories();
    } catch (_) {
      // Ignore — fetchCategories already falls back to cache internally.
    }
    if (!context.mounted) return;

    final provider = context.read<CategoryProvider>();
    // Open the dialog as long as we have categories (online or from cache).
    // If there are truly no categories at all, show a helpful error.
    if (provider.totalItemCount > 0) {
      _showCategorySelectionDialogForCreate(context);
    } else {
      final msg = provider.errorMessage ?? 'No categories available';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(msg)),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showCategorySelectionDialogForCreate(BuildContext context) {
    CategoryItem? selectedCategory;
    final TextEditingController dialogSearchController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                width: MediaQuery.of(ctx).size.width * 0.9,
                height: MediaQuery.of(ctx).size.height * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ctx.colors.primary,
                                ctx.colors.primary.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: ctx.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.category_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Category',
                                style: ctx.topology.textTheme.titleMedium
                                    ?.copyWith(
                                      color: ctx.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Choose a category for the new item',
                                style: ctx.topology.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogSearchController.dispose();
                            Navigator.of(dialogContext).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: ctx.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    CommonTextField(
                      controller: dialogSearchController,
                      hintText: 'Search categories...',
                      style: ctx.topology.textTheme.bodySmall?.copyWith(
                        color: ctx.colors.primary,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: ctx.colors.primary.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      suffixIcon:
                          dialogSearchController.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: ctx.colors.primary,
                                  size: 18,
                                ),
                                onPressed: () {
                                  dialogSearchController.clear();
                                  context
                                      .read<CategoryProvider>()
                                      .searchCategories('');
                                  setDialogState(() {});
                                },
                              )
                              : null,
                      onChanged: (value) {
                        context.read<CategoryProvider>().searchCategories(
                          value,
                        );
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: context.colors.primary,
                              ),
                            );
                          }

                          if (provider.errorMessage != null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 48,
                                    color: Colors.red.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    provider.errorMessage!,
                                    style: context.topology.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () => provider.refresh(),
                                    icon: const Icon(Icons.refresh_rounded),
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

                          if (provider.totalItemCount == 0) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          context.colors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          context.colors.primary.withValues(
                                            alpha: 0.05,
                                          ),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.category_outlined,
                                      size: 48,
                                      color: context.colors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    dialogSearchController.text.isNotEmpty
                                        ? 'No categories matching\n'
                                            '"${dialogSearchController.text}"'
                                        : 'No categories available',
                                    style: context.topology.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context.colors.primary
                                              .withValues(alpha: 0.7),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (dialogSearchController
                                      .text
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    TextButton.icon(
                                      onPressed: () {
                                        dialogSearchController.clear();
                                        context
                                            .read<CategoryProvider>()
                                            .searchCategories('');
                                        setDialogState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.clear_all_rounded,
                                        size: 16,
                                      ),
                                      label: const Text('Clear search'),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: provider.totalItemCount,
                            itemBuilder: (context, index) {
                              final category = provider.getCategoryByIndex(
                                index,
                              );
                              if (category == null) {
                                return const SizedBox.shrink();
                              }
                              final isSelected =
                                  selectedCategory?.id == category.id;
                              return _buildCategoryItem(
                                context,
                                provider,
                                category,
                                isSelected,
                                () => setDialogState(
                                  () => selectedCategory = category,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            dialogSearchController.dispose();
                            Navigator.of(dialogContext).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: ctx.colors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed:
                              selectedCategory != null
                                  ? () async {
                                    Navigator.of(dialogContext).pop();
                                    dialogSearchController.dispose();
                                    if (!context.mounted) return;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder:
                                          (_) => WillPopScope(
                                            onWillPop: () async => false,
                                            child: Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  28,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color:
                                                          context
                                                              .colors
                                                              .primary,
                                                      strokeWidth: 3,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Loading fields for',
                                                      style: context
                                                          .topology
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      selectedCategory!.name,
                                                      style: context
                                                          .topology
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color:
                                                                context
                                                                    .colors
                                                                    .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    );

                                    try {
                                      final categoryProvider =
                                          context.read<CategoryProvider>();
                                      await categoryProvider
                                          .loadFieldsFromLocalStorage(
                                            selectedCategory!.id,
                                          );
                                      final loadedFields =
                                          categoryProvider.getFieldsAsJson();
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                      await _navigateToCreateItem(
                                        context,
                                        selectedCategory: selectedCategory!,
                                        preloadedFields: loadedFields,
                                      );
                                    } catch (e) {
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.error_outline_rounded,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Failed to load fields: $e',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor:
                                                Colors.red.shade600,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.all(16),
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  : null,
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: const Text('Continue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      if (mounted) {
        context.read<CategoryProvider>().searchCategories('');
      }
    });
  }

  // ── Category item widget ───────────────────────────────────────────────────

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryProvider provider,
    CategoryItem category,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        if (category.children.isNotEmpty) {
          provider.toggleExpansion(category);
        }
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? context.colors.primary.withValues(alpha: 0.1)
                  : _getCategoryBackgroundColor(context, category),
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(color: context.colors.primary, width: 1.5)
                  : null,
        ),
        margin: EdgeInsets.only(left: category.level * 16.0, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child:
                  category.children.isNotEmpty
                      ? Icon(
                        category.isExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: context.colors.primary,
                        size: 18,
                      )
                      : _getIndentationIcon(category.level),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? context.colors.primary : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? context.colors.primary : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: _getCategoryTextStyle(context, category, isSelected),
                  ),
                  if (category.categoryCode != null)
                    Text(
                      'Code: ${category.categoryCode}',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  if (category.description != null &&
                      category.description!.isNotEmpty)
                    Text(
                      category.description!,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (category.children.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.children.length}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryBackgroundColor(
    BuildContext context,
    CategoryItem category,
  ) {
    if (category.level == 0) return Colors.transparent;
    return context.colors.primary.withValues(
      alpha: 0.02 + (category.level * 0.01),
    );
  }

  TextStyle? _getCategoryTextStyle(
    BuildContext context,
    CategoryItem category,
    bool isSelected,
  ) {
    if (category.level == 0) {
      return context.topology.textTheme.bodyMedium?.copyWith(
        color: context.colors.primary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      );
    }
    return context.topology.textTheme.bodySmall?.copyWith(
      color:
          isSelected
              ? context.colors.primary
              : context.colors.primary.withValues(alpha: 0.8),
      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
    );
  }

  Widget? _getIndentationIcon(int level) {
    if (level == 0) return null;
    return Icon(
      level == 1 ? Icons.subdirectory_arrow_right : Icons.more_horiz,
      color: Colors.grey.withValues(alpha: 0.6),
      size: 14,
    );
  }

  // ── Export ─────────────────────────────────────────────────────────────────

  void _showColumnSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setS) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Select Columns',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        _allColumnKeys.map((key) {
                          return CheckboxListTile(
                            title: Text(_columnLabels[key] ?? key),
                            value: selectedColumns[key] ?? false,
                            activeColor: context.colors.primary,
                            onChanged:
                                (v) => setS(
                                  () => selectedColumns[key] = v ?? false,
                                ),
                          );
                        }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: context.colors.primary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Export Data',
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Export ${selectedRows.length} selected rows to CSV file?',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.colors.primary),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _exportToCSV();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('CSV file exported successfully!'),
                          ],
                        ),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _exportToCSV() async {
    if (selectedRows.isEmpty) return;
    final list = _getFilteredLocalItems();

    final active = _activeColumns;
    final headers = active.map((k) => _columnLabels[k] ?? k).toList();

    String csvValue(String key, Map<String, dynamic> data) {
      switch (key) {
        case 'item':
          return _escapeCSV(_getItemValue(data, 'itemNo'));
        case 'description':
          return _escapeCSV(_getItemValue(data, 'description'));
        case 'category':
          return _escapeCSV(_getItemValue(data, 'categoryName'));
        case 'location':
          return _escapeCSV(_getItemValue(data, 'detailedLocation'));
        case 'status':
          return _escapeCSV(_getItemStatus(data));
        case 'inspectedOn':
          return _escapeCSV(_getItemValue(data, 'firstUseDate'));
        case 'expiryDate':
          return _escapeCSV(_getItemValue(data, 'expiryDateTimeStamp'));
        default:
          return _escapeCSV(_getItemValue(data, key));
      }
    }

    final List<List<String>> rows = [headers];
    for (int index in selectedRows) {
      if (index >= list.length) continue;
      final data = list[index];
      rows.add(active.map((k) => csvValue(k, data)).toList());
    }

    final csv = rows.map((r) => r.join(',')).join('\n');
    try {
      await exportCSV(csv, context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting file: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  String _escapeCSV(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  // ── Status ─────────────────────────────────────────────────────────────────

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'submitted':
        return Colors.green;
      case 'pending':
      case 'pending_submission':
      case 'draft':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ── Item Options Dialog ────────────────────────────────────────────────────

  void _showItemOptionsDialog(
    BuildContext context,
    Map<String, dynamic> itemData,
  ) {
    final itemNo = _strFromMap(itemData, ['itemNo', 'item_no']);
    final existingReports = _parseReports(itemData);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 620,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                      color: context.colors.primary.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                          color: context.colors.primary.withValues(alpha: 0.12),
                        ),
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
                                style: context.topology.textTheme.titleMedium
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (_getItemValue(itemData, 'description') != '-')
                                Text(
                                  _getItemValue(itemData, 'description'),
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.colors.primary,
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: _ReportTableBody(
                      itemData: itemData,
                      existingReports: existingReports,
                      dialogContext: dialogContext,
                      onReportSelected: (typeId, reportName) {
                        Navigator.of(dialogContext).pop();
                        _handleReportAction(
                          context,
                          typeId,
                          reportName,
                          itemData,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreateReportDialog(
    BuildContext context,
    Map<String, dynamic> itemData,
  ) async {
    final systemProvider = context.read<SystemProvider>();
    try {
      await systemProvider.fetchReportType();
      if (!context.mounted) return;

      final reports = systemProvider.getReportTypeModel?.data ?? [];
      if (reports.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No report types available'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      CommonDialog.show(
        context,
        widget: StatefulBuilder(
          builder:
              (context, _) => Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colors.primary.withValues(alpha: 0.1),
                            context.colors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      context.colors.primary,
                                      context.colors.primary.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.assignment_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Report Type',
                                    style: context
                                        .topology
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: context.colors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    'Item: ${_getItemValue(itemData, 'itemNo')}',
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: context.colors.primary,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _handleReportAction(
                                context,
                                report.reportType?.reportTypeId ?? '',
                                report.reportType?.reportName ?? 'Report',
                                itemData,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.colors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.description_rounded,
                                      color: context.colors.primary,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      report.reportType?.reportName ?? '',
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: context.colors.primary,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load report types: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _handleReportAction(
    BuildContext context,
    String reportTypeId,
    String reportName,
    Map<String, dynamic> itemData,
  ) async {
    final itemId = _strFromMap(itemData, ['itemId', 'itemID', 'item_id']);
    final itemNo = _strFromMap(itemData, ['itemNo', 'item_no']);

    if (itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Item ID is missing. Please sync first then try again.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final item = Item(
      itemId: itemId,
      itemNo: itemNo,
      description: _strFromMap(itemData, ['description', 'ItemDescription']),
      categoryId: _strFromMap(itemData, [
        'categoryId',
        'categoryID',
        'category_id',
      ]),
      locationId: _strFromMap(itemData, [
        'locationId',
        'locationID',
        'location_id',
      ]),
      detailedLocation: _strFromMap(itemData, [
        'detailedLocation',
        'DetailedLocation',
        'detailed_location',
        'ItemLocation',
      ]),
      status: _strFromMap(itemData, ['status']),
      rfidNo: _strFromMap(itemData, ['rfidNo', 'RFIDNo', 'rfid_no']),
      manufacturer: _strFromMap(itemData, ['manufacturer']),
      swl: _strFromMap(itemData, ['swl']),
    );

    await NavigationService().navigateTo(
      NavigationRoutes.reportFieldsScreen,
      arguments: {
        'reportTypeId': reportTypeId,
        'reportName': reportName,
        'item': item,
      },
    );
    if (mounted) await _loadLocalItems();
  }

  // ── Sync button ────────────────────────────────────────────────────────────

  Widget _buildSyncButton(BuildContext context) {
    final pendingCount = _getItemsToUpload().length;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lastSyncTime != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    _isLoadedFromCache ? Icons.offline_pin : Icons.cloud_done,
                    size: 14,
                    color: context.colors.primary.withValues(alpha: 0.65),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLoadedFromCache ? 'Cached' : _formatTime(_lastSyncTime!),
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withValues(alpha: 0.65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            )
          else if (_isLoadedFromCache)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 14,
                    color: Colors.orange.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (pendingCount > 0 && !_isSyncing)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          IconButton(
            icon:
                _isSyncing
                    ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.primary,
                        ),
                      ),
                    )
                    : Icon(
                      Icons.sync_rounded,
                      color: context.colors.primary,
                      size: 20,
                    ),
            onPressed:
                _isSyncing
                    ? null
                    : () async {
                      await _syncFromApi(silent: false);
                      if (mounted && !_isSyncing) {
                        final msg = StringBuffer();
                        if (_lastUploadCount > 0) {
                          msg.write('Uploaded $_lastUploadCount item(s). ');
                        }
                        msg.write(
                          _lastSyncTime != null
                              ? 'Synced at ${_formatTime(_lastSyncTime!)}'
                              : 'Sync completed',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(msg.toString()),
                              ],
                            ),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
            tooltip:
                pendingCount > 0
                    ? 'Upload $pendingCount pending item(s) & refresh'
                    : 'Sync items from server',
          ),
        ],
      ),
    );
  }

  Widget? _buildSyncBanner(BuildContext context) {
    final pendingCount = _getItemsToUpload().length;

    if (!_isSyncing && pendingCount > 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          border: Border(
            bottom: BorderSide(color: Colors.orange.withValues(alpha: 0.2)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 14,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$pendingCount item(s) pending upload. Tap sync to push to server.',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isSyncing) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.06),
          border: Border(
            bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.15)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Syncing items from server...',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoadedFromCache && _lastSyncTime == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.06),
          border: Border(
            bottom: BorderSide(color: Colors.orange.withValues(alpha: 0.15)),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.offline_pin, size: 14, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Offline — showing cached data. Tap sync to refresh.',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return null;
  }

  Widget _buildResultsCount(List<Map<String, dynamic>> list) {
    final count = list.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary.withValues(alpha: 0.12),
            context.colors.primary.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 15,
            color: context.colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '$count ${count == 1 ? 'item' : 'items'}',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (selectedRows.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${selectedRows.length} selected',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 15),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: context.topology.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  // ── Empty states ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary.withValues(alpha: 0.1),
                      context.colors.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 60,
                  color: context.colors.primary.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Items Yet',
                style: context.topology.textTheme.titleLarge?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Start building your inventory by creating\nyour first item for this job',
                textAlign: TextAlign.center,
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _showCategorySelectionBeforeCreate(context),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                label: const Text('Create First Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary.withValues(alpha: 0.06),
                      context.colors.primary.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.colors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'What you can do:',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _featureItem(
                      context,
                      Icons.check_circle_outline_rounded,
                      'Track items and inspections',
                    ),
                    const SizedBox(height: 8),
                    _featureItem(
                      context,
                      Icons.location_on_outlined,
                      'Manage locations and categories',
                    ),
                    const SizedBox(height: 8),
                    _featureItem(
                      context,
                      Icons.download_outlined,
                      'Export reports and data',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: context.colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchEmpty(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildAnimatedSearchBar(isDesktop: false),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade100, Colors.grey.shade50],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear_all_rounded, size: 16),
                  label: const Text('Clear Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSearchBar({required bool isDesktop}) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isSearchFocused = hasFocus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _isSearchFocused
                    ? context.colors.primary
                    : Colors.grey.shade200,
            width: _isSearchFocused ? 2 : 1,
          ),
          boxShadow: [
            if (_isSearchFocused)
              BoxShadow(
                color: context.colors.primary.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: CommonTextField(
          controller: _searchController,
          hintText:
              isDesktop
                  ? 'Search by item, description, category or location...'
                  : 'Search items',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.primary.withValues(alpha: 0.6),
          ),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: context.colors.primary,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filteredList = _getFilteredLocalItems();

    if (_isLoadingLocalItems && _localItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading items...',
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredList.isEmpty) {
      return _searchQuery.isEmpty
          ? _buildEmptyState(context)
          : _buildSearchEmpty(context);
    }

    return context.isTablet
        ? _buildTabletView(context, filteredList)
        : _buildMobileView(context, filteredList);
  }

  // ── Tablet view ────────────────────────────────────────────────────────────

  Widget _buildTabletView(
    BuildContext context,
    List<Map<String, dynamic>> list,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: _buildAnimatedSearchBar(isDesktop: true),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    _buildResultsCount(list),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildActionButton(
                              context,
                              'Create Item',
                              Icons.add_rounded,
                              context.colors.primary,
                              () => _showCategorySelectionBeforeCreate(context),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              context,
                              'Export Grid',
                              Icons.download_rounded,
                              context.colors.primary,
                              () => _showExportDialog(context),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              context,
                              'Columns',
                              Icons.view_column_rounded,
                              Colors.teal.shade600,
                              () => _showColumnSelectionDialog(context),
                            ),
                            const SizedBox(width: 8),
                            _buildSyncButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_buildSyncBanner(context) != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSyncBanner(context)!,
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: IntrinsicWidth(
                    stepWidth: double.infinity,
                    child: DataTable(
                      sortColumnIndex: sortColumnIndex,
                      showCheckboxColumn: true,
                      columnSpacing: 20,
                      dataRowMinHeight: 60,
                      dataRowMaxHeight: 60,
                      onSelectAll: (value) {
                        setState(() {
                          selectAll = value ?? false;
                          selectedRows =
                              selectAll
                                  ? Set.from(
                                    List.generate(list.length, (i) => i),
                                  )
                                  : {};
                        });
                      },
                      columns: [
                        ..._activeColumns.map(
                          (k) => _col(context, _columnLabels[k] ?? k),
                        ),
                        _col(context, 'Actions'),
                      ],
                      rows: List.generate(list.length, (index) {
                        final data = list[index];
                        return DataRow(
                          selected: selectedRows.contains(index),
                          onSelectChanged: (selected) {
                            setState(() {
                              if (selected == true) {
                                selectedRows.add(index);
                              } else {
                                selectedRows.remove(index);
                              }
                              selectAll = selectedRows.length == list.length;
                            });
                          },
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (_) =>
                                index % 2 == 0
                                    ? context.colors.primary.withValues(
                                      alpha: 0.05,
                                    )
                                    : null,
                          ),
                          cells: [
                            ..._activeColumns.map(
                              (k) => DataCell(_buildCell(context, k, data)),
                            ),
                            DataCell(_buildActionsCell(context, data)),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Mobile view ────────────────────────────────────────────────────────────

  Widget _buildMobileView(
    BuildContext context,
    List<Map<String, dynamic>> list,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(child: _buildAnimatedSearchBar(isDesktop: false)),
              const SizedBox(width: 8),
              _buildSyncButton(context),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              _buildResultsCount(list),
              const Spacer(),
              _buildActionButton(
                context,
                'Add',
                Icons.add_rounded,
                context.colors.primary,
                () => _showCategorySelectionBeforeCreate(context),
              ),
              const SizedBox(width: 6),
              _buildActionButton(
                context,
                'Export',
                Icons.download_rounded,
                context.colors.primary,
                () => _showExportDialog(context),
              ),
            ],
          ),
        ),
        if (_buildSyncBanner(context) != null) _buildSyncBanner(context)!,
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  sortColumnIndex: sortColumnIndex,
                  showCheckboxColumn: true,
                  columnSpacing: 20,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 60,
                  onSelectAll: (value) {
                    setState(() {
                      selectAll = value ?? false;
                      selectedRows =
                          selectAll
                              ? Set.from(List.generate(list.length, (i) => i))
                              : {};
                    });
                  },
                  columns: [
                    ..._activeColumns.map(
                      (k) => _col(context, _columnLabels[k] ?? k),
                    ),
                    _col(context, 'Actions'),
                  ],
                  rows: List.generate(list.length, (index) {
                    final data = list[index];
                    return DataRow(
                      selected: selectedRows.contains(index),
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            selectedRows.add(index);
                          } else {
                            selectedRows.remove(index);
                          }
                          selectAll = selectedRows.length == list.length;
                        });
                      },
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (_) =>
                            index % 2 == 0
                                ? context.colors.primary.withValues(alpha: 0.05)
                                : null,
                      ),
                      cells: [
                        ..._activeColumns.map(
                          (k) => DataCell(_buildCell(context, k, data)),
                        ),
                        DataCell(_buildActionsCell(context, data)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataColumn _col(BuildContext context, String label, {int flex = 1}) {
    return DataColumn(
      label: Expanded(
        flex: flex,
        child: Text(
          label,
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String key,
    Map<String, dynamic> data,
  ) {
    final textStyle = context.topology.textTheme.bodySmall?.copyWith(
      color: context.colors.primary,
    );

    switch (key) {
      case 'item':
        return InkWell(
          onTap:
              () => NavigationService().navigateTo(
                NavigationRoutes.jobItemDetails,
                arguments: {'itemMap': data},
              ),
          child: Text(
            _getItemValue(data, 'itemNo'),
            style: textStyle?.copyWith(fontWeight: FontWeight.w600),
          ),
        );
      case 'description':
        return Text(
          _getItemValue(data, 'description'),
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      case 'category':
        return Text(
          _getItemValue(data, 'categoryName'),
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      case 'location':
        return Text(
          _getItemValue(data, 'detailedLocation'),
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      case 'status':
        return _statusChip(context, _getItemStatus(data));
      case 'inspectedOn':
        return Text(_getItemValue(data, 'firstUseDate'), style: textStyle);
      case 'expiryDate':
        return Text(
          _getItemValue(data, 'expiryDateTimeStamp'),
          style: textStyle,
        );
      default:
        return Text(_getItemValue(data, key), style: textStyle);
    }
  }

  Widget _buildActionsCell(BuildContext context, Map<String, dynamic> data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.more_horiz, color: context.colors.primary, size: 18),
          tooltip: 'Options',
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () => _showItemOptionsDialog(context, data),
        ),
      ],
    );
  }

  Widget _statusChip(BuildContext context, String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    Map<String, dynamic> itemData,
  ) async {
    final itemId = _strFromMap(itemData, ['itemId', 'itemID', 'item_id']);
    final itemNo = _strFromMap(itemData, ['itemNo', 'item_no']);

    if (itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Item has no server ID yet. Sync first, then delete.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.orange.shade700,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Delete Item?',
                    style: context.topology.textTheme.titleLarge?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Are you sure you want to delete this item? This action cannot be undone.',
                    style: context.topology.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.of(dialogContext).pop(false),
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
                        child: ElevatedButton(
                          onPressed:
                              () => Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_rounded, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Delete',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirmed != true || !mounted) return;

    final result = await context.read<JobProvider>().deleteJobItem(
      context,
      itemId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      await JobItemStorage.removeItem(widget.jobId, itemId);
      await _loadLocalItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(result['message'] ?? 'Item deleted successfully.'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(result['error'] ?? 'Failed to delete item.'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _ReportTableBody — unchanged from original
// ══════════════════════════════════════════════════════════════════════════════

class _ReportTableBody extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final BuildContext dialogContext;
  final List<Map<String, dynamic>> existingReports;
  final void Function(String typeId, String reportName) onReportSelected;

  const _ReportTableBody({
    required this.itemData,
    required this.dialogContext,
    required this.existingReports,
    required this.onReportSelected,
  });

  @override
  State<_ReportTableBody> createState() => _ReportTableBodyState();
}

class _ReportTableBodyState extends State<_ReportTableBody> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchIfNeeded();
  }

  Future<void> _fetchIfNeeded() async {
    final provider = context.read<SystemProvider>();
    if (provider.getReportTypeModel?.data?.isNotEmpty == true) return;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      await provider.fetchReportType();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic>? _findExisting(String reportTypeId) {
    if (reportTypeId.isEmpty) return null;
    try {
      return widget.existingReports.firstWhere(
        (r) =>
            (r['reportTypeID'] ?? r['reportTypeId'] ?? '')
                .toString()
                .toLowerCase() ==
            reportTypeId.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _openPdf(
    BuildContext context, {
    required String reportId,
    required String viewUrl,
    required String downloadUrl,
    required String reportName,
  }) async {
    final idToUse = reportId.isNotEmpty ? reportId : _extractIdFromUrl(viewUrl);

    if (kIsWeb) {
      final url =
          viewUrl.isNotEmpty
              ? viewUrl
              : downloadUrl.isNotEmpty
              ? downloadUrl
              : idToUse.isNotEmpty
              ? '${AppConstants.apiBaseUrl}'
                  '/reportData/$idToUse/view-pdf'
              : '';

      if (url.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No PDF URL available for this report.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      openInNewTab(url);
      return;
    }

    if (idToUse.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report ID is missing, cannot open PDF.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final systemProvider = Provider.of<SystemProvider>(context, listen: false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Loading PDF...'),
            ],
          ),
          duration: Duration(seconds: 60),
        ),
      );
    }

    try {
      final pdfBytes = await systemProvider.fetchPdfReportById(idToUse);
      if (context.mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (pdfBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'PDF not available. The report may still be processing.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => PdfViewerScreen(
                  pdfData: pdfBytes,
                  reportName:
                      reportName.isNotEmpty ? reportName : 'Report_$idToUse',
                ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  String _extractIdFromUrl(String url) {
    if (url.isEmpty) return '';
    final uuidPattern = RegExp(
      r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
      caseSensitive: false,
    );
    final match = uuidPattern.firstMatch(url);
    return match?.group(0) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load report types',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _error = null);
                  _fetchIfNeeded();
                },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final reports =
        context.watch<SystemProvider>().getReportTypeModel?.data ?? [];

    if (reports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No report types available',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              'Internal',
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: context.colors.primary.withValues(alpha: 0.65),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
                    child: Text(
                      'Report Type',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'New Report',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    child: Text(
                      'Previous Report',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...reports.asMap().entries.map((entry) {
            final idx = entry.key;
            final report = entry.value;
            final name = report.reportType?.reportName ?? '';
            final typeId = report.reportType?.reportTypeId ?? '';
            final isEven = idx % 2 == 0;

            final existing = _findExisting(typeId);
            final reportId =
                (existing?['reportID'] ?? existing?['reportId'] ?? '')
                    .toString();
            final viewUrl = existing?['viewUrl']?.toString() ?? '';
            final downloadUrl = existing?['downloadUrl']?.toString() ?? '';
            final hasReport =
                existing != null &&
                (reportId.isNotEmpty ||
                    viewUrl.isNotEmpty ||
                    downloadUrl.isNotEmpty);

            return Container(
              decoration: BoxDecoration(
                color: isEven ? Colors.white : Colors.grey.shade50,
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
                      child: Text(
                        name,
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: _OutlineBtn(
                        icon: Icons.add,
                        label: 'New',
                        color: context.colors.primary,
                        onTap: () => widget.onReportSelected(typeId, name),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child:
                          hasReport
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _OutlineBtn(
                                    icon: Icons.picture_as_pdf_outlined,
                                    label: 'View Report',
                                    color: Colors.teal.shade600,
                                    onTap:
                                        () => _openPdf(
                                          context,
                                          reportId: reportId,
                                          viewUrl: viewUrl,
                                          downloadUrl: downloadUrl,
                                          reportName: name,
                                        ),
                                  ),
                                  if (downloadUrl.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    _OutlineBtn(
                                      icon: Icons.print_outlined,
                                      label: 'Print Report',
                                      color: Colors.blueGrey.shade600,
                                      onTap:
                                          () => _openPdf(
                                            context,
                                            reportId: reportId,
                                            viewUrl: downloadUrl,
                                            downloadUrl: downloadUrl,
                                            reportName: name,
                                          ),
                                    ),
                                  ],
                                ],
                              )
                              : Text(
                                'No Report',
                                style: context.topology.textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[500],
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutlineBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
