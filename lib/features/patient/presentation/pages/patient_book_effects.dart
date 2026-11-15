part of 'patient_book_page.dart';

/// Connects the page's cubits: new choices re-observe the schedule, a new
/// schedule updates the choices, and the request result navigates or
/// clears a slot another appointment took.
final class _PatientBookEffects extends StatelessWidget {
  const _PatientBookEffects({required this.catalog, required this.child});

  final ClinicCatalog catalog;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingSelectionCubit, BookingSelection>(
          listenWhen: (previous, current) {
            return _selectionChanged(previous, current) &&
                !_isOnlySlotCleared(previous, current);
          },
          listener: _resetBookingFailure,
        ),
        BlocListener<BookingSelectionCubit, BookingSelection>(
          listenWhen: (previous, current) {
            return current.schedulesDifferentlyFrom(previous);
          },
          listener: _onSelection,
        ),
        BlocListener<StaffWeekScheduleCubit, StaffWeekScheduleState>(
          listener: _onSchedule,
        ),
        BlocListener<BookAppointmentCubit, BookAppointmentState>(
          listener: _onRequest,
        ),
      ],
      child: child,
    );
  }

  void _onSelection(BuildContext context, BookingSelection selection) {
    final schedule = context.read<StaffWeekScheduleCubit>();
    final request = selection.scheduleRequest(catalog);
    if (request == null) {
      schedule.clear();
      return;
    }
    schedule.watch(request);
  }

  void _resetBookingFailure(BuildContext context, BookingSelection selection) {
    context.read<BookAppointmentCubit>().resetFailure();
  }

  bool _selectionChanged(BookingSelection previous, BookingSelection current) {
    return previous.service?.id != current.service?.id ||
        previous.staff?.id != current.staff?.id ||
        previous.weekStart != current.weekStart ||
        previous.date != current.date ||
        previous.slot != current.slot;
  }

  bool _isOnlySlotCleared(BookingSelection previous, BookingSelection current) {
    return previous.service?.id == current.service?.id &&
        previous.staff?.id == current.staff?.id &&
        previous.weekStart == current.weekStart &&
        previous.date == current.date &&
        previous.slot != null &&
        current.slot == null;
  }

  void _onSchedule(BuildContext context, StaffWeekScheduleState state) {
    if (state is StaffWeekScheduleLoaded) {
      context.read<BookingSelectionCubit>().applySchedule(state.schedule);
    }
  }

  void _onRequest(BuildContext context, BookAppointmentState state) {
    if (state is BookAppointmentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText.body(
            LocaleKeys.patient_book_submitted.translate(),
            tone: TextTone.onInverse,
          ),
        ),
      );
      context.go(AppRoutes.patientAppointments);
    } else if (state is BookAppointmentFailure && state.errorCode.clearsSlot) {
      context.read<BookingSelectionCubit>().clearSlot();
    }
  }
}
