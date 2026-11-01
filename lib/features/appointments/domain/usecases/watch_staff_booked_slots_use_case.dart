import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/staff_booked_slots_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Observes owner-scoped appointment data for the presentation layer.
final class WatchStaffBookedSlotsUseCase
    implements
        StreamUseCase<DataResult<List<BookedSlot>>, StaffBookedSlotsQuery> {
  /// Injects the appointment observation boundary.
  const WatchStaffBookedSlotsUseCase(this._repository);

  final AppointmentRepository _repository;

  /// Preserves successful lists and error results from persistence.
  @override
  Stream<DataResult<List<BookedSlot>>> call(StaffBookedSlotsQuery params) {
    return _repository.watchStaffBookedSlots(params.staffId, params.date);
  }
}
