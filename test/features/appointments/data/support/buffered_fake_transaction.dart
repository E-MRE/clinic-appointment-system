import 'package:cloud_firestore/cloud_firestore.dart';

/// Buffers fake writes until the handler completes and preserves set options.
/// The package's built-in transaction drops options and launches unawaited writes.
final class BufferedFakeTransaction implements Transaction {
  BufferedFakeTransaction(this._batch, this._reads);

  final WriteBatch _batch;
  final List<String> _reads;
  bool _hasWrites = false;

  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
    DocumentReference<T> documentReference,
  ) {
    if (_hasWrites) throw StateError('Transaction reads must precede writes.');
    _reads.add(documentReference.path);
    return documentReference.get();
  }

  @override
  Transaction set<T>(
    DocumentReference<T> documentReference,
    T data, [
    SetOptions? options,
  ]) {
    _hasWrites = true;
    _batch.set(documentReference, data, options);
    return this;
  }

  @override
  Transaction update(
    DocumentReference<Object?> documentReference,
    Map<Object, Object?> data,
  ) {
    _hasWrites = true;
    _batch.update(documentReference, data);
    return this;
  }

  @override
  Transaction delete(DocumentReference<Object?> documentReference) {
    _hasWrites = true;
    _batch.delete(documentReference);
    return this;
  }
}
