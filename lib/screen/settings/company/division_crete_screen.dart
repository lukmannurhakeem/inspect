import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_company_division/get_company_division.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _CultureEntry {
  final String code;
  final String label;

  const _CultureEntry(this.code, this.label);
}

class _TimezoneEntry {
  final String id;
  final String label;

  const _TimezoneEntry(this.id, this.label);
}

const List<_CultureEntry> _cultures = [
  _CultureEntry('af-ZA', 'Afrikaans (South Africa)'),
  _CultureEntry('sq-AL', 'Albanian (Albania)'),
  _CultureEntry('ar-DZ', 'Arabic (Algeria)'),
  _CultureEntry('ar-BH', 'Arabic (Bahrain)'),
  _CultureEntry('ar-EG', 'Arabic (Egypt)'),
  _CultureEntry('ar-IQ', 'Arabic (Iraq)'),
  _CultureEntry('ar-JO', 'Arabic (Jordan)'),
  _CultureEntry('ar-KW', 'Arabic (Kuwait)'),
  _CultureEntry('ar-LB', 'Arabic (Lebanon)'),
  _CultureEntry('ar-LY', 'Arabic (Libya)'),
  _CultureEntry('ar-MA', 'Arabic (Morocco)'),
  _CultureEntry('ar-OM', 'Arabic (Oman)'),
  _CultureEntry('ar-QA', 'Arabic (Qatar)'),
  _CultureEntry('ar-SA', 'Arabic (Saudi Arabia)'),
  _CultureEntry('ar-SY', 'Arabic (Syria)'),
  _CultureEntry('ar-TN', 'Arabic (Tunisia)'),
  _CultureEntry('ar-AE', 'Arabic (UAE)'),
  _CultureEntry('ar-YE', 'Arabic (Yemen)'),
  _CultureEntry('hy-AM', 'Armenian (Armenia)'),
  _CultureEntry('az-AZ', 'Azerbaijani (Azerbaijan)'),
  _CultureEntry('eu-ES', 'Basque (Spain)'),
  _CultureEntry('be-BY', 'Belarusian (Belarus)'),
  _CultureEntry('bn-BD', 'Bengali (Bangladesh)'),
  _CultureEntry('bn-IN', 'Bengali (India)'),
  _CultureEntry('bs-BA', 'Bosnian (Bosnia)'),
  _CultureEntry('bg-BG', 'Bulgarian (Bulgaria)'),
  _CultureEntry('ca-ES', 'Catalan (Spain)'),
  _CultureEntry('zh-CN', 'Chinese (Simplified, China)'),
  _CultureEntry('zh-HK', 'Chinese (Traditional, Hong Kong)'),
  _CultureEntry('zh-TW', 'Chinese (Traditional, Taiwan)'),
  _CultureEntry('hr-HR', 'Croatian (Croatia)'),
  _CultureEntry('cs-CZ', 'Czech (Czech Republic)'),
  _CultureEntry('da-DK', 'Danish (Denmark)'),
  _CultureEntry('nl-BE', 'Dutch (Belgium)'),
  _CultureEntry('nl-NL', 'Dutch (Netherlands)'),
  _CultureEntry('en-AU', 'English (Australia)'),
  _CultureEntry('en-CA', 'English (Canada)'),
  _CultureEntry('en-IN', 'English (India)'),
  _CultureEntry('en-IE', 'English (Ireland)'),
  _CultureEntry('en-MY', 'English (Malaysia)'),
  _CultureEntry('en-NZ', 'English (New Zealand)'),
  _CultureEntry('en-PH', 'English (Philippines)'),
  _CultureEntry('en-SG', 'English (Singapore)'),
  _CultureEntry('en-ZA', 'English (South Africa)'),
  _CultureEntry('en-GB', 'English (United Kingdom)'),
  _CultureEntry('en-US', 'English (United States)'),
  _CultureEntry('et-EE', 'Estonian (Estonia)'),
  _CultureEntry('fi-FI', 'Finnish (Finland)'),
  _CultureEntry('fr-BE', 'French (Belgium)'),
  _CultureEntry('fr-CA', 'French (Canada)'),
  _CultureEntry('fr-FR', 'French (France)'),
  _CultureEntry('fr-LU', 'French (Luxembourg)'),
  _CultureEntry('fr-CH', 'French (Switzerland)'),
  _CultureEntry('gl-ES', 'Galician (Spain)'),
  _CultureEntry('ka-GE', 'Georgian (Georgia)'),
  _CultureEntry('de-AT', 'German (Austria)'),
  _CultureEntry('de-DE', 'German (Germany)'),
  _CultureEntry('de-LU', 'German (Luxembourg)'),
  _CultureEntry('de-CH', 'German (Switzerland)'),
  _CultureEntry('el-GR', 'Greek (Greece)'),
  _CultureEntry('gu-IN', 'Gujarati (India)'),
  _CultureEntry('he-IL', 'Hebrew (Israel)'),
  _CultureEntry('hi-IN', 'Hindi (India)'),
  _CultureEntry('hu-HU', 'Hungarian (Hungary)'),
  _CultureEntry('is-IS', 'Icelandic (Iceland)'),
  _CultureEntry('id-ID', 'Indonesian (Indonesia)'),
  _CultureEntry('ga-IE', 'Irish (Ireland)'),
  _CultureEntry('it-IT', 'Italian (Italy)'),
  _CultureEntry('it-CH', 'Italian (Switzerland)'),
  _CultureEntry('ja-JP', 'Japanese (Japan)'),
  _CultureEntry('kn-IN', 'Kannada (India)'),
  _CultureEntry('kk-KZ', 'Kazakh (Kazakhstan)'),
  _CultureEntry('km-KH', 'Khmer (Cambodia)'),
  _CultureEntry('ko-KR', 'Korean (Korea)'),
  _CultureEntry('ky-KG', 'Kyrgyz (Kyrgyzstan)'),
  _CultureEntry('lo-LA', 'Lao (Laos)'),
  _CultureEntry('lv-LV', 'Latvian (Latvia)'),
  _CultureEntry('lt-LT', 'Lithuanian (Lithuania)'),
  _CultureEntry('mk-MK', 'Macedonian (North Macedonia)'),
  _CultureEntry('ms-BN', 'Malay (Brunei)'),
  _CultureEntry('ms-MY', 'Malay (Malaysia)'),
  _CultureEntry('ml-IN', 'Malayalam (India)'),
  _CultureEntry('mt-MT', 'Maltese (Malta)'),
  _CultureEntry('mr-IN', 'Marathi (India)'),
  _CultureEntry('mn-MN', 'Mongolian (Mongolia)'),
  _CultureEntry('ne-NP', 'Nepali (Nepal)'),
  _CultureEntry('nb-NO', 'Norwegian Bokmål (Norway)'),
  _CultureEntry('nn-NO', 'Norwegian Nynorsk (Norway)'),
  _CultureEntry('ps-AF', 'Pashto (Afghanistan)'),
  _CultureEntry('fa-IR', 'Persian (Iran)'),
  _CultureEntry('pl-PL', 'Polish (Poland)'),
  _CultureEntry('pt-BR', 'Portuguese (Brazil)'),
  _CultureEntry('pt-PT', 'Portuguese (Portugal)'),
  _CultureEntry('pa-IN', 'Punjabi (India)'),
  _CultureEntry('ro-RO', 'Romanian (Romania)'),
  _CultureEntry('ru-RU', 'Russian (Russia)'),
  _CultureEntry('sr-RS', 'Serbian (Serbia)'),
  _CultureEntry('si-LK', 'Sinhala (Sri Lanka)'),
  _CultureEntry('sk-SK', 'Slovak (Slovakia)'),
  _CultureEntry('sl-SI', 'Slovenian (Slovenia)'),
  _CultureEntry('es-AR', 'Spanish (Argentina)'),
  _CultureEntry('es-BO', 'Spanish (Bolivia)'),
  _CultureEntry('es-CL', 'Spanish (Chile)'),
  _CultureEntry('es-CO', 'Spanish (Colombia)'),
  _CultureEntry('es-CR', 'Spanish (Costa Rica)'),
  _CultureEntry('es-DO', 'Spanish (Dominican Republic)'),
  _CultureEntry('es-EC', 'Spanish (Ecuador)'),
  _CultureEntry('es-SV', 'Spanish (El Salvador)'),
  _CultureEntry('es-GT', 'Spanish (Guatemala)'),
  _CultureEntry('es-HN', 'Spanish (Honduras)'),
  _CultureEntry('es-MX', 'Spanish (Mexico)'),
  _CultureEntry('es-NI', 'Spanish (Nicaragua)'),
  _CultureEntry('es-PA', 'Spanish (Panama)'),
  _CultureEntry('es-PY', 'Spanish (Paraguay)'),
  _CultureEntry('es-PE', 'Spanish (Peru)'),
  _CultureEntry('es-PR', 'Spanish (Puerto Rico)'),
  _CultureEntry('es-ES', 'Spanish (Spain)'),
  _CultureEntry('es-UY', 'Spanish (Uruguay)'),
  _CultureEntry('es-VE', 'Spanish (Venezuela)'),
  _CultureEntry('sw-KE', 'Swahili (Kenya)'),
  _CultureEntry('sv-SE', 'Swedish (Sweden)'),
  _CultureEntry('tl-PH', 'Tagalog (Philippines)'),
  _CultureEntry('ta-IN', 'Tamil (India)'),
  _CultureEntry('ta-LK', 'Tamil (Sri Lanka)'),
  _CultureEntry('te-IN', 'Telugu (India)'),
  _CultureEntry('th-TH', 'Thai (Thailand)'),
  _CultureEntry('tr-TR', 'Turkish (Turkey)'),
  _CultureEntry('uk-UA', 'Ukrainian (Ukraine)'),
  _CultureEntry('ur-PK', 'Urdu (Pakistan)'),
  _CultureEntry('uz-UZ', 'Uzbek (Uzbekistan)'),
  _CultureEntry('vi-VN', 'Vietnamese (Vietnam)'),
  _CultureEntry('cy-GB', 'Welsh (United Kingdom)'),
];

const List<_TimezoneEntry> _timezones = [
  _TimezoneEntry('Pacific/Midway', '(UTC-11:00) Midway Island, Samoa'),
  _TimezoneEntry('Pacific/Pago_Pago', '(UTC-11:00) American Samoa'),
  _TimezoneEntry('Pacific/Honolulu', '(UTC-10:00) Hawaii'),
  _TimezoneEntry('America/Anchorage', '(UTC-09:00) Alaska'),
  _TimezoneEntry(
    'America/Los_Angeles',
    '(UTC-08:00) Pacific Time (US & Canada)',
  ),
  _TimezoneEntry('America/Tijuana', '(UTC-08:00) Tijuana, Baja California'),
  _TimezoneEntry('America/Denver', '(UTC-07:00) Mountain Time (US & Canada)'),
  _TimezoneEntry('America/Phoenix', '(UTC-07:00) Arizona'),
  _TimezoneEntry('America/Chihuahua', '(UTC-07:00) Chihuahua, Mazatlan'),
  _TimezoneEntry('America/Chicago', '(UTC-06:00) Central Time (US & Canada)'),
  _TimezoneEntry('America/Mexico_City', '(UTC-06:00) Mexico City, Monterrey'),
  _TimezoneEntry('America/Regina', '(UTC-06:00) Saskatchewan'),
  _TimezoneEntry('America/Guatemala', '(UTC-06:00) Central America'),
  _TimezoneEntry('America/New_York', '(UTC-05:00) Eastern Time (US & Canada)'),
  _TimezoneEntry('America/Indiana/Indianapolis', '(UTC-05:00) Indiana (East)'),
  _TimezoneEntry('America/Bogota', '(UTC-05:00) Bogota, Lima, Quito'),
  _TimezoneEntry('America/Caracas', '(UTC-04:30) Caracas'),
  _TimezoneEntry('America/Halifax', '(UTC-04:00) Atlantic Time (Canada)'),
  _TimezoneEntry('America/Manaus', '(UTC-04:00) Manaus'),
  _TimezoneEntry('America/Santiago', '(UTC-04:00) Santiago'),
  _TimezoneEntry('America/La_Paz', '(UTC-04:00) La Paz'),
  _TimezoneEntry('America/St_Johns', '(UTC-03:30) Newfoundland'),
  _TimezoneEntry('America/Sao_Paulo', '(UTC-03:00) Brasilia'),
  _TimezoneEntry('America/Argentina/Buenos_Aires', '(UTC-03:00) Buenos Aires'),
  _TimezoneEntry('America/Godthab', '(UTC-03:00) Greenland'),
  _TimezoneEntry('America/Montevideo', '(UTC-03:00) Montevideo'),
  _TimezoneEntry('Atlantic/South_Georgia', '(UTC-02:00) Mid-Atlantic'),
  _TimezoneEntry('Atlantic/Azores', '(UTC-01:00) Azores'),
  _TimezoneEntry('Atlantic/Cape_Verde', '(UTC-01:00) Cape Verde Is.'),
  _TimezoneEntry('Europe/London', '(UTC+00:00) London, Dublin, Edinburgh'),
  _TimezoneEntry('Africa/Casablanca', '(UTC+00:00) Casablanca'),
  _TimezoneEntry('Africa/Monrovia', '(UTC+00:00) Monrovia, Reykjavik'),
  _TimezoneEntry(
    'Europe/Berlin',
    '(UTC+01:00) Amsterdam, Berlin, Rome, Vienna',
  ),
  _TimezoneEntry('Europe/Paris', '(UTC+01:00) Paris, Madrid, Brussels'),
  _TimezoneEntry('Europe/Warsaw', '(UTC+01:00) Warsaw, Prague, Budapest'),
  _TimezoneEntry('Africa/Lagos', '(UTC+01:00) West Central Africa'),
  _TimezoneEntry('Africa/Cairo', '(UTC+02:00) Cairo'),
  _TimezoneEntry('Europe/Helsinki', '(UTC+02:00) Helsinki, Kyiv, Riga, Sofia'),
  _TimezoneEntry('Europe/Istanbul', '(UTC+02:00) Istanbul, Minsk'),
  _TimezoneEntry('Asia/Jerusalem', '(UTC+02:00) Jerusalem'),
  _TimezoneEntry('Africa/Johannesburg', '(UTC+02:00) Harare, Pretoria'),
  _TimezoneEntry('Europe/Moscow', '(UTC+03:00) Moscow, St. Petersburg'),
  _TimezoneEntry('Asia/Kuwait', '(UTC+03:00) Kuwait, Riyadh'),
  _TimezoneEntry('Africa/Nairobi', '(UTC+03:00) Nairobi'),
  _TimezoneEntry('Asia/Baghdad', '(UTC+03:00) Baghdad'),
  _TimezoneEntry('Asia/Tehran', '(UTC+03:30) Tehran'),
  _TimezoneEntry('Asia/Dubai', '(UTC+04:00) Abu Dhabi, Muscat'),
  _TimezoneEntry('Asia/Baku', '(UTC+04:00) Baku, Tbilisi, Yerevan'),
  _TimezoneEntry('Asia/Kabul', '(UTC+04:30) Kabul'),
  _TimezoneEntry('Asia/Yekaterinburg', '(UTC+05:00) Yekaterinburg'),
  _TimezoneEntry('Asia/Karachi', '(UTC+05:00) Islamabad, Karachi'),
  _TimezoneEntry('Asia/Tashkent', '(UTC+05:00) Tashkent'),
  _TimezoneEntry(
    'Asia/Kolkata',
    '(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi',
  ),
  _TimezoneEntry('Asia/Colombo', '(UTC+05:30) Sri Jayawardenepura'),
  _TimezoneEntry('Asia/Kathmandu', '(UTC+05:45) Kathmandu'),
  _TimezoneEntry('Asia/Dhaka', '(UTC+06:00) Dhaka'),
  _TimezoneEntry('Asia/Almaty', '(UTC+06:00) Almaty, Novosibirsk'),
  _TimezoneEntry('Asia/Rangoon', '(UTC+06:30) Yangon, Rangoon'),
  _TimezoneEntry('Asia/Bangkok', '(UTC+07:00) Bangkok, Hanoi, Jakarta'),
  _TimezoneEntry('Asia/Krasnoyarsk', '(UTC+07:00) Krasnoyarsk'),
  _TimezoneEntry('Asia/Shanghai', '(UTC+08:00) Beijing, Chongqing, Urumqi'),
  _TimezoneEntry('Asia/Kuala_Lumpur', '(UTC+08:00) Kuala Lumpur, Singapore'),
  _TimezoneEntry('Asia/Taipei', '(UTC+08:00) Taipei'),
  _TimezoneEntry('Asia/Ulaanbaatar', '(UTC+08:00) Ulaanbaatar'),
  _TimezoneEntry('Australia/Perth', '(UTC+08:00) Perth'),
  _TimezoneEntry('Asia/Irkutsk', '(UTC+08:00) Irkutsk'),
  _TimezoneEntry('Asia/Seoul', '(UTC+09:00) Seoul'),
  _TimezoneEntry('Asia/Tokyo', '(UTC+09:00) Osaka, Sapporo, Tokyo'),
  _TimezoneEntry('Asia/Yakutsk', '(UTC+09:00) Yakutsk'),
  _TimezoneEntry('Australia/Adelaide', '(UTC+09:30) Adelaide'),
  _TimezoneEntry('Australia/Darwin', '(UTC+09:30) Darwin'),
  _TimezoneEntry('Australia/Brisbane', '(UTC+10:00) Brisbane'),
  _TimezoneEntry('Australia/Sydney', '(UTC+10:00) Canberra, Melbourne, Sydney'),
  _TimezoneEntry('Pacific/Guam', '(UTC+10:00) Guam, Port Moresby'),
  _TimezoneEntry('Australia/Hobart', '(UTC+10:00) Hobart'),
  _TimezoneEntry('Asia/Vladivostok', '(UTC+10:00) Vladivostok'),
  _TimezoneEntry('Pacific/Noumea', '(UTC+11:00) Solomon Is., New Caledonia'),
  _TimezoneEntry('Asia/Magadan', '(UTC+11:00) Magadan'),
  _TimezoneEntry('Pacific/Auckland', '(UTC+12:00) Auckland, Wellington'),
  _TimezoneEntry('Pacific/Fiji', '(UTC+12:00) Fiji, Marshall Is.'),
  _TimezoneEntry('Asia/Kamchatka', '(UTC+12:00) Kamchatka'),
  _TimezoneEntry('Pacific/Tongatapu', '(UTC+13:00) Nukualofa'),
];

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class CompanyCreateDivision extends StatefulWidget {
  final String? id;
  final GetCompanyDivision? division;

  const CompanyCreateDivision({this.id, this.division, super.key});

  @override
  State<CompanyCreateDivision> createState() => _CompanyCreateDivision();
}

class _CompanyCreateDivision extends State<CompanyCreateDivision> {
  final _formKey = GlobalKey<FormState>();

  final _divisionNameController = TextEditingController();
  final _divisionCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _faxController = TextEditingController();

  String? _selectedCulture;
  String? _selectedTimezone;

  // Holds the existing logo URL when in edit mode so we can show a preview
  String? _existingLogoUrl;

  final FileUploadController _logoController = FileUploadController();

  bool get isEditMode => widget.division != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (isEditMode && widget.division != null) {
      final d = widget.division!;

      _divisionNameController.text = d.divisionname ?? '';
      _divisionCodeController.text = d.divisioncode ?? '';
      _addressController.text = d.address ?? '';
      _telephoneController.text = d.telephone ?? '';
      _websiteController.text = d.website ?? '';
      _emailController.text = d.email ?? '';
      _faxController.text = d.fax ?? '';

      // Culture
      final culture = d.culture;
      if (culture != null && _cultures.any((c) => c.code == culture)) {
        _selectedCulture = culture;
      }

      // Timezone
      final timezone = d.timezone;
      if (timezone != null && _timezones.any((t) => t.id == timezone)) {
        _selectedTimezone = timezone;
      }

      // Existing logo URL for preview
      if (d.logo != null && d.logo!.isNotEmpty) {
        _existingLogoUrl = d.logo;
      }
    }
  }

  @override
  void dispose() {
    _divisionNameController.dispose();
    _divisionCodeController.dispose();
    _logoController.dispose();
    _addressController.dispose();
    _telephoneController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _faxController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: context.colors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditMode
                  ? 'Update the division information below'
                  : 'Create a new division for your organization',
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

  Widget _buildFormRow(
    BuildContext context,
    String label,
    Widget field, {
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
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
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
        Expanded(flex: 3, child: field),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Logo preview widget
  // ---------------------------------------------------------------------------

  /// Shown only in edit mode when the division already has a logo and the user
  /// has not yet picked a new file. Lets the user see what's currently stored.
  Widget _buildLogoPreview() {
    if (_existingLogoUrl == null) return const SizedBox.shrink();
    // Hide once the user picks a new file
    if (_logoController.pickedFile != null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _existingLogoUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: context.colors.primary.withOpacity(0.4),
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Current logo — upload a new file to replace it',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Dropdown builders
  // ---------------------------------------------------------------------------

  Widget _buildCultureDropdown() {
    return CommonDropdown<String>(
      value: _selectedCulture,
      items:
          _cultures
              .map(
                (c) => DropdownMenuItem<String>(
                  value: c.code,
                  child: Text(
                    '${c.code} — ${c.label}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
      onChanged: (val) => setState(() => _selectedCulture = val),
    );
  }

  Widget _buildTimezoneDropdown() {
    return CommonDropdown<String>(
      value: _selectedTimezone,
      items:
          _timezones
              .map(
                (t) => DropdownMenuItem<String>(
                  value: t.id,
                  child: Text(t.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
      onChanged: (val) => setState(() => _selectedTimezone = val),
    );
  }

  // ---------------------------------------------------------------------------
  // Logo field — upload input + current preview stacked
  // ---------------------------------------------------------------------------

  Widget _buildLogoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFileUploadInput(
          controller: _logoController,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'gif'],
        ),
        _buildLogoPreview(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Save
  // ---------------------------------------------------------------------------

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final systemProvider = Provider.of<SystemProvider>(
        context,
        listen: false,
      );

      try {
        if (isEditMode) {
          await systemProvider.updateDivision(
            divisionId: widget.division!.divisionid!,
            customerid: widget.id ?? widget.division!.customerid,
            divisionname: _divisionNameController.text.trim(),
            divisioncode: _divisionCodeController.text.trim(),
            logoFile: _logoController.pickedFile,
            address:
                _addressController.text.trim().isEmpty
                    ? null
                    : _addressController.text.trim(),
            telephone:
                _telephoneController.text.trim().isEmpty
                    ? null
                    : _telephoneController.text.trim(),
            website:
                _websiteController.text.trim().isEmpty
                    ? null
                    : _websiteController.text.trim(),
            email:
                _emailController.text.trim().isEmpty
                    ? null
                    : _emailController.text.trim(),
            fax:
                _faxController.text.trim().isEmpty
                    ? null
                    : _faxController.text.trim(),
            culture: _selectedCulture,
            timezone: _selectedTimezone,
          );
          if (systemProvider.hasError) {
            _showErrorSnackBar(systemProvider.errorMessage!);
          } else {
            _showSuccessSnackBar('Division updated successfully');
            NavigationService().goBack();
          }
        } else {
          await systemProvider.createDivision(
            customerid: widget.id,
            divisionname: _divisionNameController.text.trim(),
            divisioncode: _divisionCodeController.text.trim(),
            logoFile: _logoController.pickedFile,
            address:
                _addressController.text.trim().isEmpty
                    ? null
                    : _addressController.text.trim(),
            telephone:
                _telephoneController.text.trim().isEmpty
                    ? null
                    : _telephoneController.text.trim(),
            website:
                _websiteController.text.trim().isEmpty
                    ? null
                    : _websiteController.text.trim(),
            email:
                _emailController.text.trim().isEmpty
                    ? null
                    : _emailController.text.trim(),
            fax:
                _faxController.text.trim().isEmpty
                    ? null
                    : _faxController.text.trim(),
            culture: _selectedCulture,
            timezone: _selectedTimezone,
          );
          if (systemProvider.hasError) {
            _showErrorSnackBar(systemProvider.errorMessage!);
          } else {
            _showSuccessSnackBar('Division created successfully');
            NavigationService().goBack();
          }
        }
      } catch (e) {
        _showErrorSnackBar(
          'Failed to ${isEditMode ? 'update' : 'create'} division: $e',
        );
      }
    }
  }

  void _showErrorSnackBar(String message) {
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Layouts
  // ---------------------------------------------------------------------------

  Widget _buildTabletLayout(
    BuildContext context,
    SystemProvider systemProvider,
  ) {
    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          _buildInfoBanner(context),
          context.vM,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left column ──────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          context,
                          'Basic Information',
                          Icons.business_outlined,
                        ),
                        context.vM,
                        _buildFormRow(
                          context,
                          'Division Name',
                          CommonTextField(
                            controller: _divisionNameController,
                            hintText: 'Enter Division Name',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Division name is required';
                              }
                              return null;
                            },
                          ),
                          isRequired: true,
                          icon: Icons.corporate_fare,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Division Code',
                          CommonTextField(
                            controller: _divisionCodeController,
                            hintText: 'Enter Division Code',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Division code is required';
                              }
                              return null;
                            },
                          ),
                          isRequired: true,
                          icon: Icons.tag,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Logo',
                          _buildLogoField(), // ← uses unified logo field
                          icon: Icons.image_outlined,
                        ),
                        context.vL,
                        _buildSectionHeader(
                          context,
                          'Contact Information',
                          Icons.contact_mail_outlined,
                        ),
                        context.vM,
                        _buildFormRow(
                          context,
                          'Address',
                          CommonTextField(
                            controller: _addressController,
                            hintText: 'Enter Address',
                            maxLines: 2,
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.location_on_outlined,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Telephone',
                          CommonTextField(
                            controller: _telephoneController,
                            hintText: 'Enter Phone Number',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.phone_outlined,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Email Address',
                          CommonTextField(
                            controller: _emailController,
                            hintText: 'Enter Email Address',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                              }
                              return null;
                            },
                          ),
                          icon: Icons.email_outlined,
                        ),
                        context.vS,
                      ],
                    ),
                  ),
                ),
                context.hXl,
                // ── Right column ─────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          context,
                          'Additional Details',
                          Icons.more_horiz,
                        ),
                        context.vM,
                        _buildFormRow(
                          context,
                          'Website',
                          CommonTextField(
                            controller: _websiteController,
                            hintText: 'Enter Website URL',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.language_outlined,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Fax',
                          CommonTextField(
                            controller: _faxController,
                            hintText: 'Enter Fax Number',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: context.colors.primary),
                          ),
                          icon: Icons.print_outlined,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Culture',
                          _buildCultureDropdown(),
                          icon: Icons.translate_outlined,
                        ),
                        context.vS,
                        _buildFormRow(
                          context,
                          'Timezone',
                          _buildTimezoneDropdown(),
                          icon: Icons.access_time_outlined,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: CommonButton(
                  icon: isEditMode ? Icons.update : Icons.save,
                  text:
                      systemProvider.isLoading
                          ? (isEditMode ? 'Updating...' : 'Saving...')
                          : (isEditMode ? 'Update' : 'Save'),
                  onPressed: systemProvider.isLoading ? null : _handleSave,
                ),
              ),
            ],
          ),
          context.vM,
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    SystemProvider systemProvider,
  ) {
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.vM,
          _buildInfoBanner(context),
          context.vL,
          _buildSectionHeader(
            context,
            'Basic Information',
            Icons.business_outlined,
          ),
          context.vM,
          _buildFormRow(
            context,
            'Division Name',
            CommonTextField(
              controller: _divisionNameController,
              hintText: 'Enter Division Name',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Division name is required';
                }
                return null;
              },
            ),
            isRequired: true,
            icon: Icons.corporate_fare,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Division Code',
            CommonTextField(
              controller: _divisionCodeController,
              hintText: 'Enter Division Code',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Division code is required';
                }
                return null;
              },
            ),
            isRequired: true,
            icon: Icons.tag,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Logo',
            _buildLogoField(), // ← uses unified logo field
            icon: Icons.image_outlined,
          ),
          context.vL,
          _buildSectionHeader(
            context,
            'Contact Information',
            Icons.contact_mail_outlined,
          ),
          context.vM,
          _buildFormRow(
            context,
            'Address',
            CommonTextField(
              controller: _addressController,
              hintText: 'Enter Address',
              maxLines: 2,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.location_on_outlined,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Telephone',
            CommonTextField(
              controller: _telephoneController,
              hintText: 'Enter Phone Number',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.phone_outlined,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Email Address',
            CommonTextField(
              controller: _emailController,
              hintText: 'Enter Email Address',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                }
                return null;
              },
            ),
            icon: Icons.email_outlined,
          ),
          context.vL,
          _buildSectionHeader(context, 'Additional Details', Icons.more_horiz),
          context.vM,
          _buildFormRow(
            context,
            'Website',
            CommonTextField(
              controller: _websiteController,
              hintText: 'Enter Website URL',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.language_outlined,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Fax',
            CommonTextField(
              controller: _faxController,
              hintText: 'Enter Fax Number',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            icon: Icons.print_outlined,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Culture',
            _buildCultureDropdown(),
            icon: Icons.translate_outlined,
          ),
          context.vS,
          _buildFormRow(
            context,
            'Timezone',
            _buildTimezoneDropdown(),
            icon: Icons.access_time_outlined,
          ),
          context.vL,
          CommonButton(
            icon: isEditMode ? Icons.update : Icons.save,
            text:
                systemProvider.isLoading
                    ? (isEditMode ? 'Updating...' : 'Saving...')
                    : (isEditMode ? 'Update' : 'Save'),
            onPressed: systemProvider.isLoading ? null : _handleSave,
          ),
          context.vL,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEditMode ? Icons.edit : Icons.add_business,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              isEditMode ? 'Edit Division' : 'Create Division',
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
          onPressed: () => NavigationService().goBack(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Consumer<SystemProvider>(
          builder: (context, systemProvider, child) {
            return Form(
              key: _formKey,
              child:
                  context.isTablet
                      ? _buildTabletLayout(context, systemProvider)
                      : _buildMobileLayout(context, systemProvider),
            );
          },
        ),
      ),
    );
  }
}
