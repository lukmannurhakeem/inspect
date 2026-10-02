// lib/widget/regulation_picker_dialog.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/regulation_model/regulation_model.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Local cache helpers
// ─────────────────────────────────────────────────────────────────────────────
class _RegulationLocalCache {
  static const _listKey = 'inspect_regulation_list_cache';
  static const _recentKey = 'inspect_regulation_recent_ids';
  static const _recentMax = 50;

  static Future<List<RegulationModel>> getList() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_listKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => RegulationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveList(List<RegulationModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _listKey,
      jsonEncode(items.map((r) => r.toJson()).toList()),
    );
  }

  static Future<List<String>> getRecentIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recentKey);
    if (raw == null) return [];
    try {
      return List<String>.from(jsonDecode(raw));
    } catch (_) {
      return [];
    }
  }

  static Future<void> addRecentId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getRecentIds();
    list.remove(id);
    list.insert(0, id);
    if (list.length > _recentMax) list.removeRange(_recentMax, list.length);
    await prefs.setString(_recentKey, jsonEncode(list));
  }

  static Future<void> removeRecentId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getRecentIds();
    list.remove(id);
    await prefs.setString(_recentKey, jsonEncode(list));
  }

  static Future<void> clearRecentIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Public helper
// ─────────────────────────────────────────────────────────────────────────────
Future<RegulationModel?> showRegulationPickerDialog({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  final result = await showDialog<RegulationModel>(
    context: context,
    barrierDismissible: true,
    builder:
        (_) => _RegulationPickerDialog(
      systemProvider: Provider.of<SystemProvider>(context, listen: false),
    ),
  );
  if (result != null) {
    controller.text = result.regulationName ?? '';
    if (result.regulationId != null) {
      await _RegulationLocalCache.addRecentId(result.regulationId!);
    }
  }
  return result;
}

// ─────────────────────────────────────────────────────────────────────────────
// Dialog widget
// ─────────────────────────────────────────────────────────────────────────────
class _RegulationPickerDialog extends StatefulWidget {
  final SystemProvider systemProvider;

  const _RegulationPickerDialog({required this.systemProvider});

  @override
  State<_RegulationPickerDialog> createState() =>
      _RegulationPickerDialogState();
}

class _RegulationPickerDialogState extends State<_RegulationPickerDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final _newNameController = TextEditingController();
  String? _createError;

  List<RegulationModel> _allRegulations = [];
  List<String> _recentIds = [];
  bool _isLoading = true;
  bool _isOffline = false;

  RegulationModel? _selected;

  List<RegulationModel> _filteredAll = [];
  List<RegulationModel> _filteredRecent = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _newNameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isOffline = false;
    });

    final recentIds = await _RegulationLocalCache.getRecentIds();

    try {
      await widget.systemProvider.fetchRegulations();
      if (!mounted) return;
      if (widget.systemProvider.hasError)
        throw Exception(widget.systemProvider.errorMessage);

      await _RegulationLocalCache.saveList(widget.systemProvider.regulations);

      setState(() {
        _allRegulations = List.from(widget.systemProvider.regulations);
        _recentIds = recentIds;
        _isLoading = false;
        _isOffline = false;
        _rebuildFiltered();
      });
    } catch (_) {
      final cached = await _RegulationLocalCache.getList();
      if (!mounted) return;
      setState(() {
        _allRegulations = cached;
        _recentIds = recentIds;
        _isLoading = false;
        _isOffline = true;
        _rebuildFiltered();
      });
    }

    if (_recentIds.isNotEmpty) _tabController.animateTo(1);
  }

  void _rebuildFiltered() {
    final q = _searchController.text.toLowerCase().trim();
    _filteredAll =
    q.isEmpty
        ? List.from(_allRegulations)
        : _allRegulations
        .where(
          (r) => (r.regulationName ?? '').toLowerCase().contains(q),
    )
        .toList();

    final recentList =
    _recentIds
        .map((id) {
      try {
        return _allRegulations.firstWhere((r) => r.regulationId == id);
      } catch (_) {
        return null;
      }
    })
        .whereType<RegulationModel>()
        .toList();

    _filteredRecent =
    q.isEmpty
        ? recentList
        : recentList
        .where(
          (r) => (r.regulationName ?? '').toLowerCase().contains(q),
    )
        .toList();
  }

  void _onSearch(String _) => setState(_rebuildFiltered);

  void _select(RegulationModel reg) {
    setState(() {
      _selected = reg;
      _newNameController.clear();
      _createError = null;
    });
  }

  void _confirm() {
    if (_selected != null) Navigator.of(context).pop(_selected);
  }

  Future<void> _removeRecent(RegulationModel reg) async {
    if (reg.regulationId == null) return;
    await _RegulationLocalCache.removeRecentId(reg.regulationId!);
    setState(() {
      _recentIds.remove(reg.regulationId);
      if (_selected != null &&
          (reg.regulationId != null
              ? _selected!.regulationId == reg.regulationId
              : _selected!.regulationName == reg.regulationName))
        _selected = null;
      _rebuildFiltered();
    });
  }

  Future<void> _clearAllRecent() async {
    await _RegulationLocalCache.clearRecentIds();
    setState(() {
      _recentIds.clear();
      _rebuildFiltered();
    });
  }

  Future<void> _submitCreate() async {
    final name = _newNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _createError = 'Regulation name is required');
      return;
    }
    setState(() => _createError = null);
    try {
      final created = await widget.systemProvider.createRegulation(name);
      if (!mounted) return;
      if (created == null) {
        setState(() => _createError = 'Failed to create regulation');
        return;
      }
      await _RegulationLocalCache.saveList(widget.systemProvider.regulations);
      Navigator.of(context).pop(created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _createError = 'Failed to create: ${e.toString()}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UI helpers
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 14, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline — showing cached data',
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: _loadData,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 13, color: Colors.orange.shade700),
                const SizedBox(width: 2),
                Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedBanner(Color primary) {
    if (_selected == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 14, color: primary),
          const SizedBox(width: 8),
          Text(
            'Selected: ',
            style: TextStyle(color: primary.withOpacity(0.6), fontSize: 12),
          ),
          Expanded(
            child: Text(
              _selected!.regulationName ?? '-',
              style: TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabWithBadge(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegulationList(
      List<RegulationModel> items, {
        bool allowDelete = false,
        String emptyMessage = 'No regulations found',
        IconData emptyIcon = Icons.search_off,
      }) {
    final primary = Theme.of(context).colorScheme.primary;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 32, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              emptyMessage,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allowDelete && _filteredRecent.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
            child: Row(
              children: [
                Text(
                  '${items.length} regulation${items.length == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _clearAllRecent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        size: 14,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Clear all',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemExtent: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemBuilder: (context, index) {
              final reg = items[index];
              final isSelected =
                  _selected != null &&
                      (reg.regulationId != null
                          ? _selected!.regulationId == reg.regulationId
                          : _selected!.regulationName == reg.regulationName);

              return InkWell(
                onTap: () => _select(reg),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? primary.withOpacity(0.07) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    // Border only on selected
                    border:
                    isSelected
                        ? Border.all(color: primary, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reg.regulationName ?? '-',
                          style: TextStyle(
                            color: isSelected ? primary : Colors.grey.shade800,
                            fontWeight:
                            isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tick icon only on selected; delete icon on recent unselected
                      if (isSelected)
                        Icon(Icons.check_circle, size: 20, color: primary)
                      else if (allowDelete)
                        GestureDetector(
                          onTap: () => _removeRecent(reg),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateTab(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ListenableBuilder(
      listenable: widget.systemProvider,
      builder: (context, _) {
        final isCreating = widget.systemProvider.isLoading;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primary.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Create a new regulation and it will be saved to the system.',
                        style: TextStyle(
                          color: primary.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel('Regulation Name *', primary),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _newNameController,
                hint: 'e.g. DOSH ACT 1994',
                icon: Icons.gavel_outlined,
                onChanged: (_) => setState(() => _createError = null),
                textCapitalization: TextCapitalization.words,
              ),
              if (_createError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _createError!,
                  style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isCreating ? null : _submitCreate,
                  icon:
                  isCreating
                      ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.add, size: 16),
                  label: Text(isCreating ? 'Creating…' : 'Create Regulation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primary.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fieldLabel(String text, Color primary) => Text(
    text,
    style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600),
  );

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: primary.withOpacity(0.35), fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: primary.withOpacity(0.45)),
        filled: true,
        fillColor: primary.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
      style: TextStyle(color: primary, fontSize: 13),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
              child: Row(
                children: [
                  Icon(Icons.gavel_outlined, color: primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select Regulation',
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: primary.withOpacity(0.6)),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // ── Offline banner ─────────────────────────────────────────────
            if (_isOffline) _buildOfflineBanner(),

            // ── Search bar (hidden on Create tab) ──────────────────────────
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                final isCreateTab = _tabController.index == 2;
                return AnimatedCrossFade(
                  firstChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search regulations…',
                        hintStyle: TextStyle(
                          color: primary.withOpacity(0.4),
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primary.withOpacity(0.5),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: primary.withOpacity(0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: primary.withOpacity(0.15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: primary.withOpacity(0.15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      style: TextStyle(color: primary, fontSize: 13),
                    ),
                  ),
                  secondChild: const SizedBox(height: 12),
                  crossFadeState:
                  isCreateTab
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                );
              },
            ),

            // ── Tabs ────────────────────────────────────────────────────────
            const SizedBox(height: 8),
            Theme(
              data: Theme.of(context).copyWith(
                tabBarTheme: TabBarThemeData(
                  indicator: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: primary.withOpacity(0.6),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    _tabWithBadge('All', _filteredAll.length),
                    _tabWithBadge('Recent', _filteredRecent.length),
                    const Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14),
                          SizedBox(width: 4),
                          Text('New', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Tab content ─────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRegulationList(
                    _filteredAll,
                    emptyIcon: Icons.rule_outlined,
                    emptyMessage:
                    _searchController.text.isEmpty
                        ? 'No regulations available'
                        : 'No matches for "${_searchController.text}"',
                  ),
                  _buildRegulationList(
                    _filteredRecent,
                    allowDelete: true,
                    emptyIcon: Icons.history,
                    emptyMessage:
                    _searchController.text.isEmpty
                        ? 'No recently used regulations'
                        : 'No matches for "${_searchController.text}"',
                  ),
                  _buildCreateTab(context),
                ],
              ),
            ),

            // ── Selected banner + Confirm / Cancel (hidden on Create tab) ───
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                if (_tabController.index == 2) return const SizedBox.shrink();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSelectedBanner(primary),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: primary.withOpacity(0.6)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _selected != null ? _confirm : null,
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: primary.withOpacity(
                                0.25,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
