import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_request_cubit.dart';

/// Controls the template's operation independently of either domain use case.
final class ControllableWindowRequestCubit
    extends AvailabilityWindowRequestCubit {
  DataResult<StaffAvailability> result = const DataResult.error();
  Object? error;
  Completer<void>? gate;
  final List<AvailabilityWindowRequest> requests = [];

  @override
  Future<DataResult<StaffAvailability>> request(
    AvailabilityWindowRequest request,
  ) async {
    requests.add(request);
    await gate?.future;
    if (error case final failure?) throw failure;
    return result;
  }
}
