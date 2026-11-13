import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_rule_check_kind.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_rule_check_kind_presentation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The outcome of one live rule check for a staff appointment request.
final class StaffRuleCheckItem extends Equatable {
  /// Creates a rule check outcome.
  const StaffRuleCheckItem({
    required this.kind,
    required this.passed,
    this.detail,
  });

  /// The checked rule.
  final StaffRuleCheckKind kind;

  /// Whether the request satisfies the rule.
  final bool passed;

  /// The availability window or branch hours shown in a passed text
  /// (`Salı 09:00–12:00`), or null when the rule has none.
  final String? detail;

  /// The localized text of this outcome.
  String get message => passed ? kind.passedLabel(detail) : kind.failedLabel;

  /// The icon of this outcome.
  IconData get icon {
    return passed ? Icons.check_circle_outline : Icons.cancel_outlined;
  }

  @override
  List<Object?> get props => [kind, passed, detail];
}
