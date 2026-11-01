import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/stream_watch_cubit.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_service_durations_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/foundation.dart';

/// Observes assigned service durations with shared retry and close-race handling.
final class StaffServiceDurationsCubit
    extends
        StreamWatchCubit<
          List<ServiceDuration>,
          Staff,
          WatchState<List<ServiceDuration>, InstitutionErrorCode>
        > {
  /// Injects the typed observation use case.
  StaffServiceDurationsCubit(WatchStaffServiceDurationsUseCase watchUseCase)
    : super(
        watchUseCase,
        const WatchLoading<List<ServiceDuration>, InstitutionErrorCode>(),
      );

  /// Starts or replaces the observation for [staff].
  Future<void> watch(Staff staff) => watchWith(staff);

  /// Provides the waiting state for watch, retry and clear.
  @protected
  @override
  WatchState<List<ServiceDuration>, InstitutionErrorCode> loadingState() =>
      const WatchLoading();

  /// Provides the latest successfully observed data.
  @protected
  @override
  WatchState<List<ServiceDuration>, InstitutionErrorCode> loadedState(
    List<ServiceDuration> data,
  ) => WatchLoaded(List<ServiceDuration>.unmodifiable(data));

  /// Preserves typed domain codes and maps other failures to unavailable.
  @protected
  @override
  WatchState<List<ServiceDuration>, InstitutionErrorCode> failureState(
    Object? error,
  ) {
    if (error is InstitutionException) {
      return WatchFailure(error.code);
    }
    return const WatchFailure(InstitutionErrorCode.unavailable);
  }
}
