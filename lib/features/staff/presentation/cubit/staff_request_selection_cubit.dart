import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_request_selection_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/features/staff/presentation/services/staff_request_sorter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the sort order and the selected request of the Talepler page.
/// Starts sorted by date with nothing selected; [syncRequests] keeps a
/// selection whenever requests exist.
final class StaffRequestSelectionCubit
    extends Cubit<StaffRequestSelectionState> {
  /// Creates the cubit sorted by date.
  StaffRequestSelectionCubit(this._sorter)
    : super(const StaffRequestSelectionState(sort: StaffRequestSort.byDate));

  final StaffRequestSorter _sorter;
  List<Appointment> _requests = const [];

  /// Orders the requests by [sort]; the selection stays.
  void changeSort(StaffRequestSort sort) {
    if (state.sort == sort) return;
    emit(
      StaffRequestSelectionState(
        sort: sort,
        selectedRequestId: state.selectedRequestId,
        sortedRequests: List<Appointment>.unmodifiable(
          _sorter.sort(_requests, sort: sort),
        ),
      ),
    );
  }

  /// Selects the request identified by [id].
  void select(String id) {
    if (state.selectedRequestId == id) return;
    emit(
      StaffRequestSelectionState(
        sort: state.sort,
        selectedRequestId: id,
        sortedRequests: state.sortedRequests,
      ),
    );
  }

  /// Keeps the selection while it is among [requests]; otherwise selects the
  /// first request in the active order, or nothing when [requests] is empty.
  void syncRequests(Iterable<Appointment> requests) {
    _requests = List<Appointment>.unmodifiable(requests);
    final sortedRequests = List<Appointment>.unmodifiable(
      _sorter.sort(_requests, sort: state.sort),
    );
    final selectedRequestExists = _requests.any(
      (request) => request.id == state.selectedRequestId,
    );
    final String? selectedRequestId = selectedRequestExists
        ? state.selectedRequestId
        : sortedRequests.isEmpty
        ? null
        : sortedRequests.first.id;
    emit(
      StaffRequestSelectionState(
        sort: state.sort,
        selectedRequestId: selectedRequestId,
        sortedRequests: sortedRequests,
      ),
    );
  }
}
