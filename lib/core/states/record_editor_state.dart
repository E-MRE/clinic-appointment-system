import 'package:equatable/equatable.dart';

/// Active edit target and revision used to rebuild a record form.
final class RecordEditorState<T> extends Equatable {
  /// Creates a record editor state, defaulting to creation mode.
  const RecordEditorState({this.record, this.revision = 0});

  /// The record being edited, or null in creation mode.
  final T? record;

  /// Counter incremented on every editor transition.
  final int revision;

  /// Whether an existing record is being edited.
  bool get isEditing => record != null;

  @override
  List<Object?> get props => [record, revision];
}
