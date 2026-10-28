import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:flutter/widgets.dart';

/// Exposes the current institution selection and rebuilds dependent pages.
final class InstitutionSelectionScope
    extends InheritedNotifier<InstitutionSelection> {
  const InstitutionSelectionScope({
    required InstitutionSelection selection,
    required super.child,
    super.key,
  }) : super(notifier: selection);

  static InstitutionSelection of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InstitutionSelectionScope>()!
        .notifier!;
  }
}
