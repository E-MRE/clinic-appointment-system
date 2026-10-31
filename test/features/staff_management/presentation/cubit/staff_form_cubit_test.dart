import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/fixed_temporary_password_generator.dart';
import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  const generatedPassword = 'Fixed-temporary-7';
  late StaffFormCubit cubit;

  setUp(() {
    cubit = StaffFormCubit(
      const FixedTemporaryPasswordGenerator(generatedPassword),
    );
  });
  tearDown(() => cubit.close());

  test(
    'starts empty and startCreate clears edits with a generated password',
    () {
      expect(cubit.state, const StaffFormValues.empty());
      cubit.startEdit(fixtures.doctor(serviceIds: ['exam']));
      cubit.startCreate();
      expect(cubit.state, const StaffFormValues(password: generatedPassword));
      cubit.changePassword('manual');
      cubit.startCreate();
      expect(cubit.state.password, generatedPassword);
    },
  );

  test('regenerate uses injected generator and preserves other fields', () {
    cubit.changeFullName('Draft name');
    cubit.changePassword('manual');
    cubit.regeneratePassword();
    expect(cubit.state.password, generatedPassword);
    expect(cubit.state.fullName, 'Draft name');
    cubit.changePassword('second manual password');
    cubit.regeneratePassword();
    expect(cubit.state.password, generatedPassword);
  });

  test(
    'startEdit fills doctor specialty and resets technician specialty/password',
    () {
      final doctor = fixtures.doctor(serviceIds: ['exam']);
      cubit.startEdit(doctor);
      expect(cubit.state, StaffFormValues.fromStaff(doctor));
      expect(cubit.state.specialty, doctor.specialty);
      expect(cubit.state.password, isEmpty);
      cubit.changePassword('manual');
      final technician = fixtures.technician(serviceIds: ['lab']);
      cubit.startEdit(technician);
      expect(cubit.state, StaffFormValues.fromStaff(technician));
      expect(cubit.state.role, UserRole.technician);
      expect(cubit.state.specialty, isEmpty);
      expect(cubit.state.password, isEmpty);
    },
  );

  test('updates raw text without validation or trimming', () {
    cubit.changeFullName('  Draft  ');
    cubit.changeSpecialty('  Specialty  ');
    cubit.changeEmail('invalid email');
    cubit.changePassword(' short ');
    expect(
      cubit.state,
      const StaffFormValues(
        fullName: '  Draft  ',
        specialty: '  Specialty  ',
        email: 'invalid email',
        password: ' short ',
      ),
    );
  });

  test(
    'branch change clears department and services, same branch preserves them',
    () {
      cubit.startEdit(fixtures.doctor(serviceIds: ['exam']));
      final original = cubit.state;
      cubit.selectBranch(original.branchId);
      expect(cubit.state, original);
      cubit.selectBranch('new-branch');
      expect(
        cubit.state,
        original.copyWith(
          branchId: 'new-branch',
          departmentId: '',
          serviceIds: [],
        ),
      );
    },
  );

  test('department change clears services, same department preserves them', () {
    cubit.startEdit(fixtures.doctor(serviceIds: ['exam']));
    final original = cubit.state;
    cubit.selectDepartment(original.departmentId);
    expect(cubit.state, original);
    cubit.selectDepartment('new-department');
    expect(
      cubit.state,
      original.copyWith(departmentId: 'new-department', serviceIds: []),
    );
  });

  test('role change clears services, same role preserves them', () {
    cubit.startEdit(fixtures.doctor(serviceIds: ['exam']));
    final original = cubit.state;
    cubit.selectRole(original.role);
    expect(cubit.state, original);
    cubit.selectRole(UserRole.technician);
    expect(
      cubit.state,
      original.copyWith(role: UserRole.technician, serviceIds: []),
    );
  });

  test('toggle adds, removes and re-adds services in selection order', () {
    cubit.toggleService('first');
    final previous = cubit.state;
    cubit.toggleService('second');
    expect(cubit.state.serviceIds, ['first', 'second']);
    expect(previous.serviceIds, ['first']);
    cubit.toggleService('first');
    expect(cubit.state.serviceIds, ['second']);
    cubit.toggleService('first');
    expect(cubit.state.serviceIds, ['second', 'first']);
    cubit.toggleService('second');
    cubit.toggleService('first');
    expect(cubit.state.serviceIds, isEmpty);
  });
}
