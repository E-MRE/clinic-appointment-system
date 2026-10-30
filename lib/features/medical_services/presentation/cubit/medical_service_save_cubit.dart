import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';

/// Creates and updates medical services for the administrator screens.
final class MedicalServiceSaveCubit
    extends InstitutionSaveCubit<MedicalService> {
  /// Injects both medical service persistence operations used by this save cubit.
  MedicalServiceSaveCubit(this._createService, this._updateService);

  final CreateMedicalServiceUseCase _createService;
  final UpdateMedicalServiceUseCase _updateService;

  /// Creates [service] using the create use case.
  Future<void> create(MedicalService service) =>
      executeRequest(() => _createService.call(service));

  /// Updates [service] using the update use case.
  Future<void> update(MedicalService service) =>
      executeRequest(() => _updateService.call(service));
}
