import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';

/// Resolves the configured login emails to existing authenticated profiles.
abstract interface class DemoAccountResolver {
  /// Returns the linked doctor and patient identities, or a typed demo error.
  Future<DataResult<DemoAccounts>> resolve();
}
