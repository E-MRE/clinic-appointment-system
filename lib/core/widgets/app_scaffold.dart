import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Standard page shell with safe insets and responsive content padding.
final class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: context.screenSize.select(
          mobile: const AppPadding.pageMobile(),
          tablet: const AppPadding.pageTablet(),
          desktop: const AppPadding.pageDesktop(),
        ),
        child: child,
      ),
    ),
  );
}
