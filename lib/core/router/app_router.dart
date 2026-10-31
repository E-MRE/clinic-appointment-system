import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/router/fade_transition_page.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:clinic_appointment_system/core/router/not_found_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/pages/admin_home_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_route_scope.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_location_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/password_reset_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_up_page.dart';
import 'package:clinic_appointment_system/features/debug/presentation/pages/component_preview/component_preview_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_detail_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_form_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_route_guard.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_service_form_page.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_services_page.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_services_route_scope.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_home_page.dart';
import 'package:clinic_appointment_system/features/staff/presentation/pages/staff_home_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_form_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_management_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_management_route_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Defines application routes; pages resolve their own Cubits through DI.
/// Auth screens share one shell; registration and reset stack on sign-in.
GoRouter createAppRouter({
  String? initialLocation,
  bool enableDebugRoutes = kDebugMode,
  AuthRouteGuard? authGuard,
  GoRouterRedirect? redirect,
  Listenable? refreshListenable,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: redirect ?? authGuard?.redirect,
    refreshListenable: refreshListenable ?? authGuard,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      if (kDebugMode && enableDebugRoutes)
        GoRoute(
          path: AppRoutes.componentPreview,
          pageBuilder: (_, state) =>
              _fadePage(state, const ComponentPreviewPage()),
        ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, state) => _fadePage(state, const HomePage()),
      ),
      GoRoute(
        path: AppRoutes.patientHome,
        pageBuilder: (_, state) => _fadePage(state, const PatientHomePage()),
      ),
      GoRoute(
        path: AppRoutes.staffHome,
        pageBuilder: (_, state) => _fadePage(state, const StaffHomePage()),
      ),
      ShellRoute(
        pageBuilder: (_, state, child) => _fadePage(
          state,
          AdminRouteScope(
            routeClinicId: state.pathParameters['clinicId'],
            child: AdminShell(child: child),
          ),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.adminHome,
            pageBuilder: (_, state) => _fadePage(state, const AdminHomePage()),
          ),
          ShellRoute(
            builder: (_, state, child) => InstitutionRouteGuard(
              routeClinicId: state.pathParameters['clinicId'],
              child: child,
            ),
            routes: [
              GoRoute(
                path: AppRoutes.institution,
                pageBuilder: (_, state) =>
                    _fadePage(state, const InstitutionPage()),
                routes: [
                  GoRoute(
                    path: AppRoutes.branchNewSegment,
                    pageBuilder: (_, state) =>
                        _fadePage(state, const BranchFormPage()),
                  ),
                  GoRoute(
                    path: AppRoutes.branchDetailSegment,
                    pageBuilder: (_, state) => _fadePage(
                      state,
                      BranchDetailPage(
                        branchId: state.pathParameters['branchId'] ?? '',
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: AppRoutes.branchEditSegment,
                        pageBuilder: (_, state) => _fadePage(
                          state,
                          BranchFormPage(
                            branchId: state.pathParameters['branchId'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            builder: (_, state, child) =>
                MedicalServicesRouteScope(child: child),
            routes: [
              GoRoute(
                path: AppRoutes.services,
                pageBuilder: (_, state) =>
                    _fadePage(state, const MedicalServicesPage()),
                routes: [
                  GoRoute(
                    path: AppRoutes.serviceNewSegment,
                    pageBuilder: (_, state) =>
                        _fadePage(state, const MedicalServiceFormPage()),
                  ),
                  GoRoute(
                    path: AppRoutes.serviceEditSegment,
                    pageBuilder: (_, state) => _fadePage(
                      state,
                      MedicalServiceFormPage(
                        serviceId: state.pathParameters['serviceId'],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            builder: (_, state, child) =>
                StaffManagementRouteScope(child: child),
            routes: [
              GoRoute(
                path: AppRoutes.adminStaff,
                pageBuilder: (_, state) =>
                    _fadePage(state, const StaffManagementPage()),
                routes: [
                  GoRoute(
                    path: AppRoutes.adminStaffNewSegment,
                    pageBuilder: (_, state) =>
                        _fadePage(state, const StaffFormPage()),
                  ),
                  GoRoute(
                    path: AppRoutes.adminStaffEditSegment,
                    pageBuilder: (_, state) => _fadePage(
                      state,
                      StaffFormPage(staffId: state.pathParameters['staffId']),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        pageBuilder: (_, state, child) {
          return _fadePage(
            state,
            AuthShell(kind: state.uri.path.authFormKind, child: child),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.signIn,
            pageBuilder: (_, state) {
              return _fadePage(state, const SignInPage());
            },
            routes: [
              GoRoute(
                path: AppRoutes.signUpSegment,
                pageBuilder: (_, state) {
                  return _fadePage(state, const SignUpPage());
                },
              ),
              GoRoute(
                path: AppRoutes.passwordResetSegment,
                pageBuilder: (_, state) {
                  return _fadePage(state, const PasswordResetPage());
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Keys the page by its route so stack changes animate in both directions.
Page<void> _fadePage(GoRouterState state, Widget child) {
  return FadeTransitionPage<void>(key: state.pageKey, child: child);
}
