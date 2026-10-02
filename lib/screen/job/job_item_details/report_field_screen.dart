import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/date_time_extension.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/report_dropdwon_options_service.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/screen/job/job_item_details/regulation_picker_dialog_widget.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

class FieldConfig {
  final String fieldId;
  final String name;
  final String label;
  final String type;
  final String? defaultValue;
  final List<String>? options;
  final String? section;
  final bool required;
  final String? infoText;

  FieldConfig({
    required this.fieldId,
    required this.name,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
    this.section,
    this.required = false,
    this.infoText,
  });
}

class ReportFieldsScreen extends StatefulWidget {
  final String reportTypeId;
  final String reportName;
  final Item item;
  final Map<String, dynamic>? reportData;
  final bool isViewMode;
  final bool isCopyMode;
  final bool isEditMode;

  const ReportFieldsScreen({
    required this.reportTypeId,
    required this.reportName,
    super.key,
    required this.item,
    this.reportData,
    this.isViewMode = false,
    this.isCopyMode = false,
    this.isEditMode = false,
  });

  @override
  State<ReportFieldsScreen> createState() => _ReportFieldsScreenState();
}

class _ReportFieldsScreenState extends State<ReportFieldsScreen> {
  Map<String, dynamic> _fieldValues = {};
  Map<String, TextEditingController> _controllers = {};
  Map<String, FileUploadController> _fileControllers = {};

  List<FieldConfig> _fields = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  DateTime? _selectedReportDate;

  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _itemNoController = TextEditingController();
  final TextEditingController _regulationController = TextEditingController();
  String? _selectedInspectedById;
  String _viewInspectedByName = '';

  Map<String, List<String>> _localDropdownOptions = {};

  // ---------------------------------------------------------------------------
  // Checkbox list value converters
  // Internal state:  'pass' / 'fail' / 'na'
  // API format:      'true' / 'false' / 'N/A'
  // ---------------------------------------------------------------------------

  /// Internal toggle value → API string sent to server.
  String _toApiCheckboxValue(String? v) {
    switch (v) {
      case 'pass':
        return 'true';
      case 'fail':
        return 'false';
      case 'na':
        return 'N/A';
      default:
        return '';
    }
  }

  /// API string → internal toggle value (used when loading saved data).
  String? _fromApiCheckboxValue(String? apiVal) {
    if (apiVal == 'true') return 'pass';
    if (apiVal == 'false') return 'fail';
    if (apiVal == 'N/A') return 'na';
    // Already internal (e.g. re-loading a local draft)
    if (apiVal == 'pass' || apiVal == 'fail' || apiVal == 'na') return apiVal;
    return null;
  }

  @override
  void initState() {
    super.initState();

    _itemIdController.text = widget.item.itemId ?? '';
    _itemNoController.text = widget.item.itemNo ?? '';

    _localDropdownOptions = ReportDropdownOptionsService.load(
      reportTypeId: widget.reportTypeId,
      reportName: widget.reportName,
    );

    if ((widget.isViewMode || widget.isCopyMode || widget.isEditMode) &&
        widget.reportData != null) {
      final d = widget.reportData!;
      _regulationController.text = d['regulation']?.toString() ?? '';

      if (widget.isViewMode || widget.isEditMode) {
        final rawDate = d['reportDate'] ?? d['createdAt'];
        if (rawDate != null && rawDate.toString().isNotEmpty) {
          try {
            _selectedReportDate = DateTime.parse(rawDate.toString());
          } catch (_) {}
        }
      }

      _viewInspectedByName = d['inspectedBy']?.toString() ?? '';
    }

    _fetchReportFields();
    Future.microtask(() async {
      await context.read<PersonnelProvider>().fetchPersonnel();
      context.read<SystemProvider>().fetchRegulations();
      if ((widget.isViewMode || widget.isCopyMode || widget.isEditMode) &&
          widget.reportData != null) {
        _resolveInspectorName();
      }
    });
  }

  String _key(FieldConfig field) => field.fieldId;

  void _resolveInspectorName() {
    final reportData = widget.reportData!;
    final inspectedById = reportData['inspectedById']?.toString() ?? '';
    final inspectedByRaw = reportData['inspectedBy']?.toString() ?? '';

    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    final provider = context.read<PersonnelProvider>();

    if (inspectedById.isNotEmpty && uuidRegex.hasMatch(inspectedById)) {
      final personnel = provider.getPersonnelById(inspectedById);
      if (personnel != null) {
        final name =
            personnel.displayName?.isNotEmpty == true
                ? personnel.displayName!
                : personnel.fullName ?? inspectedById;
        if (mounted) {
          setState(() {
            _viewInspectedByName = name;
            if (widget.isCopyMode || widget.isEditMode) {
              _selectedInspectedById = inspectedById;
            }
          });
        }
        return;
      }
    }

    if (inspectedByRaw.isNotEmpty && uuidRegex.hasMatch(inspectedByRaw)) {
      final personnel = provider.getPersonnelById(inspectedByRaw);
      if (personnel != null) {
        final name =
            personnel.displayName?.isNotEmpty == true
                ? personnel.displayName!
                : personnel.fullName ?? inspectedByRaw;
        if (mounted) {
          setState(() {
            _viewInspectedByName = name;
            if (widget.isCopyMode || widget.isEditMode) {
              _selectedInspectedById = inspectedByRaw;
            }
          });
        }
        return;
      }
    }

    if (inspectedByRaw.isNotEmpty && !uuidRegex.hasMatch(inspectedByRaw)) {
      if (mounted) setState(() => _viewInspectedByName = inspectedByRaw);
    }
  }

  Future<void> _fetchReportFields() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<SystemProvider>();

      List<dynamic> rawFields = [];
      final result = await provider.getReportFields(widget.reportTypeId);
      if (result != null) {
        final dynamic data = result['data'] ?? result;
        if (data is List) {
          rawFields = data;
        } else if (data is Map<String, dynamic>) {
          final fields = data['reportFields'] ?? data['fields'];
          if (fields is List) rawFields = fields;
        }
      }

      List<FieldConfig> parsedFields = [];
      for (var item in rawFields) {
        if (item is Map<String, dynamic>) {
          parsedFields.add(_parseFieldConfig(item));
        } else if (item is String && item.isNotEmpty) {
          parsedFields.add(
            FieldConfig(
              fieldId: item.trim(),
              name: item.trim(),
              label: item.trim(),
              type: 'text',
            ),
          );
        }
      }

      final savedReportData =
          ((widget.isViewMode || widget.isCopyMode || widget.isEditMode) &&
                  widget.reportData != null)
              ? widget.reportData!['reportData'] as Map<String, dynamic>?
              : null;

      final savedFieldValues =
          ((widget.isViewMode || widget.isCopyMode || widget.isEditMode) &&
                  widget.reportData != null)
              ? widget.reportData!['fieldValues'] as Map<String, dynamic>?
              : null;

