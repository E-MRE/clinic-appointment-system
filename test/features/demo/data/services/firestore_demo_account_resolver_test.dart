import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/demo/data/models/demo_account_emails.dart';
import 'package:clinic_appointment_system/features/demo/data/services/firestore_demo_account_resolver.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/staff_management/data/models/staff_model_factory.dart';
import 'package:clinic_appointment_system/features/staff_management/data/repositories/firestore_staff_repository.dart';
import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/patient_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model_factory.dart';
import 'package:clinic_appointment_system/features/users/data/repositories/firestore_user_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves configured doctor and patient profiles by email', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection(FirestoreConstants.users)
        .doc('doctor-1')
        .set(
          DoctorModel.fromEntity(
            const Doctor(
              id: 'doctor-1',
              fullName: 'Dr. Servet Yılmaz',
              email: 'servet@doktor.com',
              branchId: 'old-branch',
              departmentId: 'old-department',
              serviceIds: [],
              specialty: 'Internal medicine',
            ),
          ).toJson(),
        );
    await firestore
        .collection(FirestoreConstants.users)
        .doc('patient-1')
        .set(
          PatientModel.fromEntity(
            const Patient(
              id: 'patient-1',
              fullName: 'Remzi Pala',
              email: 'remzi@pala.com',
            ),
          ).toJson(),
        );
    final resolver = FirestoreDemoAccountResolver(
      FirestoreStaffRepository(firestore, const StaffModelFactory()),
      FirestoreUserRepository(firestore, const UserModelFactory()),
      const DemoAccountEmails.demo(),
    );

    final result = await resolver.resolve();

    expect(result.isSuccess, isTrue);
    expect(result.data?.doctorUid, 'doctor-1');
    expect(result.data?.doctorFullName, 'Dr. Servet Yılmaz');
    expect(result.data?.patientUid, 'patient-1');
    expect(result.data?.patientFullName, 'Remzi Pala');
  });

  test(
    'returns a typed error when the configured patient is missing',
    () async {
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection(FirestoreConstants.users)
          .doc('doctor-1')
          .set(
            DoctorModel.fromEntity(
              const Doctor(
                id: 'doctor-1',
                fullName: 'Dr. Servet Yılmaz',
                email: 'servet@doktor.com',
                branchId: 'old-branch',
                departmentId: 'old-department',
                serviceIds: [],
                specialty: 'Internal medicine',
              ),
            ).toJson(),
          );
      final resolver = FirestoreDemoAccountResolver(
        FirestoreStaffRepository(firestore, const StaffModelFactory()),
        FirestoreUserRepository(firestore, const UserModelFactory()),
        const DemoAccountEmails.demo(),
      );

      final result = await resolver.resolve();

      expect(result.isNotSuccess, isTrue);
      expect(result.errorCode, DemoErrorCode.patientAccountMissing);
    },
  );
}
