import 'package:clinic_appointment_system/core/constants/appointment_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/models/appointment_reason_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Captures an optional reason when staff rejects or cancels an appointment.
/// Returns an [AppointmentReasonConfirmation] with trimmed text (or `null`
/// when blank), or `null` when dismissed.
final class AppointmentReasonDialog extends StatefulWidget {
  /// Creates the reason dialog with contextual headings and action label.
  const AppointmentReasonDialog({
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    this.initialReason,
    super.key,
  });

  /// Heading identifying the action (e.g. "Talebi reddet").
  final String title;

  /// Subtitle identifying the target appointment details.
  final String subtitle;

  /// Label on the destructive confirmation button (e.g. "Reddet", "İptal et").
  final String confirmLabel;

  /// Optional prefilled reason text.
  final String? initialReason;

  /// Shows this dialog over [context] and waits for user confirmation.
  Future<AppointmentReasonConfirmation?> show(BuildContext context) {
    return showDialog<AppointmentReasonConfirmation>(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  State<AppointmentReasonDialog> createState() =>
      _AppointmentReasonDialogState();
}

final class _AppointmentReasonDialogState extends State<AppointmentReasonDialog>
    with _AppointmentReasonDialogMixin {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.sectionTitle(widget.title),
          const EmptySize.s4Height(),
          AppText.body(widget.subtitle, tone: TextTone.muted),
        ],
      ),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: _onDismiss,
          child: Text(LocaleKeys.appointment_reasonDialog_dismiss.translate()),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
          onPressed: _onConfirm,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }

  SizedBox _buildContent() {
    return SizedBox(
      width: AppSizes.formDialogMaxWidth,
      child: AppTextField(
        controller: _controller,
        label: LocaleKeys.appointment_reasonDialog_reasonLabel.translate(),
        helper: LocaleKeys.appointment_reasonDialog_reasonHelper.translate(),
        maxLength: AppointmentConstants.statusReasonMaxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: _reasonLines,
      ),
    );
  }
}

mixin _AppointmentReasonDialogMixin on State<AppointmentReasonDialog> {
  int get _reasonLines => 4;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialReason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final raw = _controller.text.trim();
    final trimmed = raw.isEmpty ? null : raw;
    Navigator.of(context).pop(AppointmentReasonConfirmation(reason: trimmed));
  }

  void _onDismiss() {
    Navigator.of(context).pop(null);
  }
}
