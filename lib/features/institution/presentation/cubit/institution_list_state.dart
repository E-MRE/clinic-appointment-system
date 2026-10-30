import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// The closed set of states emitted while an institution list is observed.
sealed class InstitutionListState<T> {
  /// Creates a list state shared by the loading, loaded and failure variants.
  const InstitutionListState();
}

/// The stream failed with a domain [code].
final class InstitutionListFailure<T> extends InstitutionListState<T> {
  /// Creates a failure state identified by [code].
  const InstitutionListFailure(this.code);

  /// The failure reason to localize at the presentation boundary.
  final InstitutionErrorCode code;
}

/// The observed list contains [items].
final class InstitutionListLoaded<T> extends InstitutionListState<T> {
  /// Creates a loaded state with the current [items].
  const InstitutionListLoaded(this.items);

  /// The current records from the stream.
  final List<T> items;
}

/// The list is waiting for its first stream result or a retry.
final class InstitutionListLoading<T> extends InstitutionListState<T> {
  /// Creates a loading state.
  const InstitutionListLoading();
}
