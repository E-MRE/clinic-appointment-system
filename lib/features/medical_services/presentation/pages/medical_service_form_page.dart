import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/medical_service_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'medical_service_form_create_view.dart';
part 'medical_service_form_edit_body.dart';
part 'medical_service_form_edit_resolver.dart';
part 'medical_service_form_loading_view.dart';
part 'medical_service_form_not_found_view.dart';

/// Form page for creating or editing a medical service on mobile.
final class MedicalServiceFormPage extends StatelessWidget {
  /// Creates the medical service editor page.
  const MedicalServiceFormPage({this.serviceId, super.key});

  /// The identifier of the service being edited, or null for creation.
  final String? serviceId;

  @override
  Widget build(BuildContext context) {
    final id = serviceId;
    if (id == null) {
      return const _MedicalServiceFormCreateView();
    }
    return _MedicalServiceFormEditResolver(serviceId: id);
  }
}
