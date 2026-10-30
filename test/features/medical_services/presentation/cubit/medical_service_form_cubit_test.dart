import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceFormCubit', () {
    late MedicalServiceFormCubit cubit;

    setUp(() {
      cubit = MedicalServiceFormCubit();
    });

    tearDown(() => cubit.close());

    test('initial state defaults to empty examination form', () {
      expect(cubit.state.kind, MedicalServiceKind.examination);
      expect(cubit.state.name, '');
      expect(cubit.state.departmentId, '');
      expect(cubit.state.durationText, '');
      expect(cubit.state.feeText, '');
      expect(cubit.state.modality, RadiologyModality.xRay);
      expect(cubit.state.preparationNote, '');
      expect(cubit.state.requiresFasting, isFalse);
      expect(cubit.state.fastingText, '');
      expect(cubit.state.resultTime, LabResultTime.oneDay);
    });

    test('updates each field through its dedicated setter', () {
      cubit.selectKind(MedicalServiceKind.radiology);
      expect(cubit.state.kind, MedicalServiceKind.radiology);

      cubit.changeName('Cardiac MRI');
      expect(cubit.state.name, 'Cardiac MRI');

      cubit.selectDepartment('dept-cardio');
      expect(cubit.state.departmentId, 'dept-cardio');

      cubit.changeDuration('45');
      expect(cubit.state.durationText, '45');

      cubit.changeFee('1500');
      expect(cubit.state.feeText, '1500');

      cubit.selectModality(RadiologyModality.mri);
      expect(cubit.state.modality, RadiologyModality.mri);

      cubit.changeNote('Fast for 4 hours');
      expect(cubit.state.preparationNote, 'Fast for 4 hours');

      cubit.toggleFasting(true);
      expect(cubit.state.requiresFasting, isTrue);

      cubit.changeFasting('8-12');
      expect(cubit.state.fastingText, '8-12');

      cubit.selectResultTime(LabResultTime.sameDay);
      expect(cubit.state.resultTime, LabResultTime.sameDay);
    });

    test('turning fasting off retains fastingText in state', () {
      cubit.toggleFasting(true);
      cubit.changeFasting('10-12');
      expect(cubit.state.requiresFasting, isTrue);
      expect(cubit.state.fastingText, '10-12');

      cubit.toggleFasting(false);
      expect(cubit.state.requiresFasting, isFalse);
      expect(cubit.state.fastingText, '10-12');
    });

    test('initialize replaces state with provided values', () {
      const customValues = MedicalServiceFormValues(
        kind: MedicalServiceKind.lab,
        name: 'Glucose Tolerance',
        departmentId: 'dept-lab',
        durationText: '120',
        feeText: '600',
        requiresFasting: true,
        fastingText: '8',
        resultTime: LabResultTime.twoDays,
      );

      cubit.initialize(customValues);
      expect(cubit.state, customValues);
    });
  });
}
