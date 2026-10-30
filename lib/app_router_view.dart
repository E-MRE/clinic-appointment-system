part of 'app.dart';

/// The router app themed by the current theme mode and screen size, with the
/// startup gate wrapped around every route.
final class _AppRouterView extends StatelessWidget {
  const _AppRouterView({required this.router, required this.onGoHome});

  final GoRouter router;
  final Future<void> Function() onGoHome;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: LocaleKeys.appName.tr(),
          theme: LightTheme(context.screenSize).themeData,
          darkTheme: DarkTheme(context.screenSize).themeData,
          themeMode: mode,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: router,
          builder: (context, child) {
            return AuthStartupGate(
              onGoHome: onGoHome,
              router: router,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
