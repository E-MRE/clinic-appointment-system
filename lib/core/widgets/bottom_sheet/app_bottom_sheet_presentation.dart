import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Presents application bottom sheets with the shared modal configuration.
extension AppBottomSheetPresentation on BuildContext {
  /// Opens a modal sheet whose content is provided by [builder].
  Future<T?> showAppBottomSheet<T>({required WidgetBuilder builder}) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xLarge()),
      builder: builder,
    );
  }
}
