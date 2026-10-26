import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registration adds a name without changing raw credential input', () {
    const registration = AuthRegistration(
      fullName: ' Elif Kaya ',
      email: ' patient@example.com ',
      password: ' secret12 ',
    );
    const AuthCredentials credentials = registration;
    expect(registration.fullName, ' Elif Kaya ');
    expect(credentials.email, ' patient@example.com ');
    expect(credentials.password, ' secret12 ');
    expect(registration.toString(), isNot(contains('secret12')));
  });
}
