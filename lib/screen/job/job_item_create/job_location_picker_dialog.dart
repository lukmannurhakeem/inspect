
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/job_location_item_model/job_location_item_model.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:provider/provider.dart';

Future<void> showJobLocationPickerDialog({
  required BuildContext context,
  required TextEditingController controller,
  String jobItemId = '',
}) {
  return showDialog(
    context: context,
    builder:
        (_) => ChangeNotifierProvider.value(
      value: context.read<JobProvider>(),
      child: _JobLocationPickerDialog(
        initialValue: controller.text,
        jobItemId: jobItemId,
        onConfirm: (value) => controller.text = value,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _JobLocationPickerDialog extends StatefulWidget {
  final String initialValue;
  final String jobItemId;
  final ValueChanged<String> onConfirm;

  const _JobLocationPickerDialog({
    required this.initialValue,
    required this.jobItemId,
    required this.onConfirm,
  });

  @override
  State<_JobLocationPickerDialog> createState() =>
      _JobLocationPickerDialogState();
}

class _JobLocationPickerDialogState extends State<_JobLocationPickerDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newCodeController = TextEditingController();

  JobLocationItem? _selected;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobLocations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _newNameController.dispose();
    _newCodeController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_selected == null) return;
    widget.onConfirm(_selected!.displayLabel);
    Navigator.of(context).pop();
  }

  Future<void> _createAndSelect() async {
    final name = _newNameController.text.trim();
    final code = _newCodeController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a location name.')),
      );
      return;
    }

    setState(() => _isCreating = true);

    final created = await context.read<JobProvider>().createJobLocation(
      name: name,
      code: code,
      itemId: widget.jobItemId,
    );

    if (!mounted) return;
    setState(() => _isCreating = false);

    if (created != null) {
      widget.onConfirm(created.displayLabel);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create location. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 660),
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildSelectTab(context), _buildAddTab(context)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: context.colors.primary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Select Location',
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

  // ── Tab bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Select'), Tab(text: 'Add New')],
      ),
    );
  }

  // ── Select tab ─────────────────────────────────────────────────────────────

  Widget _buildSelectTab(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingLocations) {
          return Center(
            child: CircularProgressIndicator(color: context.colors.primary),
          );
        }

        final filtered = provider.searchJobLocations(_searchController.text);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: _inputDeco(
                  context,
                  hint: 'Search locations...',
                  prefixIcon: Icons.search,
                ),
                style: TextStyle(color: context.colors.primary, fontSize: 13),
              ),
            ),
            Expanded(
              child:
              filtered.isEmpty
                  ? _buildEmpty(
                context,
                icon: Icons.location_off_outlined,
                message:
                _searchController.text.isEmpty
                    ? 'No locations yet.\nUse "Add New" to create one.'
                    : 'No matches for "${_searchController.text}"',
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                itemCount: filtered.length,
                itemBuilder:
                    (_, i) =>
                    _buildTile(context, filtered[i], provider),
              ),
            ),
            _buildConfirmBar(context),
          ],
        );
      },
    );
  }

  Widget _buildTile(
      BuildContext context,
      JobLocationItem item,
      JobProvider provider,
      ) {
    final isSel = _selected?.locationId == item.locationId;
    return Material(
      color:
      isSel ? context.colors.primary.withOpacity(0.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => setState(() => _selected = item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                isSel ? Icons.location_on : Icons.location_on_outlined,
                size: 18,
                color:
                isSel
                    ? context.colors.primary
                    : context.colors.primary.withOpacity(0.4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (item.code != null && item.code!.isNotEmpty)
                      Text(
                        item.code!,
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary.withOpacity(0.55),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSel)
                Icon(
                  Icons.check_circle,
                  color: context.colors.primary,
                  size: 18,
                ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final ok = await provider.deleteJobLocation(
                    item.locationId ?? '',
                  );
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to delete location.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  if (_selected?.locationId == item.locationId) {
                    setState(() => _selected = null);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.delete_outline,
                    size: 17,
                    color: Colors.red.withOpacity(0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.primary.withOpacity(0.7)),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _selected != null ? _confirm : null,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: context.colors.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Add New tab ────────────────────────────────────────────────────────────

  Widget _buildAddTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Create a new location',
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            context,
            label: 'Name *',
            controller: _newNameController,
            hint: 'e.g. Warehouse A',
            icon: Icons.label_outline,
          ),
          const SizedBox(height: 12),
          _buildFormField(
            context,
            label: 'Code',
            controller: _newCodeController,
            hint: 'e.g. WH-A',
            icon: Icons.tag,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isCreating ? null : _createAndSelect,
              icon:
              _isCreating
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.add_location_alt, size: 18),
              label: Text(_isCreating ? 'Creating...' : 'Create & Select'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildFormField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
        required String hint,
        required IconData icon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: _inputDeco(context, hint: hint, prefixIcon: icon),
          style: TextStyle(color: context.colors.primary, fontSize: 13),
        ),
      ],
    );
  }

  // ── Shared ─────────────────────────────────────────────────────────────────

  Widget _buildEmpty(
      BuildContext context, {
        required IconData icon,
        required String message,
      }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: context.colors.primary.withOpacity(0.2)),
          const SizedBox(height: 10),
          Text(
            message,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary.withOpacity(0.45),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(
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
