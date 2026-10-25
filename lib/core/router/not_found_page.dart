import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSizes.lg,
        children: [
          Text(
            LocaleKeys.navigation_notFound.tr(),
            style: context.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(LocaleKeys.navigation_goHome.tr()),
          ),
        ],
      ),
    ),
  );
}
