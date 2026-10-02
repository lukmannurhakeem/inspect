import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/screen/personnel/add_member_dialog.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_confirm_dialog.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

extension _MemberMap on Map<String, dynamic> {
  String get personnelId => this['personnel_id'] as String;
  String get membersId => this['personnel_members_id'] as String;
  bool get isTeamLeader => this['is_team_leader'] as bool;
  bool get isPrimaryLeader => this['is_primary_leader'] as bool;
}

Color _fade(BuildContext context, [double opacity = 1]) =>
    context.colors.primary.withOpacity(opacity);

TextStyle? _style(
    BuildContext context,
    TextStyle? base, {
      double opacity = 1,
      FontWeight? weight,
      double? size,
    }) => base?.copyWith(
  color: _fade(context, opacity),
  fontWeight: weight,
  fontSize: size,
);

class PersonnelCreateTeamScreen extends StatefulWidget {
  final String? teamPersonnelId;

  const PersonnelCreateTeamScreen({super.key, this.teamPersonnelId});

  @override
  State<PersonnelCreateTeamScreen> createState() =>
      _PersonnelCreateTeamScreenState();
}

class _PersonnelCreateTeamScreenState extends State<PersonnelCreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Map<String, dynamic>> _pendingMembers = [];

  bool _isEditMode = false;
  bool _isLoading = true;
  String? _selectedTeamId;

  bool get _isNewTeam => _selectedTeamId == null;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    final provider = context.read<PersonnelProvider>();
    final teamId = widget.teamPersonnelId;

    try {
      await provider.fetchPersonnel();
      if (teamId != null && teamId.isNotEmpty) {
        await provider.fetchTeamPersonnel();
        await _loadTeamData(teamId);
      }
    } catch (e) {
      if (mounted) _showSnackBar('Error loading data: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTeamData(String teamId) async {
    final provider = context.read<PersonnelProvider>();

    try {
      final team = provider.teamPersonnelList.firstWhere(
            (t) => t.teamPersonnelId == teamId,
        orElse: () => throw Exception('Team not found'),
      );

      setState(() {
        _isEditMode = true;
        _selectedTeamId = teamId;
        _nameController.text = team.name ?? '';
        _typeController.text = team.type ?? '';
        _descriptionController.text = team.description ?? '';
        _pendingMembers.clear();
      });

      await provider.fetchTeamMembers(teamId);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: $e', isError: true);
      NavigationService().goBack();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AddMemberDialog(
        onMemberSelected: (personnelId, isTeamLeader, isPrimaryLeader) {
          if (!_isNewTeam) return;

          if (_pendingMembers.any((m) => m.personnelId == personnelId)) {
            _showSnackBar('Member already added', isError: true);
            return;
          }
          setState(() {
            _pendingMembers.add({
              'personnel_id': personnelId,
              'is_team_leader': isTeamLeader,
              'is_primary_leader': isPrimaryLeader,
            });
          });
          _showSnackBar('Member added successfully');
        },
      ),
    ).then((result) {
      if (result == true && !_isNewTeam && mounted) {
        context.read<PersonnelProvider>().fetchTeamMembers(_selectedTeamId!);
      }
    });
  }

  void _editMember(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder:
          (_) => _EditMemberDialog(
        personnelId: member.personnelId,
        isTeamLeader: member.isTeamLeader,
        isPrimaryLeader: member.isPrimaryLeader,
        onUpdate: (isTeamLeader, isPrimaryLeader) {
          setState(() {
            final index = _pendingMembers.indexWhere(
                  (m) => m.personnelId == member.personnelId,
            );
            if (index == -1) return;
            _pendingMembers[index]['is_team_leader'] = isTeamLeader;
            _pendingMembers[index]['is_primary_leader'] = isPrimaryLeader;
          });
          _showSnackBar('Member updated successfully');
        },
      ),
    );
  }

  void _onRemoveMember(Map<String, dynamic> member, String? name) {
    if (!_isNewTeam) {
      _confirmRemoveMember(member.membersId, name);
      return;
    }
    setState(
          () => _pendingMembers.removeWhere(
            (m) => m.personnelId == member.personnelId,
      ),
    );
    _showSnackBar('Member removed');
  }

  void _confirmRemoveMember(String memberId, String? name) {
    CommonConfirmDialog.show(
      context: context,
      title: 'Remove Member',
      message:
      'Are you sure you want to remove ${name ?? 'this member'} from the team?',
      confirmText: 'Remove',
      isDestructive: true,
      onConfirm: () => _removeTeamMember(memberId),
    );
  }

  Future<void> _removeTeamMember(String memberId) async {
    final teamId = _selectedTeamId;
    if (teamId == null) return;

    final success = await context.read<PersonnelProvider>().removeTeamMember(
      memberId,
      teamId,
    );
    if (!mounted) return;

    _showSnackBar(
      success ? 'Member removed successfully' : 'Failed to remove member',
      isError: !success,
    );
  }

  List<Map<String, dynamic>> _displayMembers(PersonnelProvider provider) {
    if (_isNewTeam) return _pendingMembers;
    return provider.teamMembers
        .map(
          (m) => <String, dynamic>{
        'personnel_members_id': m.personnelMembersId,
        'personnel_id': m.personnelId,
        'is_team_leader': m.isTeamLeader,
        'is_primary_leader': m.isPrimaryLeader,
      },
    )
        .toList();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PersonnelProvider>();
    final hasMembers =
    _isNewTeam
        ? _pendingMembers.isNotEmpty
        : provider.teamMembers.isNotEmpty;

    if (!hasMembers) {
      _showSnackBar('Please add at least one team member', isError: true);
      return;
    }

    final data = {
      'name': _nameController.text.trim(),
      'type': _typeController.text.trim(),
      'description': _descriptionController.text.trim(),
      'members': _pendingMembers,
    };

    if (_isNewTeam) {
      await _createTeam(provider, data);
    } else {
      await _updateTeam(provider, data);
    }
  }

  Future<void> _createTeam(
      PersonnelProvider provider,
      Map<String, dynamic> data,
      ) async {
    final success = await provider.createTeamPersonnel(data);
    if (!mounted) return;

    if (!success) {
      _showSnackBar('Failed to create team. Please try again.', isError: true);
      return;
    }

    final name = _nameController.text.trim();
    final teams = provider.teamPersonnelList;
    final teamId =
        teams
            .firstWhere((t) => t.name == name, orElse: () => teams.last)
            .teamPersonnelId;

    setState(() => _selectedTeamId = teamId);

    for (final member in _pendingMembers) {
      member['team_personnel_id'] = teamId;
      await provider.addTeamMember(member);
    }

    await provider.fetchTeamMembers(teamId!);
    if (!mounted) return;

    setState(_pendingMembers.clear);
    await _finish('Team created successfully with members!');
  }

  Future<void> _updateTeam(
      PersonnelProvider provider,
      Map<String, dynamic> data,
      ) async {
    final success = await provider.updateTeamPersonnel(_selectedTeamId!, data);
    if (!mounted) return;

    if (success) {
      await _finish('Team updated successfully!');
    } else {
      _showSnackBar('Failed to update team.', isError: true);
    }
  }

  Future<void> _finish(String message) async {
    _showSnackBar(message);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) NavigationService().goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Team' : 'Create Team',
          style: _style(context, context.topology.textTheme.titleMedium),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        leading: IconButton(
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body:
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<PersonnelProvider>(
        builder: (context, provider, _) => _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(PersonnelProvider provider) {
    return SingleChildScrollView(
      padding: context.paddingAll,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamInfoCard(),
            context.vL,
            _buildMembersCard(provider),
            context.vL,
            _buildActionButtons(provider),
            context.vXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfoCard() {
    return _SectionCard(
      icon: Icons.info_outline,
      title: 'Team Information',
      child: Column(
        children: [
          _buildFormField(
            label: 'Team Name',
            controller: _nameController,
            required: true,
          ),
          const SizedBox(height: 16),
          _buildFormField(label: 'Team Type', controller: _typeController),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Description',
            controller: _descriptionController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (required) const Text('* ', style: TextStyle(color: Colors.red)),
            Text(
              label,
              style: _style(
                context,
                context.topology.textTheme.bodyMedium,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CommonTextField(
          controller: controller,
          maxLines: maxLines,
          style: _style(context, context.topology.textTheme.bodySmall),
          validator:
          required
              ? (value) =>
          (value == null || value.trim().isEmpty)
              ? '$label is required'
              : null
              : null,
        ),
      ],
    );
  }

  Widget _buildMembersCard(PersonnelProvider provider) {
    final members = _displayMembers(provider);

    return _SectionCard(
      icon: Icons.people,
      title: 'Team Members',
      subtitle: '${members.length} member${members.length != 1 ? 's' : ''}',
      trailing: ElevatedButton.icon(
        onPressed: _showAddMemberDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Member'),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
        ),
      ),
      child:
      members.isEmpty
          ? _buildEmptyMembersState()
          : context.isTablet
          ? _buildMembersTable(provider, members)
          : _buildMembersCards(provider, members),
    );
  }

  Widget _buildEmptyMembersState() {
    final textTheme = context.topology.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        border: Border.all(color: _fade(context, 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.person_add_disabled, size: 48, color: _fade(context, 0.3)),
          const SizedBox(height: 16),
          Text(
            'No members added yet',
            style: _style(context, textTheme.bodyMedium, opacity: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'Click "Add Member" to add team members',
            style: _style(context, textTheme.bodySmall, opacity: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberActions(
      Map<String, dynamic> member,
      String? name, {
        double iconSize = 20,
      }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isNewTeam)
          IconButton(
            icon: Icon(
              Icons.edit,
              color: context.colors.primary,
              size: iconSize,
            ),
            tooltip: 'Edit member',
            onPressed: () => _editMember(member),
          ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: context.colors.error,
            size: iconSize,
          ),
          tooltip: 'Remove member',
          onPressed: () => _onRemoveMember(member, name),
        ),
      ],
    );
  }

  Widget _buildMembersCards(
      PersonnelProvider provider,
      List<Map<String, dynamic>> members,
      ) {
    final textTheme = context.topology.textTheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final personnel = provider.getPersonnelForMember(member.personnelId);
        final name = personnel?.fullName;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: _fade(context, 0.1),
              child: Text(
                (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '?',
                style: _style(
                  context,
                  textTheme.titleMedium,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              name ?? 'Unknown',
              style: _style(
                context,
                textTheme.bodyMedium,
                weight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  personnel?.company.jobTitle ?? 'No Job Title',
                  style: _style(context, textTheme.bodySmall, opacity: 0.7),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (member.isPrimaryLeader)
                      _buildBadge(
                        label: 'Primary Leader',
                        color: Colors.amber,
                        icon: Icons.workspace_premium,
                      ),
                    if (member.isTeamLeader)
                      _buildBadge(
                        label: 'Team Leader',
                        color: Colors.blue,
                        icon: Icons.star,
                      ),
                  ],
                ),
              ],
            ),
            trailing: _buildMemberActions(member, name),
          ),
        );
      },
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _headerColumn(String label, {bool expand = false}) {
    final text = Text(
      label,
      style: _style(
        context,
        context.topology.textTheme.titleSmall,
        weight: FontWeight.bold,
      ),
    );
    return DataColumn(label: expand ? Expanded(child: text) : text);
  }

  DataCell _textCell(String text, double width) {
    return DataCell(
      SizedBox(
        width: width,
        child: Text(
          text,
          style: _style(context, context.topology.textTheme.bodySmall),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  DataCell _flagCell(bool value) {
    return DataCell(
      Center(
        child: Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMembersTable(
      PersonnelProvider provider,
      List<Map<String, dynamic>> members,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: _fade(context, 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 48,
          ),
          child: DataTable(
            columnSpacing: 24,
            headingRowColor: MaterialStateProperty.all(_fade(context, 0.1)),
            dataRowMinHeight: 56,
            dataRowMaxHeight: 72,
            columns: [
              _headerColumn('Member', expand: true),
              _headerColumn('Job Title', expand: true),
              _headerColumn('Team Leader'),
              _headerColumn('Primary Leader'),
              _headerColumn('Actions'),
            ],
            rows: [
              for (final member in members)
                _buildMemberRow(
                  member,
                  provider.getPersonnelForMember(member.personnelId),
                ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildMemberRow(Map<String, dynamic> member, dynamic personnel) {
    final name = personnel?.fullName as String?;

    return DataRow(
      cells: [
        _textCell(name ?? 'Unknown', 200),
        _textCell(personnel?.company.jobTitle ?? '-', 180),
        _flagCell(member.isTeamLeader),
        _flagCell(member.isPrimaryLeader),
        DataCell(_buildMemberActions(member, name)),
      ],
    );
  }

  Widget _buildActionButtons(PersonnelProvider provider) {
    final busy = provider.isLoading;
    final label =
    busy
        ? (_isNewTeam ? 'Saving...' : 'Updating...')
        : (_isNewTeam ? 'Save Team' : 'Update Team');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 160,
          child: CommonButton(
            icon: Icons.cancel,
            text: 'Cancel',
            onPressed: busy ? null : NavigationService().goBack,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: CommonButton(
            icon: _isNewTeam ? Icons.save : Icons.update,
            text: label,
            onPressed: busy ? null : _submitForm,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.topology.textTheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _fade(context, 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: context.colors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: _style(
                          context,
                          textTheme.titleMedium,
                          weight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: _style(
                            context,
                            textTheme.bodySmall,
                            opacity: 0.7,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _EditMemberDialog extends StatefulWidget {
  final String personnelId;
  final bool isTeamLeader;
  final bool isPrimaryLeader;
  final void Function(bool isTeamLeader, bool isPrimaryLeader) onUpdate;

  const _EditMemberDialog({
    required this.personnelId,
    required this.isTeamLeader,
    required this.isPrimaryLeader,
    required this.onUpdate,
  });

  @override
  State<_EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<_EditMemberDialog> {
  late bool _isTeamLeader = widget.isTeamLeader;
  late bool _isPrimaryLeader = widget.isPrimaryLeader;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.topology.textTheme;
    final personnel = context.read<PersonnelProvider>().getPersonnelForMember(
      widget.personnelId,
    );

    return AlertDialog(
      title: Text(
        'Edit Member Role',
        style: _style(context, textTheme.titleMedium, weight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personnel?.fullName ?? 'Unknown',
            style: _style(context, textTheme.titleSmall, weight: FontWeight.bold),
          ),
          Text(
            personnel?.company.jobTitle ?? 'No job title',
            style: _style(context, textTheme.bodySmall, opacity: 0.7),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Team Leader'),
            subtitle: const Text('Can manage team operations'),
            value: _isTeamLeader,
            activeColor: context.colors.primary,
            onChanged:
                (value) => setState(() {
              _isTeamLeader = value;
              if (!value) _isPrimaryLeader = false;
            }),
          ),
          SwitchListTile(
            title: const Text('Primary Leader'),
            subtitle: const Text('Main team contact person'),
            value: _isPrimaryLeader,
            activeColor: context.colors.primary,
            onChanged:
            _isTeamLeader
                ? (value) => setState(() => _isPrimaryLeader = value)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onUpdate(_isTeamLeader, _isPrimaryLeader);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}