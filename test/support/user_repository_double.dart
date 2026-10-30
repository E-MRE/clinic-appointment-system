import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

class TestUserRepository implements UserRepository {
  Object? createError;
  Future<DataResult<Patient>>? pendingCreate;
  DataResult<User>? getResult;
  Stream<DataResult<User>>? profileStream;
  Patient? created;

  @override
  Future<DataResult<Patient>> createPatient(Patient patient) async {
    created = patient;
    if (pendingCreate case final creation?) return creation;
    if (createError case final error?) throw error;
    return DataResult.success(data: patient);
  }

  @override
  Stream<DataResult<User>> watchUser(String uid) {
    return profileStream ??
        Stream.value(
          getResult ??
              DataResult.success(
                data: Patient(
                  id: uid,
                  fullName: 'Elif Kaya',
                  email: 'patient@example.com',
                ),
              ),
        );
  }
}
