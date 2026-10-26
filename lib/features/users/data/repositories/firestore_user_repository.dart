import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Stores and reads user profiles through Firestore.
final class FirestoreUserRepository implements UserRepository {
  /// Injects the database used to store profiles.
  const FirestoreUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<DataResult<User>> watchUser(String uid) {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .snapshots()
        .handleError((Object error, StackTrace stackTrace) {
          if (error is FirebaseException) {
            Error.throwWithStackTrace(
              const UserException(UserErrorCode.unavailable),
              stackTrace,
            );
          }
          Error.throwWithStackTrace(error, stackTrace);
        })
        .map(_toUser);
  }

  /// Reads a profile snapshot; missing or malformed documents throw
  /// [UserException] so the stream reports them as errors.
  DataResult<User> _toUser(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw const UserException(UserErrorCode.profileMissing);
    }
    try {
      return DataResult.success(
        data: User.fromJson({...data, 'id': document.id}),
      );
    } on CheckedFromJsonException {
      throw const UserException(UserErrorCode.invalidProfile);
    } on TypeError {
      throw const UserException(UserErrorCode.invalidProfile);
    } on ArgumentError {
      throw const UserException(UserErrorCode.invalidProfile);
    }
  }

  @override
  Future<DataResult<Patient>> createPatient(Patient patient) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(patient.id)
          .set({
            ...patient.toJson(),
            FirestoreConstants.createdAt: FieldValue.serverTimestamp(),
          });
      return DataResult.success(data: patient);
    } on FirebaseException {
      throw const UserException(UserErrorCode.unavailable);
    }
  }
}
