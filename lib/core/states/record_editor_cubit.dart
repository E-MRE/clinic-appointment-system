import 'package:clinic_appointment_system/core/states/record_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shares edit target selection and form revision tracking for records.
class RecordEditorCubit<T> extends Cubit<RecordEditorState<T>> {
  /// Creates an editor in creation mode at revision zero.
  RecordEditorCubit() : super(RecordEditorState<T>());

  int get _revisionStep => 1;

  /// Resets to creation mode and increments the form revision.
  void startCreate() {
    emit(RecordEditorState<T>(revision: state.revision + _revisionStep));
  }

  /// Selects [record] for editing and increments the form revision.
  void edit(T record) {
    emit(
      RecordEditorState<T>(
        record: record,
        revision: state.revision + _revisionStep,
      ),
    );
  }

  /// Resets to creation mode after a successful save or cancel.
  void reset() => startCreate();
}
