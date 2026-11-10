import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_appointments_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the active tab of the patient's appointment table.
final class PatientAppointmentsTabCubit extends Cubit<PatientAppointmentsTab> {
  /// Creates a tab cubit defaulting to [PatientAppointmentsTab.all].
  PatientAppointmentsTabCubit() : super(PatientAppointmentsTab.all);

  /// Selects [tab] as the active tab.
  void select(PatientAppointmentsTab tab) => emit(tab);
}
