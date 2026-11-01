part of 'availability_body.dart';

/// Reattaches the page-owned cubits and subjects to the modal route by value.
final class _AvailabilityModalScope extends StatelessWidget {
  const _AvailabilityModalScope({
    required this.availability,
    required this.branch,
    required this.durations,
    required this.draft,
    required this.save,
    required this.subject,
    required this.staff,
    required this.child,
  });
  final StaffAvailabilityCubit availability;
  final AvailabilityBranchCubit branch;
  final StaffServiceDurationsCubit durations;
  final AvailabilityWindowDraftCubit draft;
  final AvailabilityWindowAddCubit save;
  final AvailabilitySubject subject;
  final Staff staff;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AvailabilitySubject>.value(value: subject),
        RepositoryProvider<Staff>.value(value: staff),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StaffAvailabilityCubit>.value(value: availability),
          BlocProvider<AvailabilityBranchCubit>.value(value: branch),
          BlocProvider<StaffServiceDurationsCubit>.value(value: durations),
          BlocProvider<AvailabilityWindowDraftCubit>.value(value: draft),
          BlocProvider<AvailabilityWindowAddCubit>.value(value: save),
        ],
        child: child,
      ),
    );
  }
}
