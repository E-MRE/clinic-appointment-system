part of 'staff_requests_page.dart';

/// The approve step shared by every request row.
extension _StaffRequestsApprove on BuildContext {
  /// Approves [request] as the signed-in staff member through the nearest
  /// [AppointmentApproveCubit].
  Future<void> approveRequest(Appointment request) async {
    final session = read<AuthCubit>().state;
    if (session is AuthSignedIn) {
      final user = session.user;
      final staff = user.staffProfile;
      if (staff != null) {
        await read<AppointmentApproveCubit>().perform(
          request,
          by: staff.accept(const StaffAppointmentActorVisitor()),
        );
      }
    }
  }
}
