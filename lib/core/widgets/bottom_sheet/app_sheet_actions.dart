import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Equal-width cancel and confirm actions for a bottom sheet.
final class AppSheetActions extends StatelessWidget {
  /// Creates sheet actions, disabling confirmation while busy.
  const AppSheetActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
    this.isBusy = false,
    super.key,
  });
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s8,
      children: [
        Expanded(
          child: SizedBox(
            height: AppSizes.s48,
            child: OutlinedButton(
              onPressed: onCancel,
              child: AppText.label(cancelLabel, tone: TextTone.primary),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: AppSizes.s48,
            child: FilledButton(
              onPressed: isBusy ? null : onConfirm,
              child: isBusy
                  ? const SizedBox.square(
                      dimension: AppSizes.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.s2,
                      ),
                    )
                  : AppText.label(confirmLabel, tone: TextTone.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
