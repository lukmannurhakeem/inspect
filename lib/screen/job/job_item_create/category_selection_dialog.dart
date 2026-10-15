import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/screen/job/job_item_create/job_form_style.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class CategorySelectionDialog extends StatefulWidget {
  const CategorySelectionDialog({
    super.key,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  final Function(CategoryItem) onCategorySelected;
  final CategoryItem? selectedCategory;

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  final _searchController = TextEditingController();
  CategoryItem? _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedCategory;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() =>
      context.read<CategoryProvider>().searchCategories(_searchController.text);

  void _confirm() {
    widget.onCategorySelected(_tempSelected!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Category',
                    style: context.topology.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            CommonTextField(
              controller: _searchController,
              hintText: 'Search categories...',
              style: context.fieldStyle,
              suffixIcon: Icon(Icons.search, color: context.colors.primary),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          Text(
                            provider.errorMessage!,
                            style: context.topology.textTheme.bodyMedium
                                ?.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: provider.refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (provider.totalItemCount == 0) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'No categories available'
                            : 'No categories matching "${_searchController.text}"',
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.tint(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.totalItemCount,
                    itemBuilder: (context, index) {
                      final category = provider.getCategoryByIndex(index);
                      if (category == null) return const SizedBox.shrink();
                      return _buildItem(context, provider, category);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _tempSelected != null ? _confirm : null,
                  child: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    CategoryProvider provider,
    CategoryItem category,
  ) {
    final primary = context.colors.primary;
    final isSelected = _tempSelected?.id == category.id;
    final isRoot = category.level == 0;
    final hasChildren = category.children.isNotEmpty;
    final textTheme = context.topology.textTheme;

    return GestureDetector(
      onTap: () {
        if (hasChildren) provider.toggleExpansion(category);
        setState(() => _tempSelected = category);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? context.tint(0.1)
                  : isRoot
                  ? Colors.transparent
                  : context.tint(0.02 + category.level * 0.01),
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? Border.all(color: primary, width: 1) : null,
        ),
        margin: EdgeInsets.only(left: category.level * 16.0, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child:
                  hasChildren
                      ? Icon(
                        category.isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: primary,
                        size: 18,
                      )
                      : isRoot
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
                  color: isSelected ? primary : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? primary : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: (isRoot ? textTheme.bodyMedium : textTheme.bodySmall)
                        ?.copyWith(
                          color:
                              isRoot || isSelected ? primary : context.tint(0.8),
                          fontWeight:
                              isSelected
                                  ? (isRoot ? FontWeight.w600 : FontWeight.w500)
                                  : (isRoot
                                      ? FontWeight.w500
                                      : FontWeight.normal),
                        ),
                  ),
                  if (category.categoryCode != null)
                    Text(
                      'Code: ${category.categoryCode}',
                      style: textTheme.bodySmall?.copyWith(
                        color: context.tint(0.6),
                        fontSize: 11,
                      ),
                    ),
                  if (category.description != null &&
                      category.description!.isNotEmpty)
                    Text(
                      category.description!,
                      style: textTheme.bodySmall?.copyWith(
                        color: context.tint(0.5),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (hasChildren)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.tint(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.children.length}',
                  style: textTheme.bodySmall?.copyWith(
                    color: primary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
