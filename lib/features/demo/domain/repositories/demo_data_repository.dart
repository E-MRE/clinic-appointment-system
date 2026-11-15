import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_data_set.dart';

/// Persists a complete demo data set as one repeatable replacement operation.
abstract interface class DemoDataRepository {
  /// Removes prior demo records and writes [set] with provider-independent
  /// failures returned as a [DataResult] carrying a demo error code.
  Future<DataResult<void>> replace(DemoDataSet set);
}
