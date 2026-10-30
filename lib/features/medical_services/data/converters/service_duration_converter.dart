import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a service duration to and from its stored integer minutes.
final class ServiceDurationConverter
    extends JsonConverter<ServiceDuration, int> {
  /// Creates a converter for service duration values.
  const ServiceDurationConverter();

  @override
  ServiceDuration fromJson(int json) => ServiceDuration(json);

  @override
  int toJson(ServiceDuration object) => object.minutes;
}