      setState(() {
        _fields = parsedFields;

        for (final field in _fields) {
          final k = _key(field);

          final labelKey = field.label.isNotEmpty ? field.label : field.name;

          final rawEntry = savedReportData?[labelKey];
          final flatEntry =
              savedFieldValues?[labelKey] ??
              savedFieldValues?[field.name] ??
              savedFieldValues?[k];

          String? savedValue;
          if (rawEntry is Map<String, dynamic>) {
            final type = rawEntry['type']?.toString() ?? '';
            if (type != 'image') {
              savedValue = rawEntry['value']?.toString();
            }
          } else if (flatEntry != null && flatEntry is! Map) {
            savedValue = flatEntry?.toString();
          }

          switch (field.type) {
            case 'text':
            case 'textarea':
            case 'number':
              _controllers[k] = TextEditingController(
                text: savedValue ?? field.defaultValue ?? '',
              );
              break;

            case 'dropdown':
              final options = field.options ?? [];
              final initial = _resolveDropdownValue(
                stored: savedValue,
                defaultValue: field.defaultValue,
                options: options,
              );
              _fieldValues[k] = initial;
              break;

            case 'checkbox':
              _fieldValues[k] =
                  savedValue != null
                      ? savedValue == 'true'
                      : field.defaultValue == 'true';
              break;

            case 'date':
              if (savedValue != null && savedValue.isNotEmpty) {
                try {
                  _fieldValues[k] = DateTime.parse(savedValue);
                } catch (_) {
                  _fieldValues[k] = null;
                }
              } else {
                _fieldValues[k] = null;
              }
              break;

            case 'checkbox_list':
              final opts = field.options ?? [];
              final Map<String, String?> initialMap = {};

              if (opts.isEmpty) {
                String? apiSingle;
                if (rawEntry is Map<String, dynamic>) {
                  apiSingle = rawEntry['value']?.toString();
                }
                initialMap['_single'] = _fromApiCheckboxValue(apiSingle);
              } else {
                for (final opt in opts) {
                  String? apiVal;

                  if (rawEntry is Map<String, dynamic>) {
                    final nestedValue = rawEntry['value'];
                    if (nestedValue is Map<String, dynamic>) {
                      apiVal = nestedValue[opt]?.toString();
                    } else if (nestedValue is String) {
                      apiVal = nestedValue;
                    }
                  }

                  if (apiVal == null) {
                    final optKey = '${labelKey}_$opt';
                    apiVal =
                        savedFieldValues?[optKey]?.toString() ??
                        savedFieldValues?['${field.name}_$opt']?.toString() ??
                        savedFieldValues?['${k}_$opt']?.toString();
                  }

                  initialMap[opt] = _fromApiCheckboxValue(apiVal);
                }
              }
              _fieldValues[k] = initialMap;
              break;

            case 'file':
              _fileControllers[k] = FileUploadController();

              Map<String, dynamic>? imageMap;

              if (rawEntry is Map<String, dynamic> &&
                  rawEntry['type'] == 'image') {
                final imageBlock = rawEntry['image'] as Map<String, dynamic>?;

                // Always use fileUrl from image block, ignore 'value' (it has duplicate path bug)
                final fileUrl = imageBlock?['fileUrl']?.toString() ?? '';
                final fileName =
                    imageBlock?['fileName']?.toString() ?? labelKey;

                if (fileUrl.isNotEmpty) {
                  imageMap = {
                    'type': 'image',
                    'url': fileUrl,
                    'fileUrl': fileUrl,
                    'fileName': fileName,
                  };
                }
              } else if (flatEntry is Map<String, dynamic> &&
                  flatEntry['type'] == 'image') {
                imageMap = flatEntry;
              }

              _fieldValues[k] = imageMap;

              break;
          }
        }

        _isLoading = false;
      });

