import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'department_section_state.dart';

/// Branch departments with inline create and row edit actions.
final class DepartmentSection extends StatefulWidget {
  const DepartmentSection({
    required this.branchId,
    required this.createSaveCubit,
    super.key,
  });
  final String branchId;
  final DepartmentSaveCubit Function() createSaveCubit;

  @override
  State<DepartmentSection> createState() => _DepartmentSectionState();
}
