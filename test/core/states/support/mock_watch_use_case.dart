import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:mocktail/mocktail.dart';

final class MockWatchUseCase extends Mock
    implements StreamUseCase<DataResult<String>, String> {}
