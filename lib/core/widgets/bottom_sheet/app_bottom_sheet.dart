import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Content frame for a modal bottom sheet.
final class AppBottomSheet extends StatelessWidget {
  /// Creates a sheet with a title and body.
  const AppBottomSheet({required this.title, required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s12,
          AppSizes.s16,
          AppSizes.s24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s16,
          children: [
            Center(
              child: Container(
                width: AppSizes.s32,
                height: AppSizes.s4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outline,
                  borderRadius: const AppRadius.full(),
                ),
              ),
            ),
            AppText.sectionTitle(title),
            child,
          ],
        ),
      ),
    );
  }
}
