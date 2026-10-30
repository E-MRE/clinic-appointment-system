import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/service_duration_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = ServiceDurationConverter();

  test('converts valid duration minutes to and from integer', () {
    final duration = converter.fromJson(30);
    expect(duration, ServiceDuration(30));
    expect(duration.minutes, 30);
    expect(converter.toJson(duration), 30);
  });

  test('throws for out-of-range duration values', () {
    for (final minutes in [4, 241, 0, -10]) {
      expect(
        () => converter.fromJson(minutes),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.invalidDuration,
          ),
        ),
      );
    }
  });
}
