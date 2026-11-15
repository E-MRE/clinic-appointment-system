import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';

/// The closed set of states emitted while observing the clinic directory.
sealed class ClinicCatalogState {
  /// Creates a state for the clinic directory observation.
  const ClinicCatalogState();
}

/// Waiting for every clinic directory collection to arrive.
final class ClinicCatalogLoading extends ClinicCatalogState {
  /// Creates the loading state.
  const ClinicCatalogLoading();
}

/// A clinic directory collection could not be observed.
final class ClinicCatalogFailure extends ClinicCatalogState {
  /// Creates the failure state.
  const ClinicCatalogFailure();
}

/// Every collection arrived; [catalog] is their latest snapshot.
final class ClinicCatalogLoaded extends ClinicCatalogState {
  /// Creates the loaded state holding [catalog].
  const ClinicCatalogLoaded(this.catalog);

  /// The latest clinic directory snapshot.
  final ClinicCatalog catalog;
}
