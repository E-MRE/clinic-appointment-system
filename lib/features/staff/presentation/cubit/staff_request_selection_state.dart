import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:equatable/equatable.dart';

/// The sort order and the selected request of the Talepler page.
final class StaffRequestSelectionState extends Equatable {
  /// Creates a selection state.
  const StaffRequestSelectionState({
    required this.sort,
    this.selectedRequestId,
  });

  /// The active sort order.
  final StaffRequestSort sort;

  /// The identifier of the selected request, or null when there is none.
  final String? selectedRequestId;

  @override
  List<Object?> get props => [sort, selectedRequestId];
}
