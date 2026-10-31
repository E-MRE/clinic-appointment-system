import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_destination_navigation.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_location_destination.dart';
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

      expect(AdminDestination.staff.matches(AppRoutes.adminStaff), isTrue);
      expect(AdminDestination.staff.matches(AppRoutes.adminStaffNew), isTrue);
      expect(
        AdminDestination.staff.matches(AppRoutes.adminStaffEdit('ada')),
        isTrue,
      );
      expect(AdminDestination.staff.matches('/admin/staffing'), isFalse);
      expect('/admin/staff'.adminDestination, AdminDestination.staff);
      expect('/admin/staff/new'.adminDestination, AdminDestination.staff);
      expect('/admin/staff/ada/edit'.adminDestination, AdminDestination.staff);
      expect('/staff'.adminDestination, AdminDestination.overview);

      expect('/admin'.adminDestination, AdminDestination.overview);
      expect(
        '/admin/institution'.adminDestination,
        AdminDestination.institution,
      );
      expect(
        '/admin/institution/clinics/c/branches/b'.adminDestination,
        AdminDestination.institution,
      );
      expect('/admin/services'.adminDestination, AdminDestination.services);
      expect('/admin/services/new'.adminDestination, AdminDestination.services);
      expect('/admin/servicesx'.adminDestination, AdminDestination.overview);
    });
  });
}
