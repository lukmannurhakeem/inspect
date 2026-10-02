import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

enum SiteSearchColumn { name, code, division, address, status }

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  SiteSearchColumn? selectedColumn;
  dynamic selectedValue;
  bool _isSearchFocused = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeData() async {
    final provider = context.read<SiteProvider>();
    await provider.fetchSite(context);
    if (mounted) _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  // ─── Filter helpers ───────────────────────────────────────────────────────

  List<dynamic> _getColumnValues(List<Site> sites, SiteSearchColumn column) {
    if (sites.isEmpty) return [];
    switch (column) {
      case SiteSearchColumn.name:
        return sites
            .map((e) => e.siteName ?? '')
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case SiteSearchColumn.code:
        return sites
            .map((e) => e.siteCode ?? '')
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case SiteSearchColumn.division:
        return sites
            .map((e) => e.divisionName ?? '')
            .where((d) => d.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case SiteSearchColumn.address:
        return sites
            .map((e) => e.address ?? '')
            .where((a) => a.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case SiteSearchColumn.status:
        return [true, false];
    }
  }

  List<Site> _getFilteredSites(List<Site> sites) {
    if (sites.isEmpty) return [];
    var filtered = List<Site>.from(sites);

    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase().trim();
      filtered =
          filtered.where((s) {
            return (s.siteName ?? '').toLowerCase().contains(q) ||
                (s.siteCode ?? '').toLowerCase().contains(q) ||
                (s.divisionName ?? '').toLowerCase().contains(q) ||
                (s.address ?? '').toLowerCase().contains(q);
          }).toList();
    }

    if (selectedColumn != null && selectedValue != null) {
      switch (selectedColumn!) {
        case SiteSearchColumn.name:
          filtered =
              filtered.where((s) => s.siteName == selectedValue).toList();
          break;
        case SiteSearchColumn.code:
          filtered =
              filtered.where((s) => s.siteCode == selectedValue).toList();
          break;
        case SiteSearchColumn.division:
          filtered =
              filtered.where((s) => s.divisionName == selectedValue).toList();
          break;
        case SiteSearchColumn.address:
          filtered = filtered.where((s) => s.address == selectedValue).toList();
          break;
        case SiteSearchColumn.status:
          filtered =
              filtered
                  .where((s) => (s.archived ?? false) == selectedValue)
                  .toList();
          break;
      }
    }

    return filtered;
  }

  String _getColumnLabel(SiteSearchColumn column) {
    switch (column) {
      case SiteSearchColumn.name:
        return 'Site Name';
      case SiteSearchColumn.code:
        return 'Site Code';
      case SiteSearchColumn.division:
        return 'Division';
      case SiteSearchColumn.address:
        return 'Address';
      case SiteSearchColumn.status:
        return 'Status';
    }
  }

  String _getValueLabel(SiteSearchColumn column, dynamic value) {
    if (column == SiteSearchColumn.status) {
      return value == true ? 'Archived' : 'Active';
    }
    return value.toString();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _editSite(Site site) {
    NavigationService().navigateTo(
      NavigationRoutes.createSite,
      arguments: {'isEdit': true, 'siteData': site},
    );
  }

  void _showDeleteConfirmation(BuildContext context, Site site) {
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
                  'Delete Site?',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete this site? This action cannot be undone.',
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
                      _buildSiteAvatar(site, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              site.siteName ?? 'Unknown',
                              style: context.topology.textTheme.titleSmall
                                  ?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (site.siteCode != null) ...[
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
                                  'Code: ${site.siteCode}',
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
                      child: Consumer<SiteProvider>(
                        builder: (context, provider, child) {
                          return ElevatedButton(
                            onPressed:
                                provider.isLoading
                                    ? null
                                    : () => _performDelete(dialogContext, site),
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

  Future<void> _performDelete(BuildContext dialogContext, Site site) async {
    if (site.siteid == null) {
      Navigator.of(dialogContext).pop();
      _showErrorSnackbar('Cannot delete: Site ID is missing');
      return;
    }

    final provider = context.read<SiteProvider>();
    final success = await provider.deleteSite(context, site.siteid!);

    if (!mounted) return;
    Navigator.of(dialogContext).pop();

    if (success) {
      _showSuccessSnackbar(site.siteName ?? 'Site');
    } else {
      _showErrorSnackbar(provider.errorMessage ?? 'Failed to delete site');
    }
  }

  // ─── Filter dialog ────────────────────────────────────────────────────────

  void _showFilterDialog(BuildContext context, List<Site> sites) {
    SiteSearchColumn? tempColumn = selectedColumn;
    dynamic tempValue = selectedValue;

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (context, setDialogState) {
          final columnValues =
              tempColumn != null
                  ? _getColumnValues(sites, tempColumn!)
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
                      child: CommonDropdown<SiteSearchColumn>(
                        value: tempColumn,
                        items: [
                          DropdownMenuItem<SiteSearchColumn>(
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
                          ...SiteSearchColumn.values.map((col) {
                            return DropdownMenuItem<SiteSearchColumn>(
                              value: col,
                              child: Text(
                                _getColumnLabel(col),
                                style: context.topology.textTheme.bodySmall
                                    ?.copyWith(color: context.colors.primary),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            tempColumn = value;
                            tempValue = null;
                          });
                        },
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
                                  ...columnValues.map((v) {
                                    return DropdownMenuItem<dynamic>(
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
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setDialogState(() => tempValue = value);
                                },
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
    return Consumer<SiteProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !provider.hasData) {
          return _buildLoadingState();
        }
        if (provider.hasError && !provider.hasData) {
          return _buildErrorState(context, provider);
        }
        if (provider.sites.isEmpty) {
          return _buildEmptyState(context);
        }

        final allSites = provider.sites;
        final filteredSites = _getFilteredSites(allSites);

        return _buildMainLayout(context, filteredSites, allSites);
      },
    );
  }

  // ─── Loading ──────────────────────────────────────────────────────────────

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
              'Loading sites...',
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

  // ─── Empty ────────────────────────────────────────────────────────────────

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
            Center(
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
                        Icons.location_on_rounded,
                        size: 80,
                        color: context.colors.primary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No sites yet',
                      style: context.topology.textTheme.headlineSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first site to get started',
                      textAlign: TextAlign.center,
                      style: context.topology.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed:
                          () => NavigationService().navigateTo(
                            NavigationRoutes.createSite,
                          ),
                      icon: const Icon(Icons.add_rounded, size: 24),
                      label: const Text('Create Site'),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Error ────────────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, SiteProvider provider) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
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
                    'Failed to load sites',
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
                      onPressed: () => provider.fetchSite(context),
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
      ),
    );
  }

  // ─── Main layout ──────────────────────────────────────────────────────────

  Widget _buildMainLayout(
    BuildContext context,
    List<Site> filteredSites,
    List<Site> allSites,
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
                            const SizedBox(height: 24),
                            _buildSearchBar(allSites, isDesktop),
                            const SizedBox(height: 16),
                            _buildFilterChips(),
                            const SizedBox(height: 16),
                            _buildResultsCount(filteredSites),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    _buildSitesList(filteredSites, isDesktop, isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          !isDesktop
              ? FloatingActionButton.extended(
                onPressed:
                    () => NavigationService().navigateTo(NavigationRoutes.createSite),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create'),
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
              )
              : null,
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeaderSection(bool isDesktop, bool isTablet) {
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
              Icons.location_on_rounded,
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
                  'Sites',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your inspection sites',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed:
                  () => NavigationService().navigateTo(NavigationRoutes.createSite),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Site'),
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

  // ─── Search bar ───────────────────────────────────────────────────────────

  Widget _buildSearchBar(List<Site> allSites, bool isDesktop) {
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
                  ? 'Search by site name, code, division, or address...'
                  : 'Search sites...',
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
                  onPressed:
                      () => _showFilterDialog(
                        context,
                        context.read<SiteProvider>().sites,
                      ),
                  tooltip: 'Filter sites',
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

  Widget _buildResultsCount(List<Site> filteredSites) {
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
                  Icons.location_on_rounded,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredSites.length} ${filteredSites.length == 1 ? 'site' : 'sites'}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Consumer<SiteProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: context.colors.primary,
                ),
                onPressed:
                    provider.isLoading
                        ? null
                        : () => provider.fetchSite(context),
                tooltip: 'Refresh',
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── List (table) ─────────────────────────────────────────────────────────

  Widget _buildSitesList(
    List<Site> filteredSites,
    bool isDesktop,
    bool isTablet,
  ) {
    if (filteredSites.isEmpty) {
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
      sliver: SliverToBoxAdapter(child: _buildSitesTable(filteredSites)),
    );
  }

  Widget _buildSitesTable(List<Site> sites) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<SiteProvider>().fetchSite(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final table = DataTable(
              showCheckboxColumn: false,
              columnSpacing: 20,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columns: _buildTableColumns(),
              rows: List.generate(sites.length, (i) {
                return _buildTableRow(sites[i], i % 2 == 0);
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

  // ── Fixed columns: Site | Division | Address | Status | Actions ───────────
  List<DataColumn> _buildTableColumns() {
    const labels = ['Site', 'Division', 'Address', 'Status', 'Actions'];
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
        onSort: e.key < labels.length - 1 ? (i, _) => setState(() {}) : null,
      );
    }).toList();
  }

  DataRow _buildTableRow(Site site, bool isEven) {
    final isArchived = site.archived ?? false;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (_) => isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      onSelectChanged: (_) {
        NavigationService().navigateTo(NavigationRoutes.siteDetails, arguments: site);
      },
      cells: [
        // ── Site name + code ────────────────────────────────────────────────
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSiteAvatar(site, size: 34),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.siteName ?? 'Unknown',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (site.siteCode != null && site.siteCode!.isNotEmpty) ...[
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
                        '# ${site.siteCode}',
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

        // ── Division ────────────────────────────────────────────────────────
        DataCell(
          Text(
            site.divisionName ?? '-',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),

        // ── Address ─────────────────────────────────────────────────────────
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              site.address?.isNotEmpty == true ? site.address! : '-',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // ── Status badge ────────────────────────────────────────────────────
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color:
                  isArchived
                      ? Colors.grey.withOpacity(0.15)
                      : Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isArchived
                        ? Colors.grey.withOpacity(0.4)
                        : Colors.green.withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        isArchived
                            ? Colors.grey.shade500
                            : Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isArchived ? 'Archived' : 'Active',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color:
                        isArchived
                            ? Colors.grey.shade700
                            : Colors.green.shade700,
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
                onPressed: () => _editSite(site),
                tooltip: 'Edit Site',
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 4),
              Consumer<SiteProvider>(
                builder:
                    (context, provider, _) => IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed:
                          provider.isLoading
                              ? null
                              : () => _showDeleteConfirmation(context, site),
                      tooltip: 'Delete Site',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Site avatar ──────────────────────────────────────────────────────────

  Widget _buildSiteAvatar(Site site, {double size = 34}) {
    final initial =
        site.siteName?.isNotEmpty == true
            ? site.siteName!.substring(0, 1).toUpperCase()
            : 'S';

    if (site.logo != null && site.logo!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size == 34 ? 8 : 12),
        child: Image.network(
          site.logo!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildSiteAvatarFallback(initial, size),
        ),
      );
    }
    return _buildSiteAvatarFallback(initial, size);
  }

  Widget _buildSiteAvatarFallback(String initial, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(size == 34 ? 8 : 12),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size == 34 ? 16 : 24,
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
              'No sites found',
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

  // ─── Snackbars ────────────────────────────────────────────────────────────

  void _showSuccessSnackbar(String siteName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Site Deleted',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '"$siteName" was successfully deleted',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Error',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
