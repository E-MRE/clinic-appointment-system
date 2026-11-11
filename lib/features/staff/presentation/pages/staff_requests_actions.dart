part of 'staff_requests_page.dart';

/// Runs staff request actions as the signed-in staff member.
extension _StaffRequestsActions on BuildContext {
  /// Performs [cubit]'s action on [request], with an optional [reason], as
  /// the signed-in staff member; does nothing without a staff session.
  Future<void> performAsStaff(
    AppointmentActionCubit cubit,
    Appointment request, {
    String? reason,
  }) async {
    final session = read<AuthCubit>().state;
    if (session is AuthSignedIn) {
      final staff = session.user.staffProfile;
      if (staff != null) {
        await cubit.perform(
          request,
          by: staff.accept(const StaffAppointmentActorVisitor()),
          reason: reason,
        );
      }
    }
  }
}
