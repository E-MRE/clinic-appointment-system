import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success exposes typed data and inherits Result behavior', () {
    const result = DataResult<int>.success(data: 21, message: 'Loaded');
    const Result outcome = result;
    expect(result.data, 21);
    expect(outcome.isSuccess, isTrue);
    expect(outcome.isNotSuccess, isFalse);
    expect(outcome.message, 'Loaded');
  });

  test('error defaults to no data and an empty message', () {
    const result = DataResult<int>.error();
    expect(result.isSuccess, isFalse);
    expect(result.isNotSuccess, isTrue);
    expect(result.data, isNull);
    expect(result.message, isEmpty);
  });

  test('error can retain data alongside its message', () {
    const result = DataResult<int>.error(data: 21, message: 'Cached data');
    expect(result.isSuccess, isFalse);
    expect(result.data, 21);
    expect(result.message, 'Cached data');
  });

  test('null data does not determine success or error status', () {
    const success = DataResult<String?>.success(data: null);
    const error = DataResult<String?>.error();
    expect(success.isSuccess, isTrue);
    expect(success.isNotSuccess, isFalse);
    expect(success.data, isNull);
    expect(success.message, isEmpty);
    expect(error.isSuccess, isFalse);
    expect(error.isNotSuccess, isTrue);
    expect(error.data, isNull);
  });
}
