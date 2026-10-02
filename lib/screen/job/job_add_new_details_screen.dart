
import 'package:file_picker/file_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

class JobAddNewDetailsScreen extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String siteId;
  final String siteName;

  // ── Edit mode ──────────────────────────────────────────────────────────────
  final bool isEditMode;

  /// The existing job object passed from JobScreen when editing.
  /// Typed as [dynamic] to avoid hard coupling to the model import here.
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

class _JobAddNewDetailsScreenState extends State<JobAddNewDetailsScreen>
    with TickerProviderStateMixin {
  String? selectedDivisionId;
  String? selectedAuthenticatorId;

  late TextEditingController jobNoController;
  late TextEditingController createdDateController;
  late TextEditingController poController;
  late TextEditingController procedureController;
  late TextEditingController notesController;
  late TextEditingController divisionController;
  late TextEditingController addressController;
  late TextEditingController allocatedDurationController;
  late TextEditingController estInspectionDurationController;
  late TextEditingController estStartDateController;
  late TextEditingController estEndDateController;
  late TextEditingController engineerCompleteController;
  late TextEditingController offshoreLocationController;
  late TextEditingController locationController;
  late TextEditingController issuingAuthNameController;
  late TextEditingController clientNameController;
  late TextEditingController issuingAuthNameSignatureController;
  late TextEditingController clientSignatureController;

  PlatformFile? _issuingAuthSignatureFile;
  PlatformFile? _clientSignatureFile;

  bool _isLoading = false;
  bool _isOffline = false;

  // ── Helpers to safely read from dynamic job object ─────────────────────────

  String _jobStr(String key) {
    if (widget.job == null) return '';
    try {
      final val = widget.job as dynamic;
      switch (key) {
        case 'jobNo':
          return val.jobNo?.toString() ?? val.jobId?.toString() ?? '';
        case 'createdDate':
          return _isoToDate(val.createdDate?.toString() ?? '');
        case 'purchaseOrderNo':
          return val.purchaseOrderNo?.toString() ?? '';
        case 'procedureNo':
          return val.procedureNo?.toString() ?? '';
        case 'notes':
          return val.notes?.toString() ?? '';
        case 'divisionId':
          return val.divisionId?.toString() ?? val.divisionID?.toString() ?? '';
        case 'address':
          return val.address?.toString() ?? '';
        case 'allocatedDuration':
          return val.allocatedDuration?.toString() ?? '';
        case 'estimatedInspectionDuration':
          return val.estimatedInspectionDuration?.toString() ?? '';
        case 'estimatedStartDate':
          return _isoToDate(val.estimatedStartDate?.toString() ?? '');
        case 'estimatedEndDate':
          return _isoToDate(val.estimatedEndDate?.toString() ?? '');
        case 'offshoreLocation':
          return val.offshoreLocation?.toString() ?? '';
        case 'location':
          return val.location?.toString() ?? '';
        case 'issuingAuthName':
          return val.issuingAuthName?.toString() ?? '';
        case 'clientName':
          return val.clientName?.toString() ?? '';
        case 'authenticator':
          return val.authenticator?.toString() ?? '';
        default:
          return '';
      }
    } catch (_) {
      return '';
    }
  }

  /// Converts ISO date string → 'yyyy-MM-dd' for the text field.
  String _isoToDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((results) {
      if (mounted) {
        setState(() {
          _isOffline = results.every((r) => r == ConnectivityResult.none);
        });
      }
    });
    _initializeControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final systemProvider = Provider.of<SystemProvider>(
        context,
        listen: false,
      );
      if (systemProvider.divisions.isEmpty) systemProvider.fetchDivision();

      final personnelProvider = Provider.of<PersonnelProvider>(
        context,
        listen: false,
      );
      if (personnelProvider.activePersonnel.isEmpty) {
        personnelProvider.fetchPersonnel();
      }

      // Pre-select dropdowns after providers have loaded
      if (widget.isEditMode && widget.job != null) {
        final divId = _jobStr('divisionId');
        if (divId.isNotEmpty) {
          setState(() {
            selectedDivisionId = divId;
            divisionController.text = divId;
          });
        }
        final authId = _jobStr('authenticator');
        if (authId.isNotEmpty) {
          setState(() => selectedAuthenticatorId = authId);
        }
      }
    });
  }

  void _initializeControllers() {
    final isEdit = widget.isEditMode && widget.job != null;

    jobNoController = TextEditingController(
      text: isEdit ? _jobStr('jobNo') : '',
    );
    createdDateController = TextEditingController(
      text:
          isEdit
              ? _jobStr('createdDate')
              : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    poController = TextEditingController(
      text: isEdit ? _jobStr('purchaseOrderNo') : '',
    );
    procedureController = TextEditingController(
      text: isEdit ? _jobStr('procedureNo') : '',
    );
    notesController = TextEditingController(
      text: isEdit ? _jobStr('notes') : '',
    );
    divisionController = TextEditingController(
      text: isEdit ? _jobStr('divisionId') : '',
    );
    addressController = TextEditingController(
      text: isEdit ? _jobStr('address') : '',
    );
    allocatedDurationController = TextEditingController(
      text: isEdit ? _jobStr('allocatedDuration') : '',
    );
    estInspectionDurationController = TextEditingController(
      text: isEdit ? _jobStr('estimatedInspectionDuration') : '',
    );
    estStartDateController = TextEditingController(
      text: isEdit ? _jobStr('estimatedStartDate') : '',
    );
    estEndDateController = TextEditingController(
      text: isEdit ? _jobStr('estimatedEndDate') : '',
    );
    engineerCompleteController = TextEditingController();
    offshoreLocationController = TextEditingController(
      text: isEdit ? _jobStr('offshoreLocation') : '',
    );
    locationController = TextEditingController(
      text: isEdit ? _jobStr('location') : '',
    );
    issuingAuthNameController = TextEditingController(
      text: isEdit ? _jobStr('issuingAuthName') : '',
    );
    clientNameController = TextEditingController(
      text: isEdit ? _jobStr('clientName') : '',
    );
    issuingAuthNameSignatureController = TextEditingController();
    clientSignatureController = TextEditingController();
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isOffline = results.every((r) => r == ConnectivityResult.none);
      });
    }
  }

  @override
  void dispose() {
    jobNoController.dispose();
    createdDateController.dispose();
    poController.dispose();
    procedureController.dispose();
    notesController.dispose();
    divisionController.dispose();
    addressController.dispose();
    allocatedDurationController.dispose();
    estInspectionDurationController.dispose();
    estStartDateController.dispose();
    estEndDateController.dispose();
    engineerCompleteController.dispose();
    offshoreLocationController.dispose();
    locationController.dispose();
    issuingAuthNameController.dispose();
    clientNameController.dispose();
    issuingAuthNameSignatureController.dispose();
    clientSignatureController.dispose();
    super.dispose();
  }

  // ── Job ID Generator ───────────────────────────────────────────────────────

  String _abbreviateSiteName(String siteName) {
    final words = siteName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return siteName.toUpperCase();

    final firstWord = words[0];
    if (words.length == 1) {
      return firstWord.length >= 3
          ? firstWord.substring(0, 3).toUpperCase()
          : firstWord.toUpperCase();
    }

    final firstTwo =
        firstWord.length >= 2
            ? firstWord.substring(0, 2).toUpperCase()
            : firstWord.toUpperCase();

    final secondInitial = words[1][0].toUpperCase();
    return '$firstTwo$secondInitial';
  }

  String _generateJobId() {
    final customerPrefix =
        widget.customerName.length >= 3
            ? widget.customerName.substring(0, 3).toUpperCase()
            : widget.customerName.toUpperCase();

    final siteCode = _abbreviateSiteName(widget.siteName);

    final year =
        createdDateController.text.isNotEmpty
            ? createdDateController.text.substring(0, 4)
            : DateTime.now().year.toString();

    final jobNoPadded = (int.tryParse(jobNoController.text.trim()) ?? 0)
        .toString()
        .padLeft(5, '0');

    return '$customerPrefix/$siteCode/$year/$jobNoPadded';
  }

  // ── Location pickers ───────────────────────────────────────────────────────

  void _openOffshoreLocationPicker() {
    showLocationPickerDialog(
      context: context,
      controller: offshoreLocationController,
      storageKey: PickerStorageKey.offshoreLocation,
      dialogTitle: 'Select Inspection Location',
      emptyHint: 'Select or enter Inspection Location',
      fieldDefinedLocations: const [],
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _openLocationPicker() {
    showLocationPickerDialog(
      context: context,
      controller: locationController,
      storageKey: PickerStorageKey.jobLocation,
      dialogTitle: 'Select Location',
      emptyHint: 'Select or enter location',
      fieldDefinedLocations: const [],
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget _buildLocationField(BuildContext context) {
    return _buildPickerChipRow(
      context,
      label: 'Location',
      icon: Icons.location_on_outlined,
      controller: locationController,
      hint: 'Select or enter location',
      onTap: _openLocationPicker,
    );
  }

  static const List<String> _procedureNoPresets = [
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

  void _openProcedureNoPicker() {
    showLocationPickerDialog(
      context: context,
      controller: procedureController,
      storageKey: PickerStorageKey.applicableCode,
      dialogTitle: 'Select Procedure No',
      emptyHint: 'Select or enter procedure no',
      fieldDefinedLocations: _procedureNoPresets,
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget _buildProcedureNoField(BuildContext context) {
    return _buildPickerChipRow(
      context,
      label: 'Procedure No',
      icon: Icons.description_outlined,
      controller: procedureController,
      hint: 'Select or enter procedure no',
      onTap: _openProcedureNoPicker,
    );
  }

  Widget _buildOffshoreLocationField(BuildContext context) {
    return _buildPickerChipRow(
      context,
      label: 'Inspection Location',
      icon: Icons.water,
      controller: offshoreLocationController,
      hint: 'Select or enter inspection location',
      onTap: _openOffshoreLocationPicker,
    );
  }

  Widget _buildPickerChipRow(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
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
            onTap: onTap,
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
                              : context.colors.primary.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        hasValue
                            ? context.colors.primary.withOpacity(0.05)
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
                                : context.colors.primary.withOpacity(0.4),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasValue ? value.text : hint,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color:
                                hasValue
                                    ? context.colors.primary
                                    : context.colors.primary.withOpacity(0.4),
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
                              color: context.colors.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      if (!hasValue)
                        Icon(
                          Icons.arrow_drop_down,
                          color: context.colors.primary.withOpacity(0.6),
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

  // ── Validation & Data ──────────────────────────────────────────────────────

  String _formatDateToIso(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return '${date.toIso8601String()}Z';
    } catch (e) {
      debugPrint('Date format error: $e');
      return '';
    }
  }

  bool _validateForm() {
    if (jobNoController.text.trim().isEmpty) {
      CommonSnackbar.showError(context, 'Job No is required');
      return false;
    }
    if (selectedDivisionId == null || selectedDivisionId!.isEmpty) {
      CommonSnackbar.showError(context, 'Division is required');
      return false;
    }
    if (estStartDateController.text.trim().isEmpty) {
      CommonSnackbar.showError(context, 'Estimated Start Date is required');
      return false;
    }
    if (estEndDateController.text.trim().isEmpty) {
      CommonSnackbar.showError(context, 'Estimated End Date is required');
      return false;
    }
    try {
      final startDate = DateFormat(
        'yyyy-MM-dd',
      ).parse(estStartDateController.text);
      final endDate = DateFormat('yyyy-MM-dd').parse(estEndDateController.text);
      if (endDate.isBefore(startDate)) {
        CommonSnackbar.showError(context, 'End date must be after start date');
        return false;
      }
    } catch (e) {
      CommonSnackbar.showError(context, 'Invalid date format');
      return false;
    }
    if (selectedAuthenticatorId == null || selectedAuthenticatorId!.isEmpty) {
      CommonSnackbar.showError(context, 'Authenticator is required');
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildJobData() {
    return {
      'jobID': _generateJobId(),
      'customerid': widget.customerId,
      'jobno': jobNoController.text,
      'siteID': widget.siteId,
      'createdDate': _formatDateToIso(createdDateController.text),
      'purchaseOrderNo': poController.text,
      'procedureNo': procedureController.text,
      'notes': notesController.text,
      'divisionID': divisionController.text,
      'address': addressController.text,
      'allocatedDuration': int.tryParse(allocatedDurationController.text) ?? 0,
      'estimatedInspectionDuration':
          int.tryParse(estInspectionDurationController.text) ?? 0,
      'estimatedStartDate': _formatDateToIso(estStartDateController.text),
      'estimatedEndDate': _formatDateToIso(estEndDateController.text),
      'isEngineerComplete':
          engineerCompleteController.text.toLowerCase() == 'yes',
      'offshoreLocation': offshoreLocationController.text,
      'location': locationController.text,
      'authenticator': selectedAuthenticatorId ?? '',
      'issuingAuthName': issuingAuthNameController.text,
      'issuingAuthSignature': _issuingAuthSignatureFile?.name ?? '',
      'clientName': clientNameController.text,
      'clientSignature': _clientSignatureFile?.name ?? '',
      'startJobNow': true,
    };
  }

  // ── Create / Update Job ────────────────────────────────────────────────────

  Future<void> _submitJob() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final jobData = _buildJobData();

      if (jobData['customerid'].toString().isEmpty) {
        CommonSnackbar.showError(context, 'Customer ID is missing');
        return;
      }
      if (jobData['siteID'].toString().isEmpty) {
        CommonSnackbar.showError(context, 'Site ID is missing');
        return;
      }

      if (!mounted) return;

      final jobProvider = Provider.of<JobProvider>(context, listen: false);

      if (widget.isEditMode && widget.job != null) {
        final jobId =
            widget.job.jobId?.toString() ?? widget.job.jobID?.toString() ?? '';
        debugPrint('✏️ Updating job: $jobId');
        await jobProvider.updateJobFromDetails(context, jobId, jobData);
      } else {
        debugPrint('📋 Job ID: ${jobData['jobID']}');
        await jobProvider.createJobFromDetails(context, jobData);
      }
    } catch (_) {
      // Errors are already handled and snackbarred in the provider.
      // We just need the finally block to run.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── UI helpers ─────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.05),
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool isRequired = false,
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
                  color: context.colors.primary.withOpacity(0.7),
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
          child: CommonDatePickerInput(label: '', controller: controller),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    String title, {
    TextEditingController? controller,
    bool isRequired = false,
    IconData? icon,
    int minLines = 1,
    int maxLines = 1,
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
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  title + (isRequired ? ' *' : ''),
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
          child: CommonTextField(
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivisionDropdown(BuildContext context, {IconData? icon}) {
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
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  'Division Name *',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Consumer<SystemProvider>(
            builder: (context, systemProvider, child) {
              if (systemProvider.isLoading) {
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              return CommonDropdown<String>(
                value: selectedDivisionId,
                items:
                    systemProvider.divisions.map((division) {
                      return DropdownMenuItem<String>(
                        value: division.divisionid,
                        child: Text(
                          division.divisionname ?? 'Unknown',
                          style: context.topology.textTheme.bodySmall,
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDivisionId = value;
                    divisionController.text = value ?? '';
                    if (value != null) {
                      final selectedDivision = systemProvider.divisions
                          .firstWhere(
                            (d) => d.divisionid == value,
                            orElse: () => systemProvider.divisions.first,
                          );
                      addressController.text = selectedDivision.address ?? '';
                    } else {
                      addressController.text = '';
                    }
                  });
                },
                borderColor: context.colors.primary,
                textStyle: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuthenticatorDropdown(BuildContext context, {IconData? icon}) {
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
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  'Authenticator *',
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Consumer<PersonnelProvider>(
            builder: (context, personnelProvider, child) {
              if (personnelProvider.isLoading) {
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final personnelList = personnelProvider.activePersonnel;

              return CommonDropdown<String>(
                value: selectedAuthenticatorId,
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
                  ...personnelList.map((personnelData) {
                    return DropdownMenuItem<String>(
                      value: personnelData.personnel.personnelID,
                      child: Text(
                        personnelData.displayName,
                        style: context.topology.textTheme.bodySmall,
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => selectedAuthenticatorId = value);
                },
                borderColor: context.colors.primary,
                textStyle: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadRow(
    BuildContext context,
    String label,
    PlatformFile? pickedFile,
    Function() onPickFile,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.upload_file,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onPickFile,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.colors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.attach_file,
                        color: context.colors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Choose File',
                        style: context.topology.textTheme.titleSmall?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (pickedFile != null) ...[
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
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          pickedFile.name,
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickIssuingAuthSignature() async {
    try {
      final result = await FilePicker.pickFiles();
      if (result != null && mounted) {
        setState(() {
          _issuingAuthSignatureFile = result.files.first;
          issuingAuthNameSignatureController.text = result.files.first.name;
        });
      }
    } catch (e) {
      debugPrint('❌ Error picking issuing auth signature: $e');
      if (mounted) CommonSnackbar.showError(context, 'Failed to pick file');
    }
  }

  Future<void> _pickClientSignature() async {
    try {
      final result = await FilePicker.pickFiles();
      if (result != null && mounted) {
        setState(() {
          _clientSignatureFile = result.files.first;
          clientSignatureController.text = result.files.first.name;
        });
      }
    } catch (e) {
      debugPrint('❌ Error picking client signature: $e');
      if (mounted) CommonSnackbar.showError(context, 'Failed to pick file');
    }
  }

  // ── Button label / title helpers ───────────────────────────────────────────

  String get _submitLabel {
    if (_isOffline) return 'Save Offline';
    if (_isLoading) return widget.isEditMode ? 'Saving...' : 'Creating...';
    return widget.isEditMode ? 'Save Changes' : 'Create Job';
  }

  String get _appBarTitle =>
      widget.isEditMode ? 'Edit Job Details' : 'New Job Details';

  // ── Layouts ────────────────────────────────────────────────────────────────

  Widget _buildTabletLayout(BuildContext context) {
    return Expanded(
      child: Padding(
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
                          _buildSectionHeader(
                            context,
                            'Job Information',
                            Icons.work_outline,
                          ),
                          context.vM,
                          _buildRow(
                            context,
                            'Job No',
                            controller: jobNoController,
                            isRequired: true,
                            icon: Icons.tag,
                          ),
                          context.vS,
                          _buildRow(
                            context,
                            'Created Date',
                            controller: createdDateController,
                            icon: Icons.calendar_today,
                          ),
                          context.vS,
                          _buildRow(
                            context,
                            'Purchase Order No',
                            controller: poController,
                            icon: Icons.shopping_cart,
                          ),
                          context.vS,
                          _buildProcedureNoField(context),
                          context.vS,
                          _buildRow(
                            context,
                            'Notes',
                            controller: notesController,
                            icon: Icons.notes,
                          ),
                          context.vL,
                          _buildSectionHeader(
                            context,
                            'Duration & Schedule',
                            Icons.schedule,
                          ),
                          context.vM,
                          _buildDateField(
                            context,
                            'Est. Start Date',
                            estStartDateController,
                            icon: Icons.event,
                            isRequired: true,
                          ),
                          context.vS,
                          _buildDateField(
                            context,
                            'Est. End Date',
                            estEndDateController,
                            icon: Icons.event_available,
                            isRequired: true,
                          ),
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
                          _buildSectionHeader(
                            context,
                            'Location Details',
                            Icons.location_on,
                          ),
                          context.vM,
                          _buildDivisionDropdown(context, icon: Icons.business),
                          context.vS,
                          _buildRow(
                            context,
                            'Address',
                            controller: addressController,
                            icon: Icons.home,
                            minLines: 3,
                            maxLines: 5,
                          ),
                          context.vS,
                          _buildLocationField(context),
                          context.vS,
                          _buildOffshoreLocationField(context),
                          context.vS,
                          context.vL,
                          _buildSectionHeader(
                            context,
                            'Authorization',
                            Icons.verified_user,
                          ),
                          context.vM,
                          _buildAuthenticatorDropdown(
                            context,
                            icon: Icons.admin_panel_settings,
                          ),
                          context.vS,
                          _buildRow(
                            context,
                            'Client Name',
                            controller: clientNameController,
                            icon: Icons.person_outline,
                          ),
                          context.vS,
                          _buildFileUploadRow(
                            context,
                            'Client Signature',
                            _clientSignatureFile,
                            _pickClientSignature,
                          ),
                          context.vS,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            context.vL,
            SizedBox(
              width: 200,
              child: CommonButton(
                text: _submitLabel,
                onPressed: _isLoading ? null : _submitJob,
              ),
            ),
            context.vM,
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: context.paddingHorizontal,
        child: Column(
          children: [
            context.vM,
            _buildSectionHeader(context, 'Job Information', Icons.work_outline),
            context.vM,
            _buildRow(
              context,
              'Job No',
              controller: jobNoController,
              isRequired: true,
              icon: Icons.tag,
            ),
            context.vS,
            _buildRow(
              context,
              'Created Date',
              controller: createdDateController,
              icon: Icons.calendar_today,
            ),
            context.vS,
            _buildRow(
              context,
              'Purchase Order No',
              controller: poController,
              icon: Icons.shopping_cart,
            ),
            context.vS,
            _buildProcedureNoField(context),
            context.vS,
            _buildRow(
              context,
              'Notes',
              controller: notesController,
              icon: Icons.notes,
            ),
            context.vL,
            _buildSectionHeader(context, 'Location Details', Icons.location_on),
            context.vM,
            _buildDivisionDropdown(context, icon: Icons.business),
            context.vS,
            _buildRow(
              context,
              'Address',
              controller: addressController,
              icon: Icons.home,
              minLines: 3,
              maxLines: 5,
            ),
            context.vS,
            _buildLocationField(context),
            context.vS,
            _buildOffshoreLocationField(context),
            context.vL,
            _buildSectionHeader(context, 'Duration & Schedule', Icons.schedule),
            context.vM,
            _buildDateField(
              context,
              'Est. Start Date',
              estStartDateController,
              icon: Icons.event,
              isRequired: true,
            ),
            context.vS,
            _buildDateField(
              context,
              'Est. End Date',
              estEndDateController,
              icon: Icons.event_available,
              isRequired: true,
            ),
            context.vL,
            _buildSectionHeader(context, 'Authorization', Icons.verified_user),
            context.vM,
            _buildAuthenticatorDropdown(
              context,
              icon: Icons.admin_panel_settings,
            ),
            context.vS,
            _buildRow(
              context,
              'Client Name',
              controller: clientNameController,
              icon: Icons.person_outline,
            ),
            context.vS,
            _buildFileUploadRow(
              context,
              'Client Signature',
              _clientSignatureFile,
              _pickClientSignature,
            ),
            context.vL,
            CommonButton(
              text: _submitLabel,
              onPressed: _isLoading ? null : _submitJob,
            ),
            context.vL,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isEditMode ? Icons.edit_outlined : Icons.add_task,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  _appBarTitle,
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.customerName}  ·  ${widget.siteName}',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationService().goBack(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: context.colors.primary),
                    const SizedBox(height: 16),
                    Text(
                      widget.isEditMode
                          ? 'Saving changes...'
                          : 'Creating job...',
                      style: context.topology.textTheme.bodyMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // ── Offline banner ──────────────────────────────────────
                  if (_isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      color: Colors.orange.shade700,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Offline mode — job will be queued and synced when you reconnect.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child:
                        context.isTablet
                            ? _buildTabletLayout(context)
                            : _buildMobileLayout(context),
                  ),
                ],
              ),
    );
  }
}
