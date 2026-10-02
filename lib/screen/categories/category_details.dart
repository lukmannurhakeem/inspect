import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class FileItem {
  final String name;
  final String path;
  final DateTime dateAdded;
  final int size;

  FileItem({
    required this.name,
    required this.path,
    required this.dateAdded,
    required this.size,
  });
}

class RegulationItem {
  final String id;
  final String name;

  RegulationItem({required this.id, required this.name});
}

class ChecklistItem {
  final String id;
  final String name;
  final String title;
  final bool archived;

  ChecklistItem({
    required this.id,
    required this.name,
    required this.title,
    required this.archived,
  });
}

class PlannedMaintenanceItem {
  final String id;
  final String reportType;
  final int frequency;

  PlannedMaintenanceItem({
    required this.id,
    required this.reportType,
    required this.frequency,
  });
}

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails>
    with SingleTickerProviderStateMixin {
  static const _tabs = [
    'Overview',
    'Custom Fields',
    'Files',
    'Regulation',
    'Checklist',
    'Planned Maintenance',
  ];

  late final TabController _tabController;
  CategoryItem? _category;

  List<Map<String, dynamic>> _fields = [];
  bool _isLoadingFields = false;

  final List<FileItem> _files = [];
  bool _isUploading = false;

  final List<RegulationItem> _regulations = [];
  final _regulationController = TextEditingController();

  final List<ChecklistItem> _checklists = [];
  final _checklistNameController = TextEditingController();
  final _checklistTitleController = TextEditingController();
  bool _checklistArchived = false;

  final List<PlannedMaintenanceItem> _maintenances = [];
  String? _selectedReportType;
  final _frequencyController = TextEditingController(text: '0');

  Color get _primary => context.colors.primary;
  TextTheme get _text => context.topology.textTheme;
  Color _tint(double opacity) => _primary.withValues(alpha: opacity);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CategoryItem) {
        setState(() => _category = args);
        _loadFields();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _regulationController.dispose();
    _checklistNameController.dispose();
    _checklistTitleController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _loadFields() async {
    final category = _category;
    if (category == null) return;

    setState(() => _isLoadingFields = true);

    try {
      final provider = context.read<CategoryProvider>();
      await provider.loadFieldsFromLocalStorage(category.id);
      if (!mounted) return;
      setState(() => _fields = provider.getFieldsAsJson());
    } catch (_) {
      if (mounted) setState(() => _fields = []);
    } finally {
      if (mounted) setState(() => _isLoadingFields = false);
    }
  }

  void _snack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = _category;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category?.name ?? 'Category Details',
          style: _text.titleSmall?.copyWith(color: _primary),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: _primary),
        backgroundColor: context.colors.onPrimary,
        leading: IconButton(
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: category == null
          ? _EmptyState(
        icon: Icons.category_outlined,
        message: 'No category data found',
      )
          : Padding(
        padding: context.paddingHorizontal,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [for (final t in _tabs) Tab(text: t)],
              labelColor: _primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _primary,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(category),
                  _buildFieldsTab(),
                  _buildFilesTab(),
                  _buildRegulationTab(),
                  _buildChecklistTab(),
                  _buildMaintenanceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(CategoryItem category) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _SectionCard(
          icon: Icons.info_outline,
          title: 'Category Information',
          child: Column(
            children: [
              _InfoRow('Category Name', category.name),
              if (category.categoryCode != null)
                _InfoRow('Category Code', category.categoryCode!),
              _InfoRow('Category ID', category.id),
              if (category.description != null)
                _InfoRow('Description', category.description!),
              _InfoRow(
                'Can Have Child Items',
                category.canHaveChildItems ? 'Yes' : 'No',
              ),
              if (category.parentId != null)
                _InfoRow('Parent ID', category.parentId!),
              _InfoRow('Custom Fields', '${_fields.length} fields'),
            ],
          ),
        ),
        if (category.children.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.account_tree_outlined,
            title: 'Child Categories (${category.children.length})',
            child: Column(
              children: [
                for (final child in category.children)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: _tint(0.1),
                      child: Icon(
                        Icons.subdirectory_arrow_right,
                        color: _primary,
                      ),
                    ),
                    title: Text(
                      child.name,
                      style: _text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _primary,
                      ),
                    ),
                    subtitle: child.categoryCode == null
                        ? null
                        : Text(
                      'Code: ${child.categoryCode}',
                      style: _text.bodySmall?.copyWith(
                        color: _tint(0.7),
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: _primary),
                    onTap: () => NavigationService().navigateTo(
                      NavigationRoutes.categoryDetails,
                      arguments: child,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFieldsTab() {
    if (_isLoadingFields) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_fields.isEmpty) {
      return _EmptyState(
        icon: Icons.table_chart_outlined,
        message: 'No custom fields configured',
      );
    }

    final groups = _groupFields();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        for (final entry in groups.entries) ...[
          _SectionCard(
            icon: _sectionIcon(entry.key),
            title: entry.key,
            trailing: Chip(
              label: Text('${entry.value.length}'),
              labelStyle: _text.bodySmall?.copyWith(color: _primary),
              backgroundColor: _tint(0.1),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
            child: Column(
              children: [for (final f in entry.value) _buildFieldTile(f)],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildFieldTile(Map<String, dynamic> field) {
    final label = field['labelText'] as String;
    final name = field['name'] as String;
    final type = field['fieldType'] as String;
    final defaultValue = field['defaultValue'] as String? ?? '';
    final required = field['required'] as bool? ?? false;
    final archived = field['isArchived'] as bool? ?? false;
    final permissions = field['permissions'] as Map<String, dynamic>? ?? {};

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: archived ? Colors.grey.withValues(alpha: 0.1) : _tint(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _tint(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_fieldIcon(type), size: 18, color: _tint(0.7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: _text.bodyMedium?.copyWith(
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (required) const _Badge('Required', Colors.red),
              if (archived) ...[
                const SizedBox(width: 6),
                const _Badge('Archived', Colors.grey),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: _text.bodySmall?.copyWith(
              color: _tint(0.6),
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Badge(type, _fieldColor(type)),
              if (defaultValue.isNotEmpty)
                Text(
                  'Default: $defaultValue',
                  style: _text.bodySmall?.copyWith(color: _primary),
                ),
              if (permissions['create'] != null)
                _PermissionLabel(
                  Icons.edit,
                  'Create: ${permissions['create']}',
                ),
              if (permissions['view'] != null)
                _PermissionLabel(
                  Icons.visibility,
                  'View: ${permissions['view']}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupFields() {
    const basicTypes = {
      'ItemNo',
      'ItemDescription',
      'Customer',
      'SiteID',
      'ItemCategory',
    };
    const locationTypes = {'ItemLocation', 'DetailedLocation'};

    final grouped = <String, List<Map<String, dynamic>>>{
      'Basic Information': [],
      'Location Details': [],
      'Manufacturer Information': [],
      'Other': [],
    };

    for (final field in _fields) {
      final type = field['fieldType'] as String;
      final label = (field['labelText'] as String).toLowerCase();

      final key = basicTypes.contains(type) || label.contains('description')
          ? 'Basic Information'
          : locationTypes.contains(type) || label.contains('location')
          ? 'Location Details'
          : label.contains('manufacture')
          ? 'Manufacturer Information'
          : 'Other';

      grouped[key]!.add(field);
    }

    grouped.removeWhere((_, v) => v.isEmpty);
    return grouped;
  }

  IconData _sectionIcon(String section) {
    switch (section) {
      case 'Location Details':
        return Icons.location_on_outlined;
      case 'Manufacturer Information':
        return Icons.factory_outlined;
      case 'Other':
        return Icons.extension_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _fieldColor(String type) {
    switch (type) {
      case 'Text':
      case 'Multi-Line Textbox':
        return Colors.blue;
      case 'Numeric':
      case 'Decimal':
        return Colors.green;
      case 'Date':
        return Colors.orange;
      case 'Boolean':
        return Colors.purple;
      case 'Dropdown':
      case 'Override Dropdown':
      case 'Conditional Dropdown':
      case 'Site Dropdown':
        return Colors.teal;
      case 'File':
        return Colors.red;
      default:
        return _primary;
    }
  }

  IconData _fieldIcon(String type) {
    switch (type) {
      case 'Text':
      case 'Multi-Line Textbox':
        return Icons.text_fields;
      case 'Numeric':
      case 'Decimal':
        return Icons.pin;
      case 'Date':
        return Icons.calendar_today;
      case 'Boolean':
        return Icons.check_box_outlined;
      case 'Dropdown':
      case 'Override Dropdown':
      case 'Conditional Dropdown':
      case 'Site Dropdown':
        return Icons.arrow_drop_down_circle;
      case 'File':
        return Icons.attach_file;
      case 'Signature':
        return Icons.edit;
      case 'Colour Picker':
        return Icons.palette;
      case 'ItemNo':
        return Icons.tag;
      case 'ItemDescription':
        return Icons.description;
      case 'Customer':
        return Icons.person;
      case 'SiteID':
        return Icons.location_city;
      case 'ItemCategory':
        return Icons.category;
      case 'ItemLocation':
        return Icons.place;
      case 'DetailedLocation':
        return Icons.my_location;
      case 'RFIDNo':
        return Icons.nfc;
      case 'LatestPhoto':
        return Icons.photo_camera;
      default:
        return Icons.input;
    }
  }

  Widget _buildFilesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: _tint(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: _tint(0.05),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 40, color: _primary),
                const SizedBox(height: 8),
                Text(
                  'Select files to upload for this category',
                  style: _text.bodyMedium?.copyWith(
                    color: context.colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 12),
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.add),
                  label: const Text('Choose Files'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploaded Files (${_files.length})',
                style: _text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
              if (_files.isNotEmpty)
                TextButton.icon(
                  onPressed: _confirmClearFiles,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _files.isEmpty
                ? _EmptyState(
              icon: Icons.folder_open,
              message: 'No files uploaded yet',
            )
                : ListView.separated(
              itemCount: _files.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _buildFileTile(_files[i], i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTile(FileItem file, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: _tint(0.1),
        child: Icon(_fileIcon(file.name), color: _primary, size: 20),
      ),
      title: Text(
        file.name,
        style: _text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_formatSize(file.size)} • ${_formatDate(file.dateAdded)}',
        style: _text.bodySmall?.copyWith(
          color: context.colors.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: IconButton(
        onPressed: () => _confirmDeleteFile(index),
        icon: const Icon(Icons.delete_outline),
        color: Colors.red,
        tooltip: 'Delete File',
      ),
    );
  }

  IconData _fileIcon(String fileName) {
    switch (fileName.split('.').last.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> _pickFiles() async {
    setState(() => _isUploading = true);

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result == null) return;

      final added = result.files.where((f) => f.path != null).map(
            (f) => FileItem(
          name: f.name,
          path: f.path!,
          dateAdded: DateTime.now(),
          size: f.size,
        ),
      );

      setState(() => _files.addAll(added));
      if (mounted) {
        _snack('Successfully uploaded ${added.length} file(s)', success: true);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<bool> _confirm(String title, String message, String action) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(action),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _confirmDeleteFile(int index) async {
    final ok = await _confirm(
      'Delete File',
      'Are you sure you want to delete "${_files[index].name}"?',
      'Delete',
    );
    if (ok && mounted) setState(() => _files.removeAt(index));
  }

  Future<void> _confirmClearFiles() async {
    final ok = await _confirm(
      'Clear All Files',
      'Are you sure you want to delete all files?',
      'Clear All',
    );
    if (ok && mounted) setState(_files.clear);
  }

  Widget _buildRegulationTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _SectionCard(
          icon: Icons.gavel_outlined,
          title: 'Add Regulation',
          child: Column(
            children: [
              CommonTextField(
                controller: _regulationController,
                hintText: 'Enter regulation name',
                style: _text.bodySmall?.copyWith(color: _primary),
              ),
              const SizedBox(height: 16),
              CommonButton(text: 'Save Regulation', onPressed: _saveRegulation),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _ListHeader('Regulations (${_regulations.length})'),
        if (_regulations.isEmpty)
          const _InlineEmpty('No regulations added yet')
        else
          for (var i = 0; i < _regulations.length; i++)
            Card(
              child: ListTile(
                title: Text(_regulations[i].name),
                trailing: _deleteButton(
                      () => setState(() => _regulations.removeAt(i)),
                ),
              ),
            ),
      ],
    );
  }

  void _saveRegulation() {
    final name = _regulationController.text.trim();
    if (name.isEmpty) return _snack('Please enter a regulation name');

    setState(() {
      _regulations.add(
        RegulationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
        ),
      );
      _regulationController.clear();
    });
    _snack('Regulation saved successfully', success: true);
  }

  Widget _buildChecklistTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _SectionCard(
          icon: Icons.checklist,
          title: 'Add Checklist',
          child: Column(
            children: [
              CommonTextField(
                controller: _checklistNameController,
                hintText: 'Name',
                style: _text.bodySmall?.copyWith(color: _primary),
              ),
              const SizedBox(height: 12),
              CommonTextField(
                controller: _checklistTitleController,
                hintText: 'Title',
                style: _text.bodySmall?.copyWith(color: _primary),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Archived'),
                value: _checklistArchived,
                onChanged: (v) =>
                    setState(() => _checklistArchived = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              CommonButton(text: 'Save Checklist', onPressed: _saveChecklist),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _ListHeader('Checklists (${_checklists.length})'),
        if (_checklists.isEmpty)
          const _InlineEmpty('No checklists added yet')
        else
          for (var i = 0; i < _checklists.length; i++)
            Card(
              child: ListTile(
                title: Text(
                  _checklists[i].name,
                  style: _text.titleSmall?.copyWith(color: _primary),
                ),
                subtitle: Text(
                  'Title: ${_checklists[i].title}',
                  style: _text.bodySmall?.copyWith(color: _primary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_checklists[i].archived)
                      const _Badge('Archived', Colors.grey),
                    _deleteButton(
                          () => setState(() => _checklists.removeAt(i)),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  void _saveChecklist() {
    final name = _checklistNameController.text.trim();
    final title = _checklistTitleController.text.trim();
    if (name.isEmpty || title.isEmpty) {
      return _snack('Please fill in all fields');
    }

    setState(() {
      _checklists.add(
        ChecklistItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          title: title,
          archived: _checklistArchived,
        ),
      );
      _checklistNameController.clear();
      _checklistTitleController.clear();
      _checklistArchived = false;
    });
    _snack('Checklist saved successfully', success: true);
  }

  Widget _buildMaintenanceTab() {
    return Consumer<SystemProvider>(
      builder: (context, system, _) {
        if (!system.hasReport && !system.isLoading && !system.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) system.fetchReportType();
          });
        }

        final reportTypes = system.getReportTypeModel?.data ?? [];

        String reportName(String id) {
          for (final r in reportTypes) {
            if (r.reportType?.reportTypeId == id) {
              return r.reportType?.reportName ?? id;
            }
          }
          return id;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _SectionCard(
              icon: Icons.build_outlined,
              title: 'Add Planned Maintenance',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (system.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (system.hasError)
                    Text(
                      'Error: ${system.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    )
                  else if (reportTypes.isEmpty)
                      const _InlineEmpty('No report types available')
                    else
                      CommonDropdown<String>(
                        label: 'Report Type',
                        textStyle: _text.titleSmall?.copyWith(color: _primary),
                        value: _selectedReportType,
                        items: [
                          for (final r in reportTypes)
                            DropdownMenuItem(
                              value: r.reportType?.reportTypeId,
                              child: Text(
                                r.reportType?.reportName ?? 'Unnamed Report',
                                style: _text.bodySmall?.copyWith(
                                  color: _primary,
                                ),
                              ),
                            ),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedReportType = v),
                      ),
                  const SizedBox(height: 16),
                  Text(
                    'Frequency',
                    style: _text.bodyMedium?.copyWith(
                      color: _primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStepper(),
                  const SizedBox(height: 16),
                  CommonButton(
                    text: 'Save Maintenance',
                    onPressed: _saveMaintenance,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _ListHeader('Planned Maintenances (${_maintenances.length})'),
            if (_maintenances.isEmpty)
              const _InlineEmpty('No planned maintenances added yet')
            else
              for (var i = 0; i < _maintenances.length; i++)
                Card(
                  child: ListTile(
                    title: Text(reportName(_maintenances[i].reportType)),
                    subtitle: Text('Frequency: ${_maintenances[i].frequency}'),
                    trailing: _deleteButton(
                          () => setState(() => _maintenances.removeAt(i)),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _buildStepper() {
    void step(int delta) {
      final current = int.tryParse(_frequencyController.text) ?? 0;
      final next = current + delta;
      if (next >= 0) _frequencyController.text = next.toString();
    }

    final style = IconButton.styleFrom(
      backgroundColor: _tint(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(8),
    );

    return Row(
      children: [
        IconButton(
          onPressed: () => step(-1),
          icon: const Icon(Icons.remove, size: 18),
          style: style,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextField(
            controller: _frequencyController,
            keyboardType: TextInputType.number,
            style: _text.bodySmall?.copyWith(color: _primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => step(1),
          icon: const Icon(Icons.add, size: 18),
          style: style,
        ),
      ],
    );
  }

  void _saveMaintenance() {
    final reportType = _selectedReportType;
    if (reportType == null) return _snack('Please select a report type');

    final frequency = int.tryParse(_frequencyController.text) ?? 0;
    if (frequency <= 0) return _snack('Frequency must be greater than 0');

    setState(() {
      _maintenances.add(
        PlannedMaintenanceItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          reportType: reportType,
          frequency: frequency,
        ),
      );
      _selectedReportType = null;
      _frequencyController.text = '0';
    });
    _snack('Planned maintenance saved successfully', success: true);
  }

  Widget _deleteButton(VoidCallback onPressed) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      onPressed: onPressed,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: context.topology.textTheme.titleMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final text = context.topology.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: primary.withValues(alpha: 0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.bodyMedium?.copyWith(color: primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.topology.textTheme.bodySmall?.copyWith(
          color: color == Colors.grey ? Colors.grey.shade700 : color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PermissionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PermissionLabel(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary.withValues(alpha: 0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ListHeader extends StatelessWidget {
  final String title;

  const _ListHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: context.topology.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String message;

  const _InlineEmpty(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: context.colors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}