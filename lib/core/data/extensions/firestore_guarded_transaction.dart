import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Runs transactions whose handlers may reject a change with an
/// [AppException].
///
/// On web the handler runs behind a JavaScript promise: an error thrown inside
/// it is wrapped in a JavaScript `Error` and reaches the caller without its
/// Dart type. The guard captures the [AppException] inside the handler, lets
/// the transaction finish without writes, and rethrows it afterwards with its
/// original stack trace on every platform.
extension FirestoreGuardedTransaction on FirebaseFirestore {
  /// Runs [handler] in a transaction and rethrows its [AppException] as is.
  Future<T> runGuardedTransaction<T>(TransactionHandler<T> handler) async {
    late T output;
    AppException? rejection;
    StackTrace rejectionTrace = StackTrace.empty;
    await runTransaction<void>((transaction) async {
      try {
        output = await handler(transaction);
      } on AppException catch (error, stackTrace) {
        rejection = error;
        rejectionTrace = stackTrace;
      }
    });
    final failure = rejection;
    if (failure != null) Error.throwWithStackTrace(failure, rejectionTrace);
    return output;
  }
}
