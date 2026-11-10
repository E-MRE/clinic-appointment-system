import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';

/// The closed set of states of the patient's clinic catalog.
sealed class PatientCatalogState {
  /// Creates a catalog state.
  const PatientCatalogState();
}

/// Waiting for every catalog collection to arrive.
final class PatientCatalogLoading extends PatientCatalogState {
  /// Creates the loading state.
  const PatientCatalogLoading();
}

/// A catalog collection could not be observed.
final class PatientCatalogFailure extends PatientCatalogState {
  /// Creates the failure state.
  const PatientCatalogFailure();
}

/// Every collection arrived; [catalog] is their latest snapshot.
final class PatientCatalogLoaded extends PatientCatalogState {
  /// Creates the loaded state holding [catalog].
  const PatientCatalogLoaded(this.catalog);

  /// The latest catalog snapshot.
  final PatientCatalog catalog;
}
