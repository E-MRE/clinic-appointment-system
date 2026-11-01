import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_policy.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Validates and atomically adds a window against authoritative branch hours.
final class AddAvailabilityWindowUseCase
    implements
        UseCase<DataResult<StaffAvailability>, AvailabilityWindowRequest> {
  /// Injects schedule persistence, branch hours, time and the validation policy.
  const AddAvailabilityWindowUseCase(
    this._repository,
    this._branchRepository,
    this._clock,
    this._policy,
  );

  final StaffAvailabilityRepository _repository;
  final BranchRepository _branchRepository;
  final Clock _clock;
  final AvailabilityPolicy _policy;

  /// Reads branch hours, then prunes and validates inside each update attempt.
  /// Throws [AvailabilityException] for branch failures or policy violations.
  @override
  Future<DataResult<StaffAvailability>> call(
    AvailabilityWindowRequest request,
  ) async {
    final hours = await _branchHours(request.subject);
    return _repository.update(request.subject, (current) {
      final today = _clock.today;
      final pruned = current.prunedBy(today);
      _policy.check(
        request.window,
        AvailabilityRuleContext(
          current: pruned,
          branchHours: hours,
          today: today,
        ),
      );
      return pruned.adding(request.window);
    });
  }

  Future<WorkingHours> _branchHours(AvailabilitySubject subject) async {
    try {
      final result = await _branchRepository
          .watchBranch(subject.branchId)
          .first;
      final branch = result.data;
      if (result.isNotSuccess || branch == null) {
        throw const AvailabilityException(AvailabilityErrorCode.unavailable);
      }
      return branch.workingHours;
    } on InstitutionException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.unavailable),
        stackTrace,
      );
    } on StateError catch (_, stackTrace) {
      // Stream.first throws StateError when the branch stream is empty.
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.unavailable),
        stackTrace,
      );
    }
  }
}
