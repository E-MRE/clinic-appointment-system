import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.appName.tr()),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              key: const Key('theme_toggle'),
              tooltip: LocaleKeys.common_themeToggle.tr(),
              onPressed: context.read<ThemeCubit>().toggle,
              icon: Icon(
                mode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
