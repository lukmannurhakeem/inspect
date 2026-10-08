import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/item_register_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

const dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
);

ButtonStyle filledStyle(
    Color color, {
      double radius = 8,
      double elevation = 0,
      EdgeInsetsGeometry? padding,
    }) => ElevatedButton.styleFrom(
  backgroundColor: color,
  foregroundColor: Colors.white,
  elevation: elevation,
  padding: padding,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
);

BoxDecoration gradientBox(
    BuildContext context, {
      double from = 0.1,
      double to = 0.05,
      double radius = 12,
      BoxShape shape = BoxShape.rectangle,
    }) {
  final primary = context.colors.primary;
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [primary.withValues(alpha: from), primary.withValues(alpha: to)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shape: shape,
    borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
  );
}

class ItemSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const ItemSearchBar({super.key, required this.controller, required this.hint});

  @override
  State<ItemSearchBar> createState() => _ItemSearchBarState();
}

class _ItemSearchBarState extends State<ItemSearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
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
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (context, value, _) => CommonTextField(
            controller: widget.controller,
            hintText: widget.hint,
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: primary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: primary.withValues(alpha: 0.6),
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear_rounded, color: primary),
              onPressed: () {
                widget.controller.clear();
                FocusScope.of(context).unfocus();
              },
            )
                : null,
          ),
        ),
      ),
    );
  }
}

class ItemSyncBanner extends StatelessWidget {
  final ItemRegisterProvider provider;
  final double bottomSpacing;

  const ItemSyncBanner({
    super.key,
    required this.provider,
    this.bottomSpacing = 0,
  });

  (MaterialColor, Widget, String)? _state() {
    final pending = provider.pendingCount;

    if (provider.isSyncing) {
      return (
      Colors.blue,
      SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.blue.shade600,
        ),
      ),
      'Syncing items from server...',
      );
    }
    if (pending > 0) {
      return (
      Colors.orange,
      const Icon(Icons.cloud_upload_outlined, size: 14, color: Colors.orange),
      '$pending item(s) pending upload. Tap sync to push to server.',
      );
    }
    if (provider.isLoadedFromCache && !provider.hasSynced) {
      return (
      Colors.orange,
      const Icon(Icons.offline_pin, size: 14, color: Colors.orange),
      'Offline — showing cached data. Tap sync to refresh.',
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = _state();
    if (state == null) return const SizedBox.shrink();
    final (color, leading, text) = state;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.2))),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: color.shade800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemSyncButton extends StatelessWidget {
  final ItemRegisterProvider provider;
  final VoidCallback onSync;

  const ItemSyncButton({super.key, required this.provider, required this.onSync});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final cached = provider.isLoadedFromCache;
    final offline = !provider.hasSynced && cached;
    final statusColor = offline
        ? Colors.orange.shade600
        : primary.withValues(alpha: 0.65);
    final pending = provider.pendingCount;

    return Container(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.hasSynced || cached)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    offline
                        ? Icons.wifi_off_rounded
                        : cached
                        ? Icons.offline_pin
                        : Icons.cloud_done,
                    size: 14,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    offline
                        ? 'Offline'
                        : cached
                        ? 'Cached'
                        : provider.lastSyncLabel!,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: offline ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
          if (pending > 0 && !provider.isSyncing)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: provider.isSyncing
                ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primary,
              ),
            )
                : Icon(Icons.sync_rounded, color: primary, size: 20),
            onPressed: provider.isSyncing ? null : onSync,
            tooltip: pending > 0
                ? 'Upload $pending pending item(s) & refresh'
                : 'Sync items from server',
          ),
        ],
      ),
    );
  }
}

class ItemResultsCount extends StatelessWidget {
  final int count;
  final int selectedCount;

