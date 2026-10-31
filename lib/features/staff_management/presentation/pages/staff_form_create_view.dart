part of 'staff_form_page.dart';

/// Full-page scaffold for creating a new staff record on mobile.
final class _StaffFormCreateView extends StatelessWidget {
  const _StaffFormCreateView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(title: LocaleKeys.staff_addTitle.tr()),
            const EmptySize.s16Height(),
            StaffForm(onSaved: (_) => context.pop()),
          ],
        ),
      ),
    );
  }
}
