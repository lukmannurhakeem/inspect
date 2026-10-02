import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/personnel_model/personnel_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/widget/common_confirm_dialog.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class PersonnelScreen extends StatefulWidget {
  const PersonnelScreen({super.key});

  @override
  State<PersonnelScreen> createState() => _PersonnelScreenState();
}

class _PersonnelScreenState extends State<PersonnelScreen>
    with SingleTickerProviderStateMixin {
  static const _tabletBreakpoint = 768.0;
  static const _desktopBreakpoint = 1024.0;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  List<PersonnelData> _filteredPersonnel = [];
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
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await context.read<PersonnelProvider>().fetchPersonnel();
    if (mounted) _animationController.forward();
  }

  void _onSearchChanged() {
    final provider = context.read<PersonnelProvider>();
    setState(() {
      _filteredPersonnel = provider.searchPersonnel(_searchController.text);
    });
  }

  double get _width => MediaQuery.of(context).size.width;

  bool get _isDesktop => _width >= _desktopBreakpoint;

  double get _gutter =>
      _isDesktop ? 32 : (_width >= _tabletBreakpoint ? 24 : 16);

  Color _fade([double opacity = 1]) => context.colors.primary.withOpacity(opacity);

  TextTheme get _textTheme => context.topology.textTheme;

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _createPersonnel() =>
      NavigationService().navigateTo(NavigationRoutes.createPersonnel);

  void _openDetails(PersonnelData data) {
    NavigationService().navigateTo(
      NavigationRoutes.personnelDetails,
      arguments: {'personnelId': data.personnel.personnelID},
    );
  }

  void _clearSearch() => _searchController.clear();

  Future<void> _confirmDelete(String personnelId, String name) {
    return CommonConfirmDialog.show(
      context: context,
      title: 'Delete Personnel',
      message: 'Are you sure you want to delete "$name"?',
      warningNote: 'This action is permanent and cannot be reversed.',
      confirmText: 'Delete',
      isDestructive: true,
      previewWidget: Row(
        children: [
          _buildAvatar(_initials(name)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: _textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      onConfirm: () => _deletePersonnel(personnelId, name),
    );
  }

  Future<void> _deletePersonnel(String personnelId, String name) async {
    final success = await context.read<PersonnelProvider>().deletePersonnel(
      personnelId,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '"$name" deleted' : 'Failed to delete "$name"'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  List<PersonnelData> _visiblePersonnel(PersonnelProvider provider) {
    if (_searchController.text.isEmpty) return provider.activePersonnel;
    return _filteredPersonnel.where((p) => !p.personnel.isArchived).toList();
  }

  BoxDecoration _cardDecoration({
    double radius = 16,
    double blur = 20,
    double offsetY = 10,
    double shadowAlpha = 0.08,
  }) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(shadowAlpha),
          blurRadius: blur,
          offset: Offset(0, offsetY),
        ),
      ],
    );
  }

  Widget _page({required Widget body, Widget? floatingActionButton}) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    double elevation = 0,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        padding: padding,
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonnelProvider>(
      builder: (context, provider, _) {
        final hasData = provider.activePersonnel.isNotEmpty;

        if (provider.isLoading && !hasData) return _buildLoadingState();
        if (provider.errorMessage != null && !hasData) {
          return _buildErrorState(provider);
        }

        final personnel = _visiblePersonnel(provider);
        if (personnel.isEmpty) return _buildEmptyState();

        return _buildMainLayout(personnel);
      },
    );
  }

  Widget _buildLoadingState() {
    return _page(
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
              'Loading personnel...',
              style: _textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: _textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty;

    return _page(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/bg_3.png',
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_fade(0.1), _fade(0.05)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSearching
                          ? Icons.search_off_rounded
                          : Icons.people_rounded,
                      size: 80,
                      color: _fade(0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    isSearching ? 'No results found' : 'No personnel yet',
                    style: _textTheme.headlineSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSearching
                        ? 'Try adjusting your search query'
                        : 'Add your first personnel member to get started',
                    textAlign: TextAlign.center,
                    style: _textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (isSearching)
                    _primaryButton(
                      label: 'Clear Search',
                      icon: Icons.clear_all_rounded,
                      onPressed: _clearSearch,
                    )
                  else
                    _primaryButton(
                      label: 'Create Personnel',
                      icon: Icons.add_rounded,
                      onPressed: _createPersonnel,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      elevation: 2,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PersonnelProvider provider) {
    return _page(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: _cardDecoration(radius: 20),
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
                  'Failed to load personnel',
                  style: _textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  provider.errorMessage ?? 'An unexpected error occurred',
                  textAlign: TextAlign.center,
                  style: _textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: _primaryButton(
                    label: 'Retry',
                    icon: Icons.refresh_rounded,
                    onPressed: provider.refreshPersonnel,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout(List<PersonnelData> personnel) {
    return _page(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(_gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildResultsCount(personnel.length),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(_gutter, 0, _gutter, 100),
              sliver: SliverToBoxAdapter(child: _buildTable(personnel)),
            ),
          ],
        ),
      ),
      floatingActionButton:
      _isDesktop
          ? null
          : FloatingActionButton.extended(
        onPressed: _createPersonnel,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(_isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_fade(0.08), Colors.white],
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
                colors: [context.colors.primary, _fade(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _fade(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.people_rounded,
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
                  'Personnel',
                  style: _textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your inspection team members',
                  style: _textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (_isDesktop) ...[
            const SizedBox(width: 16),
            _primaryButton(
              label: 'Create Personnel',
              icon: Icons.add_rounded,
              onPressed: _createPersonnel,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final focused = _isSearchFocused;

    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isSearchFocused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: focused ? context.colors.primary : Colors.grey.shade200,
            width: focused ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: focused ? _fade(0.1) : Colors.black.withOpacity(0.02),
              blurRadius: focused ? 12 : 8,
              offset: Offset(0, focused ? 4 : 2),
            ),
          ],
        ),
        child: CommonTextField(
          controller: _searchController,
          hintText:
          _isDesktop
              ? 'Search by name, job title, or employee number...'
              : 'Search personnel...',
          style: _textTheme.bodyMedium?.copyWith(color: context.colors.primary),
          prefixIcon: Icon(Icons.search_rounded, color: _fade(0.6)),
          suffixIcon:
          _searchController.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: context.colors.primary,
            ),
            tooltip: 'Clear search',
            onPressed: () {
              _clearSearch();
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCount(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_fade(0.12), _fade(0.06)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_rounded, size: 18, color: context.colors.primary),
              const SizedBox(width: 8),
              Text(
                '$count ${count == 1 ? 'person' : 'personnel'}',
                style: _textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Consumer<PersonnelProvider>(
          builder:
              (context, provider, _) => IconButton(
            icon: Icon(Icons.refresh_rounded, color: context.colors.primary),
            tooltip: 'Refresh',
            onPressed: provider.isLoading ? null : provider.refreshPersonnel,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<PersonnelData> personnel) {
    return RefreshIndicator(
      onRefresh: () => context.read<PersonnelProvider>().refreshPersonnel(),
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
                showCheckboxColumn: false,
                columnSpacing: 20,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                columns: [
                  for (final label in const [
                    'Personnel',
                    'Job Title',
                    'Mobile No.',
                    'Actions',
                  ])
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          label,
                          style: _textTheme.titleSmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
                rows: [
                  for (var i = 0; i < personnel.length; i++)
                    _buildRow(personnel[i], i.isEven),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobTitlePill(String jobTitle) {
    if (jobTitle.isEmpty) {
      return Text(
        '-',
        style: _textTheme.bodySmall?.copyWith(color: context.colors.primary),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _fade(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        jobTitle,
        style: _textTheme.bodySmall?.copyWith(
          color: _fade(0.85),
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 18),
      tooltip: tooltip,
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }

  DataRow _buildRow(PersonnelData data, bool isEven) {
    final employeeNo = data.company.employeeNumber;
    final mobileNo = data.contactInfo.workMobilePhone;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
            (_) => isEven ? _fade(0.05) : null,
      ),
      onSelectChanged: (_) => _openDetails(data),
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(_initials(data.displayName)),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.displayName,
                    style: _textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    (employeeNo?.isNotEmpty ?? false) ? employeeNo! : '-',
                    style: _textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(_buildJobTitlePill(data.company.jobTitle)),
        DataCell(
          Text(
            mobileNo.isNotEmpty ? mobileNo : '-',
            style: _textTheme.bodySmall?.copyWith(color: context.colors.primary),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(
                icon: Icons.edit_rounded,
                color: context.colors.primary,
                tooltip: 'View Details',
                onPressed: () => _openDetails(data),
              ),
              const SizedBox(width: 4),
              _actionButton(
                icon: Icons.delete_rounded,
                color: Colors.red,
                tooltip: 'Delete Personnel',
                onPressed:
                    () => _confirmDelete(
                  data.personnel.personnelID ?? '',
                  data.displayName,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String initials, {double size = 34}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary, _fade(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: _fade(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
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