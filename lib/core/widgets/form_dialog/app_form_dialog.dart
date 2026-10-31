import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog_header.dart';
import 'package:flutter/material.dart';

/// A scrollable form dialog with a title and close action.
final class AppFormDialog extends StatelessWidget {
  /// Creates a form dialog.
  const AppFormDialog({required this.title, required this.child, super.key});

  /// Heading shown above the form.
  final String title;

  /// Form displayed below the heading.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.formDialogMaxWidth,
        ),
        child: Padding(
          padding: const AppPadding.allLg(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFormDialogHeader(title: title),
                const EmptySize.s16Height(),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
