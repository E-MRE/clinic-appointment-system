import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Observes distinct durations of the services assigned to a staff member.
final class WatchStaffServiceDurationsUseCase
    implements StreamUseCase<DataResult<List<ServiceDuration>>, Staff> {
  /// Injects the medical service observation boundary.
  const WatchStaffServiceDurationsUseCase(this._repository);

  final MedicalServiceRepository _repository;

  /// Filters branch services by assigned ids and sorts durations by minutes.
  /// Failed or missing-data results remain failures; stream errors propagate.
  @override
  Stream<DataResult<List<ServiceDuration>>> call(Staff staff) {
    return _repository.watchServices(staff.branchId).map((result) {
      final services = result.data;
      if (result.isNotSuccess || services == null) {
        return DataResult<List<ServiceDuration>>.error(message: result.message);
      }
      final assignedIds = staff.serviceIds.toSet();
      final durations =
          services
              .where((service) => assignedIds.contains(service.id))
              .map((service) => service.duration)
              .toSet()
              .toList()
            ..sort((first, second) => first.minutes.compareTo(second.minutes));
      return DataResult.success(data: durations);
    });
  }
}
