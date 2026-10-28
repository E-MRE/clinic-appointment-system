import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/theme/light_theme.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mobile navigation shows selected state, badge and callbacks', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    int selected = -1;
    await _pumpNavigation(
      tester,
      ScreenSize.mobile,
      (index) => selected = index,
    );

    expect(_selected('Home'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    final bar = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.height == 80,
    );
    expect(bar, findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 64 && widget.height == 32,
      ),
      findsNWidgets(2),
    );
    await tester.tap(find.text('Schedule'));
    expect(selected, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet rail scrolls, matches dimensions and reports taps', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 900);
    int selected = -1;
    await _pumpNavigation(
      tester,
      ScreenSize.tablet,
      (index) => selected = index,
    );

    expect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.width == 88,
      ),
      findsOneWidget,
    );
    expect(find.byType(ListView), findsOneWidget);
    expect(_selected('Home'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 56 &&
            widget.constraints?.maxHeight == 32,
      ),
      findsNWidgets(2),
    );
    await tester.tap(find.text('Schedule'));
    expect(selected, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop sidebar has 264px width, primary action and callbacks', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 900);
    int selected = -1;
    bool actionPressed = false;
    await _pumpNavigation(
      tester,
      ScreenSize.desktop,
      (index) => selected = index,
      primaryAction: ElevatedButton(
        onPressed: () => actionPressed = true,
        child: const Text('Create appointment'),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxWidth == 264,
      ),
      findsOneWidget,
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    final destinationTap = find.byType(InkWell).last;
    expect(tester.getSize(destinationTap).height, greaterThanOrEqualTo(48));
    await tester.tap(find.text('Create appointment'));
    expect(actionPressed, isTrue);
    await tester.tap(find.text('Schedule'));
    expect(selected, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('all tiers fit dark theme at 2x text scale', (tester) async {
    for (final size in [
      (ScreenSize.mobile, const Size(390, 844)),
      (ScreenSize.tablet, const Size(800, 900)),
      (ScreenSize.desktop, const Size(1200, 900)),
    ]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size.$2;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: size.$2,
            textScaler: const TextScaler.linear(2),
          ),
          child: MaterialApp(
            theme: DarkTheme(size.$1).themeData,
            home: AppNavigationShell(
              destinations: _destinations,
              selectedIndex: 0,
              onDestinationSelected: (_) {},
              logo: Assets.images.auth.signInLogo,
              child: const Scaffold(body: Text('Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}

const _destinations = [
  AppNavigationDestination(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  AppNavigationDestination(
    label: 'Schedule',
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month,
    badgeCount: 3,
  ),
];

Finder _selected(String label) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.button == true &&
        widget.properties.selected == true &&
        widget.properties.label == label,
  );
}

Future<void> _pumpNavigation(
  WidgetTester tester,
  ScreenSize screenSize,
  ValueChanged<int> onSelected, {
  Widget? primaryAction,
}) async {
  final viewport = switch (screenSize) {
    ScreenSize.mobile => const Size(390, 844),
    ScreenSize.tablet => const Size(800, 900),
    ScreenSize.desktop => const Size(1200, 900),
  };
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: viewport),
      child: MaterialApp(
        theme: LightTheme(screenSize).themeData,
        home: AppNavigationShell(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: onSelected,
          logo: Assets.images.auth.signInLogo,
          primaryAction: primaryAction,
          child: const Scaffold(body: Text('Content')),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
