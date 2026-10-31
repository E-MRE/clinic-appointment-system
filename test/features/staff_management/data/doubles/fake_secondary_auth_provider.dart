import 'package:clinic_appointment_system/features/staff_management/data/services/secondary_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class FakeSecondaryAuthProvider implements SecondaryAuthProvider {
  FakeSecondaryAuthProvider(this.secondaryAuth);

  final FirebaseAuth secondaryAuth;
  Object? error;
  int calls = 0;

  @override
  Future<FirebaseAuth> auth() async {
    calls++;
    final Object? failure = error;
    if (failure != null) {
      throw failure;
    }
    return secondaryAuth;
  }
}
