import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';
import '../doubles/fake_branch_repository.dart';

void main() {
  test('delegates the branch id and stream', () async {
    final repository = FakeBranchRepository();
    final branch = Branch(
      id: 'b1',
      clinicId: 'c1',
      name: 'Central',
      address: 'Main',
      workingHours: WorkingHours.closed(),
    );
    final result = DataResult<Branch>.success(data: branch);
    final stream = Stream<DataResult<Branch>>.value(result);
    repository.branchStream = stream;
    final useCase = WatchBranchUseCase(repository);
    expect(useCase('b1'), same(stream));
    expect(await useCase('b1').single, same(result));
    expect(repository.watchedBranchId, 'b1');
  });
}
