import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/features/availability/data/models/staff_availability_model.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Persists staff schedules with atomic read-modify-write transactions.
final class FirestoreStaffAvailabilityRepository
    implements StaffAvailabilityRepository {
  /// Injects the Firestore instance used for schedules.
  const FirestoreStaffAvailabilityRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Watches the current schedule, yielding an empty schedule when absent.
  @override
  Stream<DataResult<StaffAvailability>> watch(AvailabilitySubject subject) {
    try {
      return _reference(subject)
          .snapshots()
          .handleError(_handleStreamError)
          .map(
            (snapshot) =>
                DataResult.success(data: _fromSnapshot(snapshot, subject)),
          );
    } on FirebaseException catch (_, stackTrace) {
      return Stream.error(
        const AvailabilityException(AvailabilityErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  /// Applies [change] to the current schedule in a Firestore transaction.
  @override
  Future<DataResult<StaffAvailability>> update(
    AvailabilitySubject subject,
    StaffAvailability Function(StaffAvailability current) change,
  ) async {
    try {
      final reference = _reference(subject);
      final next = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(reference);
        final current = _fromSnapshot(snapshot, subject);
        final next = change(current);
        transaction.set(reference, {
          ...StaffAvailabilityModel.fromEntity(next).toJson(),
          FirestoreConstants.updatedAt: FieldValue.serverTimestamp(),
        });
        return next;
      });
      return DataResult.success(data: next);
    } on FirebaseException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  DocumentReference<Map<String, dynamic>> _reference(
    AvailabilitySubject subject,
  ) {
    return _firestore
        .collection(FirestoreConstants.staffAvailability)
        .doc(subject.staffId);
  }

  StaffAvailability _fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    AvailabilitySubject subject,
  ) {
    final data = snapshot.data();
    if (data == null && !snapshot.exists) {
      return StaffAvailability.empty(
        staffId: subject.staffId,
        branchId: subject.branchId,
      );
    }
    try {
      if (data == null) {
        throw const FormatException('A schedule document must contain data.');
      }
      return StaffAvailabilityModel.fromJson(data).toEntity(subject);
    } on CheckedFromJsonException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.invalidRecord),
        stackTrace,
      );
    } on TypeError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.invalidRecord),
        stackTrace,
      );
    } on ArgumentError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.invalidRecord),
        stackTrace,
      );
    } on FormatException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.invalidRecord),
        stackTrace,
      );
    } on TimeException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.invalidRecord),
        stackTrace,
      );
    }
  }

  void _handleStreamError(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      Error.throwWithStackTrace(
        const AvailabilityException(AvailabilityErrorCode.unavailable),
        stackTrace,
      );
    }
    Error.throwWithStackTrace(error, stackTrace);
  }
}
