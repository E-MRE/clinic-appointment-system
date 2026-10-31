import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Loading indicator scaffold while staff profiles are being fetched.
final class StaffFormLoadingView extends StatelessWidget {
  const StaffFormLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: LoadingState(
        variant: LoadingStateVariant.centeredIndicator,
        label: LocaleKeys.staff_loading.tr(),
      ),
    );
  }
}
