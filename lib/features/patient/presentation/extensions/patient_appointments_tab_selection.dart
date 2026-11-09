import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_appointments_tab.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';

/// Rows, label and empty message of each appointments tab.
extension PatientAppointmentsTabSelection on PatientAppointmentsTab {
  /// The rows this tab shows from [overview], in display order.
  List<PatientAppointmentEntry> select(PatientAppointmentsOverview overview) {
    return switch (this) {
      PatientAppointmentsTab.all => overview.all,
      PatientAppointmentsTab.upcoming => overview.upcoming,
      PatientAppointmentsTab.past => overview.past,
    };
  }

  /// The localized tab label with its row count in [overview].
  String label(PatientAppointmentsOverview overview) {
    final count = '${select(overview).length}';
    return switch (this) {
      PatientAppointmentsTab.all => LocaleKeys.patient_appointments_tabs_all,
      PatientAppointmentsTab.upcoming =>
        LocaleKeys.patient_appointments_tabs_upcoming,
      PatientAppointmentsTab.past => LocaleKeys.patient_appointments_tabs_past,
    }.translate(args: [count]);
  }

  /// The localized message shown when this tab has no rows.
  String get emptyMessage {
    return switch (this) {
      PatientAppointmentsTab.all =>
        LocaleKeys.patient_appointments_emptyTabs_all,
      PatientAppointmentsTab.upcoming =>
        LocaleKeys.patient_appointments_emptyTabs_upcoming,
      PatientAppointmentsTab.past =>
        LocaleKeys.patient_appointments_emptyTabs_past,
    }.translate();
  }
}
