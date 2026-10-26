import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_startup_gate.dart';
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
            debugShowCheckedModeBanner: false,
            title: LocaleKeys.appName.tr(),
            theme: LightTheme(context.screenSize).themeData,
            darkTheme: DarkTheme(context.screenSize).themeData,
            themeMode: mode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: router,
            builder: (context, child) => AuthStartupGate(
              onGoHome: _retryFromHome,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _retryFromHome() async {
    router.go(AppRoutes.home);
    await authCubit.retry();
  }
}
