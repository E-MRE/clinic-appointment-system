import 'dart:async';

import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';

/// Observes every clinic through the domain watch use case.
final class ClinicListCubit
    extends InstitutionListCubit<Clinic, NoParams, WatchClinicsUseCase> {
  /// Starts observing clinics as soon as this screen-owned cubit is created.
  ClinicListCubit(super.watchUseCase) {
    unawaited(watch());
  }

  /// Starts a fresh observation of all clinics.
  Future<void> watch() {
    return watchWith(const NoParams());
  }
}
