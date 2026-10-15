import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/screen/job/job_register/item_register_widget.dart';
import 'package:provider/provider.dart';

class InspectionEmptyState extends StatelessWidget {
  final VoidCallback onStart;

  const InspectionEmptyState({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final text = context.topology.textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withValues(alpha: 0.15),
                      Colors.green.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  size: 70,
                  color: Colors.teal.shade600,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'No Inspections Yet',
                style: text.titleLarge?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Begin your inspection journey by\nconducting your first inspection',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.playlist_add_check, size: 22),
                label: const Text('Start Inspection'),
                style: filledStyle(
                  Colors.teal,
                  radius: 12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InspectionStatusBadge extends StatelessWidget {
  final String status;

  const InspectionStatusBadge({super.key, required this.status});

  static (Color, IconData) _style(String status) =>
      switch (status.toLowerCase()) {
        'approved' || 'accepted' || 'completed' => (
        Colors.green,
        Icons.check_circle,
        ),
        'rejected' || 'failed' => (Colors.red, Icons.cancel),
        'submitted' => (Colors.blue, Icons.upload),
        'draft' => (Colors.grey, Icons.edit_note),
        _ => (Colors.orange, Icons.pending),
      };

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _style(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            status.isEmpty ? 'PENDING' : status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionReportName extends StatelessWidget {
  final String name;

  const InspectionReportName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            size: 14,
            color: primary.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionPdfButton extends StatefulWidget {
  final Map<String, dynamic> report;

  const InspectionPdfButton({super.key, required this.report});

  @override
  State<InspectionPdfButton> createState() => _InspectionPdfButtonState();
}

class _InspectionPdfButtonState extends State<InspectionPdfButton> {
  bool _loading = false;

  Future<void> _open() async {
    final id = widget.report['reportId']?.toString() ?? '';
    if (id.isEmpty) {
      CommonSnackbar.showWarning(context, 'Report ID missing, cannot open PDF.');
      return;
    }

    if (kIsWeb) {
      final url = widget.report['pdfViewUrl']?.toString() ?? '';
      openInNewTab(
        url.isNotEmpty ? url : '${AppConstants.apiBaseUrl}/reportData/$id/view-pdf',
      );
      return;
    }

    final systemProvider = context.read<SystemProvider>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);
    CommonSnackbar.show(
      context: context,
      message: 'Loading PDF...',
      type: SnackbarType.info,
      duration: const Duration(seconds: 60),
    );

    try {
      final bytes = await systemProvider.fetchPdfReportById(id);
      messenger.hideCurrentSnackBar();
      if (!mounted) return;

      if (bytes == null) {
        CommonSnackbar.showWarning(
          context,
          'PDF not available. Report may still be processing.',
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              PdfViewerScreen(pdfData: bytes, reportName: 'Report_$id'),
        ),
      );
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (mounted) CommonSnackbar.showError(context, 'Failed to load PDF: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: _loading ? null : _open,
    icon: _loading
        ? const SizedBox(
      width: 14,
      height: 14,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    )
        : const Icon(Icons.picture_as_pdf, size: 16),
    label: Text(_loading ? '...' : 'PDF'),
    style:
    filledStyle(
      context.colors.primary,
      radius: 6,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    ).copyWith(
      textStyle: WidgetStatePropertyAll(context.topology.textTheme.bodySmall),
    ),
  );
}