import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../staff_management/data/doubles/mock_collection.dart';
import '../../../staff_management/data/doubles/mock_document.dart';
import '../../../staff_management/data/doubles/mock_firestore.dart';

void main() {
  test('watches a branch by id', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('branches').doc('b1').set({
      'clinicId': 'c1',
      'name': 'Central',
      'address': 'Main',
      'workingHours': {
        'monday': <dynamic>[],
        'tuesday': <dynamic>[],
        'wednesday': <dynamic>[],
        'thursday': <dynamic>[],
        'friday': <dynamic>[],
        'saturday': <dynamic>[],
        'sunday': <dynamic>[],
      },
    });
    final result = await FirestoreBranchRepository(
      firestore,
    ).watchBranch('b1').first;
    expect(result.data?.id, 'b1');
    expect(result.data?.name, 'Central');
  });
  test('missing branch emits invalidRecord', () async {
    await expectLater(
      FirestoreBranchRepository(FakeFirebaseFirestore()).watchBranch('missing'),
      emitsError(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.invalidRecord,
        ),
      ),
    );
  });
  test('provider stream error emits unavailable', () async {
    final firestore = MockFirestore();
    final collection = MockCollection();
    final document = MockDocument();
    when(() => firestore.collection('branches')).thenReturn(collection);
    when(() => collection.doc('b1')).thenReturn(document);
    when(() => document.snapshots()).thenAnswer(
      (_) => Stream.error(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
      ),
    );
    await expectLater(
      FirestoreBranchRepository(firestore).watchBranch('b1'),
      emitsError(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.unavailable,
        ),
      ),
    );
  });
}
