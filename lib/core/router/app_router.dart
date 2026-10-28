import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/router/fade_transition_page.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:clinic_appointment_system/core/router/not_found_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/pages/admin_home_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/password_reset_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_up_page.dart';
import 'package:clinic_appointment_system/features/debug/presentation/pages/component_preview/component_preview_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_detail_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_form_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_route_scope.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_home_page.dart';
import 'package:clinic_appointment_system/features/staff/presentation/pages/staff_home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Defines application routes using page-owned Cubit factories supplied by DI.
/// Auth screens share one shell; registration and reset stack on sign-in.
GoRouter createAppRouter({
  String? initialLocation,
  bool enableDebugRoutes = kDebugMode,
  AuthRouteGuard? authGuard,
  SignInCubit Function()? signInCubitFactory,
  SignUpCubit Function()? signUpCubitFactory,
  PasswordResetCubit Function()? passwordResetCubitFactory,
  ClinicListCubit Function()? clinicListCubitFactory,
  BranchListCubit Function()? branchListCubitFactory,
  DepartmentListCubit Function()? departmentListCubitFactory,
  ClinicSaveCubit Function()? clinicSaveCubitFactory,
  BranchSaveCubit Function()? branchSaveCubitFactory,
  DepartmentSaveCubit Function()? departmentSaveCubitFactory,
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
        pageBuilder: (_, state, child) =>
            _fadePage(state, AdminShell(child: child)),
        routes: [
          GoRoute(
            path: AppRoutes.adminHome,
            pageBuilder: (_, state) => _fadePage(state, const AdminHomePage()),
          ),
          if (clinicListCubitFactory != null &&
              branchListCubitFactory != null &&
              departmentListCubitFactory != null &&
              clinicSaveCubitFactory != null &&
              branchSaveCubitFactory != null &&
              departmentSaveCubitFactory != null)
            ShellRoute(
              builder: (_, state, child) => InstitutionRouteScope(
                routeClinicId: state.pathParameters['clinicId'],
                createClinics: clinicListCubitFactory,
                createBranches: branchListCubitFactory,
                createDepartments: departmentListCubitFactory,
                child: child,
              ),
              routes: [
                GoRoute(
                  path: AppRoutes.institution,
                  pageBuilder: (_, state) => _fadePage(
                    state,
                    InstitutionPage(
                      createClinicSaveCubit: clinicSaveCubitFactory,
                      createDepartmentSaveCubit: departmentSaveCubitFactory,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'clinics/:clinicId/branches/new',
                      pageBuilder: (_, state) => _fadePage(
                        state,
                        BranchFormPage(createSaveCubit: branchSaveCubitFactory),
                      ),
                    ),
                    GoRoute(
                      path: 'clinics/:clinicId/branches/:branchId',
                      pageBuilder: (_, state) => _fadePage(
                        state,
                        BranchDetailPage(
                          branchId: state.pathParameters['branchId']!,
                          createDepartmentSaveCubit: departmentSaveCubitFactory,
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          pageBuilder: (_, state) => _fadePage(
                            state,
                            BranchFormPage(
                              branchId: state.pathParameters['branchId'],
                              createSaveCubit: branchSaveCubitFactory,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
      if (signInCubitFactory != null)
        ShellRoute(
          pageBuilder: (_, state, child) {
            return _fadePage(
              state,
              AuthShell(
                kind: AuthFormKind.fromLocation(state.uri.path),
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.signIn,
              pageBuilder: (_, state) {
                return _fadePage(
                  state,
                  SignInPage(createCubit: signInCubitFactory),
                );
              },
              routes: [
                if (signUpCubitFactory != null)
                  GoRoute(
                    path: AppRoutes.signUpSegment,
                    pageBuilder: (_, state) {
                      return _fadePage(
                        state,
                        SignUpPage(createCubit: signUpCubitFactory),
                      );
                    },
                  ),
                if (passwordResetCubitFactory != null)
                  GoRoute(
                    path: AppRoutes.passwordResetSegment,
                    pageBuilder: (_, state) {
                      return _fadePage(
                        state,
                        PasswordResetPage(
                          createCubit: passwordResetCubitFactory,
                        ),
                      );
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
