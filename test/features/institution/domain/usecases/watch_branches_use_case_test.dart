import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_branch_repository.dart';

void main() {
  test('forwards the clinic branch stream unchanged', () async {
    final repository = FakeBranchRepository();
    final branches = [
      Branch(
        id: 'b1',
        clinicId: 'c1',
        name: 'Central',
        address: '100 Main Street',
        workingHours: WorkingHours.closed(),
      ),
    ];
    final result = DataResult<List<Branch>>.success(data: branches);
    final stream = Stream<DataResult<List<Branch>>>.value(result);
    repository.branchesStream = stream;
    final useCase = WatchBranchesUseCase(repository);

    expect(useCase('c1'), same(stream));
    expect(await useCase('c1').single, same(result));
    expect(repository.watchedClinicId, 'c1');
  });
}
