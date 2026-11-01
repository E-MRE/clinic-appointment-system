import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/features/availability/data/repositories/firestore_staff_availability_repository.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../staff_management/data/doubles/mock_collection.dart';
import '../../../staff_management/data/doubles/mock_document.dart';
import '../../../staff_management/data/doubles/mock_firestore.dart';

Map<String, dynamic> week() => {
  'monday': <dynamic>[],
  'tuesday': <dynamic>[],
  'wednesday': <dynamic>[],
  'thursday': <dynamic>[],
  'friday': <dynamic>[],
  'saturday': <dynamic>[],
  'sunday': <dynamic>[],
};
Matcher availabilityError(AvailabilityErrorCode code) =>
    isA<AvailabilityException>().having((error) => error.code, 'code', code);

void main() {
  const subject = AvailabilitySubject(staffId: 'doctor', branchId: 'branch-1');
  final window = WeeklyWindow(
    weekday: Weekday.monday,
    range: const TimeRangeConverter().fromJson({
      'start': '09:00',
      'end': '12:00',
    }),
  );
  late FakeFirebaseFirestore firestore;
  late FirestoreStaffAvailabilityRepository repository;
  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirestoreStaffAvailabilityRepository(firestore);
  });
  test('missing watch emits an empty schedule', () async {
    final result = await repository.watch(subject).first;
    expect(result.data?.staffId, 'doctor');
    expect(result.data?.branchId, 'branch-1');
    expect(result.data?.weekly, isEmpty);
    expect(result.data?.oneOff, isEmpty);
  });
  test('watch sorts stored windows and re-emits later writes', () async {
    final ref = firestore.collection('staffAvailability').doc('doctor');
    await ref.set({
      'branchId': 'old-branch',
      'weekly': {
        ...week(),
        'monday': [
          {'start': '13:00', 'end': '14:00'},
          {'start': '09:00', 'end': '12:00'},
        ],
      },
      'oneOff': <dynamic>[],
    });
    final expectation = expectLater(
      repository
          .watch(subject)
          .map(
            (result) => result.data?.weekly
                .map((entry) => entry.range.start.toString())
                .toList(),
          ),
      emitsInOrder([
        ['09:00', '13:00'],
        ['09:00'],
      ]),
    );
    await Future<void>.delayed(Duration.zero);
    await ref.set({
      'branchId': 'branch-1',
      'weekly': {
        ...week(),
        'monday': [
          {'start': '09:00', 'end': '12:00'},
        ],
      },
      'oneOff': <dynamic>[],
    });
    await expectation;
  });
  test(
    'update creates exact stored map and applies change to current value',
    () async {
      final first = await repository.update(
        subject,
        (current) => current.adding(window),
      );
      expect(first.data?.weekly, [window]);
      final ref = firestore.collection('staffAvailability').doc('doctor');
      expect((await ref.get()).data(), {
        'branchId': 'branch-1',
        'weekly': {
          ...week(),
          'monday': [
            {'start': '09:00', 'end': '12:00'},
          ],
        },
        'oneOff': <dynamic>[],
        'updatedAt': isA<Timestamp>(),
      });
      final second = await repository.update(
        subject,
        (current) => current.removing(window),
      );
      expect(second.data?.weekly, isEmpty);
      expect((await ref.get()).data()?['weekly'], week());
    },
  );
  test('change exception propagates unchanged without writing', () async {
    await repository.update(subject, (current) => current.adding(window));
    final ref = firestore.collection('staffAvailability').doc('doctor');
    final before = (await ref.get()).data();
    const error = AvailabilityException(
      AvailabilityErrorCode.overlappingWindow,
    );
    await expectLater(
      repository.update(subject, (current) => throw error),
      throwsA(same(error)),
    );
    expect((await ref.get()).data(), before);
  });
  test('corrupt document reports invalidRecord on watch and update', () async {
    await firestore.collection('staffAvailability').doc('doctor').set({
      'branchId': 'branch-1',
      'weekly': <String, dynamic>{},
      'oneOff': <dynamic>[],
    });
    await expectLater(
      repository.watch(subject),
      emitsError(availabilityError(AvailabilityErrorCode.invalidRecord)),
    );
    await expectLater(
      repository.update(subject, (current) => current),
      throwsA(availabilityError(AvailabilityErrorCode.invalidRecord)),
    );
  });
  test('maps Firebase watch errors with their stack', () async {
    final db = MockFirestore();
    final collection = MockCollection();
    final document = MockDocument();
    when(() => db.collection('staffAvailability')).thenReturn(collection);
    when(() => collection.doc('doctor')).thenReturn(document);
    when(() => document.snapshots()).thenAnswer(
      (_) => Stream.error(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
        StackTrace.fromString('watch-stack'),
      ),
    );
    try {
      await FirestoreStaffAvailabilityRepository(db).watch(subject).first;
      fail('Expected an availability failure');
    } on AvailabilityException catch (error, trace) {
      expect(error.code, AvailabilityErrorCode.unavailable);
      expect(trace.toString(), contains('watch-stack'));
    }
  });
  test('maps Firebase transaction errors', () async {
    final db = MockFirestore();
    final collection = MockCollection();
    final document = MockDocument();
    when(() => db.collection('staffAvailability')).thenReturn(collection);
    when(() => collection.doc('doctor')).thenReturn(document);
    when(
      () => db.runTransaction<void>(any()),
    ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));
    await expectLater(
      FirestoreStaffAvailabilityRepository(
        db,
      ).update(subject, (current) => current),
      throwsA(availabilityError(AvailabilityErrorCode.unavailable)),
    );
  });
}
