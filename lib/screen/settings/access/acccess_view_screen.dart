import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/view_user_model/view_user_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

enum UserSearchColumn { name, username, email, userGroup, status }

class AccessViewScreen extends StatefulWidget {
  const AccessViewScreen({super.key});

  @override
  State<AccessViewScreen> createState() => _AccessViewScreenState();
}

class _AccessViewScreenState extends State<AccessViewScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isSearchFocused = false;
  int sortColumnIndex = 0;

  UserSearchColumn? selectedColumn;
  dynamic selectedValue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeData() async {
    await context.read<AuthenticateProvider>().fetchUsers();
    if (mounted) _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  // ─── Filter helpers ───────────────────────────────────────────────────────

  List<dynamic> _getColumnValues(
    List<AuthUser> users,
    UserSearchColumn column,
  ) {
    if (users.isEmpty) return [];
    switch (column) {
      case UserSearchColumn.name:
        return users
            .map((e) => e.displayName)
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case UserSearchColumn.username:
        return users
            .map((e) => e.username)
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case UserSearchColumn.email:
        return users
            .map((e) => e.email)
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case UserSearchColumn.userGroup:
        return users
            .map((e) => e.userGroup)
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
      case UserSearchColumn.status:
        return [false, true];
    }
  }

  List<AuthUser> _getFilteredUsers(List<AuthUser> users) {
    if (users.isEmpty) return [];
    var filtered = users;

    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text.toLowerCase().trim();
      filtered =
          filtered.where((u) {
            return u.displayName.toLowerCase().contains(search) ||
                u.username.toLowerCase().contains(search) ||
                u.email.toLowerCase().contains(search) ||
                u.userGroup.toLowerCase().contains(search);
          }).toList();
    }

    if (selectedColumn != null && selectedValue != null) {
      switch (selectedColumn!) {
        case UserSearchColumn.name:
          filtered =
              filtered.where((u) => u.displayName == selectedValue).toList();
          break;
        case UserSearchColumn.username:
          filtered =
              filtered.where((u) => u.username == selectedValue).toList();
          break;
        case UserSearchColumn.email:
          filtered = filtered.where((u) => u.email == selectedValue).toList();
          break;
        case UserSearchColumn.userGroup:
          filtered =
              filtered.where((u) => u.userGroup == selectedValue).toList();
          break;
        case UserSearchColumn.status:
          filtered =
              filtered
                  .where((u) => u.isAccountLocked == selectedValue)
                  .toList();
          break;
      }
    }
    return filtered;
  }

  String _getColumnLabel(UserSearchColumn column) {
    switch (column) {
      case UserSearchColumn.name:
        return 'Name';
      case UserSearchColumn.username:
        return 'Username';
      case UserSearchColumn.email:
        return 'Email';
      case UserSearchColumn.userGroup:
        return 'User Group';
      case UserSearchColumn.status:
        return 'Status';
    }
  }

  String _getValueLabel(UserSearchColumn column, dynamic value) {
    if (column == UserSearchColumn.status) {
      return value == true ? 'Locked' : 'Active';
    }
    return value.toString();
  }

  // ─── Edit dialog ──────────────────────────────────────────────────────────

  void _showEditDialog(BuildContext context, AuthUser user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final firstNameController = TextEditingController(
      text: user.displayName.split(' ').firstOrNull ?? '',
    );
    final lastNameController = TextEditingController(
      text: user.displayName.split(' ').skip(1).join(' '),
    );
    String? selectedGroup = user.userGroup.isNotEmpty ? user.userGroup : null;
    bool isAccountLocked = user.isAccountLocked;

    const userGroups = [
      'inspector',
      'admin',
      'manager',
      'technician',
      'viewer',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(28),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: context.colors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit User',
                                  style: context.topology.textTheme.titleLarge
                                      ?.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  user.username,
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Fields
                      _dialogField(context, 'Username', usernameController),
                      const SizedBox(height: 12),
                      _dialogField(context, 'Email', emailController),
                      const SizedBox(height: 12),
                      _dialogField(context, 'First Name', firstNameController),
                      const SizedBox(height: 12),
                      _dialogField(context, 'Last Name', lastNameController),
                      const SizedBox(height: 12),
                      // User group dropdown
                      Text(
                        'User Group',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CommonDropdown<String>(
                        value: selectedGroup,
                        items:
                            userGroups
                                .map(
                                  (g) => DropdownMenuItem<String>(
                                    value: g,
                                    child: Text(g.toUpperCase()),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (v) => setDialogState(() => selectedGroup = v),
                        borderColor: context.colors.primary,
                      ),
                      const SizedBox(height: 12),
                      // Lock toggle
                      Row(
                        children: [
                          Switch(
                            value: isAccountLocked,
                            onChanged:
                                (v) =>
                                    setDialogState(() => isAccountLocked = v),
                            activeColor: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isAccountLocked
                                ? 'Account Locked'
                                : 'Account Active',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(
                                  color:
                                      isAccountLocked
                                          ? Colors.red.shade700
                                          : Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: context.colors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Consumer<AuthenticateProvider>(
                              builder: (context, provider, _) {
                                return ElevatedButton(
                                  onPressed:
                                      provider.isLoadingUsers
                                          ? null
                                          : () async {
                                            Navigator.of(dialogContext).pop();
                                            await provider.updateUser(
                                              context,
                                              userId: user.id.toString(),
                                              username:
                                                  usernameController.text
                                                      .trim(),
                                              email:
                                                  emailController.text.trim(),
                                              firstName:
                                                  firstNameController.text
                                                      .trim(),
                                              lastName:
                                                  lastNameController.text
                                                      .trim(),
                                              userGroup: selectedGroup,
                                              isAccountLocked: isAccountLocked,
                                            );
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child:
                                      provider.isLoadingUsers
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : const Text(
                                            'Update',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        CommonTextField(
          controller: controller,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }

  // ─── Delete dialog ────────────────────────────────────────────────────────

  void _showDeleteDialog(BuildContext context, AuthUser user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade50, Colors.orange.shade100],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.orange.shade700,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Delete User?',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete this user? This action cannot be undone.',
                  style: context.topology.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // User preview card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      _buildUserAvatar(
                        _getInitials(user.displayName),
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName
                                  : user.username,
                              style: context.topology.textTheme.titleSmall
                                  ?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This action is permanent and cannot be reversed',
                          style: context.topology.textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<AuthenticateProvider>(
                        builder: (context, provider, _) {
                          return ElevatedButton(
                            onPressed:
                                provider.isLoadingUsers
                                    ? null
                                    : () async {
                                      Navigator.of(dialogContext).pop();
                                      await provider.deleteUser(
                                        context,
                                        user.id.toString(),
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child:
                                provider.isLoadingUsers
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.delete_rounded, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Filter dialog ────────────────────────────────────────────────────────

  void _showFilterDialog(BuildContext context, List<AuthUser> users) {
    UserSearchColumn? tempColumn = selectedColumn;
    dynamic tempValue = selectedValue;

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (context, setDialogState) {
          final columnValues =
              tempColumn != null
                  ? _getColumnValues(users, tempColumn!)
                  : <dynamic>[];

          return Container(
            constraints: BoxConstraints(
              maxHeight: context.screenHeight * 0.5,
              minHeight: context.screenHeight * 0.3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Filter By',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CommonDropdown<UserSearchColumn>(
                        value: tempColumn,
                        items: [
                          DropdownMenuItem<UserSearchColumn>(
                            value: null,
                            child: Text(
                              'Select Column',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(
                                    color: context.colors.primary.withOpacity(
                                      0.6,
                                    ),
                                  ),
                            ),
                          ),
                          ...UserSearchColumn.values.map((column) {
                            return DropdownMenuItem<UserSearchColumn>(
                              value: column,
                              child: Text(
                                _getColumnLabel(column),
                                style: context.topology.textTheme.bodySmall
                                    ?.copyWith(color: context.colors.primary),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            tempColumn = value;
                            tempValue = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                context.vS,
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Value',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                          tempColumn == null
                              ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: context.colors.primary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Select a column first',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.colors.primary
                                            .withOpacity(0.5),
                                      ),
                                ),
                              )
                              : CommonDropdown<dynamic>(
                                value: tempValue,
                                items: [
                                  DropdownMenuItem<dynamic>(
                                    value: null,
                                    child: Text(
                                      'All',
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.colors.primary
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                  ),
                                  ...columnValues.map((value) {
                                    return DropdownMenuItem<dynamic>(
                                      value: value,
                                      child: Text(
                                        _getValueLabel(tempColumn!, value),
                                        style: context
                                            .topology
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: context.colors.primary,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setDialogState(() => tempValue = value);
                                },
                              ),
                    ),
                  ],
                ),
                context.vL,
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        text: 'Clear',
                        onPressed: () {
                          setState(() {
                            selectedColumn = null;
                            selectedValue = null;
                          });
                          NavigationService().goBack();
                        },
                      ),
                    ),
                    context.hS,
                    Expanded(
                      child: CommonButton(
                        text: 'Apply',
                        onPressed: () {
                          setState(() {
                            selectedColumn = tempColumn;
                            selectedValue = tempValue;
                          });
                          NavigationService().goBack();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticateProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingUsers && provider.users.isEmpty) {
          return _buildLoadingState();
        }
        if (provider.hasUsersError && provider.users.isEmpty) {
          return _buildErrorState(context, provider);
        }
        final allUsers = provider.users;
        if (allUsers.isEmpty) return _buildEmptyState(context);
        final filteredUsers = _getFilteredUsers(allUsers);
        return _buildMainLayout(context, filteredUsers, allUsers);
      },
    );
  }

  // ─── Loading / Empty / Error ──────────────────────────────────────────────

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading users...',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary.withOpacity(0.1),
                        context.colors.primary.withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    size: 80,
                    color: context.colors.primary.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'No users yet',
                  style: context.topology.textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Register your first user to get started',
                  textAlign: TextAlign.center,
                  style: context.topology.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed:
                      () => NavigationService().navigateTo(
                        NavigationRoutes.accessScreen,
                      ),
                  icon: const Icon(Icons.add_rounded, size: 24),
                  label: const Text('Create User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AuthenticateProvider provider) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to load users',
                    style: context.topology.textTheme.titleLarge?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.usersErrorMessage ??
                        'An unexpected error occurred',
                    textAlign: TextAlign.center,
                    style: context.topology.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => provider.fetchUsers(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Main layout ──────────────────────────────────────────────────────────

  Widget _buildMainLayout(
    BuildContext context,
    List<AuthUser> filteredUsers,
    List<AuthUser> allUsers,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(
                          isDesktop ? 32 : (isTablet ? 24 : 16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeaderSection(isDesktop, isTablet),
                            const SizedBox(height: 24),
                            _buildSearchBar(allUsers, isDesktop),
                            const SizedBox(height: 16),
                            _buildFilterChips(),
                            const SizedBox(height: 16),
                            _buildResultsCount(filteredUsers, context),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    _buildUsersList(filteredUsers, isDesktop, isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          !isDesktop
              ? FloatingActionButton.extended(
                onPressed:
                    () =>
                        NavigationService().navigateTo(NavigationRoutes.accessScreen),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create'),
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
              )
              : null,
    );
  }

  Widget _buildHeaderSection(bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary.withOpacity(0.08), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary,
                  context.colors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.manage_accounts_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Access',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your system users and permissions',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed:
                  () => NavigationService().navigateTo(NavigationRoutes.accessScreen),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(List<AuthUser> allUsers, bool isDesktop) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isSearchFocused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _isSearchFocused
                    ? context.colors.primary
                    : Colors.grey.shade200,
            width: _isSearchFocused ? 2 : 1,
          ),
          boxShadow: [
            if (_isSearchFocused)
              BoxShadow(
                color: context.colors.primary.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: CommonTextField(
          controller: _searchController,
          hintText:
              isDesktop
                  ? 'Search by name, username, email or group...'
                  : 'Search users...',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.primary.withOpacity(0.6),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: context.colors.primary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  tooltip: 'Clear search',
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      (selectedColumn != null && selectedValue != null)
                          ? context.colors.primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color:
                        (selectedColumn != null && selectedValue != null)
                            ? context.colors.primary
                            : context.colors.primary.withOpacity(0.5),
                  ),
                  onPressed: () => _showFilterDialog(context, allUsers),
                  tooltip: 'Filter users',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    if (selectedColumn == null || selectedValue == null) {
      return const SizedBox.shrink();
    }
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  () => setState(() {
                    selectedColumn = null;
                    selectedValue = null;
                  }),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary.withOpacity(0.12),
                      context.colors.primary.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${_getColumnLabel(selectedColumn!)}: ${_getValueLabel(selectedColumn!, selectedValue)}',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount(
    List<AuthUser> filteredUsers,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.primary.withOpacity(0.12),
                context.colors.primary.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_rounded,
                size: 18,
                color: context.colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${filteredUsers.length} ${filteredUsers.length == 1 ? 'user' : 'users'}',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Consumer<AuthenticateProvider>(
          builder: (context, provider, _) {
            return IconButton(
              icon: Icon(Icons.refresh_rounded, color: context.colors.primary),
              onPressed:
                  provider.isLoadingUsers ? null : () => provider.fetchUsers(),
              tooltip: 'Refresh',
            );
          },
        ),
      ],
    );
  }

  Widget _buildUsersList(
    List<AuthUser> filteredUsers,
    bool isDesktop,
    bool isTablet,
  ) {
    if (filteredUsers.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildNoResultsState(),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 32 : (isTablet ? 24 : 16),
        0,
        isDesktop ? 32 : (isTablet ? 24 : 16),
        100,
      ),
      sliver: SliverToBoxAdapter(child: _buildUsersTable(filteredUsers)),
    );
  }

  Widget _buildUsersTable(List<AuthUser> users) {
    return RefreshIndicator(
      onRefresh: () => context.read<AuthenticateProvider>().fetchUsers(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final table = DataTable(
              sortColumnIndex: sortColumnIndex,
              showCheckboxColumn: false,
              columnSpacing: 20,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columns: _buildTableColumns(),
              rows: List.generate(users.length, (i) {
                return _buildTableRow(users[i], i % 2 == 0);
              }),
            );
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth - 16,
                ),
                child: table,
              ),
            );
          },
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    const labels = [
      'User',
      'Username',
      'Email',
      'User Group',
      'Status',
      'Actions',
    ];
    return labels.asMap().entries.map((e) {
      return DataColumn(
        label: Expanded(
          child: Text(
            e.value,
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        onSort:
            e.key < labels.length - 1
                ? (i, _) => setState(() => sortColumnIndex = i)
                : null,
      );
    }).toList();
  }

  DataRow _buildTableRow(AuthUser user, bool isEven) {
    final isLocked = user.isAccountLocked;
    final initials = _getInitials(user.displayName);

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (_) => isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      onSelectChanged: (_) {},
      cells: [
        // User name + avatar
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUserAvatar(initials),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName.isNotEmpty ? user.displayName : '-',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (user.userGroup.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.userGroup.toUpperCase(),
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        // Username
        DataCell(
          Text(
            user.username.isNotEmpty ? user.username : '-',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        // Email
        DataCell(
          Text(
            user.email.isNotEmpty ? user.email : '-',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        // User group
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.userGroup.toUpperCase(),
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ),
        // Status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isLocked
                      ? Colors.red.withOpacity(0.12)
                      : Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        isLocked ? Colors.red.shade600 : Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isLocked ? 'Locked' : 'Active',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color:
                        isLocked ? Colors.red.shade700 : Colors.green.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Actions — edit + delete
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: context.colors.primary,
                  size: 18,
                ),
                onPressed: () => _showEditDialog(context, user),
                tooltip: 'Edit User',
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 4),
              Consumer<AuthenticateProvider>(
                builder:
                    (context, provider, _) => IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed:
                          provider.isLoadingUsers
                              ? null
                              : () => _showDeleteDialog(context, user),
                      tooltip: 'Delete User',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String initials, {double size = 34}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.47,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade100, Colors.grey.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No users found',
              style: context.topology.textTheme.titleLarge?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  selectedColumn = null;
                  selectedValue = null;
                });
              },
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
