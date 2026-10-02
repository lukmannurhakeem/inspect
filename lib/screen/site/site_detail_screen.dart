import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/navigation/navigation_service.dart';

class SiteDetailsScreen extends StatefulWidget {
  final Site site;

  const SiteDetailsScreen({super.key, required this.site});

  @override
  State<SiteDetailsScreen> createState() => _SiteDetailsScreenState();
}

class _SiteDetailsScreenState extends State<SiteDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight - (kToolbarHeight * 1.25);
    final screenWidth = context.screenWidth;
    final isArchived = widget.site.archived ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Site Details',
          style: context.topology.textTheme.titleMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        leading: IconButton(
          onPressed: () {
            NavigationService().goBack();
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background image (fixed at bottom right)
            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/bg_4.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.l),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.vM,
                    // Status Badge
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isArchived
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isArchived
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.green.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isArchived ? Icons.archive : Icons.check_circle,
                              size: 16,
                              color: isArchived ? Colors.grey[700] : Colors.green[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isArchived ? 'Archived' : 'Active',
                              style: context.topology.textTheme.bodySmall?.copyWith(
                                color: isArchived ? Colors.grey[700] : Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    context.vM,
                    // Site Name Header
                    Text(
                      widget.site.siteName ?? 'N/A',
                      style: context.topology.textTheme.titleLarge?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.vS,
                    Text(
                      widget.site.siteCode ?? 'No Code',
                      style: context.topology.textTheme.bodyMedium?.copyWith(
                        color: context.colors.primary.withOpacity(0.7),
                      ),
                    ),
                    context.vL,
                    // Logo Section
                    if (widget.site.logo != null && widget.site.logo!.isNotEmpty) ...[
                      Text(
                        'Site Logo',
                        style: context.topology.textTheme.titleMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                      context.vS,
                      context.divider,
                      context.vM,
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colors.primary.withOpacity(0.3),
                              width: 2,
                            ),
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
                              widget.site.logo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: context.colors.surface,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: context.colors.primary.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      context.vL,
                    ],
                    // Basic Information Section
                    Text(
                      'Basic Information',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    context.vS,
                    context.divider,
                    context.vM,
                    _buildInfoCard(
                      context,
                      icon: Icons.business,
                      label: 'Site Name',
                      value: widget.site.siteName,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.qr_code,
                      label: 'Site Code',
                      value: widget.site.siteCode,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.corporate_fare,
                      label: 'Division',
                      value: widget.site.divisionName,
                    ),
                    context.vM,
                    // Location Information Section
                    Text(
                      'Location Information',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    context.vS,
                    context.divider,
                    context.vM,
                    _buildInfoCard(
                      context,
                      icon: Icons.location_on,
                      label: 'Address',
                      value: widget.site.address,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.map,
                      label: 'Area',
                      value: widget.site.area,
                    ),
                    context.vM,
                    // Additional Information Section
                    Text(
                      'Additional Information',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    context.vS,
                    context.divider,
                    context.vM,
                    _buildInfoCard(
                      context,
                      icon: Icons.description,
                      label: 'Description',
                      value: widget.site.description,
                      multiline: true,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.note,
                      label: 'Notes',
                      value: widget.site.notes,
                      multiline: true,
                    ),
                    context.vM,
                    // System Information Section
                    Text(
                      'System Information',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    context.vS,
                    context.divider,
                    context.vM,
                    _buildInfoCard(
                      context,
                      icon: Icons.fingerprint,
                      label: 'Site ID',
                      value: widget.site.siteid,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.person,
                      label: 'Customer ID',
                      value: widget.site.customerId,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.business_center,
                      label: 'Division ID',
                      value: widget.site.divisionId,
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Created At',
                      value: _formatDate(widget.site.createdAt.toString()),
                    ),
                    context.vS,
                    _buildInfoCard(
                      context,
                      icon: Icons.update,
                      label: 'Updated At',
                      value: _formatDate(widget.site.updatedAt.toString()),
                    ),
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

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    bool multiline = false,
  }) {
    final displayValue = (value?.isNotEmpty == true) ? value! : 'Not specified';
    final isEmpty = value?.isEmpty ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: context.topology.textTheme.bodyMedium?.copyWith(
                    color: isEmpty
                        ? context.colors.primary.withOpacity(0.4)
                        : context.colors.primary,
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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Not available';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
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
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}