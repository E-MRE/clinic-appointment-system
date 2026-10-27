import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/users/data/models/patient_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model_factory.dart';
import 'package:clinic_appointment_system/features/users/data/repositories/firestore_user_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

// Firestore SDK types are mocked here to simulate a provider write failure.
// ignore: subtype_of_sealed_class
class MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocument extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreUserRepository repository;
  const patient = Patient(
    id: 'uid',
    fullName: 'Elif Kaya',
    email: 'elif@example.com',
  );
  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirestoreUserRepository(firestore, const UserModelFactory());
  });
  test('watches a missing profile and the later patient write', () async {
    final expectation = expectLater(
      repository.watchUser('uid'),
      emitsInOrder([
        emitsError(
          isA<UserException>().having(
            (e) => e.code,
            'code',
            UserErrorCode.profileMissing,
          ),
        ),
        isA<DataResult<User>>().having((r) => r.data, 'user', isA<Patient>()),
      ]),
    );
    await Future<void>.delayed(Duration.zero);
    await firestore
        .collection('users')
        .doc('uid')
        .set(PatientModel.fromEntity(patient).toJson());
    await expectation;
  });
  test('invalid document emits a typed stream error', () async {
    await firestore.collection('users').doc('uid').set({'role': 'doctor'});
    await expectLater(
      repository.watchUser('uid'),
      emitsError(
        isA<UserException>().having(
          (e) => e.code,
          'code',
          UserErrorCode.invalidProfile,
        ),
      ),
    );
  });
  test('creates patient with a server timestamp', () async {
    final result = await repository.createPatient(patient);
    expect(result.data, same(patient));
    final document = (await firestore.collection('users').doc('uid').get())
        .data()!;
    expect(document['role'], 'patient');
    expect(document['fullName'], 'Elif Kaya');
    expect(document['email'], 'elif@example.com');
    expect(document['createdAt'], isA<Timestamp>());
    expect(document.containsKey('id'), isFalse);
  });
  test('write failure throws a provider-independent exception', () async {
    final db = MockFirestore();
    final collection = MockCollection();
    final document = MockDocument();
    when(() => db.collection('users')).thenReturn(collection);
    when(() => collection.doc('uid')).thenReturn(document);
    when(
      () => document.set(any()),
    ).thenThrow(FirebaseException(plugin: 'firestore'));
    await expectLater(
      FirestoreUserRepository(
        db,
        const UserModelFactory(),
      ).createPatient(patient),
      throwsA(
        isA<UserException>().having(
          (e) => e.code,
          'code',
          UserErrorCode.unavailable,
        ),
      ),
    );
  });
}
