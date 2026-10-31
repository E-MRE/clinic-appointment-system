import 'package:clinic_appointment_system/features/staff_management/data/services/secondary_auth_provider.dart';
import 'package:clinic_appointment_system/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Reuses one named Firebase app to isolate staff provisioning sessions.
final class FirebaseSecondaryAuthProvider implements SecondaryAuthProvider {
  /// Creates a provider that initializes its secondary app on first use.
  FirebaseSecondaryAuthProvider();

  /// Firebase app name reserved for isolated staff account creation.
  static const String _appName = 'staff-provisioning';

  Future<FirebaseAuth>? _authFuture;

  /// Returns the cached secondary auth, sharing initialization across callers.
  @override
  Future<FirebaseAuth> auth() => _authFuture ??= _initializeAuth();

  Future<FirebaseAuth> _initializeAuth() async {
    for (final FirebaseApp app in Firebase.apps) {
      if (app.name == _appName) {
        return FirebaseAuth.instanceFor(app: app);
      }
    }
    final FirebaseApp app = await Firebase.initializeApp(
      name: _appName,
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseAuth.instanceFor(app: app);
  }
}
