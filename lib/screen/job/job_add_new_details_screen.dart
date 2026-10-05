import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/picker_storage_service.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/location_picker_dialog.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const _dateFormat = 'yyyy-MM-dd';

const List<String> _procedureNoPresets = [
  'API 510 – Pressure Vessel Inspection',
  'API 570 – Piping Inspection',
  'API 571 – Damage Mechanisms',
  'API 580 – Risk-Based Inspection',
  'API 653 – Aboveground Storage Tanks',
  'ASME B31.3 – Process Piping',
  'ASME B31.8 – Gas Transmission',
  'ASME Section VIII – Pressure Vessels',
  'BS PD 5500 – Unfired Fusion Welded Vessels',
  'EN 13445 – Unfired Pressure Vessels',
  'ISO 9001 – Quality Management',
  'ISO 14001 – Environmental Management',
  'NACE MR0175 – Sulphide Stress Cracking',
  'OSHA 1910.119 – Process Safety Management',
];

class JobAddNewDetailsScreen extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String siteId;
  final String siteName;
  final bool isEditMode;
  final dynamic job;

  const JobAddNewDetailsScreen({
    required this.customerId,
    required this.customerName,
    required this.siteId,
    required this.siteName,
    this.isEditMode = false,
    this.job,
    super.key,
  });

  @override
  State<JobAddNewDetailsScreen> createState() => _JobAddNewDetailsScreenState();
}

class _JobAddNewDetailsScreenState extends State<JobAddNewDetailsScreen> {
  final _jobNo = TextEditingController();
  final _createdDate = TextEditingController();
  final _po = TextEditingController();
  final _procedure = TextEditingController();
  final _notes = TextEditingController();
  final _division = TextEditingController();
  final _address = TextEditingController();
  final _allocatedDuration = TextEditingController();
  final _estInspectionDuration = TextEditingController();
  final _estStartDate = TextEditingController();
  final _estEndDate = TextEditingController();
  final _engineerComplete = TextEditingController();
  final _offshoreLocation = TextEditingController();
  final _location = TextEditingController();
  final _issuingAuthName = TextEditingController();
  final _clientName = TextEditingController();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  String? _divisionId;
  String? _authenticatorId;
  PlatformFile? _issuingAuthSignatureFile;
  PlatformFile? _clientSignatureFile;

  bool _isLoading = false;
  bool _isOffline = false;

  bool get _isEdit => widget.isEditMode && widget.job != null;

