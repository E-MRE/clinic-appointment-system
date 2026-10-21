import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Dependencies are owned by the caller (the DI container in production).
final class App extends StatelessWidget {
  const App({
    required this.router,
    required this.themeCubit,
    required this.authCubit,
    super.key,
  });
  final GoRouter router;
  final ThemeCubit themeCubit;
  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: themeCubit),
      BlocProvider.value(value: authCubit),
    ],
    child: LocalizationWrapper(
      child: Builder(
        builder: (context) => BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) => MaterialApp.router(
            title: LocaleKeys.appName.tr(),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: router,
          ),
        ),
      ),
    ),
  );
}
