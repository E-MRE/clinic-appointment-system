import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminDestination', () {
    test('matches and fromLocation resolve expected destinations', () {
      expect(AdminDestination.overview.matches(AppRoutes.adminHome), isTrue);
      expect(AdminDestination.overview.matches(AppRoutes.institution), isFalse);
      expect(
        AdminDestination.overview.matches('${AppRoutes.adminHome}/other'),
        isFalse,
      );

      expect(
        AdminDestination.institution.matches(AppRoutes.institution),
        isTrue,
      );
      expect(
        AdminDestination.institution.matches(
          '${AppRoutes.institution}/clinics/c/branches/b',
        ),
        isTrue,
      );
      expect(AdminDestination.institution.matches(AppRoutes.services), isFalse);

      expect(AdminDestination.services.matches(AppRoutes.services), isTrue);
      expect(
        AdminDestination.services.matches('${AppRoutes.services}/new'),
        isTrue,
      );
      expect(
        AdminDestination.services.matches('${AppRoutes.services}x'),
        isFalse,
      );

      expect(
        AdminDestination.fromLocation('/admin'),
        AdminDestination.overview,
      );
      expect(
        AdminDestination.fromLocation('/admin/institution'),
        AdminDestination.institution,
      );
      expect(
        AdminDestination.fromLocation(
          '/admin/institution/clinics/c/branches/b',
        ),
        AdminDestination.institution,
      );
      expect(
        AdminDestination.fromLocation('/admin/services'),
        AdminDestination.services,
      );
      expect(
        AdminDestination.fromLocation('/admin/services/new'),
        AdminDestination.services,
      );
      expect(
        AdminDestination.fromLocation('/admin/servicesx'),
        AdminDestination.overview,
      );
    });
  });
}
