import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';

/// State of the medical services page editor host.
final class MedicalServiceEditorState {
  /// Creates the editor state.
  const MedicalServiceEditorState({this.service, this.revision = 0});

  /// The medical service being edited, or null when in creation mode.
  final MedicalService? service;

  /// Counter incremented on every editor transition to key the form rebuild.
  final int revision;

  /// Whether the editor is editing an existing service.
  bool get isEditing => service != null;

  @override
  bool operator ==(Object other) {
    return other is MedicalServiceEditorState &&
        other.service == service &&
        other.revision == revision;
  }

  @override
  int get hashCode => Object.hash(service, revision);
}
