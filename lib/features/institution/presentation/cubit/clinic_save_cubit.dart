import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_cubit.dart';

/// Creates and updates clinics for the institution screens.
final class ClinicSaveCubit extends InstitutionSaveCubit<Clinic> {
  /// Injects both clinic operations used by this request cubit.
  ClinicSaveCubit(this._createClinic, this._updateClinic);

  final CreateClinicUseCase _createClinic;
  final UpdateClinicUseCase _updateClinic;

  /// Creates a clinic with [name].
  Future<void> create(String name) {
    return executeRequest(() => _createClinic(ClinicDraft(name: name)));
  }

  /// Updates [clinic] with [name], preserving its identifier.
  Future<void> update(Clinic clinic, String name) {
    final updatedClinic = Clinic(id: clinic.id, name: name);
    return executeRequest(() => _updateClinic(updatedClinic));
  }
}
