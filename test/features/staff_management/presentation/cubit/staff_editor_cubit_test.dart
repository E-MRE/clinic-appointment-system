import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  test(
    'staff editor accepts both roles through the shared record editor',
    () async {
      final cubit = StaffEditorCubit();
      addTearDown(cubit.close);
      const fixtures = StaffFixtures();
      final doctor = fixtures.doctor();
      final technician = fixtures.technician();
      cubit.edit(doctor);
      expect(cubit.state.record, doctor);
      cubit.edit(technician);
      expect(cubit.state.record, technician);
      cubit.reset();
      expect(cubit.state.isEditing, isFalse);
    },
  );
}
