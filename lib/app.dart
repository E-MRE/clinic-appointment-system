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

part 'app_router_view.dart';

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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: authCubit),
      ],
      child: LocalizationWrapper(
        child: _AppRouterView(router: router, onGoHome: _retryFromHome),
      ),
    );
  }

  Future<void> _retryFromHome() async {
    router.go(AppRoutes.home);
    await authCubit.retry();
  }
}
