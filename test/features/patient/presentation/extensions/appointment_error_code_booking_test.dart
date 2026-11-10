import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/appointment_error_code_booking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('inPast clears the selected slot', () {
    expect(AppointmentErrorCode.inPast.clearsSlot, isTrue);
  });
}
