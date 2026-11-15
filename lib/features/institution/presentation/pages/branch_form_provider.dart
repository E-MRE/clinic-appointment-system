part of 'branch_form_page.dart';

/// Creates the two Cubits used by the branch form.
final class _BranchFormProvider extends StatelessWidget {
  const _BranchFormProvider({this.branch});

  final Branch? branch;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey(branch?.id),
      providers: [
        BlocProvider<WorkingHoursEditorCubit>(
          create: (_) =>
              AppDependency.injector.get<WorkingHoursEditorCubit>()
                ..initialize(branch?.workingHours),
        ),
        BlocProvider<BranchSaveCubit>(
          create: (_) => AppDependency.injector.get<BranchSaveCubit>(),
        ),
      ],
      child: _BranchForm(branch: branch),
    );
  }
}
