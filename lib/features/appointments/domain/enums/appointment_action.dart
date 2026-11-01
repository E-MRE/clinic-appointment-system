/// User-requested lifecycle operations, dispatched by the companion extension.
enum AppointmentAction {
  approve,
  reject,
  cancelByPatient,
  cancelByStaff,
  complete,
  markNoShow,
}
