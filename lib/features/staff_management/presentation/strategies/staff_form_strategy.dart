import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/widgets.dart';

/// Builds normalized staff profiles; subclasses supply role-specific creation.
abstract base class StaffFormStrategy {
  /// Creates a staff form strategy.
  const StaffFormStrategy();

  /// Subclasses must supply the role-specific specialty inputs, or an empty widget.
  Widget specialtySection();

  /// Subclasses must create their role's profile from [values] with [id].
  Staff create(StaffFormValues values, {required String id});

  /// Builds the role's profile and trims its text without validating input.
  Staff build(StaffFormValues values, {required String id}) =>
      create(values, id: id).trimmed();
}
