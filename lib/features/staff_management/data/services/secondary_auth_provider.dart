import 'package:firebase_auth/firebase_auth.dart';

/// Provides authentication bound to an app other than the default app.
/// Implementations must isolate sessions from the signed-in administrator.
abstract interface class SecondaryAuthProvider {
  /// Returns auth for a secondary app whose sessions never affect the admin.
  Future<FirebaseAuth> auth();
}
