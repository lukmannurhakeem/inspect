enum ItemNoCreationMode { singleItem, batchCreation, batchCreationManual }

class BatchItemResult {
  final List<Map<String, dynamic>> items;
  final ItemNoCreationMode mode;

  const BatchItemResult({required this.items, required this.mode});
}

enum SaveStatus { invalid, success, offline, offlineFallback, failure }

class SaveResult {
  const SaveResult(this.status, [this.message]);

  final SaveStatus status;
  final String? message;

  bool get shouldPop => status != SaveStatus.invalid;
}

class FormValidationException implements Exception {
  const FormValidationException(this.message);

  final String message;
}

class JobFormField {
  const JobFormField({
    required this.id,
    required this.name,
    required this.type,
    required this.label,
    required this.isRequired,
    required this.options,
    required this.defaultValue,
  });

  factory JobFormField.fromMap(Map<String, dynamic> map) {
    final rawOptions =
        (map['dropdownOptions'] as List<dynamic>?) ??
        (map['options'] as List<dynamic>?) ??
        const [];
    return JobFormField(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      type: map['fieldType'] as String,
      label: map['labelText'] as String? ?? '',
      isRequired: map['required'] as bool? ?? false,
      options: rawOptions.map((e) => e.toString()).toList(),
      defaultValue: map['defaultValue'] as String? ?? '',
    );
  }

  static const locationTypes = {'ItemLocation', 'DetailedLocation', 'Location'};

  static const dropdownTypes = {
    'Dropdown',
    'Override Dropdown',
    'Conditional Dropdown',
    'Site Dropdown',
  };

  final String id;
  final String name;
  final String type;
  final String label;
  final bool isRequired;
  final List<String> options;
  final String defaultValue;

  String get lowerLabel => label.toLowerCase();

  bool get isItemNo => type == 'ItemNo' || lowerLabel.contains('item no');

  bool get isFile => type == 'File';

  bool get isApplicableCode =>
      type == 'ApplicableCode' ||
      (locationTypes.contains(type) && lowerLabel.contains('applicable'));

  bool get isLocation =>
      !lowerLabel.contains('applicable') &&
      (locationTypes.contains(type) ||
          (type == 'Text' && lowerLabel.contains('location')));
}
