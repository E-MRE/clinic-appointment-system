import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceEditorCubit', () {
    late MedicalServiceEditorCubit cubit;

    final sampleService = Examination(
      id: 's-edit',
      name: 'General Consultation',
      departmentId: 'dept-1',
      branchId: 'b-1',
      duration: ServiceDuration(20),
      fee: Money.kurus(100000),
    );

    setUp(() {
      cubit = MedicalServiceEditorCubit();
    });

    tearDown(() => cubit.close());

    test('initial state is create mode with revision 0', () {
      expect(cubit.state.service, isNull);
      expect(cubit.state.revision, 0);
      expect(cubit.state.isEditing, isFalse);
    });

    test('edit sets service and increments revision', () {
      cubit.edit(sampleService);

      expect(cubit.state.service, sampleService);
      expect(cubit.state.revision, 1);
      expect(cubit.state.isEditing, isTrue);
    });

    test('startCreate resets service to null and increments revision', () {
      cubit.edit(sampleService);
      expect(cubit.state.revision, 1);

      cubit.startCreate();
      expect(cubit.state.service, isNull);
      expect(cubit.state.revision, 2);
      expect(cubit.state.isEditing, isFalse);
    });

    test('reset delegates to startCreate', () {
      cubit.edit(sampleService);
      cubit.reset();

      expect(cubit.state.service, isNull);
      expect(cubit.state.revision, 2);
    });
  });
}
