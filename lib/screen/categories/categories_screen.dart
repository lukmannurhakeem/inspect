import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/screen/categories/category_importer.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

typedef _Entry = ({CategoryItem category, int number});

enum _CategoryAction { view, edit, addSub, delete }

extension on _CategoryAction {
  IconData get icon => switch (this) {
    _CategoryAction.view => Icons.visibility_outlined,
    _CategoryAction.edit => Icons.edit_rounded,
    _CategoryAction.addSub => Icons.subdirectory_arrow_right,
    _CategoryAction.delete => Icons.delete_rounded,
  };

  String get label => switch (this) {
    _CategoryAction.view => 'View',
    _CategoryAction.edit => 'Edit',
    _CategoryAction.addSub => 'Add sub-category',
    _CategoryAction.delete => 'Delete',
  };

  bool get isDestructive => this == _CategoryAction.delete;
}

class _Layout {
  const _Layout(this.width);

  final double width;

  bool get isTablet => width >= 768;
  bool get isDesktop => width >= 1024;
  double get padding => isDesktop ? 32 : (isTablet ? 24 : 16);
}

void _openCreate() =>
    NavigationService().navigateTo(NavigationRoutes.createCategories);

String _plural(int count) => '$count ${count == 1 ? 'category' : 'categories'}';

