import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shared placeholder for the entry and role home pages.
final class HomePage extends StatelessWidget {
  /// Creates a placeholder with an optional translated title.
  const HomePage({this.title, super.key});

  /// Title displayed on the placeholder.
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: PageHeader(
        title: title ?? LocaleKeys.appName.tr(),
        actions: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return IconButton(
              key: const WidgetKey.themeToggleKey(),
              tooltip: LocaleKeys.common_themeToggle.tr(),
              onPressed: context.read<ThemeCubit>().toggle,
              icon: Icon(
                mode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            );
          },
        ),
      ),
    );
  }
}
