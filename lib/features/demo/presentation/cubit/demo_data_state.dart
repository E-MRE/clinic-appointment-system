import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_command.dart';

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

/// A demo data command is in progress.
final class DemoDataLoading extends DemoDataState {
  /// Creates the loading state for [command].
  const DemoDataLoading(this.command);

  /// The command currently running.
  final DemoDataCommand command;
}

/// A demo data command completed successfully.
final class DemoDataSuccess extends DemoDataState {
  /// Creates the success state for [command].
  const DemoDataSuccess(this.command);

  /// The command that completed.
  final DemoDataCommand command;
}

/// The demo data command failed with a localizable [errorCode].
final class DemoDataFailure extends DemoDataState {
  /// Creates a failure state with its provider-independent code and [command].
  const DemoDataFailure(this.errorCode, this.command);

  /// The cause of the failed demo data request.
  final DemoErrorCode errorCode;

  /// The command that failed.
  final DemoDataCommand command;
}
