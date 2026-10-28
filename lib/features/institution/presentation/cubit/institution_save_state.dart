import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// The closed set of states emitted by institution create and update requests.
sealed class InstitutionSaveState<T> {
  /// Creates a request state shared by the progress and result variants.
  const InstitutionSaveState();
}

/// A save request failed with a domain [code].
final class InstitutionSaveFailure<T> extends InstitutionSaveState<T> {
  /// Creates a failure state identified by [code].
  const InstitutionSaveFailure(this.code);

  /// The reason to localize at the presentation boundary.
  final InstitutionErrorCode code;
}

/// No save request has started.
final class InstitutionSaveInitial<T> extends InstitutionSaveState<T> {
  /// Creates the initial request state.
  const InstitutionSaveInitial();
}

/// A save request completed with [value].
final class InstitutionSaveSaved<T> extends InstitutionSaveState<T> {
  /// Creates a saved state containing the persisted [value].
  const InstitutionSaveSaved(this.value);

  /// The entity returned by the use case.
  final T value;
}

/// A create or update request is in progress.
final class InstitutionSaveSaving<T> extends InstitutionSaveState<T> {
  /// Creates a saving state.
  const InstitutionSaveSaving();
}
