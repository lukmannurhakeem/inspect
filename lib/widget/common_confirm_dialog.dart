import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';

class CommonConfirmDialog extends StatelessWidget {
  const CommonConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.warningNote,
    this.previewWidget,
    this.icon,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String? warningNote;
  final Widget? previewWidget;
  final IconData? icon;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final bool isLoading;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String? warningNote,
    Widget? previewWidget,
    IconData? icon,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    bool isLoading = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible && !isLoading,
      builder:
          (_) => CommonConfirmDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        warningNote: warningNote,
        previewWidget: previewWidget,
        icon: icon,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        isLoading: isLoading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = isDestructive ? Colors.red.shade600 : context.colors.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: Row(
        children: [
          if (icon != null || isDestructive) ...[
            Icon(
              icon ?? Icons.warning_amber_rounded,
              color: accent,
              size: 24,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
            if (previewWidget != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: previewWidget,
              ),
            ],
            if (warningNote != null) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      warningNote!,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
          isLoading
              ? null
              : () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child:
          isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(confirmText),
        ),
      ],
    );
  }
}