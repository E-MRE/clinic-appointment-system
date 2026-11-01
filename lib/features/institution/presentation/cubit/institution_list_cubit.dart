import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/stream_watch_cubit.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:flutter/foundation.dart';

/// Maps shared stream-watch states to institution list states.
/// Subclasses supply the typed watch use case and expose the parameters their
/// screen needs to start or replace an observation.
abstract class InstitutionListCubit<
  T,
  Params,
  UseCaseType extends StreamUseCase<DataResult<List<T>>, Params>
>
    extends StreamWatchCubit<List<T>, Params, InstitutionListState<T>> {
  /// Creates a list observer for a [watchUseCase].
  InstitutionListCubit(UseCaseType watchUseCase)
    : super(watchUseCase, InstitutionListLoading<T>());

  /// Provides the waiting state for an institution list observation.
  @protected
  @override
  InstitutionListState<T> loadingState() => InstitutionListLoading<T>();

  /// Copies the observed records into an unmodifiable loaded list.
  @protected
  @override
  InstitutionListState<T> loadedState(List<T> data) =>
      InstitutionListLoaded(List<T>.unmodifiable(data));

  /// Preserves institution failure codes and maps other failures to unavailable.
  @protected
  @override
  InstitutionListState<T> failureState(Object? error) {
    if (error is InstitutionException) {
      return InstitutionListFailure<T>(error.code);
    }
    return InstitutionListFailure<T>(InstitutionErrorCode.unavailable);
  }
}
