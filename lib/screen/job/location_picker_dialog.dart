import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/picker_storage_service.dart';

// ── Public helper ─────────────────────────────────────────────────────────────

/// Shows the [LocationPickerDialog] and writes the confirmed value back into
/// [controller].
///
/// [storageKey] controls which MRU list is loaded/saved.
/// Use the constants in [PickerStorageKey] — defaults to [PickerStorageKey.itemLocation].
///
/// [dialogTitle] overrides the header title (default: "Select Location").
Future<void> showLocationPickerDialog({
  required BuildContext context,
  required TextEditingController controller,
  List<String> fieldDefinedLocations = const [],
  String storageKey = PickerStorageKey.itemLocation,
  String dialogTitle = 'Select Location',
  String emptyHint = 'Select or enter location',
}) async {
  await showDialog<void>(
    context: context,
    builder:
        (_) => LocationPickerDialog(
      fieldDefinedLocations: fieldDefinedLocations,
      initialValue: controller.text,
      storageKey: storageKey,
      dialogTitle: dialogTitle,
      emptyHint: emptyHint,
      onConfirm: (value, isCustom) async {
        controller.text = value;
        if (isCustom) {
          await PickerStorageService.add(storageKey, value);
        }
      },
    ),
  );
}

// ── Dialog widget ─────────────────────────────────────────────────────────────

class LocationPickerDialog extends StatefulWidget {
  final List<String> fieldDefinedLocations;
  final String initialValue;
  final String storageKey;
  final String dialogTitle;
  final String emptyHint;
  final void Function(String value, bool isCustom) onConfirm;

  const LocationPickerDialog({
    super.key,
    this.fieldDefinedLocations = const [],
    required this.initialValue,
    this.storageKey = PickerStorageKey.itemLocation,
    this.dialogTitle = 'Select Location',
    this.emptyHint = 'Select or enter location',
    required this.onConfirm,
  });

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog>
    with SingleTickerProviderStateMixin {
  // ── controllers ────────────────────────────────────────────────────────────
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customController = TextEditingController();

  // ── data ───────────────────────────────────────────────────────────────────
  List<String> _savedLocations = [];
  bool _isLoading = true;

  List<String> _filteredField = [];
  List<String> _filteredSaved = [];
  List<String> _filteredAll = [];

  String? _selected;

  static const double _listHeight = 240.0;
  static const double _itemHeight = 48.0;

  bool get _isCodePicker =>
      widget.storageKey == PickerStorageKey.applicableCode;

  IconData get _dialogIcon =>
      _isCodePicker ? Icons.gavel_outlined : Icons.location_on_outlined;

  IconData get _itemIconSelected =>
      _isCodePicker ? Icons.check_circle_outline : Icons.location_on;

  IconData get _itemIconUnselected =>
      _isCodePicker ? Icons.tag : Icons.location_on_outlined;

  String get _itemNoun => _isCodePicker ? 'code' : 'location';

  String get _itemNounPlural => _isCodePicker ? 'codes' : 'locations';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredField = List.from(widget.fieldDefinedLocations);

    if (widget.initialValue.isNotEmpty &&
        widget.fieldDefinedLocations.contains(widget.initialValue)) {
      _selected = widget.initialValue;
    } else if (widget.initialValue.isNotEmpty) {
      _customController.text = widget.initialValue;
    }

    _searchController.addListener(_onSearch);
    _loadSavedLocations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    _customController.dispose();
    super.dispose();
  }

  // ── data ───────────────────────────────────────────────────────────────────

  Future<void> _loadSavedLocations() async {
    final saved = await PickerStorageService.getAll(widget.storageKey);
    if (!mounted) return;
    setState(() {
      _savedLocations =
          saved
              .where(
                (loc) =>
            !widget.fieldDefinedLocations.any(
                  (f) => f.toLowerCase() == loc.toLowerCase(),
            ),
          )
              .toList();
      _rebuildFiltered(_searchController.text);
      _isLoading = false;

      if (widget.initialValue.isNotEmpty &&
          !widget.fieldDefinedLocations.contains(widget.initialValue)) {
        final idx = _savedLocations.indexWhere(
              (l) => l.toLowerCase() == widget.initialValue.toLowerCase(),
        );
        if (idx != -1) {
          _selected = _savedLocations[idx];
          _customController.clear();
          _tabController.animateTo(1);
        }
      }

      if (_savedLocations.isNotEmpty && widget.fieldDefinedLocations.isEmpty) {
        _tabController.animateTo(1);
      }
    });
  }

