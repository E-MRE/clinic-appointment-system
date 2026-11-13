import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_state.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../availability/domain/doubles/fake_staff_availability_repository.dart';
import '../../../availability/presentation/doubles/mock_branch_repository.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../../medical_services/domain/doubles/fake_medical_service_repository.dart';

void main() {
  const staff = Doctor(
    id: 'staff-1',
    fullName: 'Dr. Ada Kaya',
    email: 'ada@example.com',
    branchId: 'branch-1',
    departmentId: 'dept-1',
    serviceIds: ['exam-1'],
    specialty: 'Cardiology',
  );

  final availability = StaffAvailability(
    staffId: 'staff-1',
    branchId: 'branch-1',
  );

  final branch = Branch(
    id: 'branch-1',
    clinicId: 'clinic-1',
    name: 'Merkez Şube',
    address: 'Adres',
    workingHours: WorkingHours.closed(),
  );

  const department = Department(
    id: 'dept-1',
    name: 'Kardiyoloji',
    branchId: 'branch-1',
  );

  final service = Examination(
    id: 'exam-1',
    branchId: 'branch-1',
    departmentId: 'dept-1',
    name: 'Muayene',
    fee: Money.minorUnits(10000),
    duration: ServiceDuration(30),
  );

  late FakeStaffAvailabilityRepository availabilityRepo;
  late MockBranchRepository branchRepo;
  late FakeDepartmentRepository departmentRepo;
  late FakeMedicalServiceRepository serviceRepo;

  late StreamController<DataResult<StaffAvailability>> availabilityController;
  late StreamController<DataResult<Branch>> branchController;
  late StreamController<DataResult<List<Department>>> departmentController;
  late StreamController<DataResult<List<MedicalService>>> serviceController;

  late StaffWorkspaceCubit cubit;

  setUp(() {
    availabilityController =
        StreamController<DataResult<StaffAvailability>>.broadcast();
    branchController = StreamController<DataResult<Branch>>.broadcast();
    departmentController =
        StreamController<DataResult<List<Department>>>.broadcast();
    serviceController =
        StreamController<DataResult<List<MedicalService>>>.broadcast();

    availabilityRepo = FakeStaffAvailabilityRepository(availability)
      ..stream = availabilityController.stream;
    branchRepo = MockBranchRepository();
    when(
      () => branchRepo.watchBranch(any()),
    ).thenAnswer((_) => branchController.stream);
    departmentRepo = FakeDepartmentRepository()
      ..departmentsStream = departmentController.stream;
    serviceRepo = FakeMedicalServiceRepository()
      ..servicesStream = serviceController.stream;

    cubit = StaffWorkspaceCubit(
      WatchStaffAvailabilityUseCase(availabilityRepo),
      WatchBranchUseCase(branchRepo),
      WatchDepartmentsUseCase(departmentRepo),
      WatchMedicalServicesUseCase(serviceRepo),
    );
  });

  tearDown(() async {
    await cubit.close();
    await availabilityController.close();
    await branchController.close();
    await departmentController.close();
    await serviceController.close();
  });

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  void emitAll() {
    availabilityController.add(DataResult.success(data: availability));
    branchController.add(DataResult.success(data: branch));
    departmentController.add(const DataResult.success(data: [department]));
    serviceController.add(DataResult.success(data: [service]));
  }

  test('emits loaded state when all watches deliver', () async {
    cubit.watch(staff);
    expect(cubit.state, isA<StaffWorkspaceLoading>());

    availabilityController.add(DataResult.success(data: availability));
    await flush();
    expect(cubit.state, isA<StaffWorkspaceLoading>());

    branchController.add(DataResult.success(data: branch));
    await flush();
    expect(cubit.state, isA<StaffWorkspaceLoading>());

    departmentController.add(const DataResult.success(data: [department]));
    await flush();
    expect(cubit.state, isA<StaffWorkspaceLoading>());

    serviceController.add(DataResult.success(data: [service]));
    await flush();

    final state = cubit.state;
    expect(state, isA<StaffWorkspaceLoaded>());
    final workspace = state.workspace;
    expect(workspace, isNotNull);
    expect(workspace?.staff, staff);
    expect(workspace?.availability, availability);
    expect(workspace?.branch, branch);
    expect(workspace?.department, department);
    expect(workspace?.services, [service]);
  });

  test('emits failure when availability watch fails', () async {
    cubit.watch(staff);
    availabilityController.add(const DataResult.error(message: 'error'));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('emits failure when branch watch fails', () async {
    cubit.watch(staff);
    branchController.add(const DataResult.error(message: 'error'));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('emits failure when department watch fails', () async {
    cubit.watch(staff);
    departmentController.add(const DataResult.error(message: 'error'));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('emits failure when medical services watch fails', () async {
    cubit.watch(staff);
    serviceController.add(const DataResult.error(message: 'error'));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('emits failure when department list omits staff department', () async {
    cubit.watch(staff);
    availabilityController.add(DataResult.success(data: availability));
    branchController.add(DataResult.success(data: branch));
    departmentController.add(
      const DataResult.success(
        data: [
          Department(id: 'other-dept', name: 'Diğer', branchId: 'branch-1'),
        ],
      ),
    );
    serviceController.add(DataResult.success(data: [service]));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('emits failure when a stream emits an error', () async {
    cubit.watch(staff);
    availabilityController.addError(Exception('stream failure'));
    await flush();

    expect(cubit.state, isA<StaffWorkspaceFailure>());
  });

  test('later emission of any watch updates the workspace', () async {
    cubit.watch(staff);
    emitAll();
    await flush();

    expect(cubit.state, isA<StaffWorkspaceLoaded>());

    final updatedBranch = Branch(
      id: 'branch-1',
      clinicId: 'clinic-1',
      name: 'Yeni Şube Adı',
      address: 'Adres',
      workingHours: WorkingHours.closed(),
    );
    branchController.add(DataResult.success(data: updatedBranch));
    await flush();

    expect(cubit.state.workspace?.branch.name, 'Yeni Şube Adı');

    const updatedDepartment = Department(
      id: 'dept-1',
      name: 'Kardiyoloji Bölümü',
      branchId: 'branch-1',
    );
    departmentController.add(
      const DataResult.success(data: [updatedDepartment]),
    );
    await flush();

    expect(cubit.state.workspace?.department.name, 'Kardiyoloji Bölümü');
  });

  test(
    'retry restarts observation with the last watched staff profile',
    () async {
      cubit.watch(staff);
      availabilityController.add(const DataResult.error());
      await flush();
      expect(cubit.state, isA<StaffWorkspaceFailure>());

      cubit.retry();
      expect(cubit.state, isA<StaffWorkspaceLoading>());

      emitAll();
      await flush();
      expect(cubit.state, isA<StaffWorkspaceLoaded>());
    },
  );

  test(
    'close cancels subscriptions and ignores subsequent emissions',
    () async {
      cubit.watch(staff);
      emitAll();
      await flush();
      expect(cubit.state, isA<StaffWorkspaceLoaded>());

      await cubit.close();
      expect(cubit.isClosed, isTrue);

      availabilityController.add(const DataResult.error());
      await flush();
      expect(cubit.isClosed, isTrue);
    },
  );
}
