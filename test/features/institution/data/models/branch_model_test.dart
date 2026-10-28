import 'package:clinic_appointment_system/features/institution/data/models/branch_model.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final workingHours = WorkingHours({
    Weekday.monday: [
      TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 17, minute: 30),
      ),
    ],
  });
  final branch = Branch(
    id: 'branch-1',
    clinicId: 'clinic-1',
    name: 'Central Branch',
    address: '100 Main Street',
    workingHours: workingHours,
  );

  test('fromEntity writes exactly the branch schema and all weekdays', () {
    expect(BranchModel.fromEntity(branch).toJson(), {
      'clinicId': 'clinic-1',
      'name': 'Central Branch',
      'address': '100 Main Street',
      'workingHours': {
        'monday': [
          {'start': '09:00', 'end': '17:30'},
        ],
        'tuesday': <Map<String, String>>[],
        'wednesday': <Map<String, String>>[],
        'thursday': <Map<String, String>>[],
        'friday': <Map<String, String>>[],
        'saturday': <Map<String, String>>[],
        'sunday': <Map<String, String>>[],
      },
    });
  });

  test('fromJson rebuilds the branch values using the document id', () {
    final restored = BranchModel.fromJson({
      'id': 'branch-1',
      'clinicId': 'clinic-1',
      'name': 'Central Branch',
      'address': '100 Main Street',
      'workingHours': {
        'monday': [
          {'start': '09:00', 'end': '17:30'},
        ],
        'tuesday': <Map<String, String>>[],
        'wednesday': <Map<String, String>>[],
        'thursday': <Map<String, String>>[],
        'friday': <Map<String, String>>[],
        'saturday': <Map<String, String>>[],
        'sunday': <Map<String, String>>[],
      },
    });

    expect(restored, isA<Branch>());
    expect(restored.id, branch.id);
    expect(restored.clinicId, branch.clinicId);
    expect(restored.name, branch.name);
    expect(restored.address, branch.address);
    expect(restored.workingHours, branch.workingHours);
  });
}
