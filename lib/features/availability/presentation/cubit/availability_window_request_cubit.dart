import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs a single availability request with close-safe progress and error mapping.
/// Subclasses supply the domain operation through [request].
abstract class AvailabilityWindowRequestCubit
    extends Cubit<AvailabilityWindowSaveState> {
  /// Creates an idle request cubit.
  AvailabilityWindowRequestCubit()
    : super(const AvailabilityWindowSaveInitial());

  /// Executes the subclass's domain operation for the supplied request.
  @protected
  Future<DataResult<StaffAvailability>> request(
    AvailabilityWindowRequest request,
  );

  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Restores the initial state when no request is in flight.
  void reset() {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    emit(const AvailabilityWindowSaveInitial());
  }

  /// Submits [window] for [subject], ignoring concurrent or closed requests.
  Future<void> submit(
    AvailabilitySubject subject,
    AvailabilityWindow window,
  ) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(const AvailabilityWindowSaving());
    try {
      final result = await request(
        AvailabilityWindowRequest(subject: subject, window: window),
      );
      if (_isClosingOrClosed) return;
      final availability = result.data;
      if (result.isNotSuccess || availability == null) {
        _emitFailure(
          const AvailabilityWindowSaveFailure(
            AvailabilityErrorCode.unavailable,
          ),
        );
        return;
      }
      emit(AvailabilityWindowSaved(availability));
    } on AvailabilityException catch (error) {
      _emitFailure(
        AvailabilityWindowSaveFailure(error.code, conflict: error.conflict),
      );
    } catch (_) {
      _emitFailure(
        const AvailabilityWindowSaveFailure(AvailabilityErrorCode.unavailable),
      );
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emitFailure(AvailabilityWindowSaveFailure failure) {
    if (_isClosingOrClosed) return;
    emit(failure);
  }

  /// Closes the cubit and ignores any pending request completion.
  @override
  Future<void> close() async {
    _isClosing = true;
    await super.close();
  }
}
