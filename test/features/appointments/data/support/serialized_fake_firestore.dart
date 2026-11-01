import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'buffered_fake_transaction.dart';

/// Test-only transaction scheduling around fake_cloud_firestore 4.4.0.
/// Its built-in runTransaction neither serializes nor retries handlers, ignores
/// set options, and does not await writes. This harness serializes and buffers
/// writes through the package's batch API; it does not simulate SDK retries.
final class SerializedFakeFirestore extends FakeFirebaseFirestore {
  Future<void> _tail = Future.value();
  final List<String> transactionReads = [];

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    transactionReads.clear();
    try {
      final batch = this.batch();
      final output = await transactionHandler(
        BufferedFakeTransaction(batch, transactionReads),
      );
      await batch.commit();
      return output;
    } finally {
      done.complete();
    }
  }
}
