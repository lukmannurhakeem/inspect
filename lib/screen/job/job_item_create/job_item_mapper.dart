import 'package:inspect/screen/job/job_item_create/job_item_form_models.dart';

const _descriptionKeys = ['description', 'ItemDescription', 'item_description'];
const _locationKeys = [
  'detailedLocation',
  'detailed_location',
  'ItemLocation',
  'location',
];
const _applicableKeys = ['applicableCode', 'applicable_code', 'ApplicableCode'];
const _categoryKeys = ['categoryName', 'category_name', 'ItemCategory'];
const _rfidKeys = ['rfidNo', 'rfid_no', 'RFIDNo'];
const _customerKeys = ['customerName', 'customer_name', 'Customer'];
const _siteKeys = ['siteName', 'site_name', 'SiteID', 'Site'];
const _firstUseKeys = ['firstUseDate', 'first_use_date', 'FirstUseDate'];
const _expiryKeys = [
  'expiryDateTimeStamp',
  'expiry_date',
  'ExpiryDate',
  'expiryDate',
];
const _manufacturerKeys = ['manufacturer', 'Manufacturer'];
const _swlKeys = ['swl', 'SWL'];
const _serialKeys = ['serialNumber', 'serial_number', 'SerialNumber'];

class _LabelRule {
  _LabelRule(this.rootKey, this.readKeys, this.matches, {this.isDate = false});

  final String rootKey;
  final List<String> readKeys;
  final bool Function(String label) matches;
  final bool isDate;
}

final _labelRules = <_LabelRule>[
  _LabelRule(
    'firstUseDate',
    _firstUseKeys,
    (l) => l.contains('first use') || l.contains('inspected'),
    isDate: true,
  ),
  _LabelRule(
    'expiryDateTimeStamp',
    _expiryKeys,
    (l) => l.contains('expiry') || l.contains('expiration'),
    isDate: true,
  ),
  _LabelRule('manufacturer', _manufacturerKeys, (l) => l.contains('manufacturer')),
  _LabelRule('swl', _swlKeys, (l) => l.contains('swl')),
  _LabelRule('serialNumber', _serialKeys, (l) => l.contains('serial')),
  _LabelRule('description', _descriptionKeys, (l) => l.contains('description')),
  _LabelRule(
    'detailedLocation',
    _locationKeys,
    (l) => l.contains('location') && !l.contains('applicable'),
  ),
  _LabelRule(
    'applicableCode',
    _applicableKeys,
    (l) => l.contains('applicable code'),
  ),
  _LabelRule('customerName', _customerKeys, (l) => l.contains('customer')),
  _LabelRule('siteName', _siteKeys, (l) => l.contains('site')),
  _LabelRule('rfidNo', _rfidKeys, (l) => l.contains('rfid')),
];

abstract final class JobItemMapper {
  static const _staticFieldTypes = {
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

  static const _typeRootKeys = {
    'ItemDescription': 'description',
    'ApplicableCode': 'applicableCode',
    'ItemCategory': 'categoryName',
    'RFIDNo': 'rfidNo',
    'Customer': 'customerName',
    'SiteID': 'siteName',
  };

  static String firstValue(Map<String, dynamic> source, Iterable<String> keys) {
    for (final key in keys) {
      final value = source[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  static Set<String> checkedOptions(String text) =>
      text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();

  static String toIsoDateTime(String raw) {
    if (raw.isEmpty || raw.contains('T')) return raw;
    final date = _parseDate(raw);
    if (date == null) return raw;
    return '${date.toUtc().toIso8601String().split('.').first}Z';
  }

  static String isoToDisplayDate(String iso) {
    if (!iso.contains('T')) return iso;
    final date = DateTime.tryParse(iso)?.toLocal();
    if (date == null) return iso;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String toCamelCase(String input) {
    if (input.isEmpty) return input;
    final camel = input.replaceAllMapped(
      RegExp(r'_([a-zA-Z])'),
      (m) => m.group(1)!.toUpperCase(),
    );
    return camel[0].toLowerCase() + camel.substring(1);
  }

  static bool isStaticField(JobFormField field) =>
      _staticFieldTypes.contains(field.type) ||
      _ruleFor(field.lowerLabel) != null;

  static void writeStaticField(
    Map<String, dynamic> root,
    JobFormField field,
    String value,
  ) {
    if (value.isEmpty) return;

    if (JobFormField.locationTypes.contains(field.type)) {
      final key =
          field.lowerLabel.contains('applicable')
              ? 'applicableCode'
              : 'detailedLocation';
      root[key] = value;
      return;
    }

    final typeKey = _typeRootKeys[field.type];
    if (typeKey != null) {
      root[typeKey] = value;
      return;
    }

    final rule = _ruleFor(field.lowerLabel);
    if (rule == null) {
      root[field.name] = value;
      return;
    }
    root[rule.rootKey] = rule.isDate ? toIsoDateTime(value) : value;
  }

  static String prefillValue(Map<String, dynamic> data, JobFormField field) {
    final label = field.lowerLabel;

    switch (field.type) {
      case 'ItemDescription':
        return firstValue(data, _descriptionKeys);
      case 'ItemLocation':
      case 'DetailedLocation':
      case 'Location':
        return firstValue(
          data,
          label.contains('applicable') ? _applicableKeys : _locationKeys,
        );
      case 'ApplicableCode':
        return firstValue(data, _applicableKeys);
      case 'ItemCategory':
        return firstValue(data, _categoryKeys);
      case 'RFIDNo':
        return firstValue(data, _rfidKeys);
      case 'Customer':
        return firstValue(data, _customerKeys);
      case 'SiteID':
        return firstValue(data, _siteKeys);
      case 'Checklist Item':
        return checkedOptions(_valueByName(data, field.name)).join(',');
      case 'Date':
        final rule = _ruleFor(label, dateOnly: true);
        final raw =
            rule != null
                ? firstValue(data, rule.readKeys)
                : _valueByName(data, field.name);
        return isoToDisplayDate(raw);
      default:
        final byName = _valueByName(data, field.name);
        if (byName.isNotEmpty) return byName;
        final rule = _ruleFor(label);
        if (rule == null) return '';
        final raw = firstValue(data, rule.readKeys);
        return rule.isDate ? isoToDisplayDate(raw) : raw;
    }
  }

  static _LabelRule? _ruleFor(String label, {bool dateOnly = false}) =>
      _labelRules
          .where((r) => (!dateOnly || r.isDate) && r.matches(label))
          .firstOrNull;

  static String _valueByName(Map<String, dynamic> data, String name) {
    if (name.isEmpty) return '';
    final keys = [name, toCamelCase(name)];

    final direct = firstValue(data, keys);
    if (direct.isNotEmpty) return direct;

    final lowered = keys.map((k) => k.toLowerCase()).toSet();
    for (final entry in data.entries) {
      if (!lowered.contains(entry.key.toLowerCase())) continue;
      final value = entry.value?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }

    final itemData = data['itemData'];
    return itemData is Map<String, dynamic> ? firstValue(itemData, keys) : '';
  }

  static DateTime? _parseDate(String raw) {
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) {
      return DateTime.tryParse(raw);
    }
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(raw)) {
      final [day, month, year] = raw.split('/').map(int.parse).toList();
      return DateTime(year, month, day);
    }
    return null;
  }
}
