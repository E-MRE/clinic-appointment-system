import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_data_set.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_account_resolver.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_data_repository.dart';

/// Supplies controllable linked-account and persistence results to demo tests.
final class DemoUseCaseFakeDependencies
    implements DemoAccountResolver, DemoDataRepository {
  /// Creates the fake with independently configurable operation results.
  DemoUseCaseFakeDependencies({
    required this.accountResult,
    this.replaceResult = const DataResult.success(data: null),
  });

  /// The result returned from account resolution.
  final DataResult<DemoAccounts> accountResult;

  /// The result returned from demo data replacement.
  final DataResult<void> replaceResult;

  /// Number of account-resolution requests received.
  int resolveCalls = 0;

  /// Number of replacement requests received.
  int replaceCalls = 0;

  /// The latest set passed to [replace].
  DemoDataSet? replacedDataSet;

  @override
  Future<DataResult<DemoAccounts>> resolve() async {
    resolveCalls++;
    return accountResult;
  }

  @override
  Future<DataResult<void>> replace(DemoDataSet set) async {
    replaceCalls++;
    replacedDataSet = set;
    return replaceResult;
  }
}
