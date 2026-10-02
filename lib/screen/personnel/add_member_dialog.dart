import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/personnel_model/personnel_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class AddMemberDialog extends StatefulWidget {
  final Function(String personnelId, bool isTeamLeader, bool isPrimaryLeader)? onMemberSelected;

  const AddMemberDialog({super.key, this.onMemberSelected});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  String _nameFilter = "";
  String _employeeNoFilter = "";
  String _jobTitleFilter = "";

  PersonnelData? _selectedPersonnel;
  bool _isTeamLeader = false;
  bool _isPrimaryLeader = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<PersonnelProvider>();
      if (provider.personnelList.isEmpty) {
        provider.fetchPersonnel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonnelProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.personnelList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        List<PersonnelData> filteredList =
        provider.activePersonnel.where((p) {
          final matchesName = p.fullName.toLowerCase().contains(_nameFilter.toLowerCase());
          final matchesEmp = p.company.employeeNumber.toLowerCase().contains(
            _employeeNoFilter.toLowerCase(),
          );
          final matchesJob = p.company.jobTitle.toLowerCase().contains(
            _jobTitleFilter.toLowerCase(),
          );
          return matchesName && matchesEmp && matchesJob;
        }).toList();

        return AlertDialog(
          title: Text(_selectedPersonnel == null ? 'Select Team Member' : 'Configure Member Role',  style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary
          ),),
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: 600,
            height: 450,
            child:
            _selectedPersonnel == null
                ? _buildPersonnelSelection(filteredList)
                : _buildRoleSelection(),
          ),
          actions:
          _selectedPersonnel == null
              ? [
            CommonButton(
              icon: Icons.cancel,
              text: 'Cancel',
              onPressed: provider.isLoading ? null : () => NavigationService().goBack(),
            ),
          ]
              : [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedPersonnel = null;
                  _isTeamLeader = false;
                  _isPrimaryLeader = false;
                });
              },
              child: const Text("Back"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(onPressed: _addMember, child: const Text("Add Member")),
          ],
        );
      },
    );
  }

  Widget _buildPersonnelSelection(List<PersonnelData> filteredList) {
    return Column(
      children: [
        // Filters row
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                labelText: 'Name',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
                onChanged: (v) => setState(() => _nameFilter = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child:  CommonTextField(
                labelText: 'Employee No.',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
                onChanged: (v) => setState(() => _employeeNoFilter = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextField(
                labelText: 'Job Title',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
                onChanged: (v) => setState(() => _jobTitleFilter = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),

        // Personnel List
        Expanded(
          child:
          filteredList.isEmpty
              ?  Center(child: Text('No personnel found',style: context.topology.textTheme.bodyMedium?.copyWith(color: context.colors.primary),))
              : ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final p = filteredList[index];
              return ListTile(
                title: Text(p.fullName,style: context.topology.textTheme.titleSmall?.copyWith(color: context.colors.primary)),
                subtitle: Text(p.company.jobTitle,style: context.topology.textTheme.bodyMedium?.copyWith(color: context.colors.primary)),
                trailing: Text(p.company.employeeNumber,style: context.topology.textTheme.bodySmall?.copyWith(color: context.colors.primary)),
                onTap: () {
                  setState(() {
                    _selectedPersonnel = p;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected personnel info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Selected Member:',
                    style: context.topology.textTheme.bodyMedium?.copyWith(color: context.colors.primary)
                ),
                context.vM,
                Text(
                    _selectedPersonnel!.fullName,
                    style: context.topology.textTheme.titleSmall?.copyWith(color: context.colors.primary)
                ),
                Text(_selectedPersonnel!.company.jobTitle,     style: context.topology.textTheme.bodySmall?.copyWith(color: context.colors.primary)),
                context.vM,
                Text(
                  'Employee No: ${_selectedPersonnel!.company.employeeNumber}',
                  style: context.topology.textTheme.bodyMedium?.copyWith(color: context.colors.primary),
                ),
              ],
            ),
          ),
        ),
        context.vL,

        // Role selection
        Text('Member Roles:',     style: context.topology.textTheme.titleMedium?.copyWith(color: context.colors.primary)),
        context.vM,

        CheckboxListTile(
          title:  Text('Team Leader'  ,  style: context.topology.textTheme.titleSmall?.copyWith(color: context.colors.primary)),
          subtitle:  Text('Can manage team members and assignments',    style: context.topology.textTheme.bodySmall?.copyWith(color: context.colors.primary)),
          value: _isTeamLeader,
          onChanged: (value) {
            setState(() {
              _isTeamLeader = value ?? false;
            });
          },
        ),

        CheckboxListTile(
          title:  Text('Primary Leader',  style: context.topology.textTheme.titleSmall?.copyWith(color: context.colors.primary)),
          subtitle:  Text('Main point of contact for the team',    style: context.topology.textTheme.bodySmall?.copyWith(color: context.colors.primary)),
          value: _isPrimaryLeader,
          onChanged: (value) {
            setState(() {
              _isPrimaryLeader = value ?? false;
            });
          },
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You can assign multiple team leaders, but typically only one primary leader per team.',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addMember() {
    if (_selectedPersonnel == null) return;

    // Call the callback if provided
    if (widget.onMemberSelected != null) {
      widget.onMemberSelected!(
        _selectedPersonnel!.personnel.personnelID,
        _isTeamLeader,
        _isPrimaryLeader,
      );
    }

    // Close the dialog and return success
    Navigator.of(context).pop(true);
  }
}
