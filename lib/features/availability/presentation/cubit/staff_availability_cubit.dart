import 'package:clinic_appointment_system/core/states/stream_watch_cubit.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:flutter/foundation.dart';

/// Observes a staff schedule with shared retry and close-race handling.
final class StaffAvailabilityCubit
    extends
        StreamWatchCubit<
          StaffAvailability,
          AvailabilitySubject,
          WatchState<StaffAvailability, AvailabilityErrorCode>
        > {
  /// Injects the typed observation use case.
  StaffAvailabilityCubit(WatchStaffAvailabilityUseCase watchUseCase)
    : super(
        watchUseCase,
        const WatchLoading<StaffAvailability, AvailabilityErrorCode>(),
      );

  /// Starts or replaces the observation for [subject].
  Future<void> watch(AvailabilitySubject subject) => watchWith(subject);

  /// Provides the waiting state for watch, retry and clear.
  @protected
  @override
  WatchState<StaffAvailability, AvailabilityErrorCode> loadingState() =>
      const WatchLoading();

  /// Provides the latest successfully observed data.
  @protected
  @override
  WatchState<StaffAvailability, AvailabilityErrorCode> loadedState(
    StaffAvailability data,
  ) => WatchLoaded(data);

  /// Preserves typed domain codes and maps other failures to unavailable.
  @protected
  @override
  WatchState<StaffAvailability, AvailabilityErrorCode> failureState(
    Object? error,
  ) {
    if (error is AvailabilityException) {
      return WatchFailure(error.code);
    }
    return const WatchFailure(AvailabilityErrorCode.unavailable);
  }
}
