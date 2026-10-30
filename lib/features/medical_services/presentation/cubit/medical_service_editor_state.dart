import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:equatable/equatable.dart';

/// State of the medical services page editor host.
final class MedicalServiceEditorState extends Equatable {
  /// Creates the editor state.
  const MedicalServiceEditorState({this.service, this.revision = 0});

  /// The medical service being edited, or null when in creation mode.
  final MedicalService? service;

  /// Counter incremented on every editor transition to key the form rebuild.
  final int revision;

  /// Whether the editor is editing an existing service.
  bool get isEditing => service != null;

  @override
  List<Object?> get props => [service, revision];
}
