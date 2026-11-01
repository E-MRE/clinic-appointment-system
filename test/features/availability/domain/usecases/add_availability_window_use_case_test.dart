import 'package:clinic_appointment_system/core/constants/availability_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_policy.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/add_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../institution/domain/doubles/fake_branch_repository.dart';
import '../doubles/fake_staff_availability_repository.dart';
import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late FakeStaffAvailabilityRepository repository;
  late FakeBranchRepository branches;
  late AddAvailabilityWindowUseCase useCase;
  final yesterday = CalendarDate(year: 2026, month: 11, day: 1);

  setUp(() {
    repository = FakeStaffAvailabilityRepository(fixture.empty);
    branches = FakeBranchRepository();
    branches.branchStream = Stream.value(
      DataResult.success(
        data: Branch(
          id: subject.branchId,
          name: 'Central',
          clinicId: 'clinic',
          address: 'Main street',
          workingHours: fixture.hours,
        ),
      ),
    );
    useCase = AddAvailabilityWindowUseCase(
      repository,
      branches,
      FixedClock(DateTime(2026, 11, 2)),
      const AvailabilityPolicy.standard(),
    );
  });

  test(
    'reads authoritative branch hours, prunes yesterday, then adds',
    () async {
      final expired = fixture.oneOff(540, 600, date: yesterday);
      final retained = fixture.oneOff(780, 840, date: fixture.tuesday);
      repository.current = fixture.empty.withOneOff([expired, retained]);
      final candidate = fixture.weekly(540, 600);
      final result = await useCase(
        AvailabilityWindowRequest(subject: subject, window: candidate),
      );
      expect(result.isSuccess, isTrue);
      expect(
        result.data,
        fixture.empty.withOneOff([retained]).adding(candidate),
      );
      expect(repository.current, result.data);
      expect(branches.watchedBranchId, subject.branchId);
      expect(repository.updatedSubject, subject);
    },
  );

  test('overlap preserves conflict and does not write', () async {
    final conflict = fixture.weekly(540, 600);
    final stored = fixture.empty.adding(conflict);
    repository.current = stored;
    await expectLater(
      useCase(
        AvailabilityWindowRequest(
          subject: subject,
          window: fixture.weekly(570, 630),
        ),
      ),
      throwsA(
        isA<AvailabilityException>()
            .having(
              (error) => error.code,
              'code',
              AvailabilityErrorCode.overlappingWindow,
            )
            .having((error) => error.conflict, 'conflict', conflict),
      ),
    );
    expect(repository.writes, isZero);
    expect(repository.current, stored);
  });

  test('past date is rejected', () async {
    await expectLater(
      useCase(
        AvailabilityWindowRequest(
          subject: subject,
          window: fixture.oneOff(540, 600, date: yesterday),
        ),
      ),
      matchers.throwsCode(AvailabilityErrorCode.pastDate),
    );
    expect(repository.writes, isZero);
  });

  test('closed branch day is rejected', () async {
    await expectLater(
      useCase(
        AvailabilityWindowRequest(
          subject: subject,
          window: fixture.weekly(540, 600, day: Weekday.sunday),
        ),
      ),
      matchers.throwsCode(AvailabilityErrorCode.branchClosed),
    );
    expect(repository.writes, isZero);
  });

  test('window spanning the branch lunch gap is rejected', () async {
    await expectLater(
      useCase(
        AvailabilityWindowRequest(
          subject: subject,
          window: fixture.weekly(690, 810),
        ),
      ),
      matchers.throwsCode(AvailabilityErrorCode.outsideBranchHours),
    );
    expect(repository.writes, isZero);
  });

  test(
    'institution stream failure becomes unavailable before update',
    () async {
      branches.branchStream = Stream.error(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
      );
      await expectLater(
        useCase(
          AvailabilityWindowRequest(
            subject: subject,
            window: fixture.weekly(540, 600),
          ),
        ),
        matchers.throwsCode(AvailabilityErrorCode.unavailable),
      );
      expect(repository.updateCalls, isZero);
    },
  );

  test('failed, null and empty branch results become unavailable', () async {
    for (final stream in <Stream<DataResult<Branch>>>[
      Stream.value(const DataResult.error()),
      Stream.value(const DataResult.success(data: null)),
      const Stream.empty(),
    ]) {
      branches.branchStream = stream;
      await expectLater(
        useCase(
          AvailabilityWindowRequest(
            subject: subject,
            window: fixture.weekly(540, 600),
          ),
        ),
        matchers.throwsCode(AvailabilityErrorCode.unavailable),
      );
    }
    expect(repository.updateCalls, isZero);
  });

  test('expired one-offs do not count toward the policy limit', () async {
    repository.current = StaffAvailability(
      staffId: subject.staffId,
      branchId: subject.branchId,
      oneOff: List.generate(
        AvailabilityConstants.maxOneOffWindows,
        (_) => fixture.oneOff(540, 600, date: yesterday),
      ),
    );
    final candidate = fixture.oneOff(540, 600);
    final result = await useCase(
      AvailabilityWindowRequest(subject: subject, window: candidate),
    );
    expect(result.data, fixture.empty.adding(candidate));
  });
}