  // ── filtering ──────────────────────────────────────────────────────────────

  void _onSearch() => setState(() => _rebuildFiltered(_searchController.text));

  void _rebuildFiltered(String query) {
    final q = query.toLowerCase().trim();
    _filteredField =
    q.isEmpty
        ? List.from(widget.fieldDefinedLocations)
        : widget.fieldDefinedLocations
        .where((l) => l.toLowerCase().contains(q))
        .toList();

    _filteredSaved =
    q.isEmpty
        ? List.from(_savedLocations)
        : _savedLocations
        .where((l) => l.toLowerCase().contains(q))
        .toList();

    final combined =
    <String>{...widget.fieldDefinedLocations, ..._savedLocations}.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    _filteredAll =
    q.isEmpty
        ? combined
        : combined.where((l) => l.toLowerCase().contains(q)).toList();
  }

  // ── selection ──────────────────────────────────────────────────────────────

  void _selectItem(String loc) => setState(() {
    _selected = loc;
    _customController.clear();
  });

  void _onCustomChanged(String value) => setState(() {
    if (value.isNotEmpty) _selected = null;
  });

  bool get _canConfirm =>
      _customController.text.trim().isNotEmpty || _selected != null;

  void _confirm() {
    final custom = _customController.text.trim();
    if (custom.isNotEmpty) {
      widget.onConfirm(custom, true);
    } else if (_selected != null) {
      final fromSaved = _savedLocations.contains(_selected);
      widget.onConfirm(_selected!, fromSaved);
    }
    Navigator.of(context).pop();
  }

  Future<void> _deleteFromSaved(String loc) async {
    await PickerStorageService.remove(widget.storageKey, loc);
    setState(() {
      _savedLocations.remove(loc);
      _rebuildFiltered(_searchController.text);
      if (_selected == loc) _selected = null;
    });
  }

  Future<void> _clearAllSaved() async {
    await PickerStorageService.clearKey(widget.storageKey);
    setState(() {
      _savedLocations.clear();
      _rebuildFiltered(_searchController.text);
      if (_selected != null &&
          !widget.fieldDefinedLocations.contains(_selected)) {
        _selected = null;
      }
    });
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasAnyList =
        widget.fieldDefinedLocations.isNotEmpty || _savedLocations.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
              child: Row(
                children: [
                  Icon(_dialogIcon, color: context.colors.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.dialogTitle,
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 40),
              Center(
                child: CircularProgressIndicator(
                  color: context.colors.primary,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 40),
            ] else ...[
              // ── Search bar ─────────────────────────────────────────────
              if (hasAnyList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: _inputDecoration(
                      context,
                      hint:
                      'Search ${widget.dialogTitle.replaceAll('Select ', '').toLowerCase()}s…',
                      prefixIcon: Icons.search,
                    ),
                    style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),

              // ── TabBar ────────────────────────────────────────────────
              if (hasAnyList) ...[
                const SizedBox(height: 8),
                _buildTabBar(context),
              ],

              // ── Tab content ───────────────────────────────────────────
              if (hasAnyList)
                SizedBox(
                  height: _listHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Predefined
                      _buildLocationList(
                        context,
                        items: _filteredField,
                        isFromSaved: false,
                        emptyIcon: Icons.category_outlined,
                        emptyText:
                        _searchController.text.isEmpty
                            ? 'No predefined $_itemNounPlural'
                            : 'No matches for "${_searchController.text}"',
                      ),
                      // Recent
                      _buildLocationList(
                        context,
                        items: _filteredSaved,
                        isFromSaved: true,
                        emptyIcon: Icons.history,
                        emptyText:
                        _searchController.text.isEmpty
                            ? 'No recently used $_itemNounPlural'
                            : 'No matches for "${_searchController.text}"',
                        headerAction:
                        _savedLocations.isNotEmpty
                            ? _buildClearAllButton(context)
                            : null,
                      ),
                      // All (A-Z)
                      _buildLocationList(
                        context,
                        items: _filteredAll,
                        isFromSaved: false,
                        emptyIcon: Icons.search_off,
                        emptyText: 'No matches for "${_searchController.text}"',
                      ),
                    ],
                  ),
                ),

              // ── Divider ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        hasAnyList
                            ? 'or type your own'
                            : 'Enter ${widget.dialogTitle.replaceAll('Select ', '').toLowerCase()}',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary.withOpacity(0.45),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── Custom input ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _customController,
                  onChanged: _onCustomChanged,
                  onSubmitted: (_) => _canConfirm ? _confirm() : null,
                  decoration: _inputDecoration(
                    context,
                    hint:
                    hasAnyList
                        ? 'Type a custom ${widget.dialogTitle.replaceAll('Select ', '').toLowerCase()}…'
                        : 'Enter ${widget.dialogTitle.replaceAll('Select ', '').toLowerCase()}…',
                    prefixIcon: Icons.edit_location_alt_outlined,
                  ),
                  style: TextStyle(color: context.colors.primary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),

              // ── Action buttons ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: context.colors.primary.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _customController,
                      builder:
                          (_, __, ___) => ElevatedButton.icon(
                        onPressed: _canConfirm ? _confirm : null,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Confirm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: context.colors.primary
                              .withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Tab bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: context.colors.primary.withOpacity(0.6),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: [
          _tabWithBadge(
            'Predefined',
            _filteredField.length,
            total: widget.fieldDefinedLocations.length,
          ),
          _tabWithBadge(
            'Recent',
            _filteredSaved.length,
            total: _savedLocations.length,
          ),
          _tabWithBadge(
            'All',
            _filteredAll.length,
            total: widget.fieldDefinedLocations.length + _savedLocations.length,
          ),
        ],
      ),
    );
  }

  Tab _tabWithBadge(String label, int filtered, {required int total}) {
    final count = _searchController.text.isEmpty ? total : filtered;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Virtualised list ───────────────────────────────────────────────────────

  Widget _buildLocationList(
      BuildContext context, {
        required List<String> items,
        required bool isFromSaved,
        required IconData emptyIcon,
        required String emptyText,
        Widget? headerAction,
      }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 32,
              color: context.colors.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 8),
            Text(
              emptyText,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary.withOpacity(0.4),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (headerAction != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
            child: Row(
              children: [
                Text(
                  '${items.length} ${items.length == 1 ? _itemNoun : _itemNounPlural}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                headerAction,
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemExtent: _itemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemBuilder: (_, index) {
              final loc = items[index];
              final isSelected = _selected == loc;
              final isSavedItem = isFromSaved || _savedLocations.contains(loc);

              return Material(
                color:
                isSelected
                    ? context.colors.primary.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _selectItem(loc),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? _itemIconSelected : _itemIconUnselected,
                          size: 18,
                          color:
                          isSelected
                              ? context.colors.primary
                              : context.colors.primary.withOpacity(0.4),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            loc,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(
                              color: context.colors.primary,
                              fontWeight:
                              isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isFromSaved && _savedLocations.contains(loc))
                          _sourceBadge(context, 'recent'),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: context.colors.primary,
                            size: 18,
                          ),
                        if (isSavedItem && isFromSaved)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _deleteFromSaved(loc),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: context.colors.primary.withOpacity(0.35),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _sourceBadge(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: context.colors.primary.withOpacity(0.6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildClearAllButton(BuildContext context) {
    return TextButton.icon(
      onPressed: _clearAllSaved,
      icon: const Icon(Icons.delete_sweep, size: 13, color: Colors.red),
      label: const Text(
        'Clear all',
        style: TextStyle(color: Colors.red, fontSize: 11),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // ── Input decoration ───────────────────────────────────────────────────────

  InputDecoration _inputDecoration(
      BuildContext context, {
        required String hint,
        required IconData prefixIcon,
      }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: context.colors.primary.withOpacity(0.3)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: context.colors.primary.withOpacity(0.4),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: context.colors.primary.withOpacity(0.5),
        size: 20,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
    );
  }
}
