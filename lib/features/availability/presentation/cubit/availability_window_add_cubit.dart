import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/add_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_request_cubit.dart';
import 'package:flutter/foundation.dart';

/// Adds a window through the shared request lifecycle.
final class AvailabilityWindowAddCubit extends AvailabilityWindowRequestCubit {
  /// Injects the domain add operation.
  AvailabilityWindowAddCubit(this._useCase);

  final AddAvailabilityWindowUseCase _useCase;

  /// Delegates the request to the injected use case.
  @protected
  @override
  Future<DataResult<StaffAvailability>> request(
    AvailabilityWindowRequest request,
  ) => _useCase(request);
}