  const ItemResultsCount({
    super.key,
    required this.count,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final style = context.topology.textTheme.bodySmall;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: gradientBox(context, from: 0.12, to: 0.06, radius: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 15, color: primary),
          const SizedBox(width: 6),
          Text(
            '$count ${count == 1 ? 'item' : 'items'}',
            style: style?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (selectedCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$selectedCount selected',
                style: style?.copyWith(
                  color: primary,
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
}

class ItemActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ItemActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 15),
    label: Text(label),
    style:
    filledStyle(
      color,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ).copyWith(
      textStyle: WidgetStatePropertyAll(
        context.topology.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class ItemStatusChip extends StatelessWidget {
  final String status;

  const ItemStatusChip({super.key, required this.status});

  static Color _color(String status) => switch (status) {
    'accepted' || 'submitted' => Colors.green,
    'pending' || 'pending_submission' || 'draft' => Colors.orange,
    'rejected' => Colors.red,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color(status);

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
}

class ItemEmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const ItemEmptyState({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: gradientBox(context, shape: BoxShape.circle),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 60,
                  color: primary.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Items Yet',
                style: text.titleLarge?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Start building your inventory by creating\nyour first item for this job',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                label: const Text('Create First Item'),
                style: filledStyle(
                  primary,
                  radius: 12,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: gradientBox(context, from: 0.06, to: 0.03).copyWith(
                  border: Border.all(color: primary.withValues(alpha: 0.12)),
                ),
                child: Column(
                  children: [
                    Text(
                      'What you can do:',
                      style: text.titleSmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final (icon, label) in const [
                      (
                      Icons.check_circle_outline_rounded,
                      'Track items and inspections',
                      ),
                      (
                      Icons.location_on_outlined,
                      'Manage locations and categories',
                      ),
                      (Icons.download_outlined, 'Export reports and data'),
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(icon, size: 16, color: primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label,
                                style: text.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
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
}

class ItemStateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final Color? titleColor;
  final Widget? action;

  const ItemStateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    this.titleColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final tint = color ?? primary;
    final text = context.topology.textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: tint.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(
              color: titleColor ?? primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: text.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    );
  }
}

class LoadingFieldsDialog extends StatelessWidget {
  final String label;

  const LoadingFieldsDialog({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: primary, strokeWidth: 3),
            const SizedBox(height: 16),
            Text(
              'Loading fields for',
              style: text.bodyMedium?.copyWith(
                color: Colors.grey[600],
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: text.titleSmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _search = TextEditingController();
  CategoryItem? _selected;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    context.read<CategoryProvider>().searchCategories(value);
    setState(() {});
  }

  void _clearSearch() {
    _search.clear();
    _onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: gradientBox(
                    context,
                    from: 1,
                    to: 0.8,
                    radius: 10,
                  ).copyWith(
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
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
                        style: text.titleMedium?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Choose a category for the new item',
                        style: text.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 8),
            CommonTextField(
              controller: _search,
              hintText: 'Search categories...',
              style: text.bodySmall?.copyWith(color: primary),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: primary.withValues(alpha: 0.6),
                size: 20,
              ),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                icon: Icon(Icons.clear_rounded, color: primary, size: 18),
                onPressed: _clearSearch,
              ),
              onChanged: _onSearch,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, provider, _) => _buildBody(context, provider),
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
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
                  child: Text('Cancel', style: TextStyle(color: primary)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.of(context).pop(_selected),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Continue'),
                  style: filledStyle(
                    primary,
                    radius: 10,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
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

  Widget _buildBody(BuildContext context, CategoryProvider provider) {
    final primary = context.colors.primary;

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: primary));
    }

    if (provider.errorMessage != null) {
      return ItemStateMessage(
        icon: Icons.error_outline_rounded,
        color: Colors.red,
        titleColor: Colors.red,
        title: provider.errorMessage!,
        action: ElevatedButton.icon(
          onPressed: () => provider.refresh(),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
          style: filledStyle(primary),
        ),
      );
    }

    if (provider.totalItemCount == 0) {
      final query = _search.text;
      return ItemStateMessage(
        icon: Icons.category_outlined,
        title: query.isEmpty
            ? 'No categories available'
            : 'No categories matching\n"$query"',
        action: query.isEmpty
            ? null
            : TextButton.icon(
          onPressed: _clearSearch,
          icon: const Icon(Icons.clear_all_rounded, size: 16),
          label: const Text('Clear search'),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.totalItemCount,
      itemBuilder: (context, index) {
        final category = provider.getCategoryByIndex(index);
        if (category == null) return const SizedBox.shrink();
        return CategoryTile(
          provider: provider,
          category: category,
          selected: _selected?.id == category.id,
          onTap: () => setState(() => _selected = category),
        );
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryProvider provider;
  final CategoryItem category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.provider,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;
    final hasChildren = category.children.isNotEmpty;
    final description = category.description;

    return GestureDetector(
      onTap: () {
        if (hasChildren) provider.toggleExpansion(category);
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(left: category.level * 16.0, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.1)
              : category.level == 0
              ? Colors.transparent
              : primary.withValues(alpha: 0.02 + category.level * 0.01),
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: primary, width: 1.5) : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: hasChildren
                  ? Icon(
                category.isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                color: primary,
                size: 18,
              )
                  : category.level == 0
                  ? null
                  : Icon(
                category.level == 1
                    ? Icons.subdirectory_arrow_right
                    : Icons.more_horiz,
                color: Colors.grey.withValues(alpha: 0.6),
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? primary : Colors.grey,
                  width: 2,
                ),
                color: selected ? primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: category.level == 0
                        ? text.bodyMedium?.copyWith(
                      color: primary,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    )
                        : text.bodySmall?.copyWith(
                      color: selected
                          ? primary
                          : primary.withValues(alpha: 0.8),
                      fontWeight: selected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  if (category.categoryCode != null)
                    Text(
                      'Code: ${category.categoryCode}',
                      style: text.bodySmall?.copyWith(
                        color: primary.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  if (description != null && description.isNotEmpty)
                    Text(
                      description,
                      style: text.bodySmall?.copyWith(
                        color: primary.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (hasChildren) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.children.length}',
                  style: text.bodySmall?.copyWith(
                    color: primary,
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
}

class ReportTableBody extends StatefulWidget {
  final Map<String, dynamic> item;
  final void Function(String typeId, String name) onSelected;

  const ReportTableBody({super.key, required this.item, required this.onSelected});

  @override
  State<ReportTableBody> createState() => _ReportTableBodyState();
}

class _ReportTableBodyState extends State<ReportTableBody> {
  static final _uuid = RegExp(
    r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
    caseSensitive: false,
  );

  late final List<Map<String, dynamic>> _existing = ItemRegisterProvider.reports(
    widget.item,
  );
  late Future<void> _future = Future.microtask(_fetch);

  Future<void> _fetch() async {
    if (!mounted) return;
    final provider = context.read<SystemProvider>();
    if (provider.getReportTypeModel?.data?.isNotEmpty != true) {
      await provider.fetchReportType();
    }
  }

  Map<String, dynamic>? _existingFor(String typeId) => typeId.isEmpty
      ? null
      : _existing
      .where(
        (r) =>
    (r['reportTypeID'] ?? r['reportTypeId'] ?? '')
        .toString()
        .toLowerCase() ==
        typeId.toLowerCase(),
  )
      .firstOrNull;

  Future<void> _openPdf({
    required String reportId,
    required String viewUrl,
    required String downloadUrl,
    required String name,
  }) async {
    final id = reportId.isNotEmpty
        ? reportId
        : _uuid.firstMatch(viewUrl)?.group(0) ?? '';

    if (kIsWeb) {
      final url = [
        viewUrl,
        downloadUrl,
        if (id.isNotEmpty) '${AppConstants.apiBaseUrl}/reportData/$id/view-pdf',
      ].firstWhere((u) => u.isNotEmpty, orElse: () => '');

      if (url.isEmpty) {
        CommonSnackbar.showWarning(context, 'No PDF URL available for this report.');
        return;
      }
      openInNewTab(url);
      return;
    }

    if (id.isEmpty) {
      CommonSnackbar.showWarning(context, 'Report ID is missing, cannot open PDF.');
      return;
    }

    final systemProvider = context.read<SystemProvider>();
    final messenger = ScaffoldMessenger.of(context);
    CommonSnackbar.show(
      context: context,
      message: 'Loading PDF...',
      type: SnackbarType.info,
      duration: const Duration(seconds: 60),
    );

    try {
      final bytes = await systemProvider.fetchPdfReportById(id);
      messenger.hideCurrentSnackBar();
      if (!mounted) return;

      if (bytes == null) {
        CommonSnackbar.showWarning(
          context,
          'PDF not available. The report may still be processing.',
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            pdfData: bytes,
            reportName: name.isNotEmpty ? name : 'Report_$id',
          ),
        ),
      );
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (mounted) CommonSnackbar.showError(context, 'Failed to load PDF: $e');
    }
  }

  Widget _tableRow(
      Widget name,
      Widget create,
      Widget previous, {
        Color? color,
        Border? border,
      }) => Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
    decoration: BoxDecoration(color: color, border: border),
    child: Row(
      children: [
        Expanded(flex: 3, child: name),
        Expanded(
          flex: 2,
          child: Align(alignment: Alignment.centerLeft, child: create),
        ),
        Expanded(
          flex: 3,
          child: Align(alignment: Alignment.centerLeft, child: previous),
        ),
      ],
    ),
  );

  Widget _headerText(String label) => Text(
    label,
    style: context.topology.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.grey[700],
    ),
  );

  Widget _buildStatus(AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final text = context.topology.textTheme.bodyMedium;

    if (snapshot.hasError) {
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
                style: text?.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () =>
                    setState(() => _future = Future.microtask(_fetch)),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry'),
                style: filledStyle(context.colors.primary),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Text(
          'No report types available',
          style: text?.copyWith(color: Colors.grey[500]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reports =
        context.watch<SystemProvider>().getReportTypeModel?.data ?? [];

    if (reports.isEmpty) {
      return FutureBuilder<void>(
        future: _future,
        builder: (_, snapshot) => _buildStatus(snapshot),
      );
    }

    final primary = context.colors.primary;
    final small = context.topology.textTheme.bodySmall;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              'Internal',
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: primary.withValues(alpha: 0.65),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          _tableRow(
            _headerText('Report Type'),
            _headerText('New Report'),
            _headerText('Previous Report'),
            color: Colors.grey.shade50,
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          ...reports.indexed.map((entry) {
            final (index, report) = entry;
            final name = report.reportType?.reportName ?? '';
            final typeId = report.reportType?.reportTypeId ?? '';
            final existing = _existingFor(typeId);
            final reportId =
            (existing?['reportID'] ?? existing?['reportId'] ?? '')
                .toString();
            final viewUrl = existing?['viewUrl']?.toString() ?? '';
            final downloadUrl = existing?['downloadUrl']?.toString() ?? '';
            final hasReport =
                reportId.isNotEmpty ||
                    viewUrl.isNotEmpty ||
                    downloadUrl.isNotEmpty;

            return _tableRow(
              Text(name, style: small?.copyWith(color: primary)),
              _OutlineBtn(
                icon: Icons.add,
                label: 'New',
                color: primary,
                onTap: () => widget.onSelected(typeId, name),
              ),
              hasReport
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OutlineBtn(
                    icon: Icons.picture_as_pdf_outlined,
                    label: 'View Report',
                    color: Colors.teal.shade600,
                    onTap: () => _openPdf(
                      reportId: reportId,
                      viewUrl: viewUrl,
                      downloadUrl: downloadUrl,
                      name: name,
                    ),
                  ),
                  if (downloadUrl.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _OutlineBtn(
                      icon: Icons.print_outlined,
                      label: 'Print Report',
                      color: Colors.blueGrey.shade600,
                      onTap: () => _openPdf(
                        reportId: reportId,
                        viewUrl: downloadUrl,
                        downloadUrl: downloadUrl,
                        name: name,
                      ),
                    ),
                  ],
                ],
              )
                  : Text(
                'No Report',
                style: small?.copyWith(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              color: index.isEven ? Colors.white : Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
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
  Widget build(BuildContext context) => InkWell(
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