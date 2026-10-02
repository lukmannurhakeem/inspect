import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String? _selectedUserGroup;
  String? _selectedDivisionId;
  String? _selectedCustomerName;

  bool _passwordReset = false;
  bool _isAccountLocked = false;

  final List<String> _userGroups = [
    'inspector',
    'admin',
    'manager',
    'technician',
    'viewer',
    'customer',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemProvider>().fetchDivision();
      context.read<CustomerProvider>().fetchCustomers(context);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register User',
          style: context.topology.textTheme.titleLarge?.copyWith(
            color: context.colors.primary,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
      ),
      body: Consumer2<SystemProvider, CustomerProvider>(
        builder: (context, systemProvider, customerProvider, child) {
          return SingleChildScrollView(
            padding: context.paddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionHeader('Personal Information'),
                  context.vM,

                  _buildFormField(
                    'First Name',
                    _firstNameController,
                    isRequired: true,
                  ),
                  context.vS,

                  _buildFormField(
                    'Last Name',
                    _lastNameController,
                    isRequired: true,
                  ),
                  context.vS,

                  _buildFormField(
                    'Username',
                    _usernameController,
                    isRequired: true,
                  ),
                  context.vS,

                  _buildFormField(
                    'Email',
                    _emailController,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  context.vL,

                  _buildSectionHeader('Account Security'),
                  context.vM,

                  _buildPasswordField(
                    'Password',
                    _passwordController,
                    isRequired: true,
                  ),
                  context.vS,

                  _buildPasswordField(
                    'Confirm Password',
                    _confirmPasswordController,
                    isRequired: true,
                    validator: _validateConfirmPassword,
                  ),
                  context.vL,

                  _buildSectionHeader('Division & Access'),
                  context.vM,

                  _buildDivisionDropdown(systemProvider),
                  context.vS,

                  _buildDropdownField(
                    'User Group',
                    _selectedUserGroup,
                    _userGroups
                        .map(
                          (group) => DropdownMenuItem<String>(
                            value: group,
                            child: Text(group.toUpperCase()),
                          ),
                        )
                        .toList(),
                    (value) => setState(() {
                      _selectedUserGroup = value;
                      _selectedCustomerName = null;
                    }),
                    isRequired: true,
                  ),
                  context.vS,

                  if (_selectedUserGroup == 'customer') ...[
                    _buildCustomerDropdown(customerProvider),
                    context.vS,
                  ],

                  context.vL,

                  _buildSectionHeader('Account Settings'),
                  context.vM,

                  CheckboxListTile(
                    title: const Text('Require Password Reset on First Login'),
                    subtitle: const Text(
                      'User must change password when first logging in',
                    ),
                    value: _passwordReset,
                    onChanged:
                        (value) =>
                            setState(() => _passwordReset = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  CheckboxListTile(
                    title: const Text('Lock Account'),
                    subtitle: const Text(
                      'Account will be locked and cannot login',
                    ),
                    value: _isAccountLocked,
                    onChanged:
                        (value) =>
                            setState(() => _isAccountLocked = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  context.vXl,

                  CommonButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    text: _isLoading ? 'Creating Account...' : 'Create Account',
                  ),

                  context.vM,

                  TextButton(
                    onPressed: () => NavigationService().goBack(),
                    child: Text(
                      'Already have an account? Back to Login',
                      style: TextStyle(color: context.colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerDropdown(CustomerProvider customerProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer *',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        customerProvider.isFetching && customerProvider.customers.isEmpty
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading customers...',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
            : DropdownButtonFormField<String>(
              value: _selectedCustomerName,
              isExpanded: true,
              items: [
                if (customerProvider.customers.isEmpty)
                  DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      'No customers available',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withOpacity(0.6),
                      ),
                    ),
                  )
                else
                  ...customerProvider.customers.map((customer) {
                    return DropdownMenuItem<String>(
                      value: customer.customername, // ✅ name, not id
                      child: Text(
                        customer.customername ?? 'Unknown Customer',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    );
                  }).toList(),
              ],
              onChanged:
                  customerProvider.customers.isEmpty
                      ? null
                      : (value) =>
                          setState(() => _selectedCustomerName = value),
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon:
                    customerProvider.customers.isEmpty
                        ? IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          onPressed:
                              () => customerProvider.fetchCustomers(context),
                          tooltip: 'Refresh customers',
                        )
                        : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Customer is required';
                }
                return null;
              },
            ),
        if (customerProvider.customers.isEmpty &&
            !customerProvider.isFetching) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to load customers',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () => customerProvider.fetchCustomers(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Retry', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDivisionDropdown(SystemProvider systemProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Division *',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        systemProvider.isLoading && systemProvider.divisions.isEmpty
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading divisions...',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
            : DropdownButtonFormField<String>(
              value: _selectedDivisionId,
              items: [
                if (systemProvider.divisions.isEmpty)
                  DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      'No divisions available',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary.withOpacity(0.6),
                      ),
                    ),
                  )
                else
                  ...systemProvider.divisions.map((division) {
                    return DropdownMenuItem<String>(
                      value: division.divisionid,
                      child: Text(
                        division.divisionname ?? 'Unknown Division',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    );
                  }).toList(),
              ],
              onChanged:
                  systemProvider.divisions.isEmpty
                      ? null
                      : (value) => setState(() => _selectedDivisionId = value),
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon:
                    systemProvider.divisions.isEmpty
                        ? IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          onPressed: () => systemProvider.fetchDivision(),
                          tooltip: 'Refresh divisions',
                        )
                        : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Division is required';
                }
                return null;
              },
              isExpanded: true,
            ),
        if (systemProvider.hasError && systemProvider.divisions.isEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  systemProvider.errorMessage ?? 'Failed to load divisions',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () => systemProvider.fetchDivision(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Retry', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: context.topology.textTheme.titleMedium?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    TextInputType? keyboardType,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        CommonTextField(
          controller: controller,
          keyboardType: keyboardType,
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
          hintText: hint,
          validator:
              validator ??
              (isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label is required';
                    }
                    return null;
                  }
                  : null),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        CommonTextField(
          controller: controller,
          obscureText: true,
          showPasswordToggle: true,
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
          validator:
              validator ??
              (isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  }
                  : null),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    void Function(String?) onChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vXs,
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator:
              isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label is required';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthenticateProvider>(
        context,
        listen: false,
      );
      final success = await authProvider.registerUser(
        context,
        _buildRegisterData(),
      );

      if (!mounted) return;

      if (success) {
        CommonSnackbar.showSuccess(context, 'User registered successfully!');
        NavigationService().goBack();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _buildRegisterData() {
    return {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "username": _usernameController.text.trim(),
      "divisionid": _selectedDivisionId,
      "passwordReset": _passwordReset,
      "is_account_locked": _isAccountLocked,
      "user_group": _selectedUserGroup,
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      if (_selectedUserGroup == 'customer')
        "customer_name": _selectedCustomerName,
    };
  }
}
