import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_patient_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_appointments_overview_factory.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_booking_catalog_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes only the signed-in patient's appointments.
/// Failed results keep their [AppointmentErrorCode]; stream errors report
/// [AppointmentErrorCode.unavailable].
final class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  /// Injects the owner-scoped observation use case.
  PatientAppointmentsCubit(
    this._watchAppointments,
    this._clock,
    this._overviewFactory,
    this._bookingCatalogCalculator,
  ) : super(const PatientAppointmentsLoading());

  final WatchPatientAppointmentsUseCase _watchAppointments;
  final Clock _clock;
  final PatientAppointmentsOverviewFactory _overviewFactory;
  final PatientBookingCatalogCalculator _bookingCatalogCalculator;
  StreamSubscription<DataResult<List<Appointment>>>? _subscription;
  String? _patientId;
  List<Appointment>? _appointments;
  ClinicCatalog? _catalog;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts observing the appointments of [patientId], replacing any
  /// earlier observation.
  void watch(String patientId) {
    if (_isClosingOrClosed) return;
    _patientId = patientId;
    _appointments = null;
    _cancel();
    emit(const PatientAppointmentsLoading());
    try {
      _subscription = _watchAppointments
          .call(patientId)
          .listen(
            _onResult,
            onError: (Object _) {
              _emit(
                const PatientAppointmentsFailure(
                  AppointmentErrorCode.unavailable,
                ),
              );
            },
          );
    } on Exception {
      _emit(const PatientAppointmentsFailure(AppointmentErrorCode.unavailable));
    }
  }

  /// Restarts the last observation; does nothing before the first [watch].
  void retry() {
    final patientId = _patientId;
    if (patientId != null) watch(patientId);
  }

  /// Supplies the latest catalog so the loaded presentation model can join
  /// both independently observed sources.
  void updateCatalog(ClinicCatalog catalog) {
    _catalog = catalog;
    _emitIfReady();
  }

  void _onResult(DataResult<List<Appointment>> result) {
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _appointments = null;
      _emit(PatientAppointmentsFailure(result.appointmentErrorCode));
      return;
    }
    _appointments = appointments;
    _emitIfReady();
  }

  void _emitIfReady() {
    final appointments = _appointments;
    final catalog = _catalog;
    final patientId = _patientId;
    if (appointments == null || catalog == null || patientId == null) return;

    final now = _clock.now();
    final overview = _overviewFactory.create(
      appointments: appointments,
      catalog: catalog,
      now: now,
      patient: PatientAppointmentActor(id: patientId),
    );
    final bookableDepartments = _bookingCatalogCalculator.calculate(catalog);
    _emit(
      PatientAppointmentsLoaded(
        appointments: appointments,
        overview: overview,
        bookableDepartments: bookableDepartments,
      ),
    );
  }

  void _emit(PatientAppointmentsState state) {
    if (_isClosingOrClosed) return;
    emit(state);
  }

  void _cancel() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  /// Cancels the observation before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
    await super.close();
  }
}
