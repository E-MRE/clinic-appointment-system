import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/fasting_hours_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/lab_result_time_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/radiology_modality_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/service_duration_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_summary.dart';

/// Composes localized summary texts for medical service views without runtime type checks.
final class MedicalServiceSummaryVisitor
    implements MedicalServiceVisitor<MedicalServiceSummary> {
  /// Creates a summary visitor.
  const MedicalServiceSummaryVisitor();

  @override
  MedicalServiceSummary visitExamination(Examination service) {
    return MedicalServiceSummary(
      tableSubtitle: LocaleKeys.services_summary_examination_tableSubtitle
          .translate(),
      typeLine: _withDuration(
        LocaleKeys.services_summary_examination_typeLine.translate(),
        service,
      ),
      detail: LocaleKeys.services_summary_examination_detail.translate(),
    );
  }

  @override
  MedicalServiceSummary visitRadiology(RadiologyService service) {
    final modalityLabel = service.modality.label;
    final typeLine = _withDuration(
      LocaleKeys.services_summary_radiology_typeLine.translate(
        args: [modalityLabel],
      ),
      service,
    );
    final note = service.preparationNote?.trim();
    if (note != null && note.isNotEmpty) {
      return MedicalServiceSummary(
        tableSubtitle: LocaleKeys
            .services_summary_radiology_tableSubtitleWithNote
            .translate(args: [modalityLabel, note]),
        typeLine: typeLine,
        detail: LocaleKeys.services_summary_radiology_detailWithNote.translate(
          args: [note],
        ),
      );
    }
    return MedicalServiceSummary(
      tableSubtitle: LocaleKeys.services_summary_radiology_tableSubtitleNoNote
          .translate(args: [modalityLabel]),
      typeLine: typeLine,
      detail: LocaleKeys.services_summary_radiology_detailNoNote.translate(),
    );
  }

  @override
  MedicalServiceSummary visitLabTest(LabTest service) {
    final String fastingText;
    if (service.fastingHours case final fasting?) {
      fastingText = LocaleKeys.services_summary_lab_fastingWithHours.translate(
        args: [fasting.formatted],
      );
    } else {
      fastingText = LocaleKeys.services_summary_lab_fastingNone.translate();
    }
    final resultText = LocaleKeys.services_summary_lab_resultFormat.translate(
      args: [service.resultTime.resultSummary],
    );
    final summaryText = '$fastingText · $resultText';
    return MedicalServiceSummary(
      tableSubtitle: summaryText,
      typeLine: _withDuration(
        LocaleKeys.services_summary_lab_typeLine.translate(),
        service,
      ),
      detail: summaryText,
    );
  }

  /// Appends the formatted duration to a kind line: `Muayene · 20 dk`.
  String _withDuration(String line, MedicalService service) =>
      '$line · ${service.duration.formatted}';
}
