import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/mixins/medical_service_input_validation_mixin.dart';

final class MedicalServiceValidationProbe
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {}
