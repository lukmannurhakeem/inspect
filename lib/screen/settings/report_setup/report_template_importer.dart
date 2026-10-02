import 'dart:async';
import 'dart:typed_data';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/repository/system/system_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:provider/provider.dart';

class ReportTemplateImporter {
  ReportTemplateImporter._();

  static final SystemRepository _repo = ServiceLocator().systemRepository;

  static Future<void> pickAndImport(BuildContext context) async {
    debugPrint('[Importer] pickAndImport called');

    FilePickerResult? picked;
    try {
      picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: true,
        withData: true,
      );
    } catch (e) {
      debugPrint('[Importer] file picker error: $e');
      if (context.mounted)
        _showError(context, 'Could not open file picker: $e');
      return;
    }

    if (picked == null || picked.files.isEmpty) {
      debugPrint('[Importer] no file selected');
      return;
    }

    debugPrint('[Importer] picked ${picked.files.length} file(s)');
    if (!context.mounted) return;

    final List<_ParsedTemplate> templates = [];
    final List<String> parseErrors = [];

    for (final file in picked.files) {
      debugPrint('[Importer] parsing: ${file.name}');
      try {
        final bytes = file.bytes;
        if (bytes == null) throw Exception('No bytes — try again');
        final parsed = _parseExcel(bytes, file.name);
        debugPrint('[Importer] ${file.name}: ${parsed.length} templates found');
        templates.addAll(parsed);
      } catch (e, st) {
        debugPrint('[Importer] parse error for ${file.name}: $e\n$st');
        parseErrors.add('${file.name}: $e');
      }
    }

    if (!context.mounted) return;

    if (templates.isEmpty) {
      _showError(
        context,
        'No report templates found in the selected file(s).\n\n'
            '${parseErrors.isNotEmpty ? parseErrors.join('\n') : 'Make sure you use the INSPECT Excel template format.'}',
      );
      return;
    }

    final confirmed = await _showPreviewDialog(context, templates, parseErrors);
    if (confirmed != true || !context.mounted) return;

