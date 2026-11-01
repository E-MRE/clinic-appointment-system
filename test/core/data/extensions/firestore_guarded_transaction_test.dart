import 'package:clinic_appointment_system/core/data/extensions/firestore_guarded_transaction.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../features/staff_management/data/doubles/mock_firestore.dart';

class _MockTransaction extends Mock implements Transaction {}

/// Mimics the web plugin: errors thrown by the handler lose their Dart type.
Future<void> _webLikeTransaction(Invocation invocation) async {
  final handler = invocation.positionalArguments.first as TransactionHandler;
  try {
    await handler(_MockTransaction());
  } catch (error) {
    throw StateError('Dart exception: $error');
  }
}

void main() {
  late MockFirestore firestore;
  setUp(() {
    firestore = MockFirestore();
    when(
      () => firestore.runTransaction<void>(any()),
    ).thenAnswer(_webLikeTransaction);
  });
  test('returns the handler output', () async {
    final output = await firestore.runGuardedTransaction((_) async => 42);
    expect(output, 42);
  });
  test('rethrows handler rejections with their type and stack', () async {
    try {
      await firestore.runGuardedTransaction<int>((_) async {
        Error.throwWithStackTrace(
          const AvailabilityException(AvailabilityErrorCode.outsideBranchHours),
          StackTrace.fromString('rule-stack'),
        );
      });
      fail('Expected an availability failure');
    } on AvailabilityException catch (error, trace) {
      expect(error.code, AvailabilityErrorCode.outsideBranchHours);
      expect(trace.toString(), contains('rule-stack'));
    }
  });
  test('propagates platform failures unchanged', () async {
    when(() => firestore.runTransaction<void>(any())).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );
    await expectLater(
      firestore.runGuardedTransaction((_) async => 1),
      throwsA(isA<FirebaseException>()),
    );
  });
}