      await _loadOfflineImages();
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('not found') ||
          msg.contains('no data') ||
          msg.contains('404')) {
        setState(() {
          _fields = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String? _resolveDropdownValue({
    required String? stored,
    required String? defaultValue,
    required List<String> options,
  }) {
    if (options.isEmpty) return null;
    if (stored != null && options.contains(stored)) return stored;
    if (defaultValue != null && options.contains(defaultValue))
      return defaultValue;
    return options.first;
  }

  FieldConfig _parseFieldConfig(Map<String, dynamic> data) {
    final fieldId =
        (data['reportFieldID'] ??
                data['id'] ??
                data['fieldId'] ??
                '${data['labelText']}_${DateTime.now().microsecondsSinceEpoch}')
            .toString();

    final rawType =
        (data['fieldType'] ?? data['type'] ?? data['field_type'] ?? 'text')
            .toString();
    final fieldType = _normaliseFieldType(rawType);

    final fieldLabel =
        (data['labelText'] ?? data['label'] ?? data['name'] ?? '').toString();
    final fieldName = (data['name'] ?? data['labelText'] ?? '').toString();

    String? defaultValue;
    List<String>? options;

    final rawDefault = data['defaultValue'];

    if (rawDefault is Map<String, dynamic>) {
      final val = rawDefault['value'];
      if (val != null && val is! Map && val is! List) {
        defaultValue = val.toString();
      }
      if (fieldType == 'dropdown' || fieldType == 'checkbox_list') {
        final rawOptions = rawDefault['options'];
        if (rawOptions is List && rawOptions.isNotEmpty) {
          options =
              rawOptions
                  .map((e) => e.toString().trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
          if (options.isNotEmpty && fieldType == 'dropdown') {
            defaultValue ??= options.first;
          }
        }
      }
    } else if (rawDefault != null && rawDefault is! List) {
      defaultValue = rawDefault.toString();
    }

    if ((fieldType == 'dropdown' || fieldType == 'checkbox_list') &&
        (options == null || options.isEmpty)) {
      final rawOpts = data['options'];
      if (rawOpts is List && rawOpts.isNotEmpty) {
        options =
            rawOpts
                .map((e) => e.toString().trim())
                .where((s) => s.isNotEmpty)
                .toList();
        if (options.isNotEmpty && fieldType == 'dropdown') {
          defaultValue ??= options.first;
        }
      }
    }

    if (fieldType == 'dropdown' && (options == null || options.isEmpty)) {
      final rawOptsStr = data['options']?.toString() ?? '';
      if (rawOptsStr.isNotEmpty) {
        final parsed =
            rawOptsStr
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
        if (parsed.isNotEmpty) {
          options = parsed;
          defaultValue ??= options.first;
        }
      }
    }

    if ((fieldType == 'dropdown' || fieldType == 'checkbox_list') &&
        (options == null || options.isEmpty) &&
        fieldLabel.isNotEmpty) {
      final localOpts =
          _localDropdownOptions[fieldLabel] ?? _localDropdownOptions[fieldName];
      if (localOpts != null && localOpts.isNotEmpty) {
        options = localOpts;
        if (fieldType == 'dropdown') defaultValue ??= options.first;
      }
    }

    if (fieldType == 'dropdown' &&
        (options == null || options.isEmpty) &&
        (defaultValue?.contains(',') == true)) {
      final parsed =
          defaultValue!
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
      if (parsed.isNotEmpty) {
        options = parsed;
        defaultValue = options.first;
      }
    }

    return FieldConfig(
      fieldId: fieldId,
      name: fieldName.isNotEmpty ? fieldName : fieldLabel,
      label: fieldLabel,
      type: fieldType,
      defaultValue: defaultValue,
      options: options,
      section: data['section']?.toString(),
      required:
          data['isRequired'] == true ||
          data['required'] == true ||
          data['required'] == 'true',
      infoText: (data['info_text'] ?? data['infoText'])?.toString(),
    );
  }

  String _normaliseFieldType(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'text':
        return 'text';
      case 'number':
      case 'integer':
      case 'int':
        return 'number';
      case 'decimal':
      case 'float':
      case 'double':
        return 'decimal';
      case 'date':
      case 'datetime':
        return 'date';
      case 'checkbox':
      case 'bool':
      case 'boolean':
        return 'checkbox';
      case 'dropdown':
      case 'select':
      case 'enum':
        return 'dropdown';
      case 'textarea':
      case 'text_area':
      case 'multiline':
        return 'textarea';
      case 'file':
      case 'upload':
      case 'attachment':
      case 'image':
        return 'file';
      case 'label':
        return 'label';
      case 'section':
        return 'section';
      case 'checkbox_list':
      case 'checklist':
      case 'check_list':
        return 'checkbox_list';
      default:
        return 'text';
    }
  }

  Future<void> _loadOfflineImages() async {
    final reportId = widget.reportData?['reportId']?.toString() ?? '';
    if (reportId.isEmpty) return;
    if (!reportId.startsWith('offline_') &&
        widget.reportData?['isPending'] != true)
      return;

    final storedFiles = JobItemStorage.loadReportFiles(reportId);
    if (storedFiles.isEmpty) return;

    final loadLabelCount = <String, int>{};

    for (final field in _fields) {
      if (field.type != 'file') continue;
      final k = _key(field);

      final baseLabel = field.label.isNotEmpty ? field.label : field.name;
      loadLabelCount[baseLabel] = (loadLabelCount[baseLabel] ?? 0) + 1;
      final lookupKey =
          loadLabelCount[baseLabel]! > 1
              ? '$baseLabel ${loadLabelCount[baseLabel]}'
              : baseLabel;

      final base64 =
          storedFiles[lookupKey] ?? storedFiles[field.name] ?? storedFiles[k];
      if (base64 == null || base64.isEmpty) continue;

      try {
        final pipeIdx = base64.indexOf('|');
        final String filename;
        final String b64;
        if (pipeIdx > 0) {
          filename = base64.substring(0, pipeIdx);
          b64 = base64.substring(pipeIdx + 1);
        } else {
          filename = '${field.label}.jpg';
          b64 = base64;
        }
        final bytes = base64Decode(b64);
        final controller = _fileControllers[k] ?? FileUploadController();
        controller.setFile(
          PlatformFile(name: filename, size: bytes.length, bytes: bytes),
        );
        _fileControllers[k] = controller;
        debugPrint('📷 Loaded offline image for field: ${field.label}');
      } catch (e) {
        debugPrint('⚠️ Failed to load offline image ${field.label}: $e');
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    for (final fc in _fileControllers.values) fc.dispose();
    _itemIdController.dispose();
    _itemNoController.dispose();
    _regulationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildScrollableBody(),
          if (_isSubmitting) _buildSubmittingOverlay(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: context.colors.primary),
      leading: IconButton(
        onPressed: () => NavigationService().goBack(),
        icon: const Icon(Icons.chevron_left, size: 28),
      ),
      title: Column(
        children: [
          Text(
            widget.reportName,
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          if (widget.isViewMode || widget.isCopyMode || widget.isEditMode) ...[
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color:
                    widget.isCopyMode
                        ? Colors.amber.withOpacity(0.15)
                        : widget.isEditMode
                        ? Colors.green.withOpacity(0.15)
                        : Colors.blue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.isCopyMode
                    ? 'Copy Mode'
                    : widget.isEditMode
                    ? 'Edit Mode'
                    : 'View Only',
                style: TextStyle(
                  color:
                      widget.isCopyMode
                          ? Colors.amber[800]
                          : widget.isEditMode
                          ? Colors.green[800]
                          : Colors.blue[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: context.colors.primary.withOpacity(0.08),
        ),
      ),
    );
  }

  Widget _buildSubmittingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: context.colors.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                widget.isEditMode ? 'Saving changes…' : 'Submitting report…',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Scrollable body
  // ---------------------------------------------------------------------------

  Widget _buildScrollableBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.primary),
      );
    }
    if (_errorMessage != null) return _buildErrorState();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportInfoCard(),
          const SizedBox(height: 20),
          _buildSectionCard(
            icon: Icons.assignment_ind_outlined,
            title: 'Inspector Details',
            children: [
              _buildLabeledField(
                label: 'Item No',
                child:
                    widget.isViewMode
                        ? _buildReadOnlyField(_itemNoController.text)
                        : CommonTextField(
                          controller: _itemNoController,
                          hintText: 'Enter item number',
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
              ),
              const SizedBox(height: 16),
              _buildInspectedByDropdown(),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            icon: Icons.calendar_month_outlined,
            title: 'Report Details',
            children: [
              _buildLabeledField(
                label: 'Report Date',
                child:
                    widget.isViewMode
                        ? _buildReadOnlyDate()
                        : _buildDatePicker(),
              ),
              const SizedBox(height: 16),
              _buildLabeledField(
                label: 'Regulation',
                child: _buildRegulationInput(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_fields.isNotEmpty) ...[
            _buildSectionCard(
              icon: Icons.article_outlined,
              title: 'Report Fields',
              subtitle:
                  '${_fields.where((f) => f.type.toLowerCase() != 'section').length} field(s)',
              children: _buildDynamicFields(),
            ),
            const SizedBox(height: 16),
          ],
          if (_fields.isEmpty) ...[
            _buildNoFieldsHint(),
            const SizedBox(height: 16),
          ],
          if (!widget.isViewMode) _buildSubmitButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Report info card
  // ---------------------------------------------------------------------------

  Widget _buildReportInfoCard() {
    final reportLabel =
        widget.reportData != null ? _getReportLabel(widget.reportData!) : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reportName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Type ID: ${widget.reportTypeId}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isCopyMode)
                _buildWhiteChip(Icons.copy_outlined, 'Copy'),
              if (widget.isEditMode)
                _buildWhiteChip(Icons.edit_outlined, 'Edit'),
            ],
          ),
          if ((widget.isViewMode || widget.isEditMode) &&
              widget.reportData != null) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInfoTile('Report No', reportLabel)),
                if (_viewInspectedByName.isNotEmpty) ...[
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  Expanded(
                    child: _buildInfoTile('Inspector', _viewInspectedByName),
                  ),
                ],
              ],
            ),
          ],
          if (widget.isCopyMode && widget.reportData != null) ...[
            const SizedBox(height: 10),
            Text(
              'Copied from: ${_getReportLabel(widget.reportData!)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section card
  // ---------------------------------------------------------------------------

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: context.colors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.topology.textTheme.titleSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: context.colors.primary.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.colors.primary.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildReadOnlyDate() => _buildReadOnlyField(
    _selectedReportDate != null ? _selectedReportDate!.formatMediumDate : '-',
  );

  Widget _buildReadOnlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        value.isEmpty ? '—' : value,
        style: context.topology.textTheme.bodySmall?.copyWith(
          color:
              value.isEmpty
                  ? context.colors.primary.withOpacity(0.3)
                  : context.colors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colors.primary.withOpacity(0.22),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: context.colors.primary.withOpacity(0.65),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedReportDate != null
                    ? _selectedReportDate!.formatMediumDate
                    : widget.isCopyMode
                    ? 'Select new date (required)'
                    : 'Select date',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color:
                      _selectedReportDate != null
                          ? context.colors.primary
                          : widget.isCopyMode
                          ? Colors.amber[800]
                          : context.colors.primary.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.colors.primary.withOpacity(0.45),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReportDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: context.colors.primary,
                onPrimary: context.colors.onPrimary,
                onSurface: context.colors.primary,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != _selectedReportDate) {
      setState(() => _selectedReportDate = picked);
    }
  }

  Widget _buildRegulationInput() {
    if (widget.isViewMode)
      return _buildReadOnlyField(_regulationController.text);

    return InkWell(
      onTap: () async {
        await showRegulationPickerDialog(
          context: context,
          controller: _regulationController,
        );
        if (mounted) setState(() {});
      },
      borderRadius: BorderRadius.circular(12),
      child: ListenableBuilder(
        listenable: _regulationController,
        builder: (context, _) {
          final hasValue = _regulationController.text.trim().isNotEmpty;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colors.primary.withOpacity(0.22),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.gavel_outlined,
                  size: 18,
                  color: context.colors.primary.withOpacity(0.65),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasValue
                        ? _regulationController.text
                        : 'Select or enter regulation',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color:
                          hasValue
                              ? context.colors.primary
                              : context.colors.primary.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colors.primary.withOpacity(0.45),
                  size: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInspectedByDropdown() {
    if (widget.isViewMode) {
      return _buildLabeledField(
        label: 'Inspected By',
        child: _buildReadOnlyField(_viewInspectedByName),
      );
    }

    return Consumer<PersonnelProvider>(
      builder: (context, personnelProvider, _) {
        final personnelList = personnelProvider.personnelList ?? [];

        if ((widget.isCopyMode || widget.isEditMode) &&
            _selectedInspectedById == null &&
            personnelList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final reportData = widget.reportData;
            if (reportData == null) return;

            final inspectedById = reportData['inspectedById']?.toString() ?? '';
            final inspectedByRaw = reportData['inspectedBy']?.toString() ?? '';

            final uuidRegex = RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
              caseSensitive: false,
            );

            String? resolvedId;
            if (inspectedById.isNotEmpty && uuidRegex.hasMatch(inspectedById)) {
              resolvedId = inspectedById;
            } else if (inspectedByRaw.isNotEmpty &&
                uuidRegex.hasMatch(inspectedByRaw)) {
              resolvedId = inspectedByRaw;
            } else if (_viewInspectedByName.isNotEmpty) {
              try {
                final match = personnelList.firstWhere(
                  (p) =>
                      (p.displayName?.isNotEmpty == true &&
                          p.displayName == _viewInspectedByName) ||
                      (p.fullName == _viewInspectedByName),
                );
                resolvedId = match.personnel?.personnelID ?? '';
              } catch (_) {}
            }

            if (resolvedId != null &&
                resolvedId.isNotEmpty &&
                _selectedInspectedById != resolvedId) {
              setState(() => _selectedInspectedById = resolvedId);
            }
          });
        }

        if (personnelList.isEmpty) {
          return _buildLabeledField(
            label: 'Inspected By',
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber[700],
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No personnel available. Please add personnel first.',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.amber[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final items =
            personnelList.map((personnel) {
              final displayName =
                  personnel.displayName?.isNotEmpty == true
                      ? personnel.displayName!
                      : personnel.fullName ?? 'Unknown';
              final id = personnel.personnel?.personnelID ?? '';
              return DropdownMenuItem<String>(
                value: id,
                child: Text(displayName),
              );
            }).toList();

        return _buildLabeledField(
          label: 'Inspected By',
          child: CommonDropdown<String>(
            value: _selectedInspectedById,
            items: items,
            onChanged:
                (value) => setState(() => _selectedInspectedById = value),
            borderColor: context.colors.primary.withOpacity(0.22),
            backgroundColor: Colors.white,
            label: null,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Dynamic fields — grouped by section into cards
  // ---------------------------------------------------------------------------

  List<Widget> _buildDynamicFields() {
    final List<_FieldSection> sections = [];
    _FieldSection? current;

    for (final field in _fields) {
      if (field.type.toLowerCase() == 'section') {
        current = _FieldSection(name: field.label, fields: []);
        sections.add(current);
        continue;
      }

      final declaredSection =
          (field.section?.trim().isNotEmpty == true)
              ? field.section!.trim()
              : null;

      if (declaredSection != null) {
        if (current == null || current.name != declaredSection) {
          final existing =
              sections.where((s) => s.name == declaredSection).firstOrNull;
          if (existing != null) {
            current = existing;
          } else {
            current = _FieldSection(name: declaredSection, fields: []);
            sections.add(current);
          }
        }
        current.fields.add(field);
      } else {
        if (current == null || current.name.isNotEmpty) {
          final ungrouped = sections.where((s) => s.name.isEmpty).firstOrNull;
          if (ungrouped != null) {
            current = ungrouped;
          } else {
            current = _FieldSection(name: '', fields: []);
            sections.add(current);
          }
        }
        current.fields.add(field);
      }
    }

    final widgets = <Widget>[];
    for (final section in sections) {
      if (section.fields.isEmpty) continue;
      if (section.name.isEmpty) {
        for (final field in section.fields) {
          widgets.add(_buildFieldItem(field));
        }
      } else {
        widgets.add(_buildSectionGroup(section));
        widgets.add(const SizedBox(height: 16));
      }
    }
    return widgets;
  }

  Widget _buildSectionGroup(_FieldSection section) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary.withOpacity(0.07),
                  context.colors.primary.withOpacity(0.03),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: context.colors.primary.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder_open_rounded,
                    size: 16,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.name,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${section.fields.length} field${section.fields.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  section.fields.asMap().entries.map((entry) {
                    final isLast = entry.key == section.fields.length - 1;
                    return Column(
                      children: [
                        _buildFieldItem(entry.value, insideSection: true),
                        if (!isLast) ...[
                          const SizedBox(height: 4),
                          Divider(
                            height: 1,
                            color: context.colors.primary.withOpacity(0.06),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(FieldConfig field, {bool insideSection = false}) {
    final k = _key(field);
    return Padding(
      padding: EdgeInsets.only(bottom: insideSection ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label,
                  style: TextStyle(
                    color: context.colors.primary.withOpacity(
                      insideSection ? 0.75 : 0.6,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (field.required)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Required',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (field.infoText != null && field.infoText!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 13, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    field.infoText!,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          _buildFieldWidget(field, k),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Field widgets
  // ---------------------------------------------------------------------------

  Widget _buildFieldWidget(FieldConfig field, String k) {
    if (widget.isViewMode) {
      switch (field.type.toLowerCase()) {
        case 'text':
        case 'textarea':
        case 'number':
          return _buildReadOnlyField(_controllers[k]?.text ?? '-');
        case 'dropdown':
          return _buildReadOnlyField(_fieldValues[k]?.toString() ?? '-');
        case 'checkbox':
          return _buildReadOnlyField((_fieldValues[k] == true) ? 'Yes' : 'No');
        case 'date':
          final d = _fieldValues[k] as DateTime?;
          return _buildReadOnlyField(d != null ? d.formatMediumDate : '-');
        case 'file':
          return _buildFileViewPreview(k);
        case 'checkbox_list':
          return _buildCheckboxListView(k, field.options ?? []);
        default:
          return _buildReadOnlyField(_controllers[k]?.text ?? '-');
      }
    }

    switch (field.type.toLowerCase()) {
      case 'text':
      case 'number':
        return CommonTextField(
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
          controller: _controllers[k],
          hintText: 'Enter ${field.label.toLowerCase()}',
          keyboardType:
              field.type == 'number'
                  ? TextInputType.number
                  : TextInputType.text,
        );
      case 'textarea':
        return CommonTextField(
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
          controller: _controllers[k],
          hintText: 'Enter ${field.label.toLowerCase()}',
          maxLines: 4,
        );
      case 'dropdown':
        return _buildCustomDropdown(field, k);
      case 'checkbox':
        return _buildCheckbox(field, k);
      case 'date':
        return _buildDateField(field, k);
      case 'file':
        return _buildFileField(field, k);
      case 'label':
        return _buildLabelField(field);
      case 'checkbox_list':
        return _buildCheckboxListField(field, k);
      default:
        return CommonTextField(
          controller: _controllers[k],
          hintText: 'Enter ${field.label.toLowerCase()}',
        );
    }
  }

  Widget _buildCustomDropdown(FieldConfig field, String k) {
    final options = field.options ?? [];
    if (options.isEmpty) {
      return CommonTextField(
        controller: TextEditingController(),
        hintText: 'No options available',
        enabled: false,
      );
    }
    final resolved = _resolveDropdownValue(
      stored: _fieldValues[k]?.toString(),
      defaultValue: field.defaultValue,
      options: options,
    );
    if (_fieldValues[k] != resolved) _fieldValues[k] = resolved;

    return CommonDropdown<String>(
      textStyle: context.topology.textTheme.bodySmall?.copyWith(
        color: context.colors.primary,
      ),
      value: resolved,
      items:
          options
              .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
              .toList(),
      onChanged: (value) => setState(() => _fieldValues[k] = value),
      borderColor: context.colors.primary.withOpacity(0.22),
      backgroundColor: Colors.white,
      label: null,
    );
  }

  Widget _buildCheckbox(FieldConfig field, String k) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.primary.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          field.label,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
        value: _fieldValues[k] ?? false,
        onChanged: (v) => setState(() => _fieldValues[k] = v ?? false),
        activeColor: context.colors.primary,
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDateField(FieldConfig field, String k) {
    final selectedDate = _fieldValues[k] as DateTime?;
    return InkWell(
      onTap: () => _selectFieldDate(context, field, k),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colors.primary.withOpacity(0.22),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: context.colors.primary.withOpacity(0.65),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDate != null
                    ? selectedDate.formatMediumDate
                    : 'Select date',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color:
                      selectedDate != null
                          ? context.colors.primary
                          : context.colors.primary.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.colors.primary.withOpacity(0.45),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFieldDate(
    BuildContext context,
    FieldConfig field,
    String k,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fieldValues[k] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: context.colors.primary,
                onPrimary: context.colors.onPrimary,
                onSurface: context.colors.primary,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _fieldValues[k] = picked);
  }

  Widget _buildFileField(FieldConfig field, String k) {
    final controller = _fileControllers[k];
    if (controller == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: controller,
      builder:
          (context, _) => CommonFileUploadInput(
            controller: controller,
            enableCamera: true,
            allowedExtensions: const [
              'jpg',
              'jpeg',
              'png',
              'pdf',
              'doc',
              'docx',
              'xls',
              'xlsx',
            ],
          ),
    );
  }

  // ---------------------------------------------------------------------------
  // Checkbox list field (edit mode)
  // ---------------------------------------------------------------------------

  Widget _buildCheckboxListField(FieldConfig field, String k) {
    final options = field.options ?? [];
    final hasOptions = options.isNotEmpty;

    final currentMap =
        (_fieldValues[k] as Map<String, String?>?) ?? <String, String?>{};

    Widget threeButtons(String mapKey) {
      final current = currentMap[mapKey];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn(
            icon: Icons.check,
            isActive: current == 'pass',
            activeColor: const Color(0xFF3B6D11),
            activeBg: const Color(0xFFEAF3DE),
            activeBorder: const Color(0xFF639922),
            onTap:
                () => setState(() {
                  final map = Map<String, String?>.from(currentMap);
                  map[mapKey] = map[mapKey] == 'pass' ? null : 'pass';
                  _fieldValues[k] = map;
                }),
            tooltip: 'Pass',
          ),
          const SizedBox(width: 6),
          _buildToggleBtn(
            icon: Icons.close,
            isActive: current == 'fail',
            activeColor: const Color(0xFFA32D2D),
            activeBg: const Color(0xFFFCEBEB),
            activeBorder: const Color(0xFFE24B4A),
            onTap:
                () => setState(() {
                  final map = Map<String, String?>.from(currentMap);
                  map[mapKey] = map[mapKey] == 'fail' ? null : 'fail';
                  _fieldValues[k] = map;
                }),
            tooltip: 'Fail',
          ),
          const SizedBox(width: 6),
          _buildToggleBtn(
            label: '—',
            isActive: current == 'na',
            activeColor: context.colors.primary,
            activeBg: context.colors.primary.withOpacity(0.08),
            activeBorder: context.colors.primary.withOpacity(0.35),
            onTap:
                () => setState(() {
                  final map = Map<String, String?>.from(currentMap);
                  map[mapKey] = map[mapKey] == 'na' ? null : 'na';
                  _fieldValues[k] = map;
                }),
            tooltip: 'N/A',
          ),
        ],
      );
    }

    if (!hasOptions) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colors.primary.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  field.label,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              threeButtons('_single'),
            ],
          ),
        ),
      );
    }

    return Column(
      children:
          options.map((opt) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colors.primary.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt,
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    threeButtons(opt),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildToggleBtn({
    IconData? icon,
    String? label,
    required bool isActive,
    required Color activeColor,
    required Color activeBg,
    required Color activeBorder,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    assert(
      icon != null || label != null,
      '_buildToggleBtn requires either icon or label',
    );
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? activeBg : const Color(0xFFF7F8FC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isActive
                      ? activeBorder
                      : context.colors.primary.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Center(
            child:
                icon != null
                    ? Icon(
                      icon,
                      size: 18,
                      color:
                          isActive
                              ? activeColor
                              : context.colors.primary.withOpacity(0.4),
                    )
                    : Text(
                      label!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive
                                ? activeColor
                                : context.colors.primary.withOpacity(0.4),
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Checkbox list field (view mode)
  // ---------------------------------------------------------------------------

  Widget _buildCheckboxListView(String k, List<String> options) {
    final map = (_fieldValues[k] as Map<String, String?>?) ?? {};
    final hasOptions = options.isNotEmpty;

    String? _normalise(String? val) {
      if (val == 'true') return 'pass';
      if (val == 'false') return 'fail';
      if (val == 'N/A') return 'na';
      return val;
    }

    Widget statusChip(String? rawVal) {
      final val = _normalise(rawVal);
      final chipLabel =
          val == 'pass'
              ? 'Pass'
              : val == 'fail'
              ? 'Fail'
              : val == 'na'
              ? 'N/A'
              : '-';
      final color =
          val == 'pass'
              ? const Color(0xFF3B6D11)
              : val == 'fail'
              ? const Color(0xFFA32D2D)
              : context.colors.primary.withOpacity(0.45);
      final dot =
          val == 'pass'
              ? const Color(0xFF639922)
              : val == 'fail'
              ? const Color(0xFFE24B4A)
              : context.colors.primary.withOpacity(0.3);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            chipLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      );
    }

    if (!hasOptions) {
      final val = map['_single'];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.primary.withOpacity(0.1)),
        ),
        child: Row(
          children: [const Expanded(child: SizedBox()), statusChip(val)],
        ),
      );
    }

    return Column(
      children:
          options.map((opt) {
            final val = map[opt];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colors.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  statusChip(val),
                ],
              ),
            );
          }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // File/image view preview
  // ---------------------------------------------------------------------------

  Widget _buildFileViewPreview(String k) {
    final fieldVal = _fieldValues[k];
    if (fieldVal is Map<String, dynamic> && fieldVal['type'] == 'image') {
      final url = fieldVal['url']?.toString() ?? '';
      final fileUrl = fieldVal['fileUrl']?.toString() ?? '';
      final fileName = fieldVal['fileName']?.toString() ?? 'Image';
      final displayUrl = url.isNotEmpty ? url : fileUrl;

      if (displayUrl.isNotEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: context.colors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: Image.network(
                    displayUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: context.colors.primary,
                            strokeWidth: 2,
                            value:
                                progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                color: Colors.red[300],
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    final fc = _fileControllers[k];
    if (fc == null || !fc.hasFile) return _buildReadOnlyField('-');

    final fileName = fc.fileName;
    final extension = fileName.split('.').last.toLowerCase();
    final isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
    ].contains(extension);

    Widget? imageWidget;
    if (isImage) {
      if (fc.imageFile != null && !kIsWeb) {
        imageWidget = Image.file(
          fc.imageFile!,
          width: double.infinity,
          fit: BoxFit.contain,
        );
      } else if (fc.pickedFile?.bytes != null) {
        imageWidget = Image.memory(
          fc.pickedFile!.bytes!,
          width: double.infinity,
          fit: BoxFit.contain,
        );
      } else if (!kIsWeb && fc.pickedFile?.path != null) {
        imageWidget = Image.file(
          File(fc.pickedFile!.path!),
          width: double.infinity,
          fit: BoxFit.contain,
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                imageWidget != null
                    ? Icons.image_outlined
                    : Icons.insert_drive_file_outlined,
                color: context.colors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName.isNotEmpty ? fileName : 'File uploaded',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (imageWidget != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: imageWidget,
              ),
            ),
          ],
          if (imageWidget == null && fileName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'File attached',
              style: TextStyle(
                color: context.colors.primary.withOpacity(0.4),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabelField(FieldConfig field) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              field.infoText ?? field.label,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFieldsHint() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'No custom fields defined for this report type. You can submit with the required information above.',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.blue[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 36,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to Load Fields',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchReportFields,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit button
  // ---------------------------------------------------------------------------

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : () async => await _handleSubmit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          disabledBackgroundColor: context.colors.primary.withOpacity(0.45),
          elevation: 4,
          shadowColor: context.colors.primary.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isCopyMode
                  ? Icons.copy_outlined
                  : widget.isEditMode
                  ? Icons.save_outlined
                  : Icons.check_circle_outline,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              _isSubmitting
                  ? widget.isEditMode
                      ? 'Saving…'
                      : 'Submitting…'
                  : widget.isCopyMode
                  ? 'Submit Copy'
                  : widget.isEditMode
                  ? 'Save Changes'
                  : 'Submit Report',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Handle submit — validates then branches to create or update
  // ---------------------------------------------------------------------------

  Future<void> _handleSubmit() async {
    if (_selectedReportDate == null) {
      _showErrorSnackBar(
        widget.isCopyMode
            ? 'Please select a new report date for this copy'
            : 'Please select a report date',
      );
      return;
    }
    if (_itemIdController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter Item ID');
      return;
    }
    if (_itemNoController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter Item No');
      return;
    }
    if (_selectedInspectedById == null || _selectedInspectedById!.isEmpty) {
      _showErrorSnackBar('Please select an inspector');
      return;
    }
    if (_regulationController.text.trim().isEmpty) {
      _showErrorSnackBar('Please select or enter a regulation');
      return;
    }

    for (final field in _fields) {
      if (!field.required) continue;
      final k = _key(field);
      switch (field.type) {
        case 'text':
        case 'textarea':
        case 'number':
          if (_controllers[k]?.text.trim().isEmpty ?? true) {
            _showErrorSnackBar('Please enter ${field.label}');
            return;
          }
          break;
        case 'dropdown':
          if (_fieldValues[k] == null) {
            _showErrorSnackBar('Please select ${field.label}');
            return;
          }
          break;
        case 'date':
          if (_fieldValues[k] == null) {
            _showErrorSnackBar('Please select ${field.label}');
            return;
          }
          break;
        case 'file':
          if (_fileControllers[k]?.hasFile != true) {
            _showErrorSnackBar('Please upload ${field.label}');
            return;
          }
          break;
        case 'checkbox_list':
          final map = _fieldValues[k] as Map<String, String?>? ?? {};
          final hasAny = map.values.any((v) => v != null);
          if (!hasAny) {
            _showErrorSnackBar(
              'Please select at least one option for ${field.label}',
            );
            return;
          }
          break;
      }
    }

    // Build flat fieldValues map (internal format: pass/fail/na).
    final Map<String, String> fieldValues = {};
    final Map<String, PlatformFile> pickedFiles = {};
    final labelCount = <String, int>{};

    for (final field in _fields) {
      if (field.type.toLowerCase() == 'section' || field.name.trim().isEmpty)
        continue;
      final k = _key(field);

      final baseLabel = field.label.isNotEmpty ? field.label : field.name;
      labelCount[baseLabel] = (labelCount[baseLabel] ?? 0) + 1;
      final payloadKey =
          labelCount[baseLabel]! > 1
              ? '$baseLabel ${labelCount[baseLabel]}'
              : baseLabel;

      switch (field.type) {
        case 'text':
        case 'textarea':
        case 'number':
          fieldValues[payloadKey] = _controllers[k]?.text ?? '';
          break;
        case 'dropdown':
          fieldValues[payloadKey] = _fieldValues[k]?.toString() ?? '';
          break;
        case 'checkbox':
          fieldValues[payloadKey] = (_fieldValues[k] ?? false).toString();
          break;
        case 'date':
          final date = _fieldValues[k] as DateTime?;
          fieldValues[payloadKey] = date?.toIso8601String() ?? '';
          break;
        case 'file':
          final fc = _fileControllers[k];
          if (fc != null && fc.hasFile && fc.pickedFile != null) {
            fieldValues['${payloadKey}_filename'] = fc.fileName;
            fieldValues[payloadKey] = 'file_uploaded';
            pickedFiles[payloadKey] = fc.pickedFile!;
          } else {
            fieldValues[payloadKey] = '';
          }
          break;
        case 'checkbox_list':
          final map = _fieldValues[k] as Map<String, String?>? ?? {};
          map.forEach((opt, val) {
            if (val != null) {
              fieldValues['${payloadKey}_$opt'] = val;
            }
          });
          break;
      }
    }

    final personnelProvider = context.read<PersonnelProvider>();
    final selectedPersonnel = personnelProvider.getPersonnelById(
      _selectedInspectedById!,
    );
    final inspectedByName =
        selectedPersonnel?.displayName?.isNotEmpty == true
            ? selectedPersonnel!.displayName!
            : selectedPersonnel?.fullName ?? 'Unknown';
    final inspectedById =
        selectedPersonnel?.personnel?.personnelID ?? _selectedInspectedById!;

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.isEditMode
                        ? Icons.edit_outlined
                        : Icons.fact_check_outlined,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.isCopyMode
                      ? 'Confirm Copy'
                      : widget.isEditMode
                      ? 'Confirm Changes'
                      : 'Confirm Submit',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isCopyMode)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy_outlined,
                            size: 15,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This is a copy with a new date.',
                              style: TextStyle(
                                color: Colors.amber[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.isEditMode)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 15,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This will overwrite the existing report.',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _buildConfirmRow(
                    'Report Date',
                    _selectedReportDate!.formatMediumDate,
                  ),
                  _buildConfirmRow('Item ID', _itemIdController.text),
                  _buildConfirmRow('Item No', _itemNoController.text),
                  _buildConfirmRow('Inspected By', inspectedByName),
                  _buildConfirmRow('Regulation', _regulationController.text),
                  if (fieldValues.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Field Values',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.colors.primary,
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildConfirmFieldRows(fieldValues),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: context.colors.primary.withOpacity(0.6),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Branch: edit → update, otherwise → create/copy
                  if (widget.isEditMode) {
                    _updateReportData(fieldValues, pickedFiles, inspectedById);
                  } else {
                    _submitReportData(fieldValues, pickedFiles, inspectedById);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.isCopyMode
                      ? 'Submit Copy'
                      : widget.isEditMode
                      ? 'Save Changes'
                      : 'Submit',
                ),
              ),
            ],
          ),
    );
  }

  List<Widget> _buildConfirmFieldRows(Map<String, String> fieldValues) {
    final rows = <Widget>[];
    final labelCount = <String, int>{};

    for (final field in _fields) {
      if (field.type.toLowerCase() == 'section' || field.name.trim().isEmpty)
        continue;

      final baseLabel = field.label.isNotEmpty ? field.label : field.name;
      labelCount[baseLabel] = (labelCount[baseLabel] ?? 0) + 1;
      final payloadKey =
          labelCount[baseLabel]! > 1
              ? '$baseLabel ${labelCount[baseLabel]}'
              : baseLabel;

      if (field.type == 'checkbox_list') {
        final opts =
            (field.options?.isNotEmpty == true)
                ? field.options!
                : const ['_single'];
        final summaryParts = <String>[];
        for (final opt in opts) {
          final val = fieldValues['${payloadKey}_$opt'];
          if (val != null) {
            final symbol =
                val == 'pass'
                    ? '✓'
                    : val == 'fail'
                    ? '✗'
                    : val == 'na'
                    ? '—'
                    : '?';
            final displayOpt = opt == '_single' ? field.label : opt;
            summaryParts.add('$displayOpt: $symbol');
          }
        }
        if (summaryParts.isNotEmpty) {
          rows.add(_buildConfirmRow(field.label, summaryParts.join('  ')));
        }
        continue;
      }

      final rawVal = fieldValues[payloadKey] ?? '';
      if (rawVal.isEmpty) continue;

      if (rawVal == 'file_uploaded') {
        final fn = fieldValues['${payloadKey}_filename'] ?? '';
        if (fn.isNotEmpty) rows.add(_buildConfirmRow(field.label, '📎 $fn'));
      } else {
        rows.add(_buildConfirmRow(field.label, rawVal));
      }
    }
    return rows;
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.colors.primary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit report data (POST — create new / copy)
  // ---------------------------------------------------------------------------

  Future<void> _submitReportData(
    Map<String, String> fieldValues,
    Map<String, PlatformFile> pickedFiles,
    String inspectedById,
  ) async {
    setState(() => _isSubmitting = true);

    try {
      final connectivity = await Connectivity().checkConnectivity();
      final isOnline = connectivity.any((r) => r != ConnectivityResult.none);

      if (!isOnline) {
        await _saveReportOffline(
          fieldValues,
          inspectedById,
          pickedFiles: pickedFiles,
        );
        return;
      }

      final reportDateISO = _selectedReportDate!.toUtc().toIso8601String();

      final wrappedFieldValues = <String, dynamic>{};
      final labelCount = <String, int>{};

      for (final field in _fields) {
        if (field.type.toLowerCase() == 'section' || field.name.trim().isEmpty)
          continue;

        final baseLabel = field.label.isNotEmpty ? field.label : field.name;
        labelCount[baseLabel] = (labelCount[baseLabel] ?? 0) + 1;
        final label =
            labelCount[baseLabel]! > 1
                ? '$baseLabel ${labelCount[baseLabel]}'
                : baseLabel;

        if (field.type == 'checkbox_list') {
          final map = _fieldValues[_key(field)] as Map<String, String?>? ?? {};
          final isSingle = map.length == 1 && map.containsKey('_single');

          if (isSingle) {
            wrappedFieldValues[label] = {
              'value': _toApiCheckboxValue(map['_single']),
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          } else {
            final optMap = <String, String>{};
            map.forEach((opt, val) {
              if (val != null) optMap[opt] = _toApiCheckboxValue(val);
            });
            wrappedFieldValues[label] = {
              'value': optMap,
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          }
          continue;
        }

        if (!fieldValues.containsKey(label)) continue;

        if (field.type == 'file') {
          final filename = fieldValues['${label}_filename'] ?? '';
          wrappedFieldValues[label] = {
            'value': filename,
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': 'image',
          };
        } else {
          wrappedFieldValues[label] = {
            'value': fieldValues[label],
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': field.type,
          };
        }
      }

      final Map<String, PlatformFile> labeledFiles = {};
      final tempLabelCount = <String, int>{};

      for (final field in _fields) {
        if (field.type != 'file') continue;

        final baseLabel = field.label.isNotEmpty ? field.label : field.name;
        tempLabelCount[baseLabel] = (tempLabelCount[baseLabel] ?? 0) + 1;
        final label =
            tempLabelCount[baseLabel]! > 1
                ? '$baseLabel ${tempLabelCount[baseLabel]}'
                : baseLabel;

        if (!pickedFiles.containsKey(label)) continue;
        labeledFiles[label] = pickedFiles[label]!;
      }

      final payload = <String, dynamic>{
        'reportTypeID': widget.reportTypeId,
        'itemID': widget.item.itemId ?? '',
        'itemNo': widget.item.itemNo ?? '',
        'status': 'draft',
        'inspectedBy': inspectedById,
        'reportDate': reportDateISO,
        'regulation': _regulationController.text.trim(),
        'reportData': wrappedFieldValues,
        if (widget.isCopyMode && widget.reportData != null)
          'copiedFromReportId':
              widget.reportData!['reportId']?.toString() ?? '',
      };

      final systemProvider = context.read<SystemProvider>();
      final result = await systemProvider.pushReportPayload(
        payload,
        files: labeledFiles.isNotEmpty ? labeledFiles : null,
      );

      if (result == null)
        throw Exception('No response from server. Please try again.');

      final reportMap = result['report'] as Map<String, dynamic>?;
      final serverReportId =
          reportMap?['reportID']?.toString() ??
          reportMap?['reportId']?.toString() ??
          result['reportId']?.toString() ??
          result['id']?.toString() ??
          '';
      final serverReportNo =
          reportMap?['reportNo']?.toString() ??
          result['reportNo']?.toString() ??
          '';
      final pdfUrlView =
          reportMap?['pdfViewUrl']?.toString() ??
          reportMap?['pdfDownloadUrl']?.toString() ??
          result['pdfUrlView']?.toString() ??
          result['pdfViewUrl']?.toString() ??
          '';

      if (serverReportId.isEmpty)
        throw Exception('Server did not return a report ID.');

      final serverStatus =
          reportMap?['status']?.toString() ??
          result['status']?.toString() ??
          'draft';

      final localEntry = <String, dynamic>{
        'reportId': serverReportId,
        'reportNo': serverReportNo,
        'reportName': widget.reportName,
        'reportTypeId': widget.reportTypeId,
        'reportDate': reportDateISO,
        'createdAt': reportMap?['createdAt']?.toString() ?? reportDateISO,
        'status': serverStatus,
        'approvalStatus': reportMap?['approvalStatus']?.toString() ?? '',
        'inspectedBy': inspectedById,
        'inspectedById': inspectedById,
        'regulation': _regulationController.text.trim(),
        'fieldValues': fieldValues,
        'reportData': wrappedFieldValues,
        'isPending': false,
        'pdfUrlView': pdfUrlView,
        if (widget.isCopyMode && widget.reportData != null)
          'copiedFromReportId':
              widget.reportData!['reportId']?.toString() ?? '',
      };

      final itemId = widget.item.itemId ?? '';
      if (itemId.isNotEmpty) {
        final existing = await JobItemStorage.getItemReports(itemId);
        await JobItemStorage.saveItemReports(itemId, [
          ...existing,
          localEntry,
        ]);
      }

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  widget.isCopyMode
                      ? 'Report copy submitted successfully.'
                      : 'Report submitted successfully.',
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        _clearForm();
        Navigator.pop(context, true);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _openPdfViewer(serverReportId, pdfUrlView);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed:
                  () => _submitReportData(
                    fieldValues,
                    pickedFiles,
                    inspectedById,
                  ),
            ),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Update report data (PUT — edit existing)
  // ---------------------------------------------------------------------------

  Future<void> _updateReportData(
    Map<String, String> fieldValues,
    Map<String, PlatformFile> pickedFiles,
    String inspectedById,
  ) async {
    setState(() => _isSubmitting = true);

    final reportId =
        widget.reportData?['reportId']?.toString() ??
        widget.reportData?['reportID']?.toString() ??
        '';

    if (reportId.isEmpty) {
      _showErrorSnackBar('Cannot edit: report ID is missing.');
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final reportDateISO = _selectedReportDate!.toUtc().toIso8601String();

      final wrappedFieldValues = <String, dynamic>{};
      final labelCount = <String, int>{};

      for (final field in _fields) {
        if (field.type.toLowerCase() == 'section' || field.name.trim().isEmpty)
          continue;

        final baseLabel = field.label.isNotEmpty ? field.label : field.name;
        labelCount[baseLabel] = (labelCount[baseLabel] ?? 0) + 1;
        final label =
            labelCount[baseLabel]! > 1
                ? '$baseLabel ${labelCount[baseLabel]}'
                : baseLabel;

        if (field.type == 'checkbox_list') {
          final map = _fieldValues[_key(field)] as Map<String, String?>? ?? {};
          final isSingle = map.length == 1 && map.containsKey('_single');
          if (isSingle) {
            wrappedFieldValues[label] = {
              'value': _toApiCheckboxValue(map['_single']),
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          } else {
            final optMap = <String, String>{};
            map.forEach((opt, val) {
              if (val != null) optMap[opt] = _toApiCheckboxValue(val);
            });
            wrappedFieldValues[label] = {
              'value': optMap,
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          }
          continue;
        }

        if (!fieldValues.containsKey(label)) continue;

        if (field.type == 'file') {
          final filename = fieldValues['${label}_filename'] ?? '';
          wrappedFieldValues[label] = {
            'value': filename,
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': 'image',
          };
        } else {
          wrappedFieldValues[label] = {
            'value': fieldValues[label],
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': field.type,
          };
        }
      }

      // Remap files by label
      final Map<String, PlatformFile> labeledFiles = {};
      final tempLabelCount = <String, int>{};
      for (final field in _fields) {
        if (field.type != 'file') continue;
        final baseLabel = field.label.isNotEmpty ? field.label : field.name;
        tempLabelCount[baseLabel] = (tempLabelCount[baseLabel] ?? 0) + 1;
        final label =
            tempLabelCount[baseLabel]! > 1
                ? '$baseLabel ${tempLabelCount[baseLabel]}'
                : baseLabel;
        if (!pickedFiles.containsKey(label)) continue;
        labeledFiles[label] = pickedFiles[label]!;
      }

      final payload = <String, dynamic>{
        'reportTypeID': widget.reportTypeId,
        'itemID': widget.item.itemId ?? '',
        'itemNo': _itemNoController.text.trim(),
        'status': 'draft',
        'inspectedBy': inspectedById,
        'reportDate': reportDateISO,
        'regulation': _regulationController.text.trim(),
        'reportData': wrappedFieldValues,
      };

      final systemProvider = context.read<SystemProvider>();
      final result = await systemProvider.updateReportPayload(
        reportId,
        payload,
        files: labeledFiles.isNotEmpty ? labeledFiles : null,
      );

      if (result == null)
        throw Exception('No response from server. Please try again.');

      // Update local cache entry in-place
      final itemId = widget.item.itemId ?? '';
      if (itemId.isNotEmpty) {
        final existing = await JobItemStorage.getItemReports(itemId);
        final updated =
            existing.map((r) {
              final id =
                  r['reportId']?.toString() ?? r['reportID']?.toString() ?? '';
              if (id != reportId) return r;
              return <String, dynamic>{
                ...r,
                'reportDate': reportDateISO,
                'inspectedBy': inspectedById,
                'inspectedById': inspectedById,
                'regulation': _regulationController.text.trim(),
                'fieldValues': fieldValues,
                'reportData': wrappedFieldValues,
                'itemNo': _itemNoController.text.trim(),
              };
            }).toList();
        await JobItemStorage.saveItemReports(itemId, updated);
      }

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text('Report updated successfully.'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update report: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed:
                  () => _updateReportData(
                    fieldValues,
                    pickedFiles,
                    inspectedById,
                  ),
            ),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Offline report save
  // ---------------------------------------------------------------------------

  Future<void> _saveReportOffline(
    Map<String, String> fieldValues,
    String inspectedById, {
    Map<String, PlatformFile>? pickedFiles,
  }) async {
    try {
      final reportDateISO = _selectedReportDate!.toUtc().toIso8601String();
      final tempId = 'offline_${DateTime.now().millisecondsSinceEpoch}';

      final wrappedFieldValues = <String, dynamic>{};
      final labelCount = <String, int>{};

      for (final field in _fields) {
        if (field.type.toLowerCase() == 'section' || field.name.trim().isEmpty)
          continue;

        final baseLabel = field.label.isNotEmpty ? field.label : field.name;
        labelCount[baseLabel] = (labelCount[baseLabel] ?? 0) + 1;
        final label =
            labelCount[baseLabel]! > 1
                ? '$baseLabel ${labelCount[baseLabel]}'
                : baseLabel;

        if (field.type == 'checkbox_list') {
          final map = _fieldValues[_key(field)] as Map<String, String?>? ?? {};
          final isSingle = map.length == 1 && map.containsKey('_single');

          if (isSingle) {
            wrappedFieldValues[label] = {
              'value': _toApiCheckboxValue(map['_single']),
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          } else {
            final optMap = <String, String>{};
            map.forEach((opt, val) {
              if (val != null) optMap[opt] = _toApiCheckboxValue(val);
            });
            wrappedFieldValues[label] = {
              'value': optMap,
              if (field.section?.isNotEmpty == true) 'section': field.section,
              'type': 'checkbox_list',
            };
          }
          continue;
        }

        if (!fieldValues.containsKey(label)) continue;

        if (field.type == 'file') {
          final filename = fieldValues['${label}_filename'] ?? '';
          wrappedFieldValues[label] = {
            'value': filename,
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': 'image',
          };
        } else {
          wrappedFieldValues[label] = {
            'value': fieldValues[label],
            if (field.section?.isNotEmpty == true) 'section': field.section,
            'type': field.type,
          };
        }
      }

      final localEntry = <String, dynamic>{
        'reportId': tempId,
        'reportNo': '',
        'reportName': widget.reportName,
        'reportTypeId': widget.reportTypeId,
        'reportTypeID': widget.reportTypeId,
        'reportDate': reportDateISO,
        'createdAt': reportDateISO,
        'status': 'pending_submission',
        'approvalStatus': '',
        'inspectedBy': inspectedById,
        'inspectedById': inspectedById,
        'regulation': _regulationController.text.trim(),
        'fieldValues': fieldValues,
        'reportData': wrappedFieldValues,
        'isPending': true,
        'pdfUrlView': '',
        'pdfUrl': '',
      };

      final itemId = widget.item.itemId ?? '';
      if (itemId.isNotEmpty) {
        final existing = await JobItemStorage.getItemReports(itemId);
        await JobItemStorage.saveItemReports(itemId, [
          ...existing,
          localEntry,
        ]);
      }

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final encoded = <String, String>{};
        for (final entry in pickedFiles.entries) {
          final file = entry.value;
          final bytes = file.bytes;
          if (bytes != null && bytes.isNotEmpty) {
            final filename =
                file.name.isNotEmpty ? file.name : '${entry.key}.jpg';
            encoded[entry.key] = '$filename|${base64Encode(bytes)}';
          }
        }
        if (encoded.isNotEmpty) {
          await JobItemStorage.saveReportFiles(tempId, encoded);
        }
      }

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.offline_pin, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Offline — report saved locally and will be submitted when connected.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        _clearForm();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save report locally: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // PDF viewer
  // ---------------------------------------------------------------------------

  Future<void> _openPdfViewer(String reportId, String pdfUrlView) async {
    if (!mounted) return;
    final viewUrl =
        pdfUrlView.isNotEmpty
            ? pdfUrlView
            : 'https://api.inspectdev.com/api/v1/reportData/$reportId/view-pdf';

    try {
      if (kIsWeb || context.isTablet) {
        openInNewTab(viewUrl);
      } else {
        final systemProvider = context.read<SystemProvider>();
        final pdfBytes = await systemProvider.fetchPdfReportById(reportId);
        if (pdfBytes != null && mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => PdfViewerScreen(
                    pdfData: pdfBytes,
                    reportName: 'Report_$reportId',
                  ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF not ready yet: $e'),
            backgroundColor: Colors.orange[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _getReportLabel(Map<String, dynamic> report) {
    final reportNo = report['reportNo']?.toString() ?? '';
    if (reportNo.isNotEmpty) return reportNo;
    return report['reportId']?.toString() ?? '-';
  }

  void _clearForm() {
    _regulationController.clear();
    for (final c in _controllers.values) c.clear();
    for (final fc in _fileControllers.values) fc.clear();
    setState(() {
      _selectedReportDate = null;
      _selectedInspectedById = null;
      _fieldValues.clear();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ── Section grouping helper ───────────────────────────────────────────────────

class _FieldSection {
  final String name;
  final List<FieldConfig> fields;

  _FieldSection({required this.name, required this.fields});
}
