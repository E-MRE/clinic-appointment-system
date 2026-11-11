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

final class _StaffCalendarGridState extends State<_StaffCalendarGrid> {
  static const Duration _nowUpdateInterval = Duration(minutes: 1);
  static const int _lastIndexOffset = 1;

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

  @override
  Widget build(BuildContext context) {
    final now = _clock.now();
    final today = CalendarDate.fromDateTime(now);
    final layout = StaffCalendarLayout(
      visibleDates: widget.visibleDates,
      appointments: widget.appointments,
      availability: widget.availability,
      branchHours: widget.branchHours,
      now: now,
    );

    final totalHeight =
        (layout.endHour - layout.startHour) * AppSizes.staffCalendarHourHeight;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border.all(
          color: context.colorScheme.outlineVariant,
          width: AppSizes.borderThin,
        ),
        borderRadius: const AppRadius.medium(),
      ),
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
                child: Row(
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
                          showsRightBorder:
                              i < layout.days.length - _lastIndexOffset,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
