import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/staff_management/data/models/staff_model_factory.dart';
import 'package:clinic_appointment_system/features/staff_management/data/visitors/staff_document_visitor.dart';
import 'package:clinic_appointment_system/features/staff_management/data/visitors/staff_editable_fields_visitor.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Persists staff profiles without exposing provider failures to callers.
final class FirestoreStaffRepository implements StaffRepository {
  /// Injects profile storage and the stored staff model factory.
  const FirestoreStaffRepository(this._firestore, this._models);

  final FirebaseFirestore _firestore;
  final StaffModelFactory _models;

  /// Creates the profile under its auth uid with a server creation timestamp.
  /// Rejects unsaved ids and translates Firebase failures to [UserException].
  @override
  Future<DataResult<Staff>> createStaff(Staff staff) async {
    if (staff.id == Staff.unsavedId) {
      throw const UserException(UserErrorCode.invalidProfile);
    }
    try {
      await _firestore.collection(FirestoreConstants.users).doc(staff.id).set({
        ...staff.accept(const StaffDocumentVisitor()),
        FirestoreConstants.createdAt: FieldValue.serverTimestamp(),
      });
      return DataResult.success(data: staff);
    } on FirebaseException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  /// Updates only role-specific editable fields, preserving identity and scope.
  /// Firebase write failures throw [UserException].
  @override
  Future<DataResult<Staff>> updateStaff(Staff staff) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(staff.id)
          .update(staff.accept(const StaffEditableFieldsVisitor()));
      return DataResult.success(data: staff);
    } on FirebaseException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  /// Watches doctors and technicians sorted by full name.
  /// Malformed profiles and Firebase failures are [UserException] stream errors.
  @override
  Stream<DataResult<List<Staff>>> watchStaff() {
    try {
      return _firestore
          .collection(FirestoreConstants.users)
          .where(
            FirestoreConstants.role,
            whereIn: [UserRole.doctor.name, UserRole.technician.name],
          )
          .snapshots()
          .handleError(_handleError)
          .map(_toStaff);
    } on FirebaseException catch (_, stackTrace) {
      return Stream.error(
        const UserException(UserErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  DataResult<List<Staff>> _toStaff(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    try {
      final List<Staff> staff =
          snapshot.docs.map((
            QueryDocumentSnapshot<Map<String, dynamic>> document,
          ) {
            return _models.fromJson({...document.data(), 'id': document.id});
          }).toList()..sort(
            (Staff first, Staff second) =>
                first.fullName.compareTo(second.fullName),
          );
      return DataResult.success(data: staff);
    } on CheckedFromJsonException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.invalidProfile),
        stackTrace,
      );
    } on TypeError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.invalidProfile),
        stackTrace,
      );
    } on ArgumentError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.invalidProfile),
        stackTrace,
      );
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      Error.throwWithStackTrace(
        const UserException(UserErrorCode.unavailable),
        stackTrace,
      );
    }
    Error.throwWithStackTrace(error, stackTrace);
  }
}
