part of 'staff_form_page.dart';

/// Resolves an existing staff profile by id and renders loading, edit, or not-found views.
final class _StaffFormEditResolver extends StatelessWidget {
  const _StaffFormEditResolver({required this.staffId});

  final String staffId;

  @override
  Widget build(BuildContext context) {
    final listState = context.watch<StaffListCubit>().state;
    if (listState is InstitutionListLoading<Staff>) {
      return const _StaffFormLoadingView();
    }
    if (listState is InstitutionListLoaded<Staff>) {
      final matches = listState.items.where((s) => s.id == staffId);
      if (matches.isNotEmpty) {
        return _StaffFormEditBody(staff: matches.first);
      }
    }
    return const _StaffFormNotFoundView();
  }
}
