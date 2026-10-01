
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/navigation/navigation_service.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  List<_InfoSection> get _sections => [
    _InfoSection('Basic Information', [
      _InfoEntry(Icons.person, 'Customer Name', customer.customername),
      _InfoEntry(Icons.code, 'Account Code', customer.accountCode),
      _InfoEntry(Icons.location_on, 'Site Code', customer.sitecode),
    ]),
    _InfoSection('Division & Agent', [
      _InfoEntry(Icons.business, 'Division Name', customer.divisionname),
      _InfoEntry(Icons.tag, 'Division ID', customer.divisionid),
      _InfoEntry(Icons.support_agent, 'Agent', customer.agent),
    ]),
    _InfoSection('Location & Notes', [
      _InfoEntry(
        Icons.location_city,
        'Address',
        customer.address,
        multiline: true,
      ),
      _InfoEntry(Icons.note, 'Notes', customer.notes, multiline: true),
    ]),
    _InfoSection('System Information', [
      _InfoEntry(Icons.fingerprint, 'Customer ID', customer.customerid),
      _InfoEntry(
        Icons.calendar_today,
        'Created At',
        _formatDate(customer.createdAt),
      ),
      _InfoEntry(Icons.update, 'Updated At', _formatDate(customer.updatedAt)),
    ]),
  ];

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Not available';
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${_months[date.month - 1]} ${date.year}, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final logo = customer.logo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Details',
          style: context.topology.textTheme.titleMedium?.copyWith(
            color: primary,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        backgroundColor: context.colors.onPrimary,
        leading: IconButton(
          onPressed: () => NavigationService().goBack(),
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight - (kToolbarHeight * 1.25),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/bg_2.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.l),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.vM,
                    Align(
                      alignment: Alignment.centerRight,
                      child: _StatusBadge(isArchived: customer.archived ?? false),
                    ),
                    context.vM,
                    Text(
                      customer.customername ?? 'N/A',
                      style: context.topology.textTheme.titleLarge?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.vS,
                    Text(
                      customer.accountCode ?? 'No Account Code',
                      style: context.topology.textTheme.bodyMedium?.copyWith(
                        color: primary.withOpacity(0.7),
                      ),
                    ),
                    context.vL,
                    if (logo != null && logo.isNotEmpty) ...[
                      _SectionTitle('Customer Logo'),
                      Center(child: _LogoPreview(url: logo)),
                      context.vL,
                    ],
                    for (final section in _sections) ...[
                      _SectionTitle(section.title),
                      for (final entry in section.entries) ...[
                        _InfoCard(entry: entry),
                        if (entry != section.entries.last) context.vS,
                      ],
                      context.vM,
                    ],
                    context.vXxl,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoEntry {
  final IconData icon;
  final String label;
  final String? value;
  final bool multiline;

  const _InfoEntry(this.icon, this.label, this.value, {this.multiline = false});
}

class _InfoSection {
  final String title;
  final List<_InfoEntry> entries;

  const _InfoSection(this.title, this.entries);
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.topology.textTheme.titleMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        context.vS,
        context.divider,
        context.vM,
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isArchived;

  const _StatusBadge({required this.isArchived});

  @override
  Widget build(BuildContext context) {
    final accent = isArchived ? Colors.grey : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isArchived ? Icons.archive : Icons.check_circle,
            size: 16,
            color: accent.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            isArchived ? 'Archived' : 'Active',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: accent.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoPreview extends StatelessWidget {
  final String url;

  const _LogoPreview({required this.url});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: primary.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                color: context.colors.surface,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: primary.withOpacity(0.5),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final _InfoEntry entry;

  const _InfoCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final isEmpty = entry.value?.isEmpty ?? true;
    final multiline = entry.multiline;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(entry.icon, size: 20, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: primary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEmpty ? 'Not specified' : entry.value!,
                  style: context.topology.textTheme.bodyMedium?.copyWith(
                    color: isEmpty ? primary.withOpacity(0.4) : primary,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                  maxLines: multiline ? null : 1,
                  overflow: multiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
