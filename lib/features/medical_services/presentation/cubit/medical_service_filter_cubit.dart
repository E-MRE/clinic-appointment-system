import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the active kind filter for medical service views.
final class MedicalServiceFilterCubit extends Cubit<MedicalServiceKindFilter> {
  /// Creates a filter cubit defaulting to [MedicalServiceKindFilter.all].
  MedicalServiceFilterCubit() : super(MedicalServiceKindFilter.all);

  /// Selects [filter] as the active kind filter.
  void select(MedicalServiceKindFilter filter) => emit(filter);
}
