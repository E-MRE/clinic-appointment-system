import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/add_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/remove_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Adds or removes availability windows with single-flight request handling.
/// The injected use cases own validation and atomic schedule changes.
final class AvailabilityWindowSaveCubit
    extends Cubit<AvailabilityWindowSaveState> {
  /// Injects the window addition and removal operations.
  AvailabilityWindowSaveCubit(this._addWindow, this._removeWindow)
    : super(const AvailabilityWindowSaveInitial());

  final AddAvailabilityWindowUseCase _addWindow;
  final RemoveAvailabilityWindowUseCase _removeWindow;
  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Adds [window] to [subject]'s schedule through the domain policy.
  Future<void> add(AvailabilitySubject subject, AvailabilityWindow window) {
    return _executeRequest(() {
      return _addWindow(
        AvailabilityWindowRequest(subject: subject, window: window),
      );
    });
  }

  /// Removes [window] from [subject]'s schedule by value.
  Future<void> remove(AvailabilitySubject subject, AvailabilityWindow window) {
    return _executeRequest(() {
      return _removeWindow(
        AvailabilityWindowRequest(subject: subject, window: window),
      );
    });
  }

  /// Restores the initial state when no request is in flight.
  void reset() {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    emit(const AvailabilityWindowSaveInitial());
  }

  Future<void> _executeRequest(
    Future<DataResult<StaffAvailability>> Function() request,
  ) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(const AvailabilityWindowSaving());
    try {
      final result = await request();
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
