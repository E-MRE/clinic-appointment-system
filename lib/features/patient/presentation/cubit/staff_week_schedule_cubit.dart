import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/states/keyed_list_watch.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/staff_booked_slots_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_booked_slots_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes one staff member's availability and the booked slots of every
/// listed day of one week (one subscription per day), and emits their
/// combination as a [StaffWeekSchedule] whose past slots are dropped at the
/// clock's current instant. Watching again replaces every subscription;
/// any failure cancels them until [retry] or the next [watch].
final class StaffWeekScheduleCubit extends Cubit<StaffWeekScheduleState> {
  /// Injects the observation use cases, the clock and the slot generator.
  StaffWeekScheduleCubit(
    this._watchAvailability,
    this._watchBookedSlots,
    this._clock,
    this._generator,
  ) : super(const StaffWeekScheduleIdle()) {
    _bookedWatch = KeyedListWatch<CalendarDate, BookedSlot>(
      onChanged: (List<BookedSlot> slots) {
        _bookedSlots = slots;
        _emitIfComplete();
      },
      onFailure: _fail,
    );
  }

  final WatchStaffAvailabilityUseCase _watchAvailability;
  final WatchStaffBookedSlotsUseCase _watchBookedSlots;
  final Clock _clock;
  final SlotGenerator _generator;

  late final KeyedListWatch<CalendarDate, BookedSlot> _bookedWatch;
  StreamSubscription<DataResult<StaffAvailability>>? _availabilitySubscription;
  StaffWeekScheduleRequest? _request;
  StaffAvailability? _availability;
  List<BookedSlot>? _bookedSlots;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts observing the schedule described by [request], replacing any
  /// earlier observation.
  void watch(StaffWeekScheduleRequest request) {
    if (_isClosingOrClosed) return;
    _cancel();
    _request = request;
    emit(const StaffWeekScheduleLoading());
    try {
      _availabilitySubscription = _watchAvailability
          .call(AvailabilitySubject.ofStaff(request.staff))
          .listen(_onAvailability, onError: (Object _) => _fail());
      _bookedWatch.watch(request.dates, (CalendarDate date) {
        return _watchBookedSlots.call(
          StaffBookedSlotsQuery(staffId: request.staff.id, date: date),
        );
      });
    } on Exception {
      _fail();
    }
  }

  /// Restarts the last observation; does nothing before the first [watch].
  void retry() {
    final request = _request;
    if (request != null) watch(request);
  }

  /// Stops observing and returns to idle.
  void clear() {
    if (_isClosingOrClosed) return;
    _cancel();
    _request = null;
    emit(const StaffWeekScheduleIdle());
  }

  void _onAvailability(DataResult<StaffAvailability> result) {
    final availability = result.data;
    if (result.isNotSuccess || availability == null) {
      _fail();
      return;
    }
    _availability = availability;
    _emitIfComplete();
  }

  void _emitIfComplete() {
    if (_isClosingOrClosed) return;
    final request = _request;
    final availability = _availability;
    final bookedSlots = _bookedSlots;
    if (request == null || availability == null || bookedSlots == null) {
      return;
    }
    emit(
      StaffWeekScheduleLoaded(
        StaffWeekSchedule(
          request: request,
          availability: availability,
          bookedSlots: bookedSlots,
          now: _clock.now(),
          generator: _generator,
        ),
      ),
    );
  }

  void _fail() {
    if (_isClosingOrClosed) return;
    _cancel();
    emit(const StaffWeekScheduleFailure());
  }

  void _cancel() {
    unawaited(_availabilitySubscription?.cancel());
    _availabilitySubscription = null;
    _bookedWatch.cancel();
    _availability = null;
    _bookedSlots = null;
  }

  /// Cancels every observation before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _cancel();
    await super.close();
  }
}
