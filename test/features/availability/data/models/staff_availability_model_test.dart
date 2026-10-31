import 'package:clinic_appointment_system/features/availability/data/models/staff_availability_model.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round trips stored fields and takes identity from the subject', () {
    final json = {
      'branchId': 'old-branch',
      'weekly': {
        'monday': [
          {'start': '09:00', 'end': '12:00'},
        ],
        'tuesday': <dynamic>[],
        'wednesday': <dynamic>[],
        'thursday': <dynamic>[],
        'friday': <dynamic>[],
        'saturday': <dynamic>[],
        'sunday': <dynamic>[],
      },
      'oneOff': [
        {'date': '2026-11-02', 'start': '16:30', 'end': '17:30'},
      ],
    };
    final model = StaffAvailabilityModel.fromJson({
      ...json,
      'updatedAt': 'ignored',
    });
    expect(model.toJson(), json);
    final entity = model.toEntity(
      const AvailabilitySubject(staffId: 'doctor', branchId: 'current-branch'),
    );
    expect(entity.staffId, 'doctor');
    expect(entity.branchId, 'current-branch');
    expect(StaffAvailabilityModel.fromEntity(entity).toJson(), {
      ...json,
      'branchId': 'current-branch',
    });
  });
}
