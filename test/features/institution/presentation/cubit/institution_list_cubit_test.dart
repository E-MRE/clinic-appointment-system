import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('institution list cubits', () {
    test('clinic list transitions from loading to loaded', () async {
      final repository = _MockClinicRepository();
      final controller = StreamController<DataResult<List<Clinic>>>.broadcast();
      when(
        () => repository.watchClinics(),
      ).thenAnswer((_) => controller.stream);
      final cubit = ClinicListCubit(WatchClinicsUseCase(repository));
      const clinic = Clinic(id: 'clinic-1', name: 'North Clinic');

      expect(cubit.state, isA<InstitutionListLoading<Clinic>>());
      controller.add(const DataResult.success(data: [clinic]));
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<InstitutionListLoaded<Clinic>>().having(
          (state) => state.items,
          'items',
          [clinic],
        ),
      );
      await cubit.close();
      await controller.close();
    });

    test(
      'branch watch uses the requested clinic and maps domain errors',
      () async {
        final repository = _MockBranchRepository();
        final controller =
            StreamController<DataResult<List<Branch>>>.broadcast();
        when(
          () => repository.watchBranches('clinic-1'),
        ).thenAnswer((_) => controller.stream);
        final cubit = BranchListCubit(WatchBranchesUseCase(repository));
        final branch = Branch(
          id: 'branch-1',
          name: 'Central',
          clinicId: 'clinic-1',
          address: 'Main street',
          workingHours: _closedHours,
        );

        await cubit.watch('clinic-1');
        controller.add(DataResult.success(data: [branch]));
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          isA<InstitutionListLoaded<Branch>>().having(
            (state) => state.items,
            'items',
            [branch],
          ),
        );

        controller.addError(
          const InstitutionException(InstitutionErrorCode.invalidRecord),
        );
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          isA<InstitutionListFailure<Branch>>().having(
            (state) => state.code,
            'code',
            InstitutionErrorCode.invalidRecord,
          ),
        );
        await cubit.close();
        await controller.close();
      },
    );

    test(
      'department stream errors without a domain code use unavailable',
      () async {
        final repository = _MockDepartmentRepository();
        final controller =
            StreamController<DataResult<List<Department>>>.broadcast();
        when(
          () => repository.watchDepartments('branch-1'),
        ).thenAnswer((_) => controller.stream);
        final cubit = DepartmentListCubit(WatchDepartmentsUseCase(repository));

        await cubit.watch('branch-1');
        controller.addError(StateError('provider detail'));
        await Future<void>.delayed(Duration.zero);

        expect(
          cubit.state,
          isA<InstitutionListFailure<Department>>().having(
            (state) => state.code,
            'code',
            InstitutionErrorCode.unavailable,
          ),
        );
        await cubit.close();
        await controller.close();
      },
    );

    test(
      're-watch cancels the old branch stream and observes the new clinic',
      () async {
        var firstCancelled = false;
        final first = StreamController<DataResult<List<Branch>>>(
          onCancel: () => firstCancelled = true,
        );
        final second = StreamController<DataResult<List<Branch>>>();
        final repository = _MockBranchRepository();
        when(() => repository.watchBranches(any())).thenAnswer((invocation) {
          return switch (invocation.positionalArguments.single as String) {
            'clinic-1' => first.stream,
            'clinic-2' => second.stream,
            _ => const Stream.empty(),
          };
        });
        final cubit = BranchListCubit(WatchBranchesUseCase(repository));

        await cubit.watch('clinic-1');
        await cubit.watch('clinic-2');
        first.add(const DataResult.success(data: <Branch>[]));
        second.add(
          DataResult.success(
            data: [
              Branch(
                id: 'branch-2',
                name: 'West',
                clinicId: 'clinic-2',
                address: 'West street',
                workingHours: _closedHours,
              ),
            ],
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(firstCancelled, isTrue);
        expect(
          cubit.state,
          isA<InstitutionListLoaded<Branch>>().having(
            (state) => state.items.single.clinicId,
            'clinicId',
            'clinic-2',
          ),
        );
        await cubit.close();
        await first.close();
        await second.close();
      },
    );

    test(
      'latest watch wins while an earlier cancellation is pending',
      () async {
        final cancelGate = Completer<void>();
        final first = StreamController<DataResult<List<Branch>>>(
          onCancel: () => cancelGate.future,
        );
        final second = StreamController<DataResult<List<Branch>>>();
        final third = StreamController<DataResult<List<Branch>>>();
        final repository = _MockBranchRepository();
        when(() => repository.watchBranches(any())).thenAnswer((invocation) {
          return switch (invocation.positionalArguments.single as String) {
            'first' => first.stream,
            'second' => second.stream,
            'third' => third.stream,
            _ => const Stream.empty(),
          };
        });
        final cubit = BranchListCubit(WatchBranchesUseCase(repository));
        await cubit.watch('first');
        final pendingSecond = cubit.watch('second');
        final pendingThird = cubit.watch('third');
        cancelGate.complete();
        await Future.wait([pendingSecond, pendingThird]);
        final latest = Branch(
          id: 'branch-3',
          clinicId: 'third',
          name: 'Latest',
          address: 'Street',
          workingHours: _closedHours,
        );
        third.add(DataResult.success(data: [latest]));
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          isA<InstitutionListLoaded<Branch>>().having(
            (state) => state.items.single,
            'latest branch',
            latest,
          ),
        );
        verifyNever(() => repository.watchBranches('second'));
        await cubit.close();
        await first.close();
        unawaited(second.close());
        await third.close();
      },
    );

    test('close cancels a pending stream and ignores later events', () async {
      var cancelled = false;
      final controller = StreamController<DataResult<List<Clinic>>>(
        onCancel: () => cancelled = true,
      );
      final repository = _MockClinicRepository();
      when(
        () => repository.watchClinics(),
      ).thenAnswer((_) => controller.stream);
      final cubit = ClinicListCubit(WatchClinicsUseCase(repository));
      final pending = cubit.close();

      await pending;
      controller.add(const DataResult.success(data: <Clinic>[]));
      await Future<void>.delayed(Duration.zero);

      expect(cancelled, isTrue);
      expect(cubit.state, isA<InstitutionListLoading<Clinic>>());
      await controller.close();
    });
  });
}

final _closedHours = WorkingHours.closed();

class _MockClinicRepository extends Mock implements ClinicRepository {}

class _MockBranchRepository extends Mock implements BranchRepository {}

class _MockDepartmentRepository extends Mock implements DepartmentRepository {}
