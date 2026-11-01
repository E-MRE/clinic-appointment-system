import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/stream_watch_cubit.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:flutter/foundation.dart';

/// Observes branch hours with shared retry and close-race handling.
final class AvailabilityBranchCubit
    extends
        StreamWatchCubit<
          Branch,
          String,
          WatchState<Branch, InstitutionErrorCode>
        > {
  /// Injects the typed observation use case.
  AvailabilityBranchCubit(WatchBranchUseCase watchUseCase)
    : super(watchUseCase, const WatchLoading<Branch, InstitutionErrorCode>());

  /// Starts or replaces the observation for [branchId].
  Future<void> watch(String branchId) => watchWith(branchId);

  /// Provides the waiting state for watch, retry and clear.
  @protected
  @override
  WatchState<Branch, InstitutionErrorCode> loadingState() =>
      const WatchLoading();

  /// Provides the latest successfully observed data.
  @protected
  @override
  WatchState<Branch, InstitutionErrorCode> loadedState(Branch data) =>
      WatchLoaded(data);

  /// Preserves typed domain codes and maps other failures to unavailable.
  @protected
  @override
  WatchState<Branch, InstitutionErrorCode> failureState(Object? error) {
    if (error is InstitutionException) {
      return WatchFailure(error.code);
    }
    return const WatchFailure(InstitutionErrorCode.unavailable);
  }
}
