part of 'staff_form_page.dart';

/// Scaffold and header wrapping the edit form for an existing staff profile.
final class _StaffFormEditBody extends StatelessWidget {
  const _StaffFormEditBody({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(title: LocaleKeys.staff_editTitle.tr()),
            const EmptySize.s16Height(),
            StaffForm(staff: staff, onSaved: (_) => context.pop()),
          ],
        ),
      ),
    );
  }
}
