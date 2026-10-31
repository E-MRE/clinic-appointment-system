import 'package:clinic_appointment_system/core/states/record_editor_cubit.dart';
import 'package:clinic_appointment_system/core/states/record_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const initialRevision = 0;
  const firstRevision = 1;
  const secondRevision = 2;
  test('state equality includes record and revision', () {
    expect(
      const RecordEditorState<String>(record: 'record'),
      const RecordEditorState<String>(record: 'record'),
    );
    expect(
      const RecordEditorState<String>(record: 'record'),
      isNot(const RecordEditorState<String>(record: 'other')),
    );
    expect(
      const RecordEditorState<String>(revision: firstRevision),
      isNot(const RecordEditorState<String>()),
    );
  });

  group('RecordEditorCubit', () {
    late RecordEditorCubit<String> cubit;

    const sampleRecord = 'record';

    setUp(() {
      cubit = RecordEditorCubit<String>();
    });

    tearDown(() => cubit.close());

    test('initial state is create mode with revision 0', () {
      expect(cubit.state.record, isNull);
      expect(cubit.state.revision, initialRevision);
      expect(cubit.state.isEditing, isFalse);
    });

    test('edit sets record and increments revision', () {
      cubit.edit(sampleRecord);

      expect(cubit.state.record, sampleRecord);
      expect(cubit.state.revision, firstRevision);
      expect(cubit.state.isEditing, isTrue);
    });

    test('startCreate resets record to null and increments revision', () {
      cubit.edit(sampleRecord);
      expect(cubit.state.revision, firstRevision);

      cubit.startCreate();
      expect(cubit.state.record, isNull);
      expect(cubit.state.revision, secondRevision);
      expect(cubit.state.isEditing, isFalse);
    });

    test('reselecting the same target still increments the form revision', () {
      cubit.edit(sampleRecord);
      final firstState = cubit.state;
      cubit.edit(sampleRecord);
      expect(cubit.state.record, sampleRecord);
      expect(cubit.state.revision, secondRevision);
      expect(cubit.state, isNot(firstState));
    });

    test('reset delegates to startCreate', () {
      cubit.edit(sampleRecord);
      cubit.reset();

      expect(cubit.state.record, isNull);
      expect(cubit.state.revision, secondRevision);
    });
  });
}
