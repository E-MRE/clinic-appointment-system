import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';

/// The closed set of states for the admin's demo data request.
sealed class DemoDataState {
  /// Creates a demo data request state.
  const DemoDataState();
}

/// No demo data request has run in this page session.
final class DemoDataIdle extends DemoDataState {
  /// Creates the initial state.
  const DemoDataIdle();
}

/// A demo data replacement is in progress.
final class DemoDataLoading extends DemoDataState {
  /// Creates the loading state.
  const DemoDataLoading();
}

/// The demo data replacement completed successfully.
final class DemoDataSuccess extends DemoDataState {
  /// Creates the success state.
  const DemoDataSuccess();
}

/// The demo data replacement failed with a localizable [errorCode].
final class DemoDataFailure extends DemoDataState {
  /// Creates a failure state with its provider-independent code.
  const DemoDataFailure(this.errorCode);

  /// The cause of the failed demo data request.
  final DemoErrorCode errorCode;
}
