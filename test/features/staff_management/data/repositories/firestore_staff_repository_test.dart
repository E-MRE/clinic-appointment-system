import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/staff_management/data/models/staff_model_factory.dart';
import 'package:clinic_appointment_system/features/staff_management/data/repositories/firestore_staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/doubles/staff_fixtures.dart';
import '../doubles/mock_collection.dart';
import '../doubles/mock_document.dart';
import '../doubles/mock_firestore.dart';

void main() {
  const StaffFixtures fixtures = StaffFixtures();
  late FakeFirebaseFirestore firestore;
  late FirestoreStaffRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirestoreStaffRepository(firestore, const StaffModelFactory());
  });

  test(
    'creates a doctor at its auth uid with only stored fields and server time',
    () async {
      final Doctor doctor = fixtures.doctor(id: 'doctor', serviceIds: ['exam']);
      final DataResult<Staff> result = await repository.createStaff(doctor);
      expect(result.isSuccess, isTrue);
      expect(result.data, same(doctor));
      expect((await firestore.collection('users').doc('doctor').get()).data(), {
        'role': 'doctor',
        'fullName': 'Ada Kaya',
        'email': 'ada@example.com',
        'branchId': 'branch',
        'departmentId': 'department',
        'specialty': 'Cardiology',
        'serviceIds': ['exam'],
        'createdAt': isA<Timestamp>(),
      });
    },
  );
  test(
    'update saves only doctor editable fields and preserves locked fields',
    () async {
      final Timestamp createdAt = Timestamp.fromMillisecondsSinceEpoch(1234);
      await firestore.collection('users').doc('doctor').set({
        'role': 'doctor',
        'fullName': 'Original',
        'email': 'original@example.com',
        'branchId': 'original-branch',
        'departmentId': 'original-department',
        'specialty': 'Original specialty',
        'serviceIds': ['old'],
        'createdAt': createdAt,
      });
      final Doctor changed = fixtures.doctor(
        id: 'doctor',
        fullName: 'Changed',
        email: 'changed@example.com',
        branchId: 'changed-branch',
        departmentId: 'changed-department',
        specialty: 'Neurology',
        serviceIds: ['new'],
      );
      expect((await repository.updateStaff(changed)).data, same(changed));
      expect((await firestore.collection('users').doc('doctor').get()).data(), {
        'role': 'doctor',
        'fullName': 'Changed',
        'email': 'original@example.com',
        'branchId': 'original-branch',
        'departmentId': 'original-department',
        'specialty': 'Neurology',
        'serviceIds': ['new'],
        'createdAt': createdAt,
      });
    },
  );
  test(
    'watches only doctors and technicians across branches sorted by full name',
    () async {
      for (final (String id, String role, String name, String branch) in [
        ('doctor', 'doctor', 'Zeynep', 'b1'),
        ('tech', 'technician', 'Ada', 'b2'),
        ('patient', 'patient', 'A Patient', 'b1'),
        ('admin', 'admin', 'A Admin', 'b2'),
      ]) {
        await firestore.collection('users').doc(id).set({
          'role': role,
          'fullName': name,
          'email': 'a@example.com',
          'branchId': branch,
          'departmentId': 'd',
        });
      }
      final DataResult<List<Staff>> result = await repository
          .watchStaff()
          .first;
      expect(result.isSuccess, isTrue);
      expect(result.data?.map((Staff staff) => staff.id), ['tech', 'doctor']);
      expect(result.data?.map((Staff staff) => staff.fullName), [
        'Ada',
        'Zeynep',
      ]);
    },
  );

  test(
    'malformed staff emits invalidProfile instead of a partial list',
    () async {
      await firestore.collection('users').doc('bad').set({'role': 'doctor'});
      await expectLater(
        repository.watchStaff(),
        emitsError(
          isA<UserException>().having(
            (UserException error) => error.code,
            'code',
            UserErrorCode.invalidProfile,
          ),
        ),
      );
    },
  );
  test('refuses an empty auth uid before writing', () async {
    final MockFirestore db = MockFirestore();
    final FirestoreStaffRepository guarded = FirestoreStaffRepository(
      db,
      const StaffModelFactory(),
    );
    await expectLater(
      guarded.createStaff(fixtures.doctor()),
      throwsA(
        isA<UserException>().having(
          (UserException error) => error.code,
          'code',
          UserErrorCode.invalidProfile,
        ),
      ),
    );
    verifyZeroInteractions(db);
  });

  test(
    'technician create omits specialty and update preserves locked fields',
    () async {
      final Staff initial = fixtures.technician(
        id: 'tech',
        serviceIds: ['old'],
      );
      expect((await repository.createStaff(initial)).data, same(initial));
      final Map<String, dynamic>? original =
          (await firestore.collection('users').doc('tech').get()).data();
      expect(original, {
        'role': 'technician',
        'fullName': 'Ece Kaya',
        'email': 'ece@example.com',
        'branchId': 'branch',
        'departmentId': 'department',
        'serviceIds': ['old'],
        'createdAt': isA<Timestamp>(),
      });
      final Staff changed = fixtures.technician(
        id: 'tech',
        fullName: 'Changed',
        email: 'other@example.com',
        branchId: 'other',
        departmentId: 'other',
        serviceIds: ['new'],
      );
      expect((await repository.updateStaff(changed)).data, same(changed));
      expect((await firestore.collection('users').doc('tech').get()).data(), {
        ...?original,
        'fullName': 'Changed',
        'serviceIds': ['new'],
      });
    },
  );

  for (final bool updating in [false, true]) {
    test('maps Firebase write failure, updating=$updating', () async {
      final MockFirestore db = MockFirestore();
      final MockCollection collection = MockCollection();
      final MockDocument document = MockDocument();
      when(() => db.collection('users')).thenReturn(collection);
      when(() => collection.doc('uid')).thenReturn(document);
      final FirebaseException error = FirebaseException(
        plugin: 'firestore',
        code: 'permission-denied',
      );
      when(() => document.set(any())).thenThrow(error);
      when(() => document.update(any())).thenThrow(error);
      final FirestoreStaffRepository failing = FirestoreStaffRepository(
        db,
        const StaffModelFactory(),
      );
      final Staff staff = fixtures.doctor(id: 'uid');
      late Future<DataResult<Staff>> operation;
      if (updating) {
        operation = failing.updateStaff(staff);
      } else {
        operation = failing.createStaff(staff);
      }
      await expectLater(
        operation,
        throwsA(
          isA<UserException>().having(
            (UserException error) => error.code,
            'code',
            UserErrorCode.unavailable,
          ),
        ),
      );
    });
  }

  test('maps Firebase snapshot errors and retains their stack trace', () async {
    final MockFirestore db = MockFirestore();
    final MockCollection collection = MockCollection();
    when(() => db.collection('users')).thenReturn(collection);
    when(
      () => collection.where('role', whereIn: ['doctor', 'technician']),
    ).thenReturn(collection);
    when(() => collection.snapshots()).thenAnswer(
      (_) => Stream.error(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
        StackTrace.fromString('snapshot-stack'),
      ),
    );
    final FirestoreStaffRepository failing = FirestoreStaffRepository(
      db,
      const StaffModelFactory(),
    );
    try {
      await failing.watchStaff().first;
      fail('Expected UserException');
    } on UserException catch (error, stackTrace) {
      expect(error.code, UserErrorCode.unavailable);
      expect(stackTrace.toString(), contains('snapshot-stack'));
    }
  });
  test(
    'an incoming different staff role cannot overwrite the stored role or specialty',
    () async {
      await repository.createStaff(
        fixtures.doctor(id: 'uid', specialty: 'Cardiology'),
      );
      await repository.updateStaff(
        fixtures.technician(
          id: 'uid',
          fullName: 'Updated',
          serviceIds: ['lab'],
        ),
      );
      final Map<String, dynamic>? stored =
          (await firestore.collection('users').doc('uid').get()).data();
      expect(stored?['role'], 'doctor');
      expect(stored?['specialty'], 'Cardiology');
      expect(stored?['fullName'], 'Updated');
      expect(stored?['serviceIds'], ['lab']);
    },
  );
  test(
    'synchronous Firebase watch setup failure is a typed stream error',
    () async {
      final MockFirestore db = MockFirestore();
      when(
        () => db.collection('users'),
      ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));
      final FirestoreStaffRepository failing = FirestoreStaffRepository(
        db,
        const StaffModelFactory(),
      );
      await expectLater(
        failing.watchStaff(),
        emitsError(
          isA<UserException>().having(
            (UserException error) => error.code,
            'code',
            UserErrorCode.unavailable,
          ),
        ),
      );
    },
  );
}