    await _runWithDialog(context, templates);
  }

  // ── Excel parser ──────────────────────────────────────────────────────────

  static List<_ParsedTemplate> _parseExcel(Uint8List bytes, String fileName) {
    final excel = Excel.decodeBytes(bytes);
    debugPrint('[Importer] sheets: ${excel.sheets.keys.toList()}');

    final overviewSheet = _findSheet(excel, ['0 · Overview', 'Overview', '0']);
    if (overviewSheet == null)
      throw Exception("Sheet '0 · Overview' not found");

    final overviewRows = _dataRows(overviewSheet, headerRow: 4, dataStart: 5);
    debugPrint('[Importer] overview rows: ${overviewRows.length}');

    final fieldsSheet = _findSheet(excel, ['1 · Fields', 'Fields', '1']);
    final fieldRows =
    fieldsSheet != null
        ? _dataRows(fieldsSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];
    debugPrint('[Importer] field rows: ${fieldRows.length}');

    final optSheet = _findSheet(excel, [
      '2 · Field Options',
      'Field Options',
      '2',
    ]);
    final optRows =
    optSheet != null
        ? _dataRows(optSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];
    debugPrint('[Importer] option rows: ${optRows.length}');

    for (final o in optRows) {
      final k = _cellOptKey(o);
      final v = _cellOptValue(o);
      debugPrint(
        '[Importer] option row: key="$k" value="${v.length > 50 ? v.substring(0, 50) + "..." : v}"',
      );
    }

    final srSheet = _findSheet(excel, [
      '3 · Status Rules',
      'Status Rules',
      '3',
    ]);
    final srRows =
    srSheet != null
        ? _dataRows(srSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];

    final datesSheet = _findSheet(excel, ['4 · Dates', 'Dates', '4']);
    final dateRows =
    datesSheet != null
        ? _dataRows(datesSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];

    final actSheet = _findSheet(excel, ['5 · Actions', 'Actions', '5']);
    final actRows =
    actSheet != null
        ? _dataRows(actSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];

    final compSheet = _findSheet(excel, ['6 · Competency', 'Competency', '6']);
    final compRows =
    compSheet != null
        ? _dataRows(compSheet, headerRow: 4, dataStart: 5)
        : <Map<String, String>>[];

    final List<_ParsedTemplate> result = [];

    for (final ov in overviewRows) {
      final name = _cell(ov, ['★ Report Name', 'Report Name', 'col_0']);
      if (name.isEmpty) continue;

      debugPrint('[Importer] building template: "$name"');

      final fields =
      fieldRows
          .where((r) {
        final label = _cell(r, ['★ Label Text', 'Label Text', 'col_1']);
        return label.isNotEmpty;
      })
          .map((r) => _buildField(r, optRows))
          .toList();

      final statusRules =
      srRows
          .where((r) => _matchName(r, name))
          .map(_buildStatusRule)
          .toList();

      final dates =
      dateRows
          .where((r) => _matchName(r, name))
          .where((r) {
        final n = _cell(r, ['★ Date Name', 'Date Name', 'col_1']);
        return n.isNotEmpty;
      })
          .map(_buildDate)
          .toList();

      final actions =
      actRows.where((r) => _matchName(r, name)).map(_buildAction).toList();

      final competencies =
      compRows
          .where((r) => _matchName(r, name))
          .map(_buildCompetency)
          .toList();

      String cleanStatus(String raw) {
        if (raw.isEmpty) return '';
        final parts =
        raw
            .split(RegExp(r'[\n,]+'))
            .map((s) => s.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
            .where((s) => s.isNotEmpty)
            .toList();
        return parts.join(',');
      }

      final rawStatus = _cell(ov, [
        'Possible\nStatuses',
        'Possible Statuses',
        'col_11',
      ]);
      final rawBatch = _cell(ov, [
        'Possible Batch\nStatuses',
        'Possible Batch Statuses',
        'col_12',
      ]);
      final rawPerm = _cell(ov, ['Permissions', 'col_15']);
      final rawBatchType = _cell(ov, [
        'Batch Report\nType',
        'Batch Report Type',
        'col_3',
      ]);
      final rawCats = _cell(ov, [
        'Selected\nCategory IDs',
        'Selected Category IDs',
        'col_17',
      ]);
      final catList = _parseCategoryIds(rawCats);

      result.add(
        _ParsedTemplate(
          reportName: name,
          reportType: {
            'reportName': name,
            'description': _cell(ov, ['Description', 'col_1']),
            'documentCode': _cell(ov, ['Document Code', 'col_2']),
            'batchReportType': rawBatchType.isEmpty ? 'No Batch' : rawBatchType,
            'isExternalReport': _bool(ov, [
              'External\nReport',
              'External Report',
              'col_5',
            ]),
            'defaultAsDraft': _bool(ov, [
              'Default As\nDraft',
              'Default As Draft',
              'col_6',
            ]),
            'archived': _bool(ov, ['Archived', 'col_7']),
            'updateItemStatus': _bool(ov, [
              'Update Item\nStatus',
              'Update Item Status',
              'col_8',
            ], def: true),
            'updateItemDates': _bool(ov, [
              'Update Item\nDates',
              'Update Item Dates',
              'col_9',
            ], def: true),
            'isStatusRequired': _bool(ov, [
              'Status\nRequired',
              'Is Status\nRequired',
              'Status Required',
              'col_10',
            ], def: true),
            'possibleStatus': cleanStatus(rawStatus),
            'possibleBatchStatus': cleanStatus(rawBatch),
            'permission': rawPerm,
            'categoryID': catList.isEmpty ? null : catList,
          },
          reportFields: fields,
          statusRuleReports: statusRules,
          reportTypeDates: dates,
          actionReports: actions,
          competencyReports: competencies,
          sourceFile: fileName,
        ),
      );
    }

    return result;
  }

  static List<String> _parseCategoryIds(String raw) {
    if (raw.isEmpty) return [];
    return raw
        .split(RegExp(r'[\n,|]+'))
        .map((s) => s.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
        .where((s) => s.isNotEmpty)
        .where((s) => s.contains('-') && s.length >= 32)
        .toList();
  }

  // ── Row builders ──────────────────────────────────────────────────────────

  static Map<String, dynamic> _buildField(
      Map<String, String> r,
      List<Map<String, String>> optRows,
      ) {
    final label = _cell(r, ['★ Label Text', 'Label Text', 'col_1']);
    final name = _cell(r, ['★ Field Name', 'Field Name', 'col_2']);
    final fieldType = _cell(r, ['★ Field Type', 'Field Type', 'col_4']);

    debugPrint(
      '[Importer] _buildField: label="$label" name="$name" type="$fieldType"',
    );

    String options = '';
    final normalizedType = fieldType.toLowerCase().trim();
    final needsOptions =
        normalizedType == 'dropdown' ||
            normalizedType == 'checkbox_list' ||
            normalizedType == 'override dropdown' ||
            normalizedType == 'conditional dropdown';

    if (needsOptions) {
      options = _lookupOptions(name, label, optRows);
      debugPrint('[Importer] options for "$name": "$options"');
    }

    final isDropdown =
        normalizedType == 'dropdown' ||
            normalizedType == 'override dropdown' ||
            normalizedType == 'conditional dropdown';

    // Build defaultValue in the format the API expects:
    // Dropdown with options: { "dropdownType": "Options", "options": [...], "value": null }
    // Everything else: plain string
    final plainDefault = _cell(r, ['Default\nValue', 'Default Value', 'col_3']);
    final dynamic defaultValue;
    if (isDropdown && options.isNotEmpty) {
      final optList =
      options
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      defaultValue = {
        'dropdownType': 'Options',
        'options': optList,
        'value': plainDefault.isNotEmpty ? plainDefault : null,
      };
    } else {
      defaultValue = plainDefault;
    }

    return {
      'labelText': label,
      'name': name,
      'fieldType':
      isDropdown ? 'dropdown' : (fieldType.isEmpty ? 'text' : fieldType),
      'section': _cell(r, ['Section', 'col_5']),
      'defaultValue': defaultValue,
      'isRequired': _boolStr(_cell(r, ['Required', 'col_7'])),
      'isReadOnly': _boolStr(_cell(r, ['Read Only', 'col_8'])),
      'doNotCopy': _boolStr(_cell(r, ['Do Not\nCopy', 'Do Not Copy', 'col_9'])),
      'isArchive': _boolStr(_cell(r, ['Archive', 'col_10'])),
      'appendPDF': _boolStr(_cell(r, ['Append\nPDF', 'Append PDF', 'col_11'])),
      'permissionField': _cell(r, [
        'Permission\nField',
        'Permission Field',
        'col_12',
      ]),
      'infoText': _cell(r, ['Info / Help\nText', 'Info / Help Text', 'col_6']),
      'onlyAvailableField': _cell(r, [
        'Only Available\nField',
        'Only Available Field',
        'col_13',
      ]),
      'onlyAvailableOperator': _cell(r, ['Operator', 'col_14']),
      'onlyAvailableValue': _cell(r, [
        'Only Available\nValue',
        'Only Available Value',
        'col_15',
      ]),
      'fileExtensions': _cell(r, [
        'File\nExtensions',
        'File Extensions',
        'col_16',
      ]),
      'options': options,
    };
  }

  static String _lookupOptions(
      String fieldName,
      String labelText,
      List<Map<String, String>> optRows,
      ) {
    for (final o in optRows) {
      final optKey = _cellOptKey(o);
      if (optKey.isEmpty) continue;

      final optKeyLower = optKey.toLowerCase();
      final nameLower = fieldName.toLowerCase();
      final labelLower = labelText.toLowerCase();

      final isMatch =
          optKey == fieldName ||
              optKey == labelText ||
              optKeyLower == nameLower ||
              optKeyLower == labelLower ||
              optKeyLower == nameLower.replaceAll('_', ' ') ||
              nameLower == optKeyLower.replaceAll(' ', '_');

      if (isMatch) {
        final rawVal = _cellOptValue(o);
        if (rawVal.isNotEmpty) {
          final parts =
          rawVal
              .split(RegExp(r'[,\n]'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) return parts.join(',');
        }
      }
    }
    return '';
  }

  static String _cellOptKey(Map<String, String> row) {
    for (final k in row.keys) {
      if (k.contains('Field Name') || k.startsWith('★ Field Name')) {
        final v = row[k] ?? '';
        if (v.isNotEmpty) return v;
      }
    }
    return row['col_0'] ?? '';
  }

  static String _cellOptValue(Map<String, String> row) {
    for (final k in row.keys) {
      if (k.contains('Option Value') || k.startsWith('★ Option Value')) {
        final v = row[k] ?? '';
        if (v.isNotEmpty) return v;
      }
    }
    return row['col_1'] ?? '';
  }

  static Map<String, dynamic> _buildStatusRule(Map<String, String> r) => {
    'status': _cell(r, [
      'Status\n(applied)',
      'Status\n(applied when condition met)',
      'Status',
      'col_1',
    ]),
    'field': _cell(r, [
      'Field Name\n(condition)',
      'Field Name\n(condition field)',
      'Field Name',
      'col_2',
    ]),
    'operator': _cell(r, ['★ Operator', 'Operator', 'col_3']),
    'value': _cell(r, [
      'Value\n(condition)',
      'Value\n(condition value)',
      'Value',
      'col_4',
    ]),
  };

  static Map<String, dynamic> _buildDate(Map<String, String> r) => {
    'name': _cell(r, ['★ Date Name', 'Date Name', 'col_1']),
    'applyCycle': () {
      final v = _cell(r, ['★ Apply Cycle', 'Apply Cycle', 'col_2']);
      return v.isEmpty ? 'monthly' : v;
    }(),
    'isRequired': _boolStr(_cell(r, ['Required', 'col_4']), def: true),
    'disableFreeType': _boolStr(
      _cell(r, ['Disable Free\nType', 'Disable Free Type', 'col_5']),
    ),
  };

  static Map<String, dynamic> _buildAction(Map<String, String> r) => {
    'description': _cell(r, ['★ Description', 'Description', 'col_1']),
    'actionType': () {
      final v = _cell(r, ['★ Action Type', 'Action Type', 'col_2']);
      return v.isEmpty ? 'status_update' : v;
    }(),
    'applyAction': _cell(r, [
      'Apply Action\n(trigger)',
      'Apply Action',
      'col_4',
    ]),
    'matchField': _cell(r, ['Match Field', 'col_5']),
    'sourceTable': _cell(r, ['Source Table', 'col_6']),
    'sourceField': _cell(r, ['Source Field', 'col_7']),
    'destinationTable': _cell(r, [
      'Destination\nTable',
      'Destination Table',
      'col_8',
    ]),
    'destinationField': _cell(r, [
      'Destination\nField',
      'Destination Field',
      'col_9',
    ]),
    'isArchive': _boolStr(_cell(r, ['Archive', 'col_10'])),
  };

  static Map<String, dynamic> _buildCompetency(Map<String, String> r) => {
    'name': _cell(r, ['★ Competency Name', 'Competency Name', 'col_1']),
    'internalExternal': () {
      final v = _cell(r, [
        '★ Type\n(internal / external)',
        '★ Type',
        'Type',
        'col_2',
      ]);
      return v.isEmpty ? 'internal' : v;
    }(),
    'canCreate': _boolStr(_cell(r, ['Can Create', 'col_4']), def: true),
  };

  // ── Sheet helpers ─────────────────────────────────────────────────────────

  static Sheet? _findSheet(Excel excel, List<String> names) {
    for (final name in names) {
      for (final key in excel.sheets.keys) {
        if (key.toLowerCase().contains(name.toLowerCase()) ||
            name.toLowerCase().contains(key.toLowerCase())) {
          return excel.sheets[key];
        }
      }
    }
    return null;
  }

  static List<Map<String, String>> _dataRows(
      Sheet sheet, {
        required int headerRow,
        required int dataStart,
      }) {
    final rows = sheet.rows;
    if (rows.length < headerRow) return [];

    final headers = <int, String>{};
    final hRow = rows[headerRow - 1];
    for (int i = 0; i < hRow.length; i++) {
      final v = _cellValue(hRow[i]);
      if (v.isNotEmpty) headers[i] = v;
    }

    final result = <Map<String, String>>[];
    for (int ri = dataStart - 1; ri < rows.length; ri++) {
      final row = rows[ri];
      final map = <String, String>{};
      bool hasData = false;
      for (int ci = 0; ci < row.length; ci++) {
        final v = _cellValue(row[ci]);
        final key = headers[ci] ?? 'col_$ci';
        map[key] = v;
        if (v.isNotEmpty) hasData = true;
      }
      if (hasData) result.add(map);
    }
    return result;
  }

  static String _cellValue(Data? cell) {
    if (cell == null || cell.value == null) return '';
    final v = cell.value;
    if (v is BoolCellValue) return v.value ? 'true' : 'false';
    return v.toString().trim();
  }

  static String _cell(Map<String, String> row, List<String> keys) {
    for (final k in keys) {
      if (row.containsKey(k) && row[k]!.isNotEmpty) return row[k]!;
      for (final rk in row.keys) {
        if (rk.contains(k) || k.contains(rk)) {
          final v = row[rk]!;
          if (v.isNotEmpty) return v;
        }
      }
    }
    return '';
  }

  static bool _bool(
      Map<String, String> row,
      List<String> keys, {
        bool def = false,
      }) {
    final v = _cell(row, keys).toLowerCase();
    if (v == 'yes' || v == 'true' || v == '1') return true;
    if (v == 'no' || v == 'false' || v == '0') return false;
    return def;
  }

  static bool _boolStr(String v, {bool def = false}) {
    final s = v.toLowerCase().trim();
    if (s == 'yes' || s == 'true' || s == '1') return true;
    if (s == 'no' || s == 'false' || s == '0') return false;
    return def;
  }

  static bool _matchName(Map<String, String> row, String name) {
    final v = _cell(row, ['★ Report Name', 'Report Name', 'col_0']);
    return v == name;
  }

  // ── Preview dialog ────────────────────────────────────────────────────────

  static Future<bool?> _showPreviewDialog(
      BuildContext context,
      List<_ParsedTemplate> templates,
      List<String> parseErrors,
      ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.upload_file_rounded,
                      color: cs.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to Import',
                          style: tt.titleMedium?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${templates.length} template${templates.length == 1 ? '' : 's'} found',
                          style: tt.bodySmall?.copyWith(
                            color: cs.primary.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(ctx).pop(false),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.primary.withOpacity(0.12)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: templates.length,
                  separatorBuilder:
                      (_, __) => Divider(
                    height: 1,
                    color: cs.primary.withOpacity(0.08),
                  ),
                  itemBuilder: (_, i) {
                    final t = templates[i];
                    final dropdownCount =
                        t.reportFields
                            .where((f) => f['fieldType'] == 'dropdown')
                            .length;
                    final fieldsWithOptions =
                        t.reportFields
                            .where(
                              (f) =>
                          f['fieldType'] == 'dropdown' &&
                              (f['options']?.toString().isNotEmpty ??
                                  false),
                        )
                            .length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cs.primary,
                                  cs.primary.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                t.reportName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.reportName,
                                  style: tt.bodyMedium?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${t.reportFields.length} fields'
                                      '${t.reportTypeDates.isNotEmpty ? ' · ${t.reportTypeDates.length} dates' : ''}'
                                      '${t.statusRuleReports.isNotEmpty ? ' · ${t.statusRuleReports.length} rules' : ''}'
                                      '${dropdownCount > 0 ? ' · $fieldsWithOptions/$dropdownCount dropdowns with options' : ''}',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.primary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              t.reportType['documentCode']?.toString() ??
                                  '',
                              style: tt.bodySmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (parseErrors.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Some files had errors:\n${parseErrors.join('\n')}',
                          style: tt.bodySmall?.copyWith(
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Categories will not be set automatically — assign them after import via the Edit screen.',
                        style: tt.bodySmall?.copyWith(
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      icon: const Icon(Icons.upload_rounded, size: 18),
                      label: const Text(
                        'Import',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
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

  // ── Progress dialog ───────────────────────────────────────────────────────

  static Future<void> _runWithDialog(
      BuildContext context,
      List<_ParsedTemplate> templates,
      ) async {
    final nav = Navigator.of(context, rootNavigator: true);
    final sm = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final int total = templates.length;

    final ready = Completer<void>();
    String _name = 'Preparing...';
    int _index = 0;
    late StateSetter setSt;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          setSt = setState;
          if (!ready.isCompleted) ready.complete();
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Importing ($_index / $total)',
              style: tt.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : _index / total,
                    minHeight: 8,
                    backgroundColor: cs.primary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _name,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please do not close this window.',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await ready.future;

    int success = 0;
    final List<String> failed = [];

    for (int i = 0; i < templates.length; i++) {
      final t = templates[i];
      debugPrint('[Importer] importing "${t.reportName}"');

      setSt(() {
        _index = i + 1;
        _name = t.reportName;
      });

      try {
        final body = <String, dynamic>{
          'reportType': t.reportType,
          'reportFields': t.reportFields,
          'statusRuleReports': t.statusRuleReports,
          'reportTypeDates': t.reportTypeDates,
          'actionReports': t.actionReports,
          'competencyReports': t.competencyReports,
        };

        await _repo
            .createReport(body)
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('Timed out after 30s'),
        );
        success++;
        debugPrint('[Importer] "${t.reportName}": SUCCESS');
      } catch (e, st) {
        debugPrint('[Importer] "${t.reportName}": FAILED: $e\n$st');
        failed.add('${t.reportName}: $e');
      }
    }

    try {
      if (context.mounted) {
        await Provider.of<SystemProvider>(
          context,
          listen: false,
        ).fetchReportType();
      }
    } catch (_) {}

    if (nav.canPop()) nav.pop();

    if (context.mounted) {
      final ok = failed.isEmpty;
      sm.showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'All $success template${success == 1 ? '' : 's'} imported!'
                : '$success/${templates.length} imported. '
                '${failed.isNotEmpty ? 'Errors: ${failed.join('; ')}' : ''}',
          ),
          backgroundColor: ok ? Colors.green.shade600 : Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ParsedTemplate {
  final String reportName;
  final Map<String, dynamic> reportType;
  final List<Map<String, dynamic>> reportFields;
  final List<Map<String, dynamic>> statusRuleReports;
  final List<Map<String, dynamic>> reportTypeDates;
  final List<Map<String, dynamic>> actionReports;
  final List<Map<String, dynamic>> competencyReports;
  final String sourceFile;

  const _ParsedTemplate({
    required this.reportName,
    required this.reportType,
    required this.reportFields,
    required this.statusRuleReports,
    required this.reportTypeDates,
    required this.actionReports,
    required this.competencyReports,
    required this.sourceFile,
  });
}
