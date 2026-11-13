part of 'staff_calendar_page.dart';

/// The scrollable calendar grid updating the current-time indicator every minute.
final class _StaffCalendarGrid extends StatefulWidget {
  const _StaffCalendarGrid({
    required this.visibleDates,
    required this.appointments,
    required this.availability,
    required this.branchHours,
  });

  final List<CalendarDate> visibleDates;
  final Iterable<Appointment> appointments;
  final StaffAvailability availability;
  final WorkingHours branchHours;

  @override
  State<_StaffCalendarGrid> createState() => _StaffCalendarGridState();
}

final class _StaffCalendarGridState extends State<_StaffCalendarGrid>
    with _StaffCalendarGridMixin {
  @override
  Widget build(BuildContext context) {
    final now = _clock.now();
    final today = CalendarDate.fromDateTime(now);
    final layout = const StaffCalendarLayoutFactory().create(
      visibleDates: widget.visibleDates,
      appointments: widget.appointments,
      availability: widget.availability,
      branchHours: widget.branchHours,
      now: now,
    );

    final totalHeight =
        (layout.endHour - layout.startHour) * AppSizes.staffCalendarHourHeight;

    return Container(
      decoration: _buildDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StaffCalendarGridHeader(layout: layout, today: today),
          Divider(
            height: AppSizes.borderThin,
            thickness: AppSizes.borderThin,
            color: context.colorScheme.outlineVariant,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: totalHeight,
                child: _buildContentRow(layout, today, totalHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildContentRow(
    StaffCalendarLayout layout,
    CalendarDate today,
    double totalHeight,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StaffCalendarHourColumn(
          startHour: layout.startHour,
          endHour: layout.endHour,
          hourHeight: AppSizes.staffCalendarHourHeight,
        ),
        for (int i = 0; i < layout.days.length; i++)
          Expanded(
            child: _StaffCalendarDayColumn(
              day: layout.days[i],
              layout: layout,
              today: today,
              totalHeight: totalHeight,
              hourHeight: AppSizes.staffCalendarHourHeight,
              showsRightBorder: i < layout.days.length - _lastIndexOffset,
            ),
          ),
      ],
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: const AppRadius.medium(),
      border: Border.all(
        color: context.colorScheme.outlineVariant,
        width: AppSizes.borderThin,
      ),
    );
  }
}

mixin _StaffCalendarGridMixin on State<_StaffCalendarGrid> {
  Duration get _nowUpdateInterval => const Duration(minutes: 1);
  int get _lastIndexOffset => 1;

  late final Clock _clock;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _clock = AppDependency.injector.get<Clock>();
    _timer = Timer.periodic(_nowUpdateInterval, (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