ButtonStyle _primaryButtonStyle(
    Color primary, {
      EdgeInsetsGeometry? padding,
      double elevation = 0,
    }) =>
    ElevatedButton.styleFrom(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      padding: padding,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _hideWithdrawn = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryProvider>().fetchCategories();
      setState(() => _started = true);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context
          .read<CategoryProvider>()
          .searchCategories(_searchController.text.trim());
    });
  }

  Future<void> _refresh() async {
    final provider = context.read<CategoryProvider>();
    await provider.refresh();
    final query = _searchController.text.trim();
    if (mounted && query.isNotEmpty) provider.searchCategories(query);
  }

  void _onAction(_CategoryAction action, CategoryItem category) {
    switch (action) {
      case _CategoryAction.view:
        NavigationService().navigateTo(
          NavigationRoutes.categoryDetails,
          arguments: category,
        );
      case _CategoryAction.edit:
        NavigationService().navigateTo(
          NavigationRoutes.createCategories,
          arguments: {
            'categoryId': category.id,
            'parentCategoryId': category.parentId,
            'parentCategoryName': category.parentName,
          },
        );
      case _CategoryAction.addSub:
        NavigationService().navigateTo(
          NavigationRoutes.createCategories,
          arguments: {
            'parentCategoryId': category.id,
            'parentCategoryName': category.name,
          },
        );
      case _CategoryAction.delete:
        _confirmDelete(category);
    }
  }

  Future<void> _confirmDelete(CategoryItem category) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DeleteDialog(category: category),
    );
    if (deleted == null || !mounted) return;

    if (deleted) {
      CommonSnackbar.showSuccess(
        context,
        '"${category.name}" deleted successfully',
      );
    } else {
      CommonSnackbar.showError(
        context,
        context.read<CategoryProvider>().errorMessage ??
            'Failed to delete "${category.name}"',
      );
    }
  }

  List<_Entry> _visibleEntries(CategoryProvider provider) {
    final entries = <_Entry>[];
    var rootNumber = 0;
    for (var i = 0; i < provider.totalItemCount; i++) {
      final category = provider.getCategoryByIndex(i);
      if (category == null || (_hideWithdrawn && category.isWithdrawn)) {
        continue;
      }
      if (category.level == 0) rootNumber++;
      entries.add((category: category, number: rootNumber));
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, _) {
        final hasQuery = _searchController.text.isNotEmpty;

        if (provider.totalItemCount == 0 && !hasQuery) {
          if (!_started || provider.isLoading) return const _LoadingState();
          if (provider.errorMessage != null) {
            return _ErrorState(
              message: provider.errorMessage!,
              onRetry: _refresh,
            );
          }
          return const _EmptyState();
        }

        return _buildContent(provider, hasQuery);
      },
    );
  }

  Widget _buildContent(CategoryProvider provider, bool hasQuery) {
    final layout = _Layout(MediaQuery.sizeOf(context).width);
    final entries = _visibleEntries(provider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: layout.isDesktop ? null : const _Fabs(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  layout.padding,
                  layout.padding,
                  layout.padding,
                  8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(isDesktop: layout.isDesktop),
                      const SizedBox(height: 24),
                      _SearchBar(
                        controller: _searchController,
                        isDesktop: layout.isDesktop,
                      ),
                      const SizedBox(height: 16),
                      _ResultsBar(
                        count: entries.length,
                        showWithdrawnToggle: provider.withdrawnItemCount > 0,
                        hideWithdrawn: _hideWithdrawn,
                        showHint: layout.isTablet,
                        isLoading: provider.isLoading,
                        onToggleWithdrawn: () =>
                            setState(() => _hideWithdrawn = !_hideWithdrawn),
                        onRefresh: _refresh,
                      ),
                    ],
                  ),
                ),
              ),
              if (entries.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NoResults(
                    message: hasQuery
                        ? 'Try adjusting your search'
                        : 'All categories are withdrawn',
                    actionLabel: hasQuery ? 'Clear Search' : 'Show Withdrawn',
                    onAction: hasQuery
                        ? _searchController.clear
                        : () => setState(() => _hideWithdrawn = false),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    layout.padding,
                    8,
                    layout.padding,
                    100,
                  ),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverList.builder(
                            itemCount: entries.length,
                            itemBuilder: (_, index) {
                              final entry = entries[index];
                              return _CategoryTile(
                                key: ValueKey(entry.category.id),
                                category: entry.category,
                                number: entry.number,
                                isStriped: index.isEven,
                                isTablet: layout.isTablet,
                                onToggle: () =>
                                    provider.toggleExpansion(entry.category),
                                onAction: (action) =>
                                    _onAction(action, entry.category),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _ListFooter(
                            isLoading: provider.isLoading,
                            count: entries.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              color: primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.category_rounded,
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
                  'Categories',
                  style: textTheme.titleLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage inspection categories and sub-categories',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => CategoryImporter.pickAndImport(context),
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Import from Excel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(color: primary),
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
              onPressed: _openCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Category'),
              style: _primaryButtonStyle(
                primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.controller, required this.isDesktop});

  final TextEditingController controller;
  final bool isDesktop;

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
              color: _focused
                  ? primary.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: _focused ? 12 : 8,
              offset: Offset(0, _focused ? 4 : 2),
            ),
          ],
        ),
        child: CommonTextField(
          controller: widget.controller,
          hintText: widget.isDesktop
              ? 'Search by category name or code...'
              : 'Search categories...',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: primary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primary.withValues(alpha: 0.6),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.clear_rounded, color: primary),
                tooltip: 'Clear search',
                onPressed: () {
                  widget.controller.clear();
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ResultsBar extends StatelessWidget {
  const _ResultsBar({
    required this.count,
    required this.showWithdrawnToggle,
    required this.hideWithdrawn,
    required this.showHint,
    required this.isLoading,
    required this.onToggleWithdrawn,
    required this.onRefresh,
  });

  final int count;
  final bool showWithdrawnToggle;
  final bool hideWithdrawn;
  final bool showHint;
  final bool isLoading;
  final VoidCallback onToggleWithdrawn;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.category_rounded, size: 18, color: primary),
                const SizedBox(width: 8),
                Text(
                  _plural(count),
                  style: textTheme.bodySmall?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showHint) ...[
                Text(
                  'Click to expand/collapse',
                  style: textTheme.bodySmall?.copyWith(
                    color: primary.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showWithdrawnToggle) ...[
                _WithdrawnToggle(
                  hidden: hideWithdrawn,
                  onTap: onToggleWithdrawn,
                ),
                const SizedBox(width: 4),
              ],
              IconButton(
                icon: Icon(Icons.refresh_rounded, color: primary),
                tooltip: 'Refresh',
                onPressed: isLoading ? null : onRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WithdrawnToggle extends StatelessWidget {
  const _WithdrawnToggle({required this.hidden, required this.onTap});

  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final color = hidden ? Colors.red.shade600 : primary;

    return Tooltip(
      message: hidden ? 'Show withdrawn items' : 'Hide withdrawn items',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: hidden ? Colors.red.shade50 : primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hidden
                  ? Colors.red.shade300
                  : primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hidden
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 5),
              Text(
                hidden ? 'Withdrawn hidden' : 'Hide withdrawn',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    super.key,
    required this.category,
    required this.number,
    required this.isStriped,
    required this.isTablet,
    required this.onToggle,
    required this.onAction,
  });

  final CategoryItem category;
  final int number;
  final bool isStriped;
  final bool isTablet;
  final VoidCallback onToggle;
  final ValueChanged<_CategoryAction> onAction;

  bool get _isRoot => category.level == 0;
  bool get _hasChildren => category.children.isNotEmpty;

  Color _background(Color primary) {
    if (_isRoot) {
      return isStriped ? primary.withValues(alpha: 0.04) : Colors.transparent;
    }
    return primary.withValues(alpha: 0.02 + category.level * 0.01);
  }

  Widget? _indentIcon() {
    if (_isRoot) return null;
    return Icon(
      category.level == 1 ? Icons.subdirectory_arrow_right : Icons.more_horiz,
      color: Colors.grey.shade400,
      size: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;
    final code = category.categoryCode;
    final description = category.description;

    final nameStyle = _isRoot
        ? textTheme.bodyMedium?.copyWith(
      color: primary,
      fontWeight: FontWeight.w600,
    )
        : textTheme.bodySmall?.copyWith(color: primary.withValues(alpha: 0.85));

    return Padding(
      padding: EdgeInsets.only(left: category.level * 20.0, bottom: 6),
      child: Material(
        color: _background(primary),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: _isRoot
              ? BorderSide(color: Colors.grey.shade200, width: 0.5)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: _hasChildren ? onToggle : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: _hasChildren
                      ? Icon(
                    category.isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: primary,
                    size: 20,
                  )
                      : _indentIcon(),
                ),
                const SizedBox(width: 8),
                if (_isRoot) ...[
                  _Badge(
                    label: '$number',
                    color: primary,
                    background: primary.withValues(alpha: 0.1),
                    radius: 6,
                    fontSize: 12,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(category.name, style: nameStyle),
                          if (!_isRoot)
                            _Badge(
                              label: 'Sub',
                              color: primary,
                              background: primary.withValues(alpha: 0.12),
                            ),
                          if (category.isWithdrawn)
                            _Badge(
                              label: 'Withdrawn',
                              icon: Icons.block_rounded,
                              color: Colors.red.shade600,
                              background: Colors.red.shade50,
                              borderColor: Colors.red.shade300,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                        ],
                      ),
                      if (code != null && code.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        _Badge(
                          label: '# $code',
                          color: primary.withValues(alpha: 0.7),
                          background: primary.withValues(alpha: 0.08),
                          radius: 4,
                        ),
                      ],
                      if (description != null && description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_hasChildren)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _Badge(
                      label: '${category.children.length}',
                      icon: Icons.subdirectory_arrow_right,
                      color: Colors.white,
                      background: primary,
                      radius: 12,
                      fontSize: 11,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                _TileActions(isTablet: isTablet, onSelected: onAction),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
    this.borderColor,
    this.radius = 8,
    this.fontSize = 10,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  final Color? borderColor;
  final double radius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TileActions extends StatelessWidget {
  const _TileActions({required this.isTablet, required this.onSelected});

  final bool isTablet;
  final ValueChanged<_CategoryAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    if (isTablet) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final action in _CategoryAction.values)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: _IconAction(
                icon: action.icon,
                tooltip: action.label,
                color: action.isDestructive ? Colors.red : primary,
                onPressed: () => onSelected(action),
              ),
            ),
        ],
      );
    }

    return PopupMenuButton<_CategoryAction>(
      icon: Icon(Icons.more_vert, color: primary, size: 20),
      tooltip: 'Actions',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final action in _CategoryAction.values) ...[
          if (action.isDestructive) const PopupMenuDivider(),
          PopupMenuItem(
            value: action,
            child: _MenuLabel(
              action: action,
              color: action.isDestructive ? Colors.red : primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel({required this.action, required this.color});

  final _CategoryAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(action.icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          action.label,
          style: context.topology.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          icon: Icon(icon, size: 18),
          color: color,
          onPressed: onPressed,
          padding: const EdgeInsets.all(6),
          style: IconButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: color.withValues(alpha: 0.2)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.isLoading, required this.count});

  final bool isLoading;
  final int count;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    final color = primary.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            'All ${_plural(count)} loaded',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fabs extends StatelessWidget {
  const _Fabs();

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'import_categories',
          onPressed: () => CategoryImporter.pickAndImport(context),
          backgroundColor: Colors.white,
          foregroundColor: primary,
          elevation: 2,
          tooltip: 'Import from Excel',
          child: const Icon(Icons.upload_file_rounded),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: 'create_category',
          onPressed: _openCreate,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create'),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.topology.textTheme;

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
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading categories...',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

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
                  height: MediaQuery.sizeOf(context).height * 0.6,
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
                        color: primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        size: 80,
                        color: primary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No categories yet',
                      style: textTheme.headlineSmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first category to get started',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _openCreate,
                      icon: const Icon(Icons.add_rounded, size: 24),
                      label: const Text('Create Category'),
                      style: _primaryButtonStyle(
                        primary,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

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
                    color: Colors.black.withValues(alpha: 0.08),
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
                    'Failed to load categories',
                    style: textTheme.titleLarge?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: _primaryButtonStyle(
                        primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
}

class _NoResults extends StatelessWidget {
  const _NoResults({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                color: Colors.grey.shade100,
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
              'No categories found',
              style: textTheme.titleLarge?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.clear_all_rounded),
              label: Text(actionLabel),
              style: _primaryButtonStyle(
                primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({required this.category});

  final CategoryItem category;

  Future<void> _delete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final deleted =
    await context.read<CategoryProvider>().deleteCategory(category.id);
    navigator.pop(deleted);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;
    final isDeleting =
    context.select<CategoryProvider, bool>((p) => p.isDeleting);
    final code = category.categoryCode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.3),
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
                'Delete Category?',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete this category? This action cannot be undone and will also remove all sub-categories.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    _CategoryAvatar(name: category.name),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: textTheme.titleSmall?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (code != null && code.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            _Badge(
                              label: 'Code: $code',
                              color: primary,
                              background: primary.withValues(alpha: 0.1),
                              radius: 6,
                              fontSize: 11,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
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
                        style: textTheme.bodySmall?.copyWith(
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
                      onPressed:
                      isDeleting ? null : () => Navigator.of(context).pop(),
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
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDeleting ? null : () => _delete(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isDeleting
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
  }
}

class _CategoryAvatar extends StatelessWidget {
  const _CategoryAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        name.isEmpty ? 'C' : name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}