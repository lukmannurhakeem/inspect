import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/picker_storage_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/screen/job/job_item_create/job_location_picker_dialog.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ─────────────────────────────────────────────────────────────────────────────
enum ItemNoCreationMode { singleItem, batchCreation, batchCreationManual }

class BatchItemResult {
  final List<Map<String, dynamic>> items;
  final ItemNoCreationMode mode;

  const BatchItemResult({required this.items, required this.mode});
}

// ─────────────────────────────────────────────────────────────────────────────

/// Field types that map to known static root-level keys in the API payload.
const _staticFieldTypes = <String>{
  'ItemNo',
  'ItemDescription',
  'ItemLocation',
  'DetailedLocation',
  'Location',
  'ApplicableCode',
  'ItemCategory',
  'RFIDNo',
  'Customer',
  'SiteID',
};

class JobItemCreateScreen extends StatefulWidget {
  final String jobId;
  final CategoryItem? selectedCategory;
  final List<Map<String, dynamic>> preloadedFields;
  final bool isEditMode;
  final Map<String, dynamic>? existingItem;

  const JobItemCreateScreen({
    super.key,
    required this.jobId,
    this.selectedCategory,
    this.preloadedFields = const [],
    this.isEditMode = false,
    this.existingItem,
  });

  @override
  State<JobItemCreateScreen> createState() => _JobItemCreateScreenState();
}

class _JobItemCreateScreenState extends State<JobItemCreateScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final Map<String, TextEditingController> _dynamicFieldControllers = {};
  final Map<String, FileUploadController> _fileUploadControllers = {};
  List<Map<String, dynamic>> _customFields = [];
  bool _isLoadingFields = false;

  CategoryItem? _selectedCategory;
  bool _isLoading = false;

  // Item No mode
  ItemNoCreationMode _itemNoMode = ItemNoCreationMode.singleItem;
  final TextEditingController _singleItemNoController = TextEditingController();
  bool _generateItemNo = false;
  final TextEditingController _batchNumberingTemplateController =
      TextEditingController();
  final TextEditingController _batchCreateFromController =
      TextEditingController();
  final TextEditingController _batchCreateToController =
      TextEditingController();
  bool _batchGenerateItemNo = false;
  final TextEditingController _batchNumberToGenerateController =
      TextEditingController();
  final TextEditingController _batchManualItemNoController =
      TextEditingController();
  bool _batchManualGenerateItemNo = false;

  // ── Single exit point ──────────────────────────────────────────────────────
  bool _hasPopped = false;

  void _finishAndPop() {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop();
  }

  // ── initState ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    if (widget.selectedCategory != null) {
      _selectedCategory = widget.selectedCategory;
      _categoryController.text = widget.selectedCategory!.name;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.preloadedFields.isNotEmpty) {
          setState(() {
            _customFields = widget.preloadedFields;
            _initializeDynamicControllers();
          });
          if (widget.isEditMode && widget.existingItem != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _prefillFromExistingItem(widget.existingItem!);
            });
          }
        } else {
          _loadFieldsFromStorage(widget.selectedCategory!.id);
        }
      });
    } else if (widget.isEditMode && widget.existingItem != null) {
      final data = widget.existingItem!;
      final categoryId = _strFromExistingItem(data, [
        'categoryID',
        'categoryId',
        'category_id',
      ]);
      final categoryName = _strFromExistingItem(data, [
        'categoryName',
        'category_name',
      ]);

      if (categoryId.isNotEmpty) {
        _selectedCategory = CategoryItem(
          id: categoryId,
          name: categoryName.isNotEmpty ? categoryName : categoryId,
          children: [],
          level: 0,
        );
        _categoryController.text = _selectedCategory!.name;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _loadFieldsFromStorage(categoryId);
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryProvider>().fetchCategories();
      context.read<JobProvider>().fetchCustomers(context);
      context.read<SiteProvider>().fetchSite(context);
      context.read<JobProvider>().fetchJobLocations();
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _strFromExistingItem(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k]?.toString().trim() ?? '';
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  String _toIsoDateTimeString(String raw) {
    if (raw.isEmpty) return raw;
    if (raw.contains('T')) return raw;
    try {
      DateTime? dt;
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) {
        dt = DateTime.parse(raw);
      } else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(raw)) {
        final parts = raw.split('/');
        dt = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      if (dt != null) {
        return '${dt.toUtc().toIso8601String().split('.').first}Z';
      }
    } catch (_) {}
    return raw;
  }

  String _isoToDisplayDate(String iso) {
    if (iso.isEmpty) return iso;
    if (!iso.contains('T')) return iso;
    try {
      final dt = DateTime.parse(iso).toLocal();
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    } catch (_) {
      return iso;
    }
  }

  String _toCamelCase(String input) {
    if (input.isEmpty) return input;
    final snakeToCamel = input.replaceAllMapped(
      RegExp(r'_([a-zA-Z])'),
      (m) => m.group(1)!.toUpperCase(),
    );
    return snakeToCamel[0].toLowerCase() + snakeToCamel.substring(1);
  }

  // ── Prefill ────────────────────────────────────────────────────────────────

  void _prefillFromExistingItem(Map<String, dynamic> data) {
    debugPrint('🔍 _prefillFromExistingItem keys: ${data.keys.toList()}');

    String v(List<String> keys) {
      for (final k in keys) {
        final val = data[k]?.toString().trim() ?? '';
        if (val.isNotEmpty) return val;
      }
      return '';
    }

    String vItemData(List<String> keys) {
      final itemData = data['itemData'];
      if (itemData is! Map<String, dynamic>) return '';
      for (final k in keys) {
        final val = itemData[k]?.toString().trim() ?? '';
        if (val.isNotEmpty) return val;
      }
      return '';
    }

    final existingItemNo = v(['itemNo', 'item_no', 'ItemNo']);
    if (existingItemNo.isNotEmpty) {
      _singleItemNoController.text = existingItemNo;
    }

    for (var field in _customFields) {
      final fieldId = field['id'] as String;
      final fieldType = field['fieldType'] as String;
      final labelText = (field['labelText'] as String? ?? '').toLowerCase();
      final rawFieldName = field['name'] as String? ?? '';

      if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;
      if (fieldType == 'File') continue;

      final controller = _dynamicFieldControllers[fieldId];
      if (controller == null) continue;

      String value = '';

      switch (fieldType) {
        case 'ItemDescription':
          value = v(['description', 'ItemDescription', 'item_description']);
          break;

        case 'ItemLocation':
        case 'DetailedLocation':
        case 'Location':
          if (!labelText.contains('applicable')) {
            value = v([
              'detailedLocation',
              'detailed_location',
              'ItemLocation',
              'location',
            ]);
          } else {
            value = v(['applicableCode', 'applicable_code', 'ApplicableCode']);
          }
          break;

        case 'ApplicableCode':
          value = v(['applicableCode', 'applicable_code', 'ApplicableCode']);
          break;

        case 'ItemCategory':
          value = v(['categoryName', 'category_name', 'ItemCategory']);
          break;

        case 'RFIDNo':
          value = v(['rfidNo', 'rfid_no', 'RFIDNo']);
          break;

        case 'Customer':
          value = v(['customerName', 'customer_name', 'Customer']);
          break;

        case 'SiteID':
          value = v(['siteName', 'site_name', 'SiteID', 'Site']);
          break;

        case 'Checklist Item':
          if (rawFieldName.isNotEmpty) {
            value = data[rawFieldName]?.toString().trim() ?? '';
            if (value.isEmpty) {
              value = vItemData([rawFieldName, _toCamelCase(rawFieldName)]);
            }
            if (value.isNotEmpty) {
              value = value
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .join(',');
            }
          }
          break;

        case 'Date':
          String raw = '';
          if (labelText.contains('first use') ||
              labelText.contains('inspected')) {
            raw = v(['firstUseDate', 'first_use_date', 'FirstUseDate']);
          } else if (labelText.contains('expiry') ||
              labelText.contains('expiration')) {
            raw = v([
              'expiryDateTimeStamp',
              'expiry_date',
              'ExpiryDate',
              'expiryDate',
            ]);
          } else {
            if (rawFieldName.isNotEmpty) {
              raw = data[rawFieldName]?.toString().trim() ?? '';
              if (raw.isEmpty) {
                raw = vItemData([rawFieldName, _toCamelCase(rawFieldName)]);
              }
            }
          }
          value = _isoToDisplayDate(raw);
          break;

        default:
          if (rawFieldName.isNotEmpty) {
            value = data[rawFieldName]?.toString().trim() ?? '';
          }
          if (value.isEmpty && rawFieldName.isNotEmpty) {
            value = data[_toCamelCase(rawFieldName)]?.toString().trim() ?? '';
          }
          if (value.isEmpty && rawFieldName.isNotEmpty) {
            final lower = rawFieldName.toLowerCase();
            final lowerCamel = _toCamelCase(rawFieldName).toLowerCase();
            for (final entry in data.entries) {
              final lowerKey = entry.key.toLowerCase();
              if (lowerKey == lower || lowerKey == lowerCamel) {
                final candidate = entry.value?.toString().trim() ?? '';
                if (candidate.isNotEmpty) {
                  value = candidate;
                  break;
                }
              }
            }
          }
          if (value.isEmpty) {
            value = vItemData([
              rawFieldName,
              if (rawFieldName.isNotEmpty) _toCamelCase(rawFieldName),
            ]);
          }
          if (value.isEmpty) {
            if (labelText.contains('description')) {
              value = v(['description', 'ItemDescription', 'item_description']);
            } else if (labelText.contains('location') &&
                !labelText.contains('applicable')) {
              value = v([
                'detailedLocation',
                'detailed_location',
                'ItemLocation',
              ]);
            } else if (labelText.contains('applicable')) {
              value = v([
                'applicableCode',
                'applicable_code',
                'ApplicableCode',
              ]);
            } else if (labelText.contains('category')) {
              value = v(['categoryName', 'category_name']);
            } else if (labelText.contains('rfid')) {
              value = v(['rfidNo', 'rfid_no', 'RFIDNo']);
            } else if (labelText.contains('manufacturer')) {
              value = v(['manufacturer', 'Manufacturer']);
            } else if (labelText.contains('swl')) {
              value = v(['swl', 'SWL']);
            } else if (labelText.contains('first use') ||
                labelText.contains('inspected')) {
              final raw = v(['firstUseDate', 'first_use_date', 'FirstUseDate']);
              value = _isoToDisplayDate(raw);
            } else if (labelText.contains('expiry') ||
                labelText.contains('expiration')) {
              final raw = v([
                'expiryDateTimeStamp',
                'expiry_date',
                'ExpiryDate',
                'expiryDate',
              ]);
              value = _isoToDisplayDate(raw);
            } else if (labelText.contains('customer')) {
              value = v(['customerName', 'customer_name']);
            } else if (labelText.contains('site')) {
              value = v(['siteName', 'site_name']);
            } else if (labelText.contains('serial')) {
              value = v(['serialNumber', 'serial_number', 'SerialNumber']);
            }
          }
          break;
      }

      if (value.isNotEmpty) {
        controller.text = value;
        debugPrint('✅ Prefilled "$rawFieldName" [$fieldType] → "$value"');
      }
    }

    setState(() {});
  }

  // ── Field loading ──────────────────────────────────────────────────────────

  Future<void> _loadFieldsFromStorage(String categoryId) async {
    if (!mounted) return;
    setState(() => _isLoadingFields = true);

    try {
      final categoryProvider = context.read<CategoryProvider>();
      bool found = await categoryProvider.loadFieldsFromLocalStorage(
        categoryId,
      );

      if (!found || categoryProvider.getFieldsAsJson().isEmpty) {
        try {
          await categoryProvider.fetchCategories();
          found = await categoryProvider.loadFieldsFromLocalStorage(categoryId);
        } catch (e) {
          debugPrint('⚠️ API fetch failed during field load: $e');
        }
      }

      final fields = categoryProvider.getFieldsAsJson();

      if (mounted) {
        setState(() {
          _customFields = fields;
          _initializeDynamicControllers();
          _isLoadingFields = false;
        });

        if (widget.isEditMode && widget.existingItem != null) {
          _prefillFromExistingItem(widget.existingItem!);
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading fields from storage: $e');
      if (mounted) setState(() => _isLoadingFields = false);
    }
  }

  // ── dispose ────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _categoryController.dispose();
    _singleItemNoController.dispose();
    _batchNumberingTemplateController.dispose();
    _batchCreateFromController.dispose();
    _batchCreateToController.dispose();
    _batchNumberToGenerateController.dispose();
    _batchManualItemNoController.dispose();
    for (final c in _dynamicFieldControllers.values) c.dispose();
    _dynamicFieldControllers.clear();
    for (final c in _fileUploadControllers.values) c.dispose();
    _fileUploadControllers.clear();
    super.dispose();
  }

  void _initializeDynamicControllers() {
    for (final c in _dynamicFieldControllers.values) c.dispose();
    _dynamicFieldControllers.clear();
    for (final c in _fileUploadControllers.values) c.dispose();
    _fileUploadControllers.clear();

    for (var field in _customFields) {
      final fieldId = field['id'] as String;
      final fieldType = field['fieldType'] as String;
      final labelText = (field['labelText'] as String? ?? '').toLowerCase();
      final defaultValue = field['defaultValue'] as String? ?? '';

      if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;

      if (fieldType == 'File') {
        _fileUploadControllers[fieldId] = FileUploadController();
      } else {
        _dynamicFieldControllers[fieldId] = TextEditingController(
          text: defaultValue,
        );
      }
    }
  }

  // ── Location / applicable-code pickers ────────────────────────────────────

  void _showLocationPickerDialog({
    required TextEditingController controller,
    required List<String> fieldDefinedLocations,
    String storageKey = PickerStorageKey.itemLocation,
    String dialogTitle = 'Select Location',
    String emptyHint = 'Select or enter location',
  }) {
    showDialog(
      context: context,
      builder:
          (_) => _LocationPickerDialog(
            fieldDefinedLocations: fieldDefinedLocations,
            initialValue: controller.text,
            storageKey: storageKey,
            dialogTitle: dialogTitle,
            emptyHint: emptyHint,
            onConfirm: (value, isCustom) async {
              setState(() => controller.text = value);
              if (isCustom) await PickerStorageService.add(storageKey, value);
            },
          ),
    );
  }

  void _showApplicableCodePickerDialog({
    required TextEditingController controller,
    List<String> fieldDefinedCodes = const [],
  }) {
    _showLocationPickerDialog(
      controller: controller,
      fieldDefinedLocations: fieldDefinedCodes,
      storageKey: PickerStorageKey.applicableCode,
      dialogTitle: 'Select Applicable Code',
      emptyHint: 'Select or enter applicable code',
    );
  }

  // ── Category dialog ────────────────────────────────────────────────────────

  void _showCategorySelectionDialog() {
    final TextEditingController dialogSearchController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                width: MediaQuery.of(ctx).size.width * 0.9,
                height: MediaQuery.of(ctx).size.height * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Header ─────────────────────────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ctx.colors.primary,
                                ctx.colors.primary.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: ctx.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
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
                                style: ctx.topology.textTheme.titleMedium
                                    ?.copyWith(
                                      color: ctx.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Choose a category for this item',
                                style: ctx.topology.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogSearchController.dispose();
                            Navigator.of(dialogContext).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: ctx.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    // ── Search ─────────────────────────────────────────────
                    CommonTextField(
                      controller: dialogSearchController,
                      hintText: 'Search categories...',
                      style: ctx.topology.textTheme.bodySmall?.copyWith(
                        color: ctx.colors.primary,
                      ),
                      suffixIcon: Icon(Icons.search, color: ctx.colors.primary),
                      onChanged: (value) {
                        context.read<CategoryProvider>().searchCategories(
                          value,
                        );
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    // ── List ───────────────────────────────────────────────
                    Expanded(
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: context.colors.primary,
                              ),
                            );
                          }
                          if (provider.errorMessage != null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    provider.errorMessage!,
                                    style: context.topology.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => provider.refresh(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (provider.totalItemCount == 0) {
                            return Center(
                              child: Text(
                                dialogSearchController.text.isEmpty
                                    ? 'No categories available'
                                    : 'No categories matching '
                                        '"${dialogSearchController.text}"',
                                style: context.topology.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: context.colors.primary.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: provider.totalItemCount,
                            itemBuilder: (context, index) {
                              final cat = provider.getCategoryByIndex(index);
                              if (cat == null) {
                                return const SizedBox.shrink();
                              }
                              return _buildCatItemForDialog(
                                ctx,
                                provider,
                                cat,
                                setDialogState,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    // ── Footer ─────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            dialogSearchController.dispose();
                            Navigator.of(dialogContext).pop();
                          },
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
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: ctx.colors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              _selectedCategory != null
                                  ? () {
                                    dialogSearchController.dispose();
                                    Navigator.of(dialogContext).pop();
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Select'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCatItemForDialog(
    BuildContext ctx,
    CategoryProvider provider,
    CategoryItem category,
    StateSetter setDialogState,
  ) {
    final isSel = _selectedCategory?.id == category.id;

    Color bgColor() {
      if (category.level == 0) return Colors.transparent;
      return ctx.colors.primary.withValues(
        alpha: 0.02 + (category.level * 0.01),
      );
    }

    TextStyle? textStyle() {
      if (category.level == 0) {
        return ctx.topology.textTheme.bodyMedium?.copyWith(
          color: ctx.colors.primary,
          fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
        );
      }
      return ctx.topology.textTheme.bodySmall?.copyWith(
        color:
            isSel
                ? ctx.colors.primary
                : ctx.colors.primary.withValues(alpha: 0.8),
        fontWeight: isSel ? FontWeight.w500 : FontWeight.normal,
      );
    }

    Widget? indentIcon() {
      if (category.level == 0) return null;
      return Icon(
        category.level == 1 ? Icons.subdirectory_arrow_right : Icons.more_horiz,
        color: Colors.grey.withValues(alpha: 0.6),
        size: 14,
      );
    }

    return GestureDetector(
      onTap: () {
        if (category.children.isNotEmpty) {
          provider.toggleExpansion(category);
        }
        setDialogState(() {});
        setState(() {
          _selectedCategory = category;
          _categoryController.text = category.name;
        });
        _loadFieldsFromStorage(category.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSel ? ctx.colors.primary.withValues(alpha: 0.1) : bgColor(),
          borderRadius: BorderRadius.circular(4),
          border:
              isSel ? Border.all(color: ctx.colors.primary, width: 1) : null,
        ),
        margin: EdgeInsets.only(left: category.level * 16.0, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child:
                  category.children.isNotEmpty
                      ? Icon(
                        category.isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: ctx.colors.primary,
                        size: 18,
                      )
                      : indentIcon(),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSel ? ctx.colors.primary : Colors.grey,
                  width: 2,
                ),
                color: isSel ? ctx.colors.primary : Colors.transparent,
              ),
              child:
                  isSel
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: textStyle()),
                  if (category.categoryCode != null)
                    Text(
                      'Code: ${category.categoryCode}',
                      style: ctx.topology.textTheme.bodySmall?.copyWith(
                        color: ctx.colors.primary.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  if (category.description != null &&
                      category.description!.isNotEmpty)
                    Text(
                      category.description!,
                      style: ctx.topology.textTheme.bodySmall?.copyWith(
                        color: ctx.colors.primary.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (category.children.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ctx.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.children.length}',
                  style: ctx.topology.textTheme.bodySmall?.copyWith(
                    color: ctx.colors.primary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── UI section builders ────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: context.colors.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Item No', Icons.tag),
        context.vM,
        _buildItemNoModeTabs(context),
        context.vM,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(
            key: ValueKey(_itemNoMode),
            child: _buildItemNoModeFields(context),
          ),
        ),
      ],
    );
  }

  Widget _buildItemNoModeTabs(BuildContext context) {
    final modes = [
      (ItemNoCreationMode.singleItem, 'Single Item'),
      (ItemNoCreationMode.batchCreation, 'Batch Creation'),
      (ItemNoCreationMode.batchCreationManual, 'Batch Creation (Manual)'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            modes.map((entry) {
              final mode = entry.$1;
              final label = entry.$2;
              final isSelected = _itemNoMode == mode;
              return GestureDetector(
                onTap: () => setState(() => _itemNoMode = mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? context.colors.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          isSelected
                              ? context.colors.primary
                              : context.colors.primary.withValues(alpha: 0.3),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    label,
                    style: context.topology.textTheme.labelMedium?.copyWith(
                      color:
                          isSelected
                              ? Colors.white
                              : context.colors.primary.withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildItemNoModeFields(BuildContext context) {
    switch (_itemNoMode) {
      case ItemNoCreationMode.singleItem:
        return _buildSingleItemFields(context);
      case ItemNoCreationMode.batchCreation:
        return _buildBatchCreationFields(context);
      case ItemNoCreationMode.batchCreationManual:
        return _buildBatchManualFields(context);
    }
  }

  Widget _buildSingleItemFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          controller: _singleItemNoController,
          hintText: '',
          enabled: !_generateItemNo,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
          suffixIcon:
              _generateItemNo
                  ? Icon(
                    Icons.auto_fix_high,
                    size: 16,
                    color: context.colors.primary.withValues(alpha: 0.4),
                  )
                  : null,
        ),
        const SizedBox(height: 10),
        _buildGenerateItemNoCheckbox(
          context,
          value: _generateItemNo,
          onChanged:
              (v) => setState(() {
                _generateItemNo = v ?? false;
                if (_generateItemNo) _singleItemNoController.clear();
              }),
        ),
      ],
    );
  }

  Widget _buildBatchCreationFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledInput(
          context,
          label: 'Numbering Template',
          controller: _batchNumberingTemplateController,
        ),
        const SizedBox(height: 12),
        _buildLabeledInput(
          context,
          label: 'Create From',
          controller: _batchCreateFromController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildLabeledInput(
          context,
          label: 'To',
          controller: _batchCreateToController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildGenerateItemNoCheckbox(
              context,
              value: _batchGenerateItemNo,
              onChanged:
                  (v) => setState(() {
                    _batchGenerateItemNo = v ?? false;
                    if (!_batchGenerateItemNo) {
                      _batchNumberToGenerateController.clear();
                    }
                  }),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number to Generate',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  CommonTextField(
                    controller: _batchNumberToGenerateController,
                    hintText: '',
                    enabled: _batchGenerateItemNo,
                    keyboardType: TextInputType.number,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBatchManualFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          controller: _batchManualItemNoController,
          hintText: '',
          enabled: !_batchManualGenerateItemNo,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
          suffixIcon:
              _batchManualGenerateItemNo
                  ? Icon(
                    Icons.auto_fix_high,
                    size: 16,
                    color: context.colors.primary.withValues(alpha: 0.4),
                  )
                  : null,
        ),
        const SizedBox(height: 10),
        _buildGenerateItemNoCheckbox(
          context,
          value: _batchManualGenerateItemNo,
          onChanged:
              (v) => setState(() {
                _batchManualGenerateItemNo = v ?? false;
                if (_batchManualGenerateItemNo) {
                  _batchManualItemNoController.clear();
                }
              }),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary.withValues(alpha: 0.8),
            fontWeight: isRequired ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        CommonTextField(
          controller: controller,
          hintText: '',
          keyboardType: keyboardType,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateItemNoCheckbox(
    BuildContext context, {
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: context.colors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Generate Item No',
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Tooltip(
          message:
              'When checked, an Item No will be automatically generated '
              'based on the configured numbering template.',
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(
            Icons.help_outline,
            size: 16,
            color: context.colors.primary.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(BuildContext context, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Category *',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: _showCategorySelectionDialog,
            child: AbsorbPointer(
              child: CommonTextField(
                controller: _categoryController,
                hintText: 'Select a category',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    String title,
    TextEditingController controller, {
    int maxLines = 1,
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    title + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonTextField(
            controller: controller,
            maxLines: maxLines,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleDropdownRow(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isRequired,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: context.colors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              if (isRequired)
                const Text(
                  '* ',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonDropdown<String>(
            value: selectedValue,
            items:
                items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            borderColor: context.colors.primary.withValues(alpha: 0.3),
            borderWidth: 1.0,
            borderRadius: 8.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, _) {
        final customers = jobProvider.customers;
        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !customers.any((c) => c.customername == selectedValue)) {
          selectedValue = null;
        }
        return _buildSimpleDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.person,
          isRequired: isRequired,
          selectedValue: selectedValue,
          items:
              customers
                  .where(
                    (c) => c.customername != null && c.customername!.isNotEmpty,
                  )
                  .map((c) => c.customername!)
                  .toList(),
          onChanged: (value) => setState(() => controller.text = value ?? ''),
        );
      },
    );
  }

  Widget _buildSiteDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Consumer<SiteProvider>(
      builder: (context, siteProvider, _) {
        final sites = siteProvider.sites;
        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !sites.any((s) => s.siteName == selectedValue)) {
          selectedValue = null;
        }
        return _buildSimpleDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.location_city,
          isRequired: isRequired,
          selectedValue: selectedValue,
          items:
              sites
                  .where((s) => s.siteName != null && s.siteName!.isNotEmpty)
                  .map((s) => s.siteName!)
                  .toList(),
          onChanged: (value) => setState(() => controller.text = value ?? ''),
        );
      },
    );
  }

  Widget _buildItemCategoryDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final List<CategoryItem> flat = [];
        void flatten(List<CategoryItem> items) {
          for (final item in items) {
            flat.add(item);
            if (item.children.isNotEmpty) flatten(item.children);
          }
        }

        flatten(categoryProvider.filteredCategories);
        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !flat.any((c) => c.name == selectedValue)) {
          selectedValue = null;
        }
        return _buildSimpleDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.category,
          isRequired: isRequired,
          selectedValue: selectedValue,
          items: flat.map((c) => c.name).toList(),
          onChanged: (value) => setState(() => controller.text = value ?? ''),
        );
      },
    );
  }

  bool _isLocationFieldType(String fieldType, String labelText) {
    switch (fieldType) {
      case 'ItemLocation':
      case 'Location':
      case 'DetailedLocation':
        return !labelText.toLowerCase().contains('applicable');
      default:
        return fieldType == 'Text' &&
            labelText.toLowerCase().contains('location') &&
            !labelText.toLowerCase().contains('applicable');
    }
  }

  Widget _buildDynamicField(BuildContext context, Map<String, dynamic> field) {
    final fieldId = field['id'] as String;
    final labelText = field['labelText'] as String;
    final fieldType = field['fieldType'] as String;
    final isRequired = field['required'] as bool? ?? false;
    final IconData? icon = _getIconForFieldType(fieldType);
    final int maxLines = fieldType == 'Multi-Line Textbox' ? 3 : 1;

    if (fieldType == 'ItemNo' || labelText.toLowerCase().contains('item no')) {
      return const SizedBox.shrink();
    }

    switch (fieldType) {
      case 'Customer':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildCustomerDropdownField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'SiteID':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildSiteDropdownField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'ItemCategory':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildItemCategoryDropdownField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'Date':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildDatePickerField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'File':
        final fc = _fileUploadControllers[fieldId];
        if (fc == null) return const SizedBox.shrink();
        return _buildFileUploadField(
          context,
          labelText,
          fc,
          isRequired: isRequired,
          icon: icon,
        );

      case 'Boolean':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildBooleanField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'Checklist Item':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildChecklistItemField(
          context,
          labelText,
          c,
          field,
          isRequired: isRequired,
          icon: icon,
        );

      case 'Dropdown':
      case 'Override Dropdown':
      case 'Conditional Dropdown':
      case 'Site Dropdown':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildDropdownField(
          context,
          labelText,
          c,
          field,
          isRequired: isRequired,
          icon: icon,
        );

      case 'ItemLocation':
      case 'Location':
      case 'DetailedLocation':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        if (labelText.toLowerCase().contains('applicable code') ||
            labelText.toLowerCase().contains('applicablecode')) {
          return _buildApplicableCodeField(
            context,
            labelText,
            c,
            field,
            isRequired: isRequired,
            icon: icon,
          );
        }
        return _buildLocationField(
          context,
          labelText,
          c,
          isRequired: isRequired,
          icon: icon,
        );

      case 'ApplicableCode':
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        return _buildApplicableCodeField(
          context,
          labelText,
          c,
          field,
          isRequired: isRequired,
          icon: icon,
        );

      default:
        final c = _dynamicFieldControllers[fieldId];
        if (c == null) return const SizedBox.shrink();
        if (_isLocationFieldType(fieldType, labelText)) {
          return _buildLocationField(
            context,
            labelText,
            c,
            isRequired: isRequired,
            icon: icon ?? Icons.location_on_outlined,
          );
        }
        return _buildRow(
          context,
          labelText,
          c,
          maxLines: maxLines,
          isRequired: isRequired,
          icon: icon,
        );
    }
  }

  Widget _buildDatePickerField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonDatePickerInput(
            label: '',
            controller: controller,
            isRequired: isRequired,
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadField(
    BuildContext context,
    String label,
    FileUploadController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonFileUploadInput(
            controller: controller,
            isRequired: isRequired,
            enableCamera: true,
          ),
        ),
      ],
    );
  }

  Widget _buildBooleanField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  label + (isRequired ? ' *' : ''),
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight:
                        isRequired ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              value: controller.text.toLowerCase() == 'true',
              onChanged:
                  (value) => setState(() => controller.text = value.toString()),
              activeColor: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItemField(
    BuildContext context,
    String label,
    TextEditingController controller,
    Map<String, dynamic> field, {
    bool isRequired = false,
    IconData? icon,
  }) {
    final rawOptions =
        (field['dropdownOptions'] as List<dynamic>?) ??
        (field['options'] as List<dynamic>?) ??
        [];
    final options = rawOptions.map((e) => e.toString()).toList();

    final checkedValues =
        controller.text.isEmpty
            ? <String>{}
            : controller.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toSet();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    label + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              options.isEmpty
                  ? CommonTextField(
                    controller: controller,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.colors.primary.withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children:
                          options.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final option = entry.value;
                            final isChecked = checkedValues.contains(option);
                            final isLast = idx == options.length - 1;

                            return Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        idx == 0
                                            ? const Radius.circular(7)
                                            : Radius.zero,
                                    topRight:
                                        idx == 0
                                            ? const Radius.circular(7)
                                            : Radius.zero,
                                    bottomLeft:
                                        isLast
                                            ? const Radius.circular(7)
                                            : Radius.zero,
                                    bottomRight:
                                        isLast
                                            ? const Radius.circular(7)
                                            : Radius.zero,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      final updated = Set<String>.from(
                                        checkedValues,
                                      );
                                      if (isChecked) {
                                        updated.remove(option);
                                      } else {
                                        updated.add(option);
                                      }
                                      controller.text = updated.join(',');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color:
                                                isChecked
                                                    ? context.colors.primary
                                                    : Colors.transparent,
                                            border: Border.all(
                                              color:
                                                  isChecked
                                                      ? context.colors.primary
                                                      : context.colors.primary
                                                          .withValues(
                                                            alpha: 0.35,
                                                          ),
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child:
                                              isChecked
                                                  ? const Icon(
                                                    Icons.check_rounded,
                                                    size: 12,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: context
                                                .topology
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color:
                                                      isChecked
                                                          ? context
                                                              .colors
                                                              .primary
                                                          : context
                                                              .colors
                                                              .primary
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                  fontWeight:
                                                      isChecked
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    color: context.colors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller,
    Map<String, dynamic> field, {
    bool isRequired = false,
    IconData? icon,
  }) {
    final rawOptions =
        (field['dropdownOptions'] as List<dynamic>?) ??
        (field['options'] as List<dynamic>?) ??
        [];
    final dropdownItems =
        rawOptions.isEmpty
            ? ['Option 1', 'Option 2', 'Option 3']
            : rawOptions.map((e) => e.toString()).toList();
    String? selectedValue = controller.text.isEmpty ? null : controller.text;
    if (selectedValue != null && !dropdownItems.contains(selectedValue)) {
      selectedValue = null;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label + (isRequired ? ' *' : ''),
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight:
                          isRequired ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonDropdown<String>(
            value: selectedValue,
            items:
                dropdownItems
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => controller.text = value ?? ''),
            borderColor: context.colors.primary.withValues(alpha: 0.3),
            borderWidth: 1.0,
            borderRadius: 8.0,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon ?? Icons.location_on_outlined,
                size: 16,
                color: context.colors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label + (isRequired ? ' *' : ''),
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight:
                        isRequired ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap:
                () => showJobLocationPickerDialog(
                  context: context,
                  controller: controller,
                  jobItemId: widget.jobId,
                ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                final hasValue = value.text.trim().isNotEmpty;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          hasValue
                              ? context.colors.primary
                              : context.colors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        hasValue
                            ? context.colors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color:
                            hasValue
                                ? context.colors.primary
                                : context.colors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasValue ? value.text : 'Select or add location',
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color:
                                hasValue
                                    ? context.colors.primary
                                    : context.colors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasValue)
                        GestureDetector(
                          onTap: () => setState(() => controller.clear()),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: context.colors.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: context.colors.primary.withValues(alpha: 0.6),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicableCodeField(
    BuildContext context,
    String label,
    TextEditingController controller,
    Map<String, dynamic> field, {
    bool isRequired = false,
    IconData? icon,
  }) {
    final rawOptions =
        (field['dropdownOptions'] as List<dynamic>?) ??
        (field['options'] as List<dynamic>?) ??
        [];
    final fieldDefinedCodes = rawOptions.map((e) => e.toString()).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon ?? Icons.gavel_outlined,
                size: 16,
                color: context.colors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label + (isRequired ? ' *' : ''),
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight:
                        isRequired ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap:
                () => _showApplicableCodePickerDialog(
                  controller: controller,
                  fieldDefinedCodes: fieldDefinedCodes,
                ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                final hasValue = value.text.trim().isNotEmpty;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          hasValue
                              ? context.colors.primary
                              : context.colors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        hasValue
                            ? context.colors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.gavel_outlined,
                        size: 16,
                        color:
                            hasValue
                                ? context.colors.primary
                                : context.colors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasValue
                              ? value.text
                              : 'Select or enter applicable code',
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color:
                                hasValue
                                    ? context.colors.primary
                                    : context.colors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasValue)
                        GestureDetector(
                          onTap: () => setState(() => controller.clear()),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: context.colors.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: context.colors.primary.withValues(alpha: 0.6),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  IconData? _getIconForFieldType(String fieldType) {
    switch (fieldType) {
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
      case 'Checklist Item':
        return Icons.checklist_outlined;
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
      case 'Location':
        return Icons.location_on_outlined;
      case 'DetailedLocation':
        return Icons.my_location;
      case 'RFIDNo':
        return Icons.nfc;
      case 'LatestPhoto':
        return Icons.photo_camera;
      case 'ApplicableCode':
        return Icons.gavel_outlined;
      default:
        return Icons.input;
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupFieldsBySection() {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Basic Information': [],
      'Location Details': [],
      'Manufacturer Information': [],
      'Other': [],
    };

    for (var field in _customFields) {
      final fieldType = field['fieldType'] as String;
      final labelText = field['labelText'] as String;

      if (fieldType == 'ItemNo' || labelText.toLowerCase().contains('item no'))
        continue;

      if (fieldType == 'ItemDescription' ||
          fieldType == 'Customer' ||
          fieldType == 'SiteID' ||
          fieldType == 'ItemCategory' ||
          fieldType == 'ApplicableCode' ||
          labelText.toLowerCase().contains('description') ||
          labelText.toLowerCase().contains('applicable code')) {
        grouped['Basic Information']!.add(field);
      } else if (fieldType == 'ItemLocation' ||
          fieldType == 'DetailedLocation' ||
          fieldType == 'Location' ||
          (labelText.toLowerCase().contains('location') &&
              !labelText.toLowerCase().contains('applicable code'))) {
        grouped['Location Details']!.add(field);
      } else if (labelText.toLowerCase().contains('manufacturer') ||
          labelText.toLowerCase().contains('manufacture')) {
        grouped['Manufacturer Information']!.add(field);
      } else {
        grouped['Other']!.add(field);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Widget _buildFormFields(BuildContext context) {
    final groupedFields = _groupFieldsBySection();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemNoSection(context),
        context.vL,
        _buildSectionHeader(context, 'Category', Icons.category),
        context.vM,
        _buildCategoryRow(context, icon: Icons.category),
        context.vL,
        if (_customFields.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No fields available. Please select a category.',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...groupedFields.entries.map((entry) {
            final sectionName = entry.key;
            final sectionFields = entry.value;
            IconData sectionIcon = Icons.info_outline;
            if (sectionName == 'Location Details') {
              sectionIcon = Icons.location_on;
            }
            if (sectionName == 'Manufacturer Information') {
              sectionIcon = Icons.factory;
            }
            if (sectionName == 'Other') {
              sectionIcon = Icons.extension;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, sectionName, sectionIcon),
                context.vM,
                ...sectionFields.map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildDynamicField(context, field),
                  ),
                ),
                context.vL,
              ],
            );
          }),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final groupedFields = _groupFieldsBySection();
    final allSections = groupedFields.entries.toList();
    final halfIndex = (allSections.length / 2).ceil();

    IconData sectionIcon(String name) {
      if (name == 'Location Details') return Icons.location_on;
      if (name == 'Manufacturer Information') return Icons.factory;
      if (name == 'Other') return Icons.extension;
      return Icons.info_outline;
    }

    Widget buildSection(MapEntry<String, List<Map<String, dynamic>>> entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, entry.key, sectionIcon(entry.key)),
          context.vM,
          ...entry.value.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDynamicField(context, field),
            ),
          ),
          context.vL,
        ],
      );
    }

    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildItemNoSection(context),
                        context.vL,
                        _buildSectionHeader(
                          context,
                          'Category',
                          Icons.category,
                        ),
                        context.vM,
                        _buildCategoryRow(context, icon: Icons.category),
                        context.vL,
                        ...allSections.take(halfIndex).map(buildSection),
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...allSections.skip(halfIndex).map(buildSection),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: CommonButton(
                  text: _saveButtonLabel,
                  onPressed: _isLoading ? null : _saveJobItem,
                ),
              ),
            ],
          ),
          context.vM,
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          _buildFormFields(context),
          context.vL,
          CommonButton(
            text: _saveButtonLabel,
            onPressed: _isLoading ? null : _saveJobItem,
          ),
          context.vL,
        ],
      ),
    );
  }

  String get _saveButtonLabel {
    if (_isLoading) {
      return widget.isEditMode ? 'Updating...' : 'Saving...';
    }
    switch (_itemNoMode) {
      case ItemNoCreationMode.singleItem:
        return widget.isEditMode ? 'Update Item' : 'Save Item';
      case ItemNoCreationMode.batchCreation:
        return 'Create Batch';
      case ItemNoCreationMode.batchCreationManual:
        return 'Save Item';
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isEditMode ? Icons.edit : Icons.add_box,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              widget.isEditMode ? 'Edit Job Item' : 'Create Job Item',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: _finishAndPop,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: context.colors.primary),
                      const SizedBox(height: 16),
                      Text(
                        widget.isEditMode
                            ? 'Updating job item...'
                            : 'Saving job item...',
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                )
                : _isLoadingFields
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: context.colors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Loading fields...',
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                )
                : context.isTablet
                ? _buildTabletLayout(context)
                : _buildMobileLayout(context),
      ),
    );
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  List<String>? _resolveItemNumbers() {
    switch (_itemNoMode) {
      case ItemNoCreationMode.singleItem:
        if (_generateItemNo) return ['__AUTO__'];
        final no = _singleItemNoController.text.trim();
        if (no.isEmpty) {
          _showErrorSnackbar('Please enter an Item No');
          return null;
        }
        return [no];

      case ItemNoCreationMode.batchCreation:
        if (_batchGenerateItemNo) {
          final countStr = _batchNumberToGenerateController.text.trim();
          final count = int.tryParse(countStr);
          if (count == null || count <= 0) {
            _showErrorSnackbar('Please enter a valid "Number to Generate"');
            return null;
          }
          return List.generate(count, (_) => '__AUTO__');
        }
        final from = int.tryParse(_batchCreateFromController.text.trim());
        final to = int.tryParse(_batchCreateToController.text.trim());
        if (from == null || to == null) {
          _showErrorSnackbar(
            'Please enter valid numeric values for "Create From" and "To"',
          );
          return null;
        }
        if (to < from) {
          _showErrorSnackbar('"To" must be >= "From"');
          return null;
        }
        final template = _batchNumberingTemplateController.text.trim();
        return List.generate(
          to - from + 1,
          (i) => template.isNotEmpty ? '$template${from + i}' : '${from + i}',
        );

      case ItemNoCreationMode.batchCreationManual:
        if (_batchManualGenerateItemNo) return ['__AUTO__'];
        final no = _batchManualItemNoController.text.trim();
        if (no.isEmpty) {
          _showErrorSnackbar('Please enter an Item No');
          return null;
        }
        return [no];
    }
  }

  bool _isStaticField(String fieldType, String labelText) {
    if (_staticFieldTypes.contains(fieldType)) return true;
    final l = labelText.toLowerCase();
    return l.contains('description') ||
        (l.contains('location') && !l.contains('applicable')) ||
        l.contains('applicable code') ||
        l.contains('rfid') ||
        l.contains('customer') ||
        l.contains('site') ||
        l.contains('first use') ||
        l.contains('inspected') ||
        l.contains('expiry') ||
        l.contains('expiration') ||
        l.contains('manufacturer') ||
        l.contains('swl') ||
        l.contains('serial');
  }

  void _writeStaticField(
    Map<String, dynamic> root,
    String fieldType,
    String labelText,
    String fieldName,
    String value,
  ) {
    if (value.isEmpty) return;
    final l = labelText.toLowerCase();

    switch (fieldType) {
      case 'ItemDescription':
        root['description'] = value;
        return;
      case 'ItemLocation':
      case 'DetailedLocation':
      case 'Location':
        if (!l.contains('applicable')) {
          root['detailedLocation'] = value;
        } else {
          root['applicableCode'] = value;
        }
        return;
      case 'ApplicableCode':
        root['applicableCode'] = value;
        return;
      case 'ItemCategory':
        root['categoryName'] = value;
        return;
      case 'RFIDNo':
        root['rfidNo'] = value;
        return;
      case 'Customer':
        root['customerName'] = value;
        return;
      case 'SiteID':
        root['siteName'] = value;
        return;
    }

    if (l.contains('first use') || l.contains('inspected')) {
      root['firstUseDate'] = _toIsoDateTimeString(value);
    } else if (l.contains('expiry') || l.contains('expiration')) {
      root['expiryDateTimeStamp'] = _toIsoDateTimeString(value);
    } else if (l.contains('manufacturer')) {
      root['manufacturer'] = value;
    } else if (l.contains('swl')) {
      root['swl'] = value;
    } else if (l.contains('serial')) {
      root['serialNumber'] = value;
    } else if (l.contains('description')) {
      root['description'] = value;
    } else if (l.contains('location') && !l.contains('applicable')) {
      root['detailedLocation'] = value;
    } else if (l.contains('applicable')) {
      root['applicableCode'] = value;
    } else if (l.contains('customer')) {
      root['customerName'] = value;
    } else if (l.contains('site')) {
      root['siteName'] = value;
    } else if (l.contains('rfid')) {
      root['rfidNo'] = value;
    } else {
      root[fieldName] = value;
    }
  }

  void _saveJobItem() async {
    if (_selectedCategory == null) {
      _showErrorSnackbar('Please select a category');
      return;
    }

    for (var field in _customFields) {
      if (field['required'] == true) {
        final fieldId = field['id'] as String;
        final fieldType = field['fieldType'] as String;
        final labelText = (field['labelText'] as String? ?? '').toLowerCase();
        if (fieldType == 'ItemNo' || labelText.contains('item no')) {
          continue;
        }
        if (fieldType == 'File') {
          final fc = _fileUploadControllers[fieldId];
          if (fc == null || !fc.hasFile) {
            _showErrorSnackbar('${field['labelText']} is required');
            return;
          }
        } else {
          final c = _dynamicFieldControllers[fieldId];
          if (c == null || c.text.trim().isEmpty) {
            _showErrorSnackbar('${field['labelText']} is required');
            return;
          }
        }
      }
    }

    final itemNumbers = _resolveItemNumbers();
    if (itemNumbers == null) return;

    setState(() => _isLoading = true);

    final String effectiveJobId =
        widget.jobId.isNotEmpty
            ? widget.jobId
            : (widget.existingItem?['jobID']?.toString().trim() ??
                widget.existingItem?['jobId']?.toString().trim() ??
                widget.existingItem?['job_id']?.toString().trim() ??
                '');

    final String baseStatus =
        widget.isEditMode && widget.existingItem != null
            ? (widget.existingItem!['status'] ?? 'pending_submission')
            : 'pending_submission';

    final Map<String, dynamic> baseData = {
      if (effectiveJobId.isNotEmpty) 'jobID': effectiveJobId,
      'categoryName': _selectedCategory!.name,
      'categoryID': _selectedCategory!.id,
      'status': baseStatus,
    };

    final Map<String, dynamic> itemData = {};

    for (var field in _customFields) {
      final fieldId = field['id'] as String;
      final fieldName = field['name'] as String;
      final fieldType = field['fieldType'] as String;
      final labelText = field['labelText'] as String;

      if (fieldType == 'ItemNo' || labelText.toLowerCase().contains('item no'))
        continue;

      if (fieldType == 'File') {
        final fc = _fileUploadControllers[fieldId];
        if (fc != null && fc.hasFile) {
          itemData[fieldName] = fc.fileName;
        }
        continue;
      }

      final c = _dynamicFieldControllers[fieldId];
      if (c == null) continue;
      final value = c.text.trim();

      if (_isStaticField(fieldType, labelText)) {
        _writeStaticField(baseData, fieldType, labelText, fieldName, value);
      } else {
        if (value.isNotEmpty) {
          itemData[fieldName] =
              fieldType == 'Date' ? _toIsoDateTimeString(value) : value;
        }
      }
    }

    if (itemData.isNotEmpty) baseData['itemData'] = itemData;

    final List<Map<String, dynamic>> jobItems =
        itemNumbers.map((itemNo) {
          return {
            ...baseData,
            if (widget.isEditMode && widget.existingItem != null)
              'itemId':
                  widget.existingItem!['itemId']?.toString() ??
                  widget.existingItem!['item_id']?.toString() ??
                  widget.existingItem!['itemID']?.toString() ??
                  '',
            'itemNo': itemNo == '__AUTO__' ? '' : itemNo,
            'generateItemNo':
                itemNo == '__AUTO__' ||
                _generateItemNo ||
                _batchGenerateItemNo ||
                _batchManualGenerateItemNo,
          };
        }).toList();

    debugPrint(
      '📦 Saving ${jobItems.length} item(s) [mode: ${_itemNoMode.name}]',
    );
    debugPrint('   baseData keys: ${baseData.keys.toList()}');
    if (itemData.isNotEmpty) {
      debugPrint('   itemData keys: ${itemData.keys.toList()}');
    }

    final hasInternet = await _checkInternetConnection();
    if (hasInternet) {
      await _submitJobItemsToAPI(jobItems, effectiveJobId);
    } else {
      await _saveJobItemsOffline(jobItems);
    }
  }

  // ── FIXED: skip local save on edit to avoid QuotaExceededError ────────────

  Future<void> _submitJobItemsToAPI(
    List<Map<String, dynamic>> items,
    String effectiveJobId,
  ) async {
    try {
      if (items.length == 1) {
        final item = items.first;
        if (widget.isEditMode && widget.existingItem != null) {
          final itemId =
              widget.existingItem!['itemId']?.toString() ??
              widget.existingItem!['item_id']?.toString() ??
              widget.existingItem!['itemID']?.toString() ??
              '';
          await context.read<JobProvider>().updateJobItem(
            context,
            itemId,
            item,
          );
          if (mounted && effectiveJobId.isNotEmpty) {
            try {
              await context.read<JobProvider>().fetchJobRegisterModel(
                context,
                effectiveJobId,
              );
            } catch (e) {
              debugPrint('⚠️ fetchJobRegisterModel after update failed: $e');
            }
          }
          // ✅ Do NOT call _saveCompletedItemLocally on edit.
          // The item is already persisted server-side and web localStorage
          // quota (~5 MB) is easily exhausted by large item payloads.
        } else {
          await context.read<JobProvider>().createJobItemNoNav(
            context,
            item,
            effectiveJobId,
          );
          if (!mounted) return;
          await _saveCompletedItemLocally(item);
        }
      } else {
        await Future.wait(
          items.map(
            (item) => context.read<JobProvider>().createJobItemNoNav(
              context,
              item,
              effectiveJobId,
            ),
          ),
        );
        if (!mounted) return;
        for (final item in items) await _saveCompletedItemLocally(item);
        _showBatchSuccessSnackbar(items.length);
        if (mounted && effectiveJobId.isNotEmpty) {
          try {
            await context.read<JobProvider>().fetchJobRegisterModel(
              context,
              effectiveJobId,
            );
          } catch (e) {
            debugPrint('⚠️ fetchJobRegisterModel after batch failed: $e');
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      await _saveItemsAsDrafts(items);
      _showOfflineFallbackSnackbar();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    _finishAndPop();
  }

  Future<void> _saveJobItemsOffline(List<Map<String, dynamic>> items) async {
    try {
      await _saveItemsAsDrafts(items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.save, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  items.length == 1
                      ? (widget.isEditMode
                          ? 'Item updated locally. Sync when online.'
                          : 'Saved locally. Will sync when online.')
                      : '${items.length} items saved locally. Sync when online.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (mounted) _showErrorSnackbar('Error saving offline: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    _finishAndPop();
  }

  Future<void> _saveItemsAsDrafts(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final draft = {
        ...item,
        'status': 'pending_submission',
        'isPending': true,
      };
      await JobItemStorage.saveDraft(widget.jobId, draft);
    }
  }

  // ── FIXED: non-fatal quota error, only called on create (not edit) ─────────

  Future<void> _saveCompletedItemLocally(
    Map<String, dynamic> jobItemData,
  ) async {
    try {
      final submitted = {
        ...jobItemData,
        'status': 'submitted',
        'isPending': false,
        'submittedAt': DateTime.now().toIso8601String(),
      };
      await JobItemStorage.saveCompletedItem(widget.jobId, submitted);
    } catch (e) {
      debugPrint('⚠️ Error saving completed item locally (quota?): $e');
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showOfflineFallbackSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Saved locally. Will sync when online.')),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showBatchSuccessSnackbar(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('$count items created successfully.')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LocationPickerDialog
// ─────────────────────────────────────────────────────────────────────────────

class _LocationPickerDialog extends StatefulWidget {
  final List<String> fieldDefinedLocations;
  final String initialValue;
  final String storageKey;
  final String dialogTitle;
  final String emptyHint;
  final void Function(String value, bool isCustom) onConfirm;

  const _LocationPickerDialog({
    required this.fieldDefinedLocations,
    required this.initialValue,
    this.storageKey = PickerStorageKey.itemLocation,
    this.dialogTitle = 'Select Location',
    this.emptyHint = 'Select or enter location',
    required this.onConfirm,
  });

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<_LocationPickerDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customController = TextEditingController();

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

  IconData get _itemIconSel =>
      _isCodePicker ? Icons.check_circle_outline : Icons.location_on;

  IconData get _itemIconUnsel =>
      _isCodePicker ? Icons.tag : Icons.location_on_outlined;

  String get _noun => _isCodePicker ? 'code' : 'location';

  String get _nounPlural => _isCodePicker ? 'codes' : 'locations';

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
    _loadSaved();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    _customController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
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
      widget.onConfirm(_selected!, _savedLocations.contains(_selected));
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
              if (hasAnyList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: _inputDeco(
                      context,
                      hint: 'Search...',
                      prefixIcon: Icons.search,
                    ),
                    style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              if (hasAnyList) ...[
                const SizedBox(height: 8),
                _buildTabBar(context),
              ],
              if (hasAnyList)
                SizedBox(
                  height: _listHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(
                        context,
                        items: _filteredField,
                        isFromSaved: false,
                        emptyIcon: Icons.category_outlined,
                        emptyText:
                            _searchController.text.isEmpty
                                ? 'No predefined $_nounPlural'
                                : 'No matches for '
                                    '"${_searchController.text}"',
                      ),
                      _buildList(
                        context,
                        items: _filteredSaved,
                        isFromSaved: true,
                        emptyIcon: Icons.history,
                        emptyText:
                            _searchController.text.isEmpty
                                ? 'No recently used $_nounPlural'
                                : 'No matches for '
                                    '"${_searchController.text}"',
                        headerAction:
                            _savedLocations.isNotEmpty
                                ? _buildClearAllBtn(context)
                                : null,
                      ),
                      _buildList(
                        context,
                        items: _filteredAll,
                        isFromSaved: false,
                        emptyIcon: Icons.search_off,
                        emptyText: 'No matches for "${_searchController.text}"',
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        hasAnyList ? 'or type your own' : 'Enter value',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary.withValues(alpha: 0.45),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _customController,
                  onChanged: _onCustomChanged,
                  onSubmitted: (_) => _canConfirm ? _confirm() : null,
                  decoration: _inputDeco(
                    context,
                    hint: hasAnyList ? 'Type a custom value…' : 'Enter value…',
                    prefixIcon: Icons.edit_location_alt_outlined,
                  ),
                  style: TextStyle(color: context.colors.primary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
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
                          color: context.colors.primary.withValues(alpha: 0.7),
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
                                  .withValues(alpha: 0.3),
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

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.06),
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
        unselectedLabelColor: context.colors.primary.withValues(alpha: 0.6),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: [
          _tabBadge(
            'Predefined',
            _filteredField.length,
            total: widget.fieldDefinedLocations.length,
          ),
          _tabBadge(
            'Recent',
            _filteredSaved.length,
            total: _savedLocations.length,
          ),
          _tabBadge(
            'All',
            _filteredAll.length,
            total: widget.fieldDefinedLocations.length + _savedLocations.length,
          ),
        ],
      ),
    );
  }

  Tab _tabBadge(String label, int filtered, {required int total}) {
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
              color: context.colors.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 8),
            Text(
              emptyText,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary.withValues(alpha: 0.4),
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
                  '${items.length} '
                  '${items.length == 1 ? _noun : _nounPlural}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withValues(alpha: 0.45),
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
              final isSel = _selected == loc;
              final isSavedItem = isFromSaved || _savedLocations.contains(loc);
              return Material(
                color:
                    isSel
                        ? context.colors.primary.withValues(alpha: 0.08)
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
                          isSel ? _itemIconSel : _itemIconUnsel,
                          size: 18,
                          color:
                              isSel
                                  ? context.colors.primary
                                  : context.colors.primary.withValues(
                                    alpha: 0.4,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            loc,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(
                                  color: context.colors.primary,
                                  fontWeight:
                                      isSel
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isFromSaved && _savedLocations.contains(loc))
                          _sourceBadge(context, 'recent'),
                        if (isSel)
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
                                color: context.colors.primary.withValues(
                                  alpha: 0.35,
                                ),
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
        color: context.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: context.colors.primary.withValues(alpha: 0.6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildClearAllBtn(BuildContext context) {
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

  InputDecoration _inputDeco(
    BuildContext context, {
    required String hint,
    required IconData prefixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: context.colors.primary.withValues(alpha: 0.3),
      ),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: context.colors.primary.withValues(alpha: 0.4),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: context.colors.primary.withValues(alpha: 0.5),
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

// ─────────────────────────────────────────────────────────────────────────────
// CategorySelectionDialog
// ─────────────────────────────────────────────────────────────────────────────

class CategorySelectionDialog extends StatefulWidget {
  final Function(CategoryItem) onCategorySelected;
  final CategoryItem? selectedCategory;

  const CategorySelectionDialog({
    super.key,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
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
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
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
                        children: [
                          Text(
                            provider.errorMessage!,
                            style: context.topology.textTheme.bodyMedium
                                ?.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.refresh(),
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
                            : 'No categories matching '
                                '"${_searchController.text}"',
                        style: context.topology.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.totalItemCount,
                    itemBuilder: (context, index) {
                      final cat = provider.getCategoryByIndex(index);
                      if (cat == null) {
                        return const SizedBox.shrink();
                      }
                      return _buildCatItem(context, provider, cat);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      _tempSelected != null
                          ? () {
                            widget.onCategorySelected(_tempSelected!);
                            Navigator.of(context).pop();
                          }
                          : null,
                  child: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatItem(
    BuildContext context,
    CategoryProvider provider,
    CategoryItem category,
  ) {
    final isSel = _tempSelected?.id == category.id;
    return GestureDetector(
      onTap: () {
        if (category.children.isNotEmpty) {
          provider.toggleExpansion(category);
        }
        setState(() => _tempSelected = category);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isSel
                  ? context.colors.primary.withValues(alpha: 0.1)
                  : _bgColor(context, category),
          borderRadius: BorderRadius.circular(4),
          border:
              isSel
                  ? Border.all(color: context.colors.primary, width: 1)
                  : null,
        ),
        margin: EdgeInsets.only(left: category.level * 16.0, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child:
                  category.children.isNotEmpty
                      ? Icon(
                        category.isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: context.colors.primary,
                        size: 18,
                      )
                      : _indentIcon(category.level),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSel ? context.colors.primary : Colors.grey,
                  width: 2,
                ),
                color: isSel ? context.colors.primary : Colors.transparent,
              ),
              child:
                  isSel
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
                    style: _textStyle(context, category, isSel),
                  ),
                  if (category.categoryCode != null)
                    Text(
                      'Code: ${category.categoryCode}',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  if (category.description != null &&
                      category.description!.isNotEmpty)
                    Text(
                      category.description!,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (category.children.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.children.length}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _bgColor(BuildContext context, CategoryItem cat) {
    if (cat.level == 0) return Colors.transparent;
    return context.colors.primary.withValues(alpha: 0.02 + (cat.level * 0.01));
  }

  TextStyle? _textStyle(BuildContext context, CategoryItem cat, bool isSel) {
    if (cat.level == 0) {
      return context.topology.textTheme.bodyMedium?.copyWith(
        color: context.colors.primary,
        fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
      );
    }
    return context.topology.textTheme.bodySmall?.copyWith(
      color:
          isSel
              ? context.colors.primary
              : context.colors.primary.withValues(alpha: 0.8),
      fontWeight: isSel ? FontWeight.w500 : FontWeight.normal,
    );
  }

  Widget? _indentIcon(int level) {
    if (level == 0) return null;
    return Icon(
      level == 1 ? Icons.subdirectory_arrow_right : Icons.more_horiz,
      color: Colors.grey.withValues(alpha: 0.6),
      size: 14,
    );
  }
}
