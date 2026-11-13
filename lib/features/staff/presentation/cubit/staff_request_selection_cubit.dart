import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_request_selection_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_request_sort_ordering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the sort order and the selected request of the Talepler page.
/// Starts sorted by date with nothing selected; [syncRequests] keeps a
/// selection whenever requests exist.
final class StaffRequestSelectionCubit
    extends Cubit<StaffRequestSelectionState> {
  /// Creates the cubit sorted by date.
  StaffRequestSelectionCubit()
    : super(const StaffRequestSelectionState(sort: StaffRequestSort.byDate));

  /// Orders the requests by [sort]; the selection stays.
  void changeSort(StaffRequestSort sort) {
    if (state.sort == sort) return;
    emit(
      StaffRequestSelectionState(
        sort: sort,
        selectedRequestId: state.selectedRequestId,
      ),
    );
  }

  /// Selects the request identified by [id].
  void select(String id) {
    if (state.selectedRequestId == id) return;
    emit(StaffRequestSelectionState(sort: state.sort, selectedRequestId: id));
  }

  /// Keeps the selection while it is among [requests]; otherwise selects the
  /// first request in the active order, or nothing when [requests] is empty.
  void syncRequests(Iterable<Appointment> requests) {
    if (requests.any((request) => request.id == state.selectedRequestId)) {
      return;
    }
    final sorted = state.sort.sort(requests);
    final String? firstId = sorted.isEmpty ? null : sorted.first.id;
    if (firstId == state.selectedRequestId) return;
    emit(
      StaffRequestSelectionState(sort: state.sort, selectedRequestId: firstId),
    );
  }
}
