import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';

extension JobFormStyle on BuildContext {
  Color tint(double alpha) => colors.primary.withValues(alpha: alpha);

  TextStyle? get fieldStyle =>
      topology.textTheme.bodySmall?.copyWith(color: colors.primary);
}
