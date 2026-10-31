import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../support/widget_test_host.dart';

void main() {
  for (final width in [390.0, 800.0, 1200.0]) {
    testWidgets('footer visibility at width $width', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 900);
      bool signedOut = false;
      await tester.pumpWidget(
        widgetTestHost(
          AppNavigationShell(
            destinations: const [
              AppNavigationDestination(
                label: 'Home',
                icon: Icons.home,
                selectedIcon: Icons.home,
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            logo: Assets.images.auth.signInLogo,
            footer: AppNavigationUserCard(
              initials: 'AB',
              name: 'User',
              subtitle: 'Doctor',
              signOutTooltip: 'Sign out',
              onSignOut: () {
                signedOut = true;
              },
            ),
            child: const SizedBox(),
          ),
          size: Size(width, 900),
        ),
      );
      await tester.pumpAndSettle();
      if (width == 1200) {
        expect(find.text('User'), findsOneWidget);
        await tester.tap(find.byTooltip('Sign out'));
        expect(signedOut, isTrue);
      } else {
        expect(find.text('User'), findsNothing);
      }
    });
  }
}
