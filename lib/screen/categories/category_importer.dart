
import 'dart:async';
import 'dart:typed_data';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/field_model/field_model.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:provider/provider.dart';

class CategoryImporter {
  CategoryImporter._();

  static Future<void> pickAndImport(BuildContext context) async {
    debugPrint('[CatImporter] pickAndImport called');

    FilePickerResult? picked;
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json','xlsx'],
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;
        final bytes = file.bytes;
      }
    } catch (e) {
      if (context.mounted)
        _showError(context, 'Could not open file picker: $e');
      return;
    }

    if (picked == null || picked.files.isEmpty) return;

    final file = picked.files.first;
    debugPrint('[CatImporter] parsing: ${file.name}');

    _ParsedResult? parsed;
    try {
      final bytes = file.bytes;
      if (bytes == null) throw Exception('No bytes received — try again');
      parsed = _parseExcel(bytes);
      debugPrint(
        '[CatImporter] parsed: ${parsed.categories.length} cats, '
            '${parsed.subCategories.length} sub-cats',
      );
    } catch (e, st) {
      debugPrint('[CatImporter] parse error: $e\n$st');
      if (context.mounted) _showError(context, 'Failed to parse Excel:\n$e');
      return;
    }

    if (!context.mounted) return;

    if (parsed.categories.isEmpty && parsed.subCategories.isEmpty) {
      _showError(
        context,
        'No categories found.\n'
            'Make sure you use the INSPECT Categories Excel template.',
      );
      return;
    }

    final confirmed = await _showPreviewDialog(context, parsed);
    if (confirmed != true || !context.mounted) return;

    await _runWithDialog(context, parsed);
  }

  static _ParsedResult _parseExcel(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    debugPrint('[CatImporter] sheets: ${excel.sheets.keys.toList()}');

    final catSheet = _findSheet(excel, ['1', 'Categories']);
    final subSheet = _findSheet(excel, ['2', 'Sub']);
    final fieldSheet = _findSheet(excel, ['3', 'Custom', 'Field']);
    final optSheet = _findSheet(excel, ['4', 'Options']);

    int _hdr(Sheet? sheet, int def) {
      if (sheet == null) return def;
      final rows = sheet.rows;
      for (int r = 1; r <= 6 && r <= rows.length; r++) {
        final joined = rows[r - 1].map((c) => _cv(c)).join('|');
        if (joined.contains('★') || joined.toLowerCase().contains('name'))
          return r;
      }
      return def;
    }

    final catHdr = _hdr(catSheet, 4);
    final subHdr = _hdr(subSheet, 4);
    final fldHdr = _hdr(fieldSheet, 4);
    final optHdr = _hdr(optSheet, 3);
    debugPrint(
      '[CatImporter] header rows: cat=$catHdr sub=$subHdr fld=$fldHdr opt=$optHdr',
    );

    final catRows =
    catSheet != null
        ? _dataRows(catSheet, headerRow: catHdr, dataStart: catHdr + 1)
        : <Map<String, String>>[];
    final subRows =
    subSheet != null
        ? _dataRows(subSheet, headerRow: subHdr, dataStart: subHdr + 1)
        : <Map<String, String>>[];
    final fieldRows =
    fieldSheet != null
        ? _dataRows(fieldSheet, headerRow: fldHdr, dataStart: fldHdr + 1)
        : <Map<String, String>>[];
    final optRows =
    optSheet != null
        ? _dataRows(optSheet, headerRow: optHdr, dataStart: optHdr + 1)
        : <Map<String, String>>[];

    final cats =
    catRows
        .where(
          (r) =>
      _cell(r, [
        '★ Category Name',
        'Category Name',
        'col_0',
      ]).isNotEmpty,
    )
        .toList();
    final subCats =
    subRows
        .where(
          (r) =>
      _cell(r, [
        '★ Sub-Category Name',
        'Sub-Category Name',
        'col_2',
      ]).isNotEmpty,
    )
        .toList();
    final fields =
    fieldRows
        .where(
          (r) =>
      _cell(r, ['★ Label Text', 'Label Text', 'col_1']).isNotEmpty,
    )
        .toList();

    debugPrint(
      '[CatImporter] found: ${cats.length} cats, ${subCats.length} subs, ${fields.length} fields',
    );
    return _ParsedResult(
      categories: cats,
      subCategories: subCats,
      customFields: fields,
      fieldOptions: optRows,
    );
  }

  static Future<void> _runWithDialog(
      BuildContext context,
      _ParsedResult parsed,
      ) async {
    final nav = Navigator.of(context, rootNavigator: true);
    final sm = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final int total = parsed.categories.length + parsed.subCategories.length;

    final ready = Completer<void>();
    String _stepName = 'Preparing...';
    int _step = 0;
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
              'Importing ($_step / $total)',
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
                    value: total == 0 ? 0 : _step / total,
                    minHeight: 8,
                    backgroundColor: cs.primary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _stepName,
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
    final Map<String, String> nameToId = {};

    final provider = Provider.of<CategoryProvider>(context, listen: false);

    List<FieldModel> _fieldsForCategory(String catName) {
      return parsed.customFields
          .where((r) => _cell(r, ['Category Name', 'col_0']) == catName)
          .map((r) {
        final label = _cell(r, ['★ Label Text', 'Label Text', 'col_1']);
        final fieldName = _cell(r, ['★ Field Name', 'Field Name', 'col_2']);
        final fieldType = _cell(r, ['★ Field Type', 'Field Type', 'col_4']);
        final perm = _cell(r, ['Create / Edit\nPermission', 'col_6']);
        final permVal = perm.isEmpty ? 'Any' : perm;

        final autoName =
        fieldName.isNotEmpty ? fieldName : _toLabelCase(label);

        List<String>? opts;
        if (fieldType.toLowerCase() == 'dropdown' ||
            fieldType.toLowerCase() == 'override dropdown' ||
            fieldType.toLowerCase() == 'checklist item') {
          opts =
              parsed.fieldOptions
                  .where((o) {
                final fn = _cell(o, [
                  '★ Field Name',
                  'Field Name',
                  'col_0',
                ]);
                return fn == fieldName || fn == label;
              })
                  .map(
                    (o) => _cell(o, [
                  '★ Option Value',
                  'Option Value',
                  'col_1',
                ]),
              )
                  .where((v) => v.isNotEmpty)
                  .toList();
          if (opts!.isEmpty) opts = null;
        }

        return FieldModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          labelText: label,
          name: autoName,
          fieldType: fieldType.isEmpty ? 'Text' : fieldType,
          defaultValue: _cell(r, ['Default Value', 'col_3']),
          required: _boolCell(r, ['Required', 'col_8']),
          isReadOnly: false,
          permissions: {'create': permVal, 'view': permVal},
          dropdownOptions: opts,
        );
      })
          .toList();
    }

    for (final row in parsed.categories) {
      final name = _cell(row, ['★ Category Name', 'Category Name', 'col_0']);
      setSt(() {
        _step++;
        _stepName = 'Category: $name';
      });
      debugPrint('[CatImporter] [$_step/$total] category: $name');

      try {
        provider.resetFormState();
        final catFields = _fieldsForCategory(name);
        for (final f in catFields) {
          provider.addField(f);
        }
        debugPrint('[CatImporter]   → ${catFields.length} fields');

        final parentName = _cell(row, [
          'Parent Category Name\n(blank = top-level)',
          'col_2',
        ]);
        final parentId =
            nameToId[parentName] ??
                _cell(row, ['Parent Category ID\n(if known)', 'col_3']).nullIfEmpty;

        final ok = await provider.createCategory(
          categoryName: name,
          categoryCode: _cell(row, ['Category Code\n(short code)', 'col_1']),
          description: _cell(row, ['Description', 'col_4']),
          descriptionTemplate: _cell(row, ['Description\nTemplate', 'col_5']),
          parentId: parentId,
          replacementPeriod: _periodDays(
            row,
            numKey: 'col_6',
            unitKey: 'col_7',
          ),
          canHaveChildItems: _boolCell(row, ['Can Have\nChild Item', 'col_8']),
          isWithdrawn: _boolCell(row, ['Withdraw\n(archived)', 'col_9']),
          instructions: _cell(row, ['Instructions', 'col_10']).nullIfEmpty,
          notes: _cell(row, ['Notes', 'col_11']).nullIfEmpty,
          saveFieldsToStorage: true,
        );

        if (ok) {
          final id = provider.createdCategoryId ?? '';
          if (id.isNotEmpty) nameToId[name] = id;
          success++;
          debugPrint('[CatImporter]   ✓ id=$id');
        } else {
          final msg = provider.createErrorMessage ?? 'Unknown error';
          failed.add('Category "$name": $msg');
          debugPrint('[CatImporter]   ✗ $msg');
        }
      } catch (e) {
        debugPrint('[CatImporter]   ✗ exception: $e');
        failed.add('Category "$name": $e');
      }
    }

    for (final row in parsed.subCategories) {
      final name = _cell(row, [
        '★ Sub-Category Name',
        'Sub-Category Name',
        'col_2',
      ]);
      final parentName = _cell(row, [
        '★ Parent Category Name',
        'Parent Category Name',
        'col_0',
      ]);
      setSt(() {
        _step++;
        _stepName = 'Sub-category: $name';
      });
      debugPrint(
        '[CatImporter] [$_step/$total] sub-cat: $name (parent: $parentName)',
      );

      try {
        String? parentId = nameToId[parentName];
        if (parentId == null || parentId.isEmpty) {
          parentId =
              _cell(row, [
                'Parent Category ID\n(optional, overrides name)',
                'col_1',
              ]).nullIfEmpty;
        }

        if (parentId == null) {
          debugPrint('[CatImporter]   ✗ parent "$parentName" not found');
          failed.add(
            'Sub-category "$name": parent "$parentName" not found or not imported',
          );
          continue;
        }

        provider.resetFormState();
        final subFields = _fieldsForCategory(name);
        for (final f in subFields) {
          provider.addField(f);
        }
        debugPrint(
          '[CatImporter]   → ${subFields.length} fields, parentId=$parentId',
        );

        final ok = await provider.createCategory(
          categoryName: name,
          categoryCode: _cell(row, [
            'Sub-Category Code\n(short code)',
            'col_3',
          ]),
          description: _cell(row, ['Description', 'col_5']),
          descriptionTemplate: _cell(row, ['Description\nTemplate', 'col_6']),
          parentId: parentId,
          replacementPeriod: _periodDays(
            row,
            numKey: 'col_7',
            unitKey: 'col_8',
          ),
          canHaveChildItems: _boolCell(row, ['Can Have\nChild Item', 'col_9']),
          isWithdrawn: _boolCell(row, ['Withdraw\n(archived)', 'col_10']),
          instructions: _cell(row, ['Instructions', 'col_11']).nullIfEmpty,
          notes: _cell(row, ['Notes', 'col_12']).nullIfEmpty,
          saveFieldsToStorage: true,
        );

        if (ok) {
          final id = provider.createdCategoryId ?? '';
          if (id.isNotEmpty) nameToId[name] = id;
          success++;
          debugPrint('[CatImporter]   ✓ id=$id');
        } else {
          final msg = provider.createErrorMessage ?? 'Unknown error';
          failed.add('Sub-category "$name": $msg');
          debugPrint('[CatImporter]   ✗ $msg');
        }
      } catch (e) {
        debugPrint('[CatImporter]   ✗ exception: $e');
        failed.add('Sub-category "$name": $e');
      }
    }

    provider.resetFormState();
    try {
      if (context.mounted) {
        await Provider.of<CategoryProvider>(
          context,
          listen: false,
        ).fetchCategories();
      }
    } catch (_) {}

    if (nav.canPop()) nav.pop();

    if (context.mounted) {
      final ok = failed.isEmpty;
      if (ok) {
        CommonSnackbar.showSuccess(
          context,
          'All $success item${success == 1 ? '' : 's'} imported successfully!',
        );
      } else {
        CommonSnackbar.showWarning(
          context,
          '$success imported. Errors: ${failed.take(3).join('; ')}${failed.length > 3 ? '…' : ''}',
        );
      }
    }
  }

  static Future<bool?> _showPreviewDialog(
      BuildContext context,
      _ParsedResult parsed,
      ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final rows = [
      if (parsed.categories.isNotEmpty)
        _PreviewRow(
          Icons.category_outlined,
          cs.primary,
          '${parsed.categories.length} categor${parsed.categories.length == 1 ? 'y' : 'ies'}',
          parsed.categories
              .map((r) => _cell(r, ['★ Category Name', 'col_0']))
              .where((n) => n.isNotEmpty)
              .take(3)
              .join(', '),
        ),
      if (parsed.subCategories.isNotEmpty)
        _PreviewRow(
          Icons.subdirectory_arrow_right,
          Colors.indigo,
          '${parsed.subCategories.length} sub-categor${parsed.subCategories.length == 1 ? 'y' : 'ies'}',
          parsed.subCategories
              .map((r) => _cell(r, ['★ Sub-Category Name', 'col_2']))
              .where((n) => n.isNotEmpty)
              .take(3)
              .join(', '),
        ),
      if (parsed.customFields.isNotEmpty)
        _PreviewRow(
          Icons.view_list_rounded,
          Colors.teal,
          '${parsed.customFields.length} custom field${parsed.customFields.length == 1 ? '' : 's'}',
          parsed.customFields
              .map((r) => _cell(r, ['★ Label Text', 'col_1']))
              .where((n) => n.isNotEmpty)
              .take(3)
              .join(', '),
        ),
    ];

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
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
                          'Categories & Custom Fields',
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
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.primary.withOpacity(0.12)),
                ),
                child: Column(
                  children:
                  rows.asMap().entries.map((e) {
                    final r = e.value;
                    final isLast = e.key == rows.length - 1;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        border:
                        isLast
                            ? null
                            : Border(
                          bottom: BorderSide(
                            color: cs.primary.withOpacity(0.08),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: r.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              r.icon,
                              color: r.color,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: tt.bodyMedium?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (r.subtitle.isNotEmpty)
                                  Text(
                                    r.subtitle,
                                    style: tt.bodySmall?.copyWith(
                                      color: cs.primary.withOpacity(
                                        0.45,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sub-categories are linked to their parent by name. '
                            'Create parent categories first if not already in the system.',
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

  static String _toLabelCase(String input) => input
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join('');

  static Sheet? _findSheet(Excel excel, List<String> names) {
    for (final name in names) {
      for (final key in excel.sheets.keys) {
        if (key.toLowerCase().contains(name.toLowerCase())) {
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
    try {
      final rows = sheet.rows;
      if (rows.length < headerRow) return [];

      final headers = <int, String>{};
      final hRow = rows[headerRow - 1];
      for (int i = 0; i < hRow.length; i++) {
        try {
          final v = _cv(hRow[i]);
          if (v.isNotEmpty) headers[i] = v;
        } catch (_) {}
      }

      final result = <Map<String, String>>[];
      for (int ri = dataStart - 1; ri < rows.length; ri++) {
        try {
          final row = rows[ri];
          if (row.isEmpty) continue;
          final map = <String, String>{};
          bool hasData = false;
          for (int ci = 0; ci < row.length; ci++) {
            try {
              final v = _cv(row[ci]);
              map[headers[ci] ?? 'col_\$ci'] = v;
              if (v.isNotEmpty) hasData = true;
            } catch (_) {
              map[headers[ci] ?? 'col_\$ci'] = '';
            }
          }
          if (hasData) result.add(map);
        } catch (_) {
          continue; // skip bad rows
        }
      }
      return result;
    } catch (e) {
      debugPrint('[CatImporter] _dataRows error: \$e');
      return [];
    }
  }

  static String _cv(Data? cell) {
    try {
      if (cell == null) return '';
      final v = cell.value;
      if (v == null) return '';
      if (v is BoolCellValue) return v.value ? 'Yes' : 'No';
      final s = v.toString().trim();
      if (s.startsWith('#')) return '';
      return s;
    } catch (_) {
      return '';
    }
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

  static bool _boolCell(
      Map<String, String> row,
      List<String> keys, {
        bool def = false,
      }) {
    final v = _cell(row, keys).toLowerCase().trim();
    if (v == 'yes' || v == 'true' || v == '1') return true;
    if (v == 'no' || v == 'false' || v == '0') return false;
    return def;
  }

  static int? _periodDays(
      Map<String, String> row, {
        required String numKey,
        required String unitKey,
      }) {
    final numStr = _cell(row, [numKey]);
    final unit = _cell(row, [unitKey]).toLowerCase();
    final num = int.tryParse(numStr);
    if (num == null || num == 0) return null;
    switch (unit) {
      case 'weeks':
        return num * 7;
      case 'months':
        return num * 30;
      case 'years':
        return num * 365;
      default:
        return num;
    }
  }

  static void _showError(BuildContext context, String message) {
    CommonSnackbar.showError(context, message);
  }
}

class _ParsedResult {
  final List<Map<String, String>> categories;
  final List<Map<String, String>> subCategories;
  final List<Map<String, String>> customFields;
  final List<Map<String, String>> fieldOptions;

  const _ParsedResult({
    required this.categories,
    required this.subCategories,
    required this.customFields,
    required this.fieldOptions,
  });
}

class _PreviewRow {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _PreviewRow(this.icon, this.color, this.title, this.subtitle);
}

extension _StringX on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

