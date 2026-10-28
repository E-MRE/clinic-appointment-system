import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_branch_repository.dart';

void main() {
  test('trims a valid name and returns the repository result', () async {
    final repository = FakeBranchRepository();
    final hours = WorkingHours.closed();
    final branch = Branch(
      id: 'b1',
      clinicId: 'c1',
      name: 'Central',
      address: '100 Main Street',
      workingHours: hours,
    );
    final result = DataResult<Branch>.success(data: branch);
    repository.createResult = result;
    final useCase = CreateBranchUseCase(repository);

    expect(
      await useCase(
        BranchDraft(
          clinicId: 'c1',
          name: '  Central  ',
          address: '  100 Main Street  ',
          workingHours: hours,
        ),
      ),
      same(result),
    );
    expect(repository.createdDraft?.name, 'Central');
    expect(repository.createdDraft?.address, '100 Main Street');
    expect(repository.createdDraft?.clinicId, 'c1');
    expect(repository.createdDraft?.workingHours, same(hours));
    expect(repository.createCalls, 1);
  });

  test('rejects a blank name without calling the repository', () async {
    final repository = FakeBranchRepository();
    final useCase = CreateBranchUseCase(repository);

    await expectLater(
      useCase(
        BranchDraft(
          clinicId: 'c1',
          name: '  ',
          address: '100 Main Street',
          workingHours: WorkingHours.closed(),
        ),
      ),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      ),
    );
    expect(repository.createCalls, 0);
  });

  test('rejects a blank address without calling the repository', () async {
    final repository = FakeBranchRepository();
    final useCase = CreateBranchUseCase(repository);

    await expectLater(
      useCase(
        BranchDraft(
          clinicId: 'c1',
          name: 'Central',
          address: '  ',
          workingHours: WorkingHours.closed(),
        ),
      ),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.addressRequired,
        ),
      ),
    );
    expect(repository.createCalls, 0);
  });
}