  List<TextEditingController> get _controllers => [
    _jobNo,
    _createdDate,
    _po,
    _procedure,
    _notes,
    _division,
    _address,
    _allocatedDuration,
    _estInspectionDuration,
    _estStartDate,
    _estEndDate,
    _engineerComplete,
    _offshoreLocation,
    _location,
    _issuingAuthName,
    _clientName,
  ];

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _prefill();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReferenceData());
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    _updateOffline(await Connectivity().checkConnectivity());
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      _updateOffline,
    );
  }

  void _updateOffline(List<ConnectivityResult> results) {
    if (!mounted) return;
    setState(() {
      _isOffline = results.every((r) => r == ConnectivityResult.none);
    });
  }

  String _jobValue(String Function(dynamic job) read) {
    if (widget.job == null) return '';
    try {
      return read(widget.job);
    } catch (_) {
      return '';
    }
  }

  String _toDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      return DateFormat(_dateFormat).format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  void _prefill() {
    if (!_isEdit) {
      _createdDate.text = DateFormat(_dateFormat).format(DateTime.now());
      return;
    }

    String s(dynamic v) => v?.toString() ?? '';

    _jobNo.text = _jobValue((j) => s(j.jobNo ?? j.jobId));
    _createdDate.text = _toDate(_jobValue((j) => s(j.createdDate)));
    _po.text = _jobValue((j) => s(j.purchaseOrderNo));
    _procedure.text = _jobValue((j) => s(j.procedureNo));
    _notes.text = _jobValue((j) => s(j.notes));
    _division.text = _jobValue((j) => s(j.divisionId ?? j.divisionID));
    _address.text = _jobValue((j) => s(j.address));
    _allocatedDuration.text = _jobValue((j) => s(j.allocatedDuration));
    _estInspectionDuration.text = _jobValue(
          (j) => s(j.estimatedInspectionDuration),
    );
    _estStartDate.text = _toDate(_jobValue((j) => s(j.estimatedStartDate)));
    _estEndDate.text = _toDate(_jobValue((j) => s(j.estimatedEndDate)));
    _offshoreLocation.text = _jobValue((j) => s(j.offshoreLocation));
    _location.text = _jobValue((j) => s(j.location));
    _issuingAuthName.text = _jobValue((j) => s(j.issuingAuthName));
    _clientName.text = _jobValue((j) => s(j.clientName));

    _divisionId = _division.text.isEmpty ? null : _division.text;
    final authId = _jobValue((j) => s(j.authenticator));
    _authenticatorId = authId.isEmpty ? null : authId;
  }

  void _loadReferenceData() {
    final system = context.read<SystemProvider>();
    if (system.divisions.isEmpty) system.fetchDivision();

    final personnel = context.read<PersonnelProvider>();
    if (personnel.activePersonnel.isEmpty) personnel.fetchPersonnel();
  }

  String _abbreviateSiteName(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return name.toUpperCase();

    final first = words.first;
    if (words.length == 1) {
      return (first.length >= 3 ? first.substring(0, 3) : first).toUpperCase();
    }

    final prefix = (first.length >= 2 ? first.substring(0, 2) : first)
        .toUpperCase();
    return '$prefix${words[1][0].toUpperCase()}';
  }

  String _generateJobId() {
    final name = widget.customerName;
    final customer = (name.length >= 3 ? name.substring(0, 3) : name)
        .toUpperCase();
    final site = _abbreviateSiteName(widget.siteName);
    final year =
    _createdDate.text.length >= 4
        ? _createdDate.text.substring(0, 4)
        : DateTime.now().year.toString();
    final number = (int.tryParse(_jobNo.text.trim()) ?? 0).toString().padLeft(
      5,
      '0',
    );
    return '$customer/$site/$year/$number';
  }

  String _toIso(String value) {
    if (value.isEmpty) return '';
    try {
      return '${DateFormat(_dateFormat).parse(value).toIso8601String()}Z';
    } catch (e) {
      debugPrint('Date format error: $e');
      return '';
    }
  }

  String? _validate() {
    if (_jobNo.text.trim().isEmpty) return 'Job No is required';
    if (_divisionId == null || _divisionId!.isEmpty) {
      return 'Division is required';
    }
    if (_estStartDate.text.trim().isEmpty) {
      return 'Estimated Start Date is required';
    }
    if (_estEndDate.text.trim().isEmpty) {
      return 'Estimated End Date is required';
    }
    try {
      final format = DateFormat(_dateFormat);
      final start = format.parse(_estStartDate.text);
      final end = format.parse(_estEndDate.text);
      if (end.isBefore(start)) return 'End date must be after start date';
    } catch (_) {
      return 'Invalid date format';
    }
    if (_authenticatorId == null || _authenticatorId!.isEmpty) {
      return 'Authenticator is required';
    }
    if (widget.customerId.isEmpty) return 'Customer ID is missing';
    if (widget.siteId.isEmpty) return 'Site ID is missing';
    return null;
  }

  Map<String, dynamic> _buildJobData() => {
    'jobID': _generateJobId(),
    'customerid': widget.customerId,
    'jobno': _jobNo.text,
    'siteID': widget.siteId,
    'createdDate': _toIso(_createdDate.text),
    'purchaseOrderNo': _po.text,
    'procedureNo': _procedure.text,
    'notes': _notes.text,
    'divisionID': _division.text,
    'address': _address.text,
    'allocatedDuration': int.tryParse(_allocatedDuration.text) ?? 0,
    'estimatedInspectionDuration':
    int.tryParse(_estInspectionDuration.text) ?? 0,
    'estimatedStartDate': _toIso(_estStartDate.text),
    'estimatedEndDate': _toIso(_estEndDate.text),
    'isEngineerComplete': _engineerComplete.text.toLowerCase() == 'yes',
    'offshoreLocation': _offshoreLocation.text,
    'location': _location.text,
    'authenticator': _authenticatorId ?? '',
    'issuingAuthName': _issuingAuthName.text,
    'issuingAuthSignature': _issuingAuthSignatureFile?.name ?? '',
    'clientName': _clientName.text,
    'clientSignature': _clientSignatureFile?.name ?? '',
    'startJobNow': true,
  };

  Future<void> _submit() async {
    final error = _validate();
    if (error != null) {
      CommonSnackbar.showError(context, error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = _buildJobData();
      final provider = context.read<JobProvider>();

      if (_isEdit) {
        final job = widget.job;
        final id = job.jobId?.toString() ?? job.jobID?.toString() ?? '';
        await provider.updateJobFromDetails(context, id, data);
      } else {
        await provider.createJobFromDetails(context, data);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickSignature({required bool isClient}) async {
    try {
      final result = await FilePicker.pickFiles();
      if (result == null || !mounted) return;
      setState(() {
        if (isClient) {
          _clientSignatureFile = result.files.first;
        } else {
          _issuingAuthSignatureFile = result.files.first;
        }
      });
    } catch (e) {
      debugPrint('Error picking signature: $e');
      if (mounted) CommonSnackbar.showError(context, 'Failed to pick file');
    }
  }

  Future<void> _openPicker({
    required TextEditingController controller,
    required String storageKey,
    required String title,
    required String hint,
    List<String> presets = const [],
  }) async {
    await showLocationPickerDialog(
      context: context,
      controller: controller,
      storageKey: storageKey,
      dialogTitle: title,
      emptyHint: hint,
      fieldDefinedLocations: presets,
    );
    if (mounted) setState(() {});
  }

  String get _submitLabel {
    if (_isOffline) return 'Save Offline';
    if (_isLoading) return widget.isEditMode ? 'Saving...' : 'Creating...';
    return widget.isEditMode ? 'Save Changes' : 'Create Job';
  }

  Widget _label(
      BuildContext context,
      String text, {
        IconData? icon,
        bool required = false,
      }) {
    final color = context.colors.primary;
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color.withOpacity(0.7)),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              required ? '$text *' : text,
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: required ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
      BuildContext context, {
        required String label,
        required Widget child,
        IconData? icon,
        bool required = false,
        CrossAxisAlignment alignment = CrossAxisAlignment.start,
      }) {
    return Row(
      crossAxisAlignment: alignment,
      children: [
        _label(context, label, icon: icon, required: required),
        context.hS,
        Expanded(flex: 3, child: child),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title, IconData icon) {
    final color = context.colors.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textRow(
      BuildContext context,
      String label,
      TextEditingController controller, {
        IconData? icon,
        bool required = false,
        int minLines = 1,
        int maxLines = 1,
      }) {
    return _field(
      context,
      label: label,
      icon: icon,
      required: required,
      child: CommonTextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        style: context.topology.textTheme.bodySmall?.copyWith(
          color: context.colors.primary,
        ),
      ),
    );
  }

  Widget _dateRow(
      BuildContext context,
      String label,
      TextEditingController controller, {
        IconData? icon,
        bool required = false,
      }) {
    return _field(
      context,
      label: label,
      icon: icon,
      required: required,
      child: CommonDatePickerInput(label: '', controller: controller),
    );
  }

  Widget _pickerRow(
      BuildContext context, {
        required String label,
        required IconData icon,
        required TextEditingController controller,
        required String hint,
        required VoidCallback onTap,
      }) {
    final color = context.colors.primary;
    return _field(
      context,
      label: label,
      icon: icon,
      alignment: CrossAxisAlignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) {
            final hasValue = value.text.trim().isNotEmpty;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasValue ? color : color.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(8),
                color: hasValue ? color.withOpacity(0.05) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: hasValue ? color : color.withOpacity(0.4),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasValue ? value.text : hint,
                      overflow: TextOverflow.ellipsis,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: hasValue ? color : color.withOpacity(0.4),
                      ),
                    ),
                  ),
                  if (hasValue)
                    GestureDetector(
                      onTap: controller.clear,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: color.withOpacity(0.5),
                        ),
                      ),
                    )
                  else
                    Icon(Icons.arrow_drop_down, color: color.withOpacity(0.6)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loader() => const Center(
    child: SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );

  Widget _divisionDropdown(BuildContext context) {
    return _field(
      context,
      label: 'Division Name',
      icon: Icons.business,
      required: true,
      child: Consumer<SystemProvider>(
        builder: (context, system, _) {
          if (system.isLoading) return _loader();

          return CommonDropdown<String>(
            value: _divisionId,
            items:
            system.divisions
                .map(
                  (d) => DropdownMenuItem<String>(
                value: d.divisionid,
                child: Text(
                  d.divisionname ?? 'Unknown',
                  style: context.topology.textTheme.bodySmall,
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                _divisionId = value;
                _division.text = value ?? '';
                if (value == null) {
                  _address.clear();
                  return;
                }
                final selected = system.divisions.firstWhere(
                      (d) => d.divisionid == value,
                  orElse: () => system.divisions.first,
                );
                _address.text = selected.address ?? '';
              });
            },
            borderColor: context.colors.primary,
            textStyle: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _authenticatorDropdown(BuildContext context) {
    return _field(
      context,
      label: 'Authenticator',
      icon: Icons.admin_panel_settings,
      required: true,
      child: Consumer<PersonnelProvider>(
        builder: (context, personnel, _) {
          if (personnel.isLoading) return _loader();

          return CommonDropdown<String>(
            value: _authenticatorId,
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'Select authenticator',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.5),
                  ),
                ),
              ),
              ...personnel.activePersonnel.map(
                    (p) => DropdownMenuItem<String>(
                  value: p.personnel.personnelID,
                  child: Text(
                    p.displayName,
                    style: context.topology.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _authenticatorId = value),
            borderColor: context.colors.primary,
            textStyle: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _fileRow(
      BuildContext context, {
        required String label,
        required PlatformFile? file,
        required VoidCallback onPick,
      }) {
    final color = context.colors.primary;
    return _field(
      context,
      label: label,
      icon: Icons.upload_file,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.colors.secondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_file, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Choose File',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (file != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      file.name,
                      overflow: TextOverflow.ellipsis,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _spaced(BuildContext context, List<Widget> children) {
    return [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) context.vS,
        children[i],
      ],
    ];
  }

  Widget _section(
      BuildContext context,
      String title,
      IconData icon,
      List<Widget> fields,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, title, icon),
        context.vM,
        ..._spaced(context, fields),
      ],
    );
  }

  Widget _jobInfoSection(BuildContext context) {
    return _section(context, 'Job Information', Icons.work_outline, [
      _textRow(
        context,
        'Job No',
        _jobNo,
        icon: Icons.tag,
        required: true,
      ),
      _textRow(
        context,
        'Created Date',
        _createdDate,
        icon: Icons.calendar_today,
      ),
      _textRow(context, 'Purchase Order No', _po, icon: Icons.shopping_cart),
      _pickerRow(
        context,
        label: 'Procedure No',
        icon: Icons.description_outlined,
        controller: _procedure,
        hint: 'Select or enter procedure no',
        onTap:
            () => _openPicker(
          controller: _procedure,
          storageKey: PickerStorageKey.applicableCode,
          title: 'Select Procedure No',
          hint: 'Select or enter procedure no',
          presets: _procedureNoPresets,
        ),
      ),
      _textRow(context, 'Notes', _notes, icon: Icons.notes),
    ]);
  }

  Widget _locationSection(BuildContext context) {
    return _section(context, 'Location Details', Icons.location_on, [
      _divisionDropdown(context),
      _textRow(
        context,
        'Address',
        _address,
        icon: Icons.home,
        minLines: 3,
        maxLines: 5,
      ),
      _pickerRow(
        context,
        label: 'Location',
        icon: Icons.location_on_outlined,
        controller: _location,
        hint: 'Select or enter location',
        onTap:
            () => _openPicker(
          controller: _location,
          storageKey: PickerStorageKey.jobLocation,
          title: 'Select Location',
          hint: 'Select or enter location',
        ),
      ),
      _pickerRow(
        context,
        label: 'Inspection Location',
        icon: Icons.water,
        controller: _offshoreLocation,
        hint: 'Select or enter inspection location',
        onTap:
            () => _openPicker(
          controller: _offshoreLocation,
          storageKey: PickerStorageKey.offshoreLocation,
          title: 'Select Inspection Location',
          hint: 'Select or enter Inspection Location',
        ),
      ),
    ]);
  }

  Widget _scheduleSection(BuildContext context) {
    return _section(context, 'Duration & Schedule', Icons.schedule, [
      _dateRow(
        context,
        'Est. Start Date',
        _estStartDate,
        icon: Icons.event,
        required: true,
      ),
      _dateRow(
        context,
        'Est. End Date',
        _estEndDate,
        icon: Icons.event_available,
        required: true,
      ),
    ]);
  }

  Widget _authorizationSection(BuildContext context) {
    return _section(context, 'Authorization', Icons.verified_user, [
      _authenticatorDropdown(context),
      _textRow(context, 'Client Name', _clientName, icon: Icons.person_outline),
      _fileRow(
        context,
        label: 'Client Signature',
        file: _clientSignatureFile,
        onPick: () => _pickSignature(isClient: true),
      ),
    ]);
  }

  Widget _submitButton() {
    return CommonButton(
      text: _submitLabel,
      onPressed: _isLoading ? null : _submit,
    );
  }

  Widget _tabletLayout(BuildContext context) {
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
                      children: [
                        _jobInfoSection(context),
                        context.vL,
                        _scheduleSection(context),
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _locationSection(context),
                        context.vL,
                        _authorizationSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          SizedBox(width: 200, child: _submitButton()),
          context.vM,
        ],
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          _jobInfoSection(context),
          context.vL,
          _locationSection(context),
          context.vL,
          _scheduleSection(context),
          context.vL,
          _authorizationSection(context),
          context.vL,
          _submitButton(),
          context.vL,
        ],
      ),
    );
  }

  Widget _offlineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.orange.shade700,
      child: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline mode — job will be queued and synced when you reconnect.',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          const SizedBox(height: 16),
          Text(
            widget.isEditMode ? 'Saving changes...' : 'Creating job...',
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final color = context.colors.primary;
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.colors.onPrimary,
      iconTheme: IconThemeData(color: color),
      leading: IconButton(
        onPressed: () => NavigationService().goBack(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isEditMode ? Icons.edit_outlined : Icons.add_task,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                widget.isEditMode ? 'Edit Job Details' : 'New Job Details',
                style: context.topology.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.customerName}  ·  ${widget.siteName}',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body:
      _isLoading
          ? _loadingBody(context)
          : Column(
        children: [
          if (_isOffline) _offlineBanner(),
          Expanded(
            child:
            context.isTablet
                ? _tabletLayout(context)
                : _mobileLayout(context),
          ),
        ],
      ),
    );
  }
}