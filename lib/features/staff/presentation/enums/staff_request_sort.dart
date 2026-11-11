/// Sort strategies for staff appointment request reviews.
enum StaffRequestSort {
  /// Orders requests by their appointment start time (earliest first).
  byDate,

  /// Orders requests by the time they were requested (oldest first).
  byRequestTime,
}
