import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  // Minimal holder; replaced by DI + Cubit in issue #5.
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  void _toggle() {
    _themeMode.value = _themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationWrapper(
      child: Builder(
        builder: (context) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: _themeMode,
            builder: (context, mode, _) {
              return MaterialApp(
                title: LocaleKeys.appName.tr(),
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: mode,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.appName.tr()),
                        IconButton(
                          key: const Key('theme_toggle'),
                          tooltip: LocaleKeys.common_themeToggle.tr(),
                          onPressed: _toggle,
                          icon: Icon(
                            mode == ThemeMode.light
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
