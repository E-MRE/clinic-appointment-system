part of 'staff_calendar_page.dart';

/// Content layout arranging the header, legend, and scrollable body grid.
final class _StaffCalendarViewContent extends StatelessWidget {
  const _StaffCalendarViewContent();

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StaffCalendarHeader(),
          EmptySize.s12Height(),
          _StaffCalendarLegend(),
          EmptySize.s16Height(),
          Expanded(child: _StaffCalendarBody()),
        ],
      ),
    );
  }
}
