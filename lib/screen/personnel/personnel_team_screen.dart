import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/personnel_team_model/personnel_team_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/widget/common_confirm_dialog.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class PersonnelTeamScreen extends StatefulWidget {
  const PersonnelTeamScreen({super.key});

  @override
  State<PersonnelTeamScreen> createState() => _PersonnelTeamScreenState();
}

class _PersonnelTeamScreenState extends State<PersonnelTeamScreen>
    with SingleTickerProviderStateMixin {
  static const _tabletBreakpoint = 768.0;
  static const _desktopBreakpoint = 1024.0;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  List<PersonnelTeamModel> _filteredTeams = [];
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
    await context.read<PersonnelProvider>().fetchTeamPersonnel();
    if (mounted) _animationController.forward();
  }

  void _onSearchChanged() {
    final provider = context.read<PersonnelProvider>();
    setState(() {
      _filteredTeams = provider.searchTeams(_searchController.text);
    });
  }

  double get _width => MediaQuery.of(context).size.width;

  bool get _isDesktop => _width >= _desktopBreakpoint;

  double get _gutter =>
      _isDesktop ? 32 : (_width >= _tabletBreakpoint ? 24 : 16);

  TextTheme get _textTheme => context.topology.textTheme;

  Color _fade([double opacity = 1]) => context.colors.primary.withOpacity(opacity);

  List<PersonnelTeamModel> _visibleTeams(PersonnelProvider provider) =>
      _searchController.text.isEmpty
          ? provider.teamPersonnelList
          : _filteredTeams;

  String _initial(String? name) =>
      (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : 'T';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';

  void _createTeam() =>
      NavigationService().navigateTo(NavigationRoutes.createTeamPersonnel);

  void _editTeam(PersonnelTeamModel team) {
    NavigationService().navigateTo(
      NavigationRoutes.createTeamPersonnel,
      arguments: team.teamPersonnelId,
    );
  }

  void _clearSearch() => _searchController.clear();

  Future<void> _confirmDelete(String teamId, String name) {
    return CommonConfirmDialog.show(
      context: context,
      title: 'Delete Team',
      message: 'Are you sure you want to delete "$name"?',
      warningNote: 'This action is permanent and cannot be reversed.',
      confirmText: 'Delete',
      isDestructive: true,
      previewWidget: Row(
        children: [
          _buildAvatar(_initial(name)),
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
      onConfirm: () => _deleteTeam(teamId, name),
    );
  }

  Future<void> _deleteTeam(String teamId, String name) async {
    final success = await context.read<PersonnelProvider>().deleteTeamPersonnel(
      teamId,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '"$name" deleted' : 'Failed to delete "$name"'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  BoxDecoration _cardDecoration({
    double radius = 20,
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
        final hasData = provider.teamPersonnelList.isNotEmpty;

        if (provider.isLoading && !hasData) return _buildLoadingState();
        if (provider.errorMessage != null && !hasData) {
          return _buildErrorState(provider);
        }

        final teams = _visibleTeams(provider);
        if (teams.isEmpty) return _buildEmptyState();

        return _buildMainLayout(teams);
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
              'Loading teams...',
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
                      color: _fade(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSearching
                          ? Icons.search_off_rounded
                          : Icons.groups_rounded,
                      size: 80,
                      color: _fade(0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    isSearching ? 'No results found' : 'No teams yet',
                    style: _textTheme.headlineSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSearching
                        ? 'Try adjusting your search query'
                        : 'Create your first team to get started',
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
                      label: 'Create Team',
                      icon: Icons.add_rounded,
                      onPressed: _createTeam,
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
            decoration: _cardDecoration(),
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
                  'Failed to load teams',
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
                    onPressed: provider.refreshTeamPersonnel,
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

  Widget _buildMainLayout(List<PersonnelTeamModel> teams) {
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
                    _buildResultsCount(teams.length),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(_gutter, 0, _gutter, 100),
              sliver: SliverToBoxAdapter(child: _buildTable(teams)),
            ),
          ],
        ),
      ),
      floatingActionButton:
      _isDesktop
          ? null
          : FloatingActionButton.extended(
        onPressed: _createTeam,
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
      decoration: _cardDecoration(
        radius: 16,
        blur: 12,
        offsetY: 4,
        shadowAlpha: 0.04,
      ).copyWith(border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.primary,
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
              Icons.groups_rounded,
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
                  'Teams',
                  style: _textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your inspection teams',
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
              label: 'Create Team',
              icon: Icons.add_rounded,
              onPressed: _createTeam,
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
              ? 'Search by team name, type, or description...'
              : 'Search teams...',
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
            color: _fade(0.09),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.groups_rounded, size: 18, color: context.colors.primary),
              const SizedBox(width: 8),
              Text(
                '$count ${count == 1 ? 'team' : 'teams'}',
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
            onPressed:
            provider.isLoading ? null : provider.refreshTeamPersonnel,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<PersonnelTeamModel> teams) {
    return RefreshIndicator(
      onRefresh: () => context.read<PersonnelProvider>().refreshTeamPersonnel(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
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
                dataRowMaxHeight: 72,
                columns: [
                  for (final label in const [
                    'Team',
                    'Type',
                    'Description',
                    'Created',
                    'Actions',
                  ])
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          label,
                          style: _textTheme.titleSmall?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
                rows: [
                  for (var i = 0; i < teams.length; i++)
                    _buildRow(teams[i], i.isEven),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String initial) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Text(
      '-',
      style: _textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _fade(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fade(0.25)),
      ),
      child: Text(
        type,
        style: _textTheme.bodySmall?.copyWith(
          color: context.colors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(String? description) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Text(
        description ?? '-',
        style: _textTheme.bodySmall?.copyWith(
          color: description != null ? _fade(0.75) : Colors.grey.shade400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCreatedAt(DateTime date) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_today_rounded, size: 13, color: _fade(0.5)),
        const SizedBox(width: 6),
        Text(
          _formatDate(date),
          style: _textTheme.bodySmall?.copyWith(color: _fade(0.7)),
        ),
      ],
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

  DataRow _buildRow(PersonnelTeamModel team, bool isEven) {
    final name = team.name;
    final type = team.type;
    final createdAt = team.createdAt;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
            (_) => isEven ? _fade(0.05) : null,
      ),
      onSelectChanged: (_) => _editTeam(team),
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(_initial(name)),
              const SizedBox(width: 10),
              Text(
                name ?? '-',
                style: _textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        DataCell(type != null ? _buildTypeBadge(type) : _buildPlaceholder()),
        DataCell(_buildDescription(team.description)),
        DataCell(
          createdAt != null ? _buildCreatedAt(createdAt) : _buildPlaceholder(),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(
                icon: Icons.edit_rounded,
                color: context.colors.primary,
                tooltip: 'Edit Team',
                onPressed: () => _editTeam(team),
              ),
              const SizedBox(width: 4),
              _actionButton(
                icon: Icons.delete_rounded,
                color: Colors.red,
                tooltip: 'Delete Team',
                onPressed:
                    () => _confirmDelete(
                  team.teamPersonnelId ?? '',
                  name ?? 'Team',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}