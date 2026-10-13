import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/picker_storage_service.dart';
import 'package:inspect/screen/job/job_item_create/job_form_style.dart';

Future<void> showApplicableCodeDialog({
  required BuildContext context,
  required TextEditingController controller,
  required List<String> codes,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => ApplicableCodeDialog(controller: controller, codes: codes),
  );
}

class ApplicableCodeDialog extends StatefulWidget {
  const ApplicableCodeDialog({
    super.key,
    required this.controller,
    required this.codes,
  });

  final TextEditingController controller;
  final List<String> codes;

  @override
  State<ApplicableCodeDialog> createState() => _ApplicableCodeDialogState();
}

class _ApplicableCodeDialogState extends State<ApplicableCodeDialog>
    with SingleTickerProviderStateMixin {
  static const _storageKey = PickerStorageKey.applicableCode;

  late final _tabs = TabController(length: 3, vsync: this);
  final _search = TextEditingController();
  final _custom = TextEditingController();

  List<String> _saved = [];
  bool _isLoading = true;
  String? _selected;

  String get _query => _search.text.toLowerCase().trim();

  List<String> _filter(Iterable<String> items) =>
      _query.isEmpty
          ? items.toList()
          : items.where((c) => c.toLowerCase().contains(_query)).toList();

  List<String> get _predefined => _filter(widget.codes);

  List<String> get _recent => _filter(_saved);

  List<String> get _all =>
      _filter(
        {...widget.codes, ..._saved}.toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
      );

  bool get _canConfirm => _custom.text.trim().isNotEmpty || _selected != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.controller.text;
    if (widget.codes.contains(initial)) {
      _selected = initial;
    } else {
      _custom.text = initial;
    }
    _search.addListener(() => setState(() {}));
    _loadSaved();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    _custom.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final saved = await PickerStorageService.getAll(_storageKey);
    if (!mounted) return;

    final predefined = widget.codes.map((c) => c.toLowerCase()).toSet();
    setState(() {
      _saved = saved.where((s) => !predefined.contains(s.toLowerCase())).toList();
      _isLoading = false;

      final initial = widget.controller.text;
      final match = _saved.indexWhere(
        (s) => s.toLowerCase() == initial.toLowerCase(),
      );
      if (initial.isNotEmpty && !widget.codes.contains(initial) && match != -1) {
        _selected = _saved[match];
        _custom.clear();
        _tabs.animateTo(1);
      } else if (_saved.isNotEmpty && widget.codes.isEmpty) {
        _tabs.animateTo(1);
      }
    });
  }

  void _confirm() {
    final custom = _custom.text.trim();
    final value = custom.isNotEmpty ? custom : _selected!;
    widget.controller.text = value;
    if (custom.isNotEmpty || _saved.contains(value)) {
      PickerStorageService.add(_storageKey, value);
    }
    Navigator.of(context).pop();
  }

  Future<void> _delete(String code) async {
    await PickerStorageService.remove(_storageKey, code);
    setState(() {
      _saved.remove(code);
      if (_selected == code) _selected = null;
    });
  }

  Future<void> _clearAll() async {
    await PickerStorageService.clearKey(_storageKey);
    setState(() {
      _saved.clear();
      if (_selected != null && !widget.codes.contains(_selected)) {
        _selected = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAny = widget.codes.isNotEmpty || _saved.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Column(
          children: [
            _buildHeader(context),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.colors.primary,
                    strokeWidth: 2,
                  ),
                ),
              )
            else ...[
              if (hasAny) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _search,
                    decoration: _decoration(
                      context,
                      hint: 'Search...',
                      icon: Icons.search,
                    ),
                    style: TextStyle(color: context.colors.primary, fontSize: 13),
                  ),
                ),
                _buildTabBar(context),
                SizedBox(
                  height: 240,
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _buildList(
                        context,
                        items: _predefined,
                        isSaved: false,
                        emptyIcon: Icons.category_outlined,
                        emptyText: _emptyText('No predefined codes'),
                      ),
                      _buildList(
                        context,
                        items: _recent,
                        isSaved: true,
                        emptyIcon: Icons.history,
                        emptyText: _emptyText('No recently used codes'),
                        showClear: _saved.isNotEmpty,
                      ),
                      _buildList(
                        context,
                        items: _all,
                        isSaved: false,
                        emptyIcon: Icons.search_off,
                        emptyText: _emptyText('No codes'),
                      ),
                    ],
                  ),
                ),
              ],
              _buildDivider(context, hasAny ? 'or type your own' : 'Enter value'),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _custom,
                  onChanged:
                      (v) => setState(() {
                        if (v.isNotEmpty) _selected = null;
                      }),
                  onSubmitted: (_) => _canConfirm ? _confirm() : null,
                  decoration: _decoration(
                    context,
                    hint: hasAny ? 'Type a custom value…' : 'Enter value…',
                    icon: Icons.edit_location_alt_outlined,
                  ),
                  style: TextStyle(color: context.colors.primary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
              _buildActions(context),
            ],
          ],
        ),
      ),
    );
  }

  String _emptyText(String fallback) =>
      _search.text.isEmpty ? fallback : 'No matches for "${_search.text}"';

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
      child: Row(
        children: [
          Icon(Icons.gavel_outlined, color: context.colors.primary, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Select Applicable Code',
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
    );
  }

  Widget _buildDivider(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.tint(0.2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.tint(0.45),
                fontSize: 11,
              ),
            ),
          ),
          Expanded(child: Divider(color: context.tint(0.2))),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: context.tint(0.7))),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _custom,
            builder:
                (_, __, ___) => ElevatedButton.icon(
                  onPressed: _canConfirm ? _confirm : null,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: context.tint(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.tint(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabs,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: context.tint(0.6),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: [
          _tab('Predefined', _predefined.length),
          _tab('Recent', _recent.length),
          _tab('All', _all.length),
        ],
      ),
    );
  }

  Tab _tab(String label, int count) {
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
              color: Colors.white.withValues(alpha: 0.25),
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

  Widget _buildList(
    BuildContext context, {
    required List<String> items,
    required bool isSaved,
    required IconData emptyIcon,
    required String emptyText,
    bool showClear = false,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 32, color: context.tint(0.2)),
            const SizedBox(height: 8),
            Text(
              emptyText,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.tint(0.4),
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
        if (showClear)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
            child: Row(
              children: [
                Text(
                  '${items.length} ${items.length == 1 ? 'code' : 'codes'}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.tint(0.45),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _clearAll,
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
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemExtent: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemBuilder: (_, index) => _buildTile(context, items[index], isSaved),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, String code, bool isSaved) {
    final primary = context.colors.primary;
    final isSelected = _selected == code;

    return Material(
      color: isSelected ? context.tint(0.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap:
            () => setState(() {
              _selected = code;
              _custom.clear();
            }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle_outline : Icons.tag,
                size: 18,
                color: isSelected ? primary : context.tint(0.4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  code,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: primary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isSaved && _saved.contains(code)) _buildBadge(context),
              if (isSelected) Icon(Icons.check_circle, color: primary, size: 18),
              if (isSaved)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _delete(code),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.close, size: 16, color: context.tint(0.35)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: context.tint(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'recent',
        style: TextStyle(
          fontSize: 9,
          color: context.tint(0.6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _decoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: context.tint(0.3)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.tint(0.4), fontSize: 13),
      prefixIcon: Icon(icon, color: context.tint(0.5), size: 20),
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
