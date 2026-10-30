import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_filter_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceFilterCubit', () {
    test('defaults to all and updates on select', () {
      final cubit = MedicalServiceFilterCubit();
      expect(cubit.state, MedicalServiceKindFilter.all);

      cubit.select(MedicalServiceKindFilter.radiology);
      expect(cubit.state, MedicalServiceKindFilter.radiology);

      cubit.select(MedicalServiceKindFilter.lab);
      expect(cubit.state, MedicalServiceKindFilter.lab);

      cubit.close();
    });
  });
}
