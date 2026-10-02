import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/item_files_screen.dart';
import 'package:inspect/screen/settings/report_setup/report_template_importer.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

enum ReportSearchColumn { name, description, category, documentCode, status }

class ReportTypeScreen extends StatefulWidget {
  const ReportTypeScreen({super.key});

  @override
  State<ReportTypeScreen> createState() => _ReportTypeScreenState();
}

class _ReportTypeScreenState extends State<ReportTypeScreen>
    with SingleTickerProviderStateMixin {
  List<FileItem> _files = [];
  bool _isUploading = false;
  int sortColumnIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isSearchFocused = false;

  Map<String, dynamic>? _savedDraft;
  String _draftSavedAt = '';

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  bool _isLoadedFromCache = false;

  ReportSearchColumn? selectedColumn;
  dynamic selectedValue;

  // ─── Safe field accessor ──────────────────────────────────────────────────

  String _safeText(dynamic val) {
    try {
      final s = val?.toString() ?? '';
      return s.isEmpty ? '-' : s;
    } catch (_) {
      return '-';
    }
  }

  bool _safeBool(dynamic val, {bool fallback = false}) {
    try {
      if (val == null) return fallback;
      if (val is bool) return val;
      return val.toString().toLowerCase() == 'true';
    } catch (_) {
      return fallback;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedDraft();
      _initData();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Init ─────────────────────────────────────────────────────────────────

  Future<void> _initData() async {
    try {
      final provider = context.read<SystemProvider>();

      final cached = LocalStorage.getJsonList(
        LocalStorageConstant.cachedReportTypes,
      );
      final lastSync = LocalStorage.getString(
        LocalStorageConstant.lastReportTypeSyncTimestamp,
      );

      if (cached.isNotEmpty) {
        provider.loadReportTypesFromCache(cached);
        if (mounted) {
          setState(() {
            _isLoadedFromCache = true;
            _lastSyncTime =
                lastSync.isNotEmpty ? DateTime.tryParse(lastSync) : null;
          });
        }
      }

      await _syncReports(silent: cached.isNotEmpty);
      if (mounted) _animationController.forward();
    } catch (e, stack) {
      debugPrint('ReportTypeScreen _initData error: $e\n$stack');
      if (mounted) _animationController.forward();
    }
  }

  Future<void> _syncReports({bool silent = false}) async {
    if (_isSyncing) return;
    if (mounted) setState(() => _isSyncing = true);

    try {
      final provider = context.read<SystemProvider>();
      await provider.fetchReportType();

      final freshData = provider.getReportTypeModel?.data;
      debugPrint('DATA COUNT: ${freshData?.length}');
      if (freshData != null && freshData.isNotEmpty) {
        debugPrint('FIRST ITEM reportType: ${freshData.first.reportType}');
        debugPrint(
          'FIRST ITEM reportTypeId: ${freshData.first.reportType?.reportTypeId}',
        );
      }
      if (freshData != null && freshData.isNotEmpty) {
        final serialised =
            freshData
                .map<Map<String, dynamic>>((item) {
                  try {
                    return item.toJson();
                  } catch (e) {
                    debugPrint('toJson error for item: $e');
                    return <String, dynamic>{};
                  }
                })
                .where((m) => m.isNotEmpty)
                .toList();

        await LocalStorage.setJsonList(
          LocalStorageConstant.cachedReportTypes,
          serialised,
        );
        await LocalStorage.setString(
          LocalStorageConstant.lastReportTypeSyncTimestamp,
          DateTime.now().toIso8601String(),
        );
      }

      if (mounted) {
        setState(() {
          _isLoadedFromCache = false;
          _lastSyncTime = DateTime.now();
        });
        if (!silent) {
          CommonSnackbar.showSuccess(context, 'Reports synced successfully');
        }
      }
    } catch (e, stack) {
      debugPrint('ReportTypeScreen _syncReports error: $e\n$stack');
      if (mounted && !silent) {
        CommonSnackbar.showError(context, 'Sync failed. Showing cached data.');
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  // ─── Draft ────────────────────────────────────────────────────────────────

  void _loadSavedDraft() {
    try {
      final draft = LocalStorage.getJson(
        LocalStorageConstant.reportDraft,
      );
      final savedAt = LocalStorage.getString(
        LocalStorageConstant.lastReportDraftTimestamp,
      );
      if (draft != null && (draft['reportName']?.toString() ?? '').isNotEmpty) {
        if (mounted) {
          setState(() {
            _savedDraft = draft;
            _draftSavedAt = savedAt;
          });
        }
      }
    } catch (e) {
      debugPrint('_loadSavedDraft error: $e');
    }
  }

  Future<void> _discardDraft() async {
    try {
      await LocalStorage.remove(LocalStorageConstant.reportDraft);
      await LocalStorage.remove(
        LocalStorageConstant.lastReportDraftTimestamp,
      );
      if (mounted) {
        setState(() {
          _savedDraft = null;
          _draftSavedAt = '';
        });
      }
    } catch (e) {
      debugPrint('_discardDraft error: $e');
    }
  }

  String _formatDraftTimestamp(String iso) {
    try {
      final diff = DateTime.now().difference(DateTime.parse(iso).toLocal());
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return iso;
    }
  }

  // ─── Search / Filter ──────────────────────────────────────────────────────

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  String _safeFieldString(dynamic reportItem, ReportSearchColumn column) {
    try {
      final rt = reportItem?.reportType;
      switch (column) {
        case ReportSearchColumn.name:
          return rt?.reportName?.toString() ?? '';
        case ReportSearchColumn.description:
          return rt?.description?.toString() ?? '';
        case ReportSearchColumn.category:
          return rt?.categoryId?.toString() ?? '';
        case ReportSearchColumn.documentCode:
          return rt?.documentCode?.toString() ?? '';
        case ReportSearchColumn.status:
          return '';
      }
    } catch (_) {
      return '';
    }
  }

  List<dynamic> _getColumnValues(
    List<dynamic> reports,
    ReportSearchColumn column,
  ) {
    if (reports.isEmpty) return [];
    try {
      if (column == ReportSearchColumn.status) return [true, false];
      return reports
          .map((e) => _safeFieldString(e, column))
          .where((n) => n.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
    } catch (e) {
      debugPrint('_getColumnValues error: $e');
      return [];
    }
  }

  List<dynamic> _getFilteredReports(List<dynamic> reports) {
    if (reports.isEmpty) return [];
    try {
      var list = List<dynamic>.from(reports);

      if (_searchController.text.isNotEmpty) {
        final q = _searchController.text.toLowerCase().trim();
        list =
            list.where((r) {
              try {
                final name =
                    _safeFieldString(r, ReportSearchColumn.name).toLowerCase();
                final desc =
                    _safeFieldString(
                      r,
                      ReportSearchColumn.description,
                    ).toLowerCase();
                final cat =
                    _safeFieldString(
                      r,
                      ReportSearchColumn.category,
                    ).toLowerCase();
                final code =
                    _safeFieldString(
                      r,
                      ReportSearchColumn.documentCode,
                    ).toLowerCase();
                return name.contains(q) ||
                    desc.contains(q) ||
                    cat.contains(q) ||
                    code.contains(q);
              } catch (_) {
                return false;
              }
            }).toList();
      }

      if (selectedColumn != null && selectedValue != null) {
        switch (selectedColumn!) {
          case ReportSearchColumn.name:
            list =
                list
                    .where(
                      (r) =>
                          _safeFieldString(r, ReportSearchColumn.name) ==
                          selectedValue,
                    )
                    .toList();
            break;
          case ReportSearchColumn.description:
            list =
                list
                    .where(
                      (r) =>
                          _safeFieldString(r, ReportSearchColumn.description) ==
                          selectedValue,
                    )
                    .toList();
            break;
          case ReportSearchColumn.category:
            list =
                list
                    .where(
                      (r) =>
                          _safeFieldString(r, ReportSearchColumn.category) ==
                          selectedValue,
                    )
                    .toList();
            break;
          case ReportSearchColumn.documentCode:
            list =
                list
                    .where(
                      (r) =>
                          _safeFieldString(
                            r,
                            ReportSearchColumn.documentCode,
                          ) ==
                          selectedValue,
                    )
                    .toList();
            break;
          case ReportSearchColumn.status:
            list =
                list.where((r) {
                  try {
                    return _safeBool(r?.reportType?.archived) == selectedValue;
                  } catch (_) {
                    return false;
                  }
                }).toList();
            break;
        }
      }
      return list;
    } catch (e, stack) {
      debugPrint('_getFilteredReports error: $e\n$stack');
      return [];
    }
  }

  String _getColumnLabel(ReportSearchColumn col) {
    switch (col) {
      case ReportSearchColumn.name:
        return 'Report Name';
      case ReportSearchColumn.description:
        return 'Description';
      case ReportSearchColumn.category:
        return 'Category';
      case ReportSearchColumn.documentCode:
        return 'Document Code';
      case ReportSearchColumn.status:
        return 'Status';
    }
  }

  String _getValueLabel(ReportSearchColumn col, dynamic value) {
    if (col == ReportSearchColumn.status) {
      return value == true ? 'Archived' : 'Active';
    }
    return value?.toString() ?? '';
  }

  void _showFilterDialog(BuildContext context, List<dynamic> reports) {
    ReportSearchColumn? tempColumn = selectedColumn;
    dynamic tempValue = selectedValue;

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (context, setDialogState) {
          final columnValues =
              tempColumn != null
                  ? _getColumnValues(reports, tempColumn!)
                  : <dynamic>[];

          return Container(
            constraints: BoxConstraints(
              maxHeight: context.screenHeight * 0.5,
              minHeight: context.screenHeight * 0.3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Filter By',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CommonDropdown<ReportSearchColumn>(
                        value: tempColumn,
                        items: [
                          DropdownMenuItem<ReportSearchColumn>(
                            value: null,
                            child: Text(
                              'Select Column',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(
                                    color: context.colors.primary.withOpacity(
                                      0.6,
                                    ),
                                  ),
                            ),
                          ),
                          ...ReportSearchColumn.values.map(
                            (col) => DropdownMenuItem<ReportSearchColumn>(
                              value: col,
                              child: Text(
                                _getColumnLabel(col),
                                style: context.topology.textTheme.bodySmall
                                    ?.copyWith(color: context.colors.primary),
                              ),
                            ),
                          ),
                        ],
                        onChanged:
                            (v) => setDialogState(() {
                              tempColumn = v;
                              tempValue = null;
                            }),
                      ),
                    ),
                  ],
                ),
                context.vS,
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Value',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                          tempColumn == null
                              ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: context.colors.primary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Select a column first',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.colors.primary
                                            .withOpacity(0.5),
                                      ),
                                ),
                              )
                              : CommonDropdown<dynamic>(
                                value: tempValue,
                                items: [
                                  DropdownMenuItem<dynamic>(
                                    value: null,
                                    child: Text(
                                      'All',
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.colors.primary
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                  ),
                                  ...columnValues.map(
                                    (v) => DropdownMenuItem<dynamic>(
                                      value: v,
                                      child: Text(
                                        _getValueLabel(tempColumn!, v),
                                        style: context
                                            .topology
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: context.colors.primary,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged:
                                    (v) => setDialogState(() => tempValue = v),
                              ),
                    ),
                  ],
                ),
                context.vL,
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        text: 'Clear',
                        onPressed: () {
                          setState(() {
                            selectedColumn = null;
                            selectedValue = null;
                          });
                          NavigationService().goBack();
                        },
                      ),
                    ),
                    context.hS,
                    Expanded(
                      child: CommonButton(
                        text: 'Apply',
                        onPressed: () {
                          setState(() {
                            selectedColumn = tempColumn;
                            selectedValue = tempValue;
                          });
                          NavigationService().goBack();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemProvider>(
      builder: (context, provider, child) {
        try {
          if (provider.isLoading &&
              (provider.getReportTypeModel?.data ?? []).isEmpty) {
            return _buildLoadingState();
          }

          if (provider.hasError &&
              (provider.getReportTypeModel?.data ?? []).isEmpty) {
            return _buildErrorState(context, provider);
          }

          final allReports = List<dynamic>.from(
            provider.getReportTypeModel?.data ?? [],
          );

          if (allReports.isEmpty) return _buildEmptyState(context);

          final filtered = _getFilteredReports(allReports);
          return _buildMainLayout(context, filtered, allReports);
        } catch (e, stack) {
          debugPrint('ReportTypeScreen build error: $e\n$stack');
          return _buildCrashErrorState(context, provider, e);
        }
      },
    );
  }

  // ─── State screens ────────────────────────────────────────────────────────

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading reports...',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
            Padding(
              padding: context.paddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDraftBanner(context),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    context.colors.primary.withOpacity(0.1),
                                    context.colors.primary.withOpacity(0.05),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.description_rounded,
                                size: 80,
                                color: context.colors.primary.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'No reports yet',
                              style: context.topology.textTheme.headlineSmall
                                  ?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Create your first report type to get started',
                              textAlign: TextAlign.center,
                              style: context.topology.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed:
                                  () => NavigationService().navigateTo(
                                    NavigationRoutes.reportCreate,
                                  ),
                              icon: const Icon(Icons.add_rounded, size: 24),
                              label: const Text('Create Report Type'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed:
                                  () => ReportTemplateImporter.pickAndImport(
                                    context,
                                  ),
                              icon: const Icon(
                                Icons.upload_file_rounded,
                                size: 20,
                              ),
                              label: const Text('Import from Excel'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.colors.primary,
                                side: BorderSide(color: context.colors.primary),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildErrorState(BuildContext context, SystemProvider provider) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.3,
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
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Failed to load reports',
                        style: context.topology.textTheme.titleLarge?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.errorMessage ?? 'An unexpected error occurred',
                        textAlign: TextAlign.center,
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _syncReports(silent: false),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrashErrorState(
    BuildContext context,
    SystemProvider provider,
    Object error,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: Colors.orange.shade400,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Something went wrong',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'An unexpected error occurred while displaying the report list. Please try refreshing.',
                  textAlign: TextAlign.center,
                  style: context.topology.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedColumn = null;
                        selectedValue = null;
                        _searchController.clear();
                      });
                      _syncReports(silent: false);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Main layout ──────────────────────────────────────────────────────────

  Widget _buildMainLayout(
    BuildContext context,
    List<dynamic> filteredReports,
    List<dynamic> allReports,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(
                          isDesktop ? 32 : (isTablet ? 24 : 16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeaderSection(isDesktop, isTablet),
                            const SizedBox(height: 16),
                            _buildDraftBanner(context),
                            const SizedBox(height: 8),
                            _buildSearchBar(allReports, isDesktop),
                            const SizedBox(height: 16),
                            _buildFilterChips(),
                            const SizedBox(height: 16),
                            _buildResultsCount(filteredReports),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    _buildReportsList(filteredReports, isDesktop, isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          !isDesktop
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'import_templates',
                    onPressed:
                        () => ReportTemplateImporter.pickAndImport(context),
                    backgroundColor: Colors.white,
                    foregroundColor: context.colors.primary,
                    elevation: 2,
                    tooltip: 'Import Templates',
                    child: const Icon(Icons.upload_file_rounded),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    heroTag: 'create_report',
                    onPressed:
                        () => NavigationService().navigateTo(
                          NavigationRoutes.reportCreate,
                        ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create'),
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                ],
              )
              : null,
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeaderSection(bool isDesktop, bool isTablet) {
    final timeLabel =
        _lastSyncTime != null
            ? '${_lastSyncTime!.hour.toString().padLeft(2, '0')}:${_lastSyncTime!.minute.toString().padLeft(2, '0')}'
            : null;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary.withOpacity(0.08), Colors.white],
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
                colors: [
                  context.colors.primary,
                  context.colors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.description_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Types',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your report templates',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (timeLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          _isLoadedFromCache
                              ? Icons.offline_pin
                              : Icons.cloud_done,
                          size: 14,
                          color: context.colors.primary.withOpacity(0.65),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isLoadedFromCache ? 'Offline' : timeLabel,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary.withOpacity(0.65),
                            fontSize: 11,
                          ),
                        ),
                      ],
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
                      _isSyncing ? null : () => _syncReports(silent: false),
                  tooltip: 'Sync reports',
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => ReportTemplateImporter.pickAndImport(context),
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Import from Excel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.primary,
                side: BorderSide(color: context.colors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed:
                  () => NavigationService().navigateTo(NavigationRoutes.reportCreate),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Draft banner ─────────────────────────────────────────────────────────

  Widget _buildDraftBanner(BuildContext context) {
    if (_savedDraft == null) return const SizedBox.shrink();

    final draftName =
        _savedDraft!['reportName']?.toString() ?? 'Untitled Draft';
    final fieldCount = (_savedDraft!['reportFields'] as List?)?.length ?? 0;
    final timeLabel =
        _draftSavedAt.isNotEmpty
            ? _formatDraftTimestamp(_draftSavedAt)
            : 'recently';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary.withOpacity(0.08),
            context.colors.primary.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.primary.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Unsaved Draft',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Saved $timeLabel',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary,
                        context.colors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
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
                        draftName,
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _draftChip(
                            context,
                            Icons.text_fields,
                            '$fieldCount field${fieldCount != 1 ? 's' : ''}',
                          ),
                          if ((_savedDraft!['statusRuleReports'] as List?)
                                  ?.isNotEmpty ==
                              true)
                            _draftChip(
                              context,
                              Icons.rule,
                              '${(_savedDraft!['statusRuleReports'] as List).length} rule${(_savedDraft!['statusRuleReports'] as List).length != 1 ? 's' : ''}',
                            ),
                          if ((_savedDraft!['reportTypeDates'] as List?)
                                  ?.isNotEmpty ==
                              true)
                            _draftChip(
                              context,
                              Icons.calendar_today,
                              '${(_savedDraft!['reportTypeDates'] as List).length} date${(_savedDraft!['reportTypeDates'] as List).length != 1 ? 's' : ''}',
                            ),
                          if ((_savedDraft!['actionReports'] as List?)
                                  ?.isNotEmpty ==
                              true)
                            _draftChip(
                              context,
                              Icons.bolt,
                              '${(_savedDraft!['actionReports'] as List).length} action${(_savedDraft!['actionReports'] as List).length != 1 ? 's' : ''}',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                            () => NavigationService().navigateTo(
                              NavigationRoutes.reportCreate,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Resume',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () => _confirmDiscardDraft(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          'Discard',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _draftChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: context.colors.primary.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDiscardDraft(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.orange.shade700,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Discard Draft?',
                    style: context.topology.textTheme.titleLarge?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will permanently delete your saved draft. This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: context.topology.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _discardDraft();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Discard',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
  }

  // ─── Search bar ───────────────────────────────────────────────────────────

  Widget _buildSearchBar(List<dynamic> allReports, bool isDesktop) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (mounted) setState(() => _isSearchFocused = hasFocus);
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
                color: context.colors.primary.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: CommonTextField(
          controller: _searchController,
          hintText:
              isDesktop
                  ? 'Search by name, description, category, or document code...'
                  : 'Search reports...',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.primary.withOpacity(0.6),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: context.colors.primary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  tooltip: 'Clear search',
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      (selectedColumn != null && selectedValue != null)
                          ? context.colors.primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color:
                        (selectedColumn != null && selectedValue != null)
                            ? context.colors.primary
                            : context.colors.primary.withOpacity(0.5),
                  ),
                  onPressed: () => _showFilterDialog(context, allReports),
                  tooltip: 'Filter reports',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Filter chips ─────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    if (selectedColumn == null || selectedValue == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedColumn = null;
                  selectedValue = null;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary.withOpacity(0.12),
                      context.colors.primary.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${_getColumnLabel(selectedColumn!)}: ${_getValueLabel(selectedColumn!, selectedValue)}',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Results count ────────────────────────────────────────────────────────

  Widget _buildResultsCount(List<dynamic> filteredReports) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary.withOpacity(0.12),
                  context.colors.primary.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_rounded,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredReports.length} ${filteredReports.length == 1 ? 'report' : 'reports'}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isSyncing) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colors.primary.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Syncing...',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: context.colors.primary),
            onPressed: _isSyncing ? null : () => _syncReports(silent: false),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  // ─── Reports list ─────────────────────────────────────────────────────────

  Widget _buildReportsList(
    List<dynamic> filteredReports,
    bool isDesktop,
    bool isTablet,
  ) {
    if (filteredReports.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildNoResultsState(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 32 : (isTablet ? 24 : 16),
        0,
        isDesktop ? 32 : (isTablet ? 24 : 16),
        100,
      ),
      sliver: SliverToBoxAdapter(child: _buildReportsTable(filteredReports)),
    );
  }

  Widget _buildReportsTable(List<dynamic> reports) {
    return RefreshIndicator(
      onRefresh: () async {
        await _syncReports(silent: false);
        _loadSavedDraft();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final table = DataTable(
              sortColumnIndex: sortColumnIndex,
              showCheckboxColumn: false,
              columnSpacing: 20,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columns: _buildTableColumns(),
              rows: List.generate(reports.length, (i) {
                // Wrap each row build in try-catch so one bad item
                // doesn't crash the whole table
                try {
                  return _buildTableRow(reports[i], i % 2 == 0, i);
                } catch (e, stack) {
                  debugPrint('Row $i build error: $e\n$stack');
                  return _buildFallbackRow(i % 2 == 0);
                }
              }),
            );

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth - 16,
                ),
                child: table,
              ),
            );
          },
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    const labels = [
      'Name',
      'Description',
      'Category',
      'Document Code',
      'Status',
      'Actions',
    ];
    return labels.asMap().entries.map((e) {
      return DataColumn(
        label: Expanded(
          child: Text(
            e.value,
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        onSort:
            e.key < labels.length - 1
                ? (i, _) => setState(() => sortColumnIndex = i)
                : null,
      );
    }).toList();
  }

  /// Fallback row shown when a single item fails to render
  DataRow _buildFallbackRow(bool isEven) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (_) => isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      cells: List.generate(
        6,
        (_) => DataCell(
          Text(
            '-',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildTableRow(dynamic reportItem, bool isEven, int index) {
    // Safely extract reportType
    dynamic data;
    try {
      data = reportItem?.reportType;
    } catch (_) {
      data = null;
    }

    final isActive = !_safeBool(data?.archived);

    // Safe field reads
    final reportName = _safeText(data?.reportName);
    final description = _safeText(data?.description);
    final documentCode = _safeText(data?.documentCode);

    // Try categoryName first, fall back to categoryId
    String category = '-';
    try {
      final cn = data?.categoryName?.toString() ?? '';
      final ci = data?.categoryId?.toString() ?? '';
      category = cn.isNotEmpty ? cn : (ci.isNotEmpty ? ci : '-');
    } catch (_) {}

    String reportTypeId = '';
    try {
      reportTypeId = data?.reportTypeId?.toString() ?? '';
    } catch (_) {}

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (_) => isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      onSelectChanged: (selected) {
        if (selected == true) {
          try {
            NavigationService().navigateTo(
              NavigationRoutes.reportTypeDetails,
              arguments: {
                'reportTypeID':
                    reportTypeId.isEmpty ? 'default-id' : reportTypeId,
                'reportName': reportName == '-' ? '' : reportName,
              },
            );
          } catch (e) {
            debugPrint('Navigation error: $e');
          }
        }
      },
      cells: [
        // ── Name + document code badge ──────────────────────────────────────
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportAvatar(data),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportName,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (documentCode != '-') ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '# $documentCode',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // ── Description ─────────────────────────────────────────────────────
        DataCell(
          Text(
            description,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),

        // ── Category ────────────────────────────────────────────────────────
        DataCell(
          Text(
            category,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),

        // ── Document code ───────────────────────────────────────────────────
        DataCell(
          Text(
            documentCode,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),

        // ── Status badge ────────────────────────────────────────────────────
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? Colors.green.withOpacity(0.12)
                      : Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        isActive ? Colors.green.shade600 : Colors.grey.shade500,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isActive ? 'Active' : 'Archived',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color:
                        isActive ? Colors.green.shade700 : Colors.grey.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Actions ─────────────────────────────────────────────────────────
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: context.colors.primary,
                  size: 18,
                ),
                onPressed: () => _editReport(reportItem, index),
                tooltip: 'Edit Report',
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () => _showDeleteDialog(reportItem, index),
                tooltip: 'Delete Report',
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Report avatar ────────────────────────────────────────────────────────

  Widget _buildReportAvatar(dynamic data, {double size = 34}) {
    String initial = 'R';
    try {
      final name = data?.reportName?.toString() ?? '';
      if (name.isNotEmpty) initial = name.substring(0, 1).toUpperCase();
    } catch (_) {}

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.25),
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

  // ─── No results ───────────────────────────────────────────────────────────

  Widget _buildNoResultsState() {
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
              'No reports found',
              style: context.topology.textTheme.titleLarge?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  selectedColumn = null;
                  selectedValue = null;
                });
              },
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CRUD actions ─────────────────────────────────────────────────────────

  void _editReport(dynamic reportItem, int index) {
    try {
      NavigationService().navigateTo(
        NavigationRoutes.reportCreate,
        arguments: {
          'isEdit': true,
          'reportData': reportItem?.reportType,
          'reportIndex': index,
          'fullReportItem': reportItem,
        },
      );
    } catch (e) {
      debugPrint('_editReport error: $e');
    }
  }

  void _showDeleteDialog(dynamic reportItem, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
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
                  'Delete Report?',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete this report type? This action cannot be undone.',
                  style: context.topology.textTheme.bodyMedium?.copyWith(
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
                      _buildReportAvatar(reportItem?.reportType, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _safeText(reportItem?.reportType?.reportName),
                              style: context.topology.textTheme.titleSmall
                                  ?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (_safeText(
                                  reportItem?.reportType?.documentCode,
                                ) !=
                                '-') ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Code: ${_safeText(reportItem?.reportType?.documentCode)}',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
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
                          style: context.topology.textTheme.bodySmall?.copyWith(
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
                        onPressed: () => Navigator.of(dialogContext).pop(),
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
                      child: Consumer<SystemProvider>(
                        builder: (context, provider, child) {
                          return ElevatedButton(
                            onPressed:
                                provider.isLoading
                                    ? null
                                    : () async {
                                      Navigator.of(dialogContext).pop();
                                      await _deleteReport(reportItem, index);
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
                                provider.isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
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
                          );
                        },
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
  }

  Future<void> _deleteReport(dynamic reportItem, int index) async {
    try {
      final provider = Provider.of<SystemProvider>(context, listen: false);
      CommonSnackbar.showInfo(context, 'Deleting report...');
      final reportId = _safeText(
        reportItem?.reportType?.reportTypeId ??
            reportItem?.reportType?.jobId ??
            index.toString(),
      );
      await provider.deleteReport(
        reportId == '-' ? index.toString() : reportId,
      );
      if (mounted) {
        CommonSnackbar.showSuccess(context, 'Report deleted successfully');
      }
    } catch (e, stack) {
      debugPrint('_deleteReport error: $e\n$stack');
      if (mounted) {
        CommonSnackbar.showError(context, 'Error deleting report: $e');
      }
    }
  }

  Future<void> _pickAndUploadFiles() async {
    try {
      if (mounted) setState(() => _isUploading = true);
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        for (PlatformFile file in result.files) {
          if (file.path != null) {
            if (mounted) {
              setState(
                () => _files.add(
                  FileItem(
                    name: file.name,
                    path: file.path!,
                    dateAdded: DateTime.now(),
                    size: file.size,
                  ),
                ),
              );
            }
          }
        }
        if (mounted) {
          CommonSnackbar.showSuccess(
            context,
            'Successfully uploaded ${result.files.length} file(s)',
          );
        }
      }
    } catch (e, stack) {
      debugPrint('_pickAndUploadFiles error: $e\n$stack');
      if (mounted) {
        CommonSnackbar.showError(context, 'Error uploading files: $e');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }
}
