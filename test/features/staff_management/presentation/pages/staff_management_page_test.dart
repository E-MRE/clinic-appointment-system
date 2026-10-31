import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_fab.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_management_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/staff_page_harness.dart';

void main() {
  late StaffPageHarness harness;

  setUp(() async {
    harness = StaffPageHarness();
    await harness.initialize();
  });

  Finder getDepartmentSelect() => find.byType(AppSelectField<String?>);

  Future<void> selectDepartment(WidgetTester tester, String label) async {
    await tester.tap(getDepartmentSelect());
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  for (final size in [
    StaffPageHarness.desktop,
    StaffPageHarness.tablet,
    StaffPageHarness.mobile,
  ]) {
    testWidgets('clinic counts and responsive staff content at $size', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const StaffManagementPage(), size: size);
      await harness.load(tester);

      expect(find.text('Personel'), findsOneWidget);
      expect(find.text('Başka Kurum'), findsNothing);
      expect(find.byIcon(Icons.search), findsNothing);
      expect(find.text('Tümü · 3'), findsOneWidget);
      expect(find.text('Doktor · 2'), findsOneWidget);
      expect(find.text('Teknisyen · 1'), findsOneWidget);
      expect(find.byType(AppFilterChips<StaffRoleFilter>), findsOneWidget);
      expect(find.text('Ada Kaya'), findsOneWidget);
      expect(find.text('Ali Veli Demir'), findsOneWidget);
      expect(find.text('Ece Kaya'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is AppAvatar && widget.initials == 'AD',
        ),
        findsOneWidget,
      );
      final select = tester.widget<AppSelectField<String?>>(
        getDepartmentSelect(),
      );
      expect(select.options.map((option) => option.label), [
        'Tüm bölümler',
        'Kardiyoloji',
        'Radyoloji',
      ]);
      expect(select.options.first.value, isNull);

      if (size == StaffPageHarness.mobile) {
        expect(find.text('3 kişi · 2 şube'), findsOneWidget);
        expect(find.byType(AppListTile), findsNWidgets(3));
        expect(find.text('Doktor · Kardiyoloji · Merkez'), findsOneWidget);
        expect(find.text('Doktor · Kardiyoloji · Kadıköy'), findsOneWidget);
        expect(find.text('Teknisyen · Radyoloji · Merkez'), findsOneWidget);
        expect(find.byType(AppAddFab), findsOneWidget);
        expect(find.byType(AppDataTable<Staff>), findsNothing);
      } else {
        expect(find.text('2 doktor · 1 teknisyen · 2 şube'), findsOneWidget);
        expect(find.byType(AppDataTable<Staff>), findsOneWidget);
        expect(find.text('Consultation'), findsOneWidget);
        expect(find.text('X-ray, Blood count'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Scrollbar && widget.thumbVisibility == true,
          ),
          findsOneWidget,
        );
        expect(find.byType(AppAddFab), findsNothing);
      }
      expect(
        find.byType(AppSidePanel),
        size == StaffPageHarness.desktop ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'combined filters, cross-branch department and reset at $size',
      (tester) async {
        addTearDown(() => harness.dispose(tester));
        await harness.pump(tester, const StaffManagementPage(), size: size);
        await harness.load(tester);
        await selectDepartment(tester, 'Kardiyoloji');
        expect(find.text('Ada Kaya'), findsOneWidget);
        expect(find.text('Ali Veli Demir'), findsOneWidget);
        expect(find.text('Ece Kaya'), findsNothing);
        expect(find.text('Tümü · 3'), findsOneWidget);
        await tester.tap(find.text('Doktor · 2'));
        await tester.pumpAndSettle();
        expect(find.text('Ada Kaya'), findsOneWidget);
        expect(find.text('Ali Veli Demir'), findsOneWidget);
        final technician = find.text('Teknisyen · 1');
        await tester.ensureVisible(technician);
        await tester.tap(technician);
        await tester.pumpAndSettle();
        expect(find.text('Bu filtreye uyan personel yok'), findsOneWidget);
        expect(find.text('Ada Kaya'), findsNothing);
        await selectDepartment(tester, 'Tüm bölümler');
        expect(find.text('Ece Kaya'), findsOneWidget);
        expect(find.text('Bu filtreye uyan personel yok'), findsNothing);
        await tester.ensureVisible(find.text('Tümü · 3'));
        await tester.tap(find.text('Tümü · 3'));
        await tester.pumpAndSettle();
        expect(find.text('Ada Kaya'), findsOneWidget);
        expect(find.text('Ali Veli Demir'), findsOneWidget);
        expect(find.text('Ece Kaya'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'loading and failure hide panel; retry and empty restore create panel',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const StaffManagementPage());
      await harness.emitBranches(tester);
      expect(find.byType(LoadingState), findsOneWidget);
      expect(find.byType(AppSidePanel), findsNothing);

      await harness.emitStaff(tester, const DataResult.error());
      expect(find.text('Tekrar dene'), findsOneWidget);
      expect(find.byType(AppSidePanel), findsNothing);
      await tester.runAsync(() async {
        await tester.tap(find.text('Tekrar dene'));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(harness.staff.state, isA<InstitutionListLoading<Staff>>());
      expect(find.byType(AppSidePanel), findsNothing);
      await harness.emitStaff(tester, const DataResult.success(data: []));
      expect(find.text('Henüz personel yok'), findsOneWidget);
      expect(find.byType(AppSidePanel), findsOneWidget);
      expect(find.byType(StaffForm), findsOneWidget);
      expect(find.byType(AppAddButton), findsOneWidget);
    },
  );

  for (final size in [StaffPageHarness.mobile, StaffPageHarness.tablet]) {
    testWidgets('clinic-empty list offers an add action at $size', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const StaffManagementPage(), size: size);
      await harness.emitBranches(tester);
      await harness.emitStaff(
        tester,
        DataResult.success(data: [harness.records.last]),
      );
      expect(find.text('Henüz personel yok'), findsOneWidget);
      expect(find.byType(AppSidePanel), findsNothing);
      final empty = find.byType(EmptyState);
      expect(
        find.descendant(of: empty, matching: find.byType(AppAddButton)),
        findsOneWidget,
      );
    });
  }

  testWidgets(
    'desktop edit action fills the revision-keyed panel and add resets it',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const StaffManagementPage());
      await harness.load(tester);
      final createForm = tester.widget<StaffForm>(find.byType(StaffForm));
      final edit = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      expect(find.text('Personeli düzenle'), findsOneWidget);
      final editForm = tester.widget<StaffForm>(find.byType(StaffForm));
      expect(editForm.staff?.id, 'ada');
      expect(editForm.key, isNot(createForm.key));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextFormField && widget.initialValue == 'Ada Kaya',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(AppAddButton));
      await tester.pumpAndSettle();
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff, isNull);
      expect(find.text('Personeli düzenle'), findsNothing);
    },
  );

  testWidgets(
    'tablet add and row edit open working dialogs with branch provider',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(
        tester,
        const StaffManagementPage(),
        size: StaffPageHarness.tablet,
      );
      await harness.load(tester);
      await tester.tap(find.byType(AppAddButton));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormDialog), findsOneWidget);
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff, isNull);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormDialog), findsNothing);
      await tester.tap(find.text('Ada Kaya'));
      await tester.pumpAndSettle();
      expect(find.text('Personeli düzenle'), findsOneWidget);
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff?.id, 'ada');
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();
      final edit = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      expect(find.text('Personeli düzenle'), findsOneWidget);
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff?.id, 'ada');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('no branches shows the branch prerequisite and hides add', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    harness.selection.selectClinic('missing');
    await harness.pump(
      tester,
      const StaffManagementPage(),
      size: StaffPageHarness.mobile,
    );
    await harness.emitBranches(tester, []);
    expect(find.text('Önce bir şube ekleyin'), findsOneWidget);
    expect(find.text('Kurum ve şubeler'), findsOneWidget);
    expect(find.byType(AppAddFab), findsNothing);
    expect(find.byType(AppSidePanel), findsNothing);
  });

  testWidgets('no clinic shows the branch prerequisite', (tester) async {
    addTearDown(() => harness.dispose(tester));
    final selection = InstitutionSelection();
    addTearDown(selection.dispose);
    await harness.pump(
      tester,
      InstitutionSelectionScope(
        selection: selection,
        child: const StaffManagementPage(),
      ),
    );
    expect(find.text('Önce bir şube ekleyin'), findsOneWidget);
    expect(find.byType(AppSidePanel), findsNothing);
  });

  testWidgets(
    'preloaded branches initialize both lookups and branch updates rewatch them',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await tester.runAsync(() async {
        harness.branchStream.add(
          DataResult.success(data: harness.clinicBranches),
        );
        await Future<void>.delayed(Duration.zero);
      });
      await harness.pump(tester, const StaffManagementPage());
      await harness.emitStaff(
        tester,
        DataResult.success(data: harness.records),
      );
      expect(harness.departmentRepository.watchedBranchIds, [
        'branch',
        'second',
      ]);
      expect(harness.serviceRepository.watchedBranchIds, ['branch', 'second']);
      expect(find.text('2 doktor · 1 teknisyen · 2 şube'), findsOneWidget);
      final extra = Branch(
        id: 'extra',
        clinicId: 'clinic',
        name: 'Ek şube',
        address: 'Adres',
        workingHours: WorkingHours.closed(),
      );
      await harness.emitBranches(tester, [...harness.clinicBranches, extra]);
      expect(harness.departmentRepository.watchedBranchIds, [
        'branch',
        'extra',
        'second',
      ]);
      expect(harness.serviceRepository.watchedBranchIds, [
        'branch',
        'extra',
        'second',
      ]);
      expect(find.text('2 doktor · 1 teknisyen · 3 şube'), findsOneWidget);
    },
  );

  testWidgets(
    'clinic change clears old editor and filters and updates lookup watches',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const StaffManagementPage());
      await harness.load(tester);
      expect(harness.departmentRepository.watchedBranchIds, [
        'branch',
        'second',
      ]);
      expect(harness.serviceRepository.watchedBranchIds, ['branch', 'second']);
      await selectDepartment(tester, 'Kardiyoloji');
      final edit = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      harness.selection.selectClinic('another');
      await tester.pumpAndSettle();
      expect(find.byType(StaffForm), findsNothing);
      expect(
        harness.departments.state,
        isA<InstitutionListLoading<Department>>(),
      );
      final another = Branch(
        id: 'other-clinic-branch',
        clinicId: 'another',
        name: 'Diğer',
        address: 'Adres',
        workingHours: WorkingHours.closed(),
      );
      await harness.emitBranches(tester, [another]);
      expect(harness.departmentRepository.watchedBranchIds, [
        'other-clinic-branch',
      ]);
      expect(harness.serviceRepository.watchedBranchIds, [
        'other-clinic-branch',
      ]);
      expect(find.text('Başka Kurum'), findsOneWidget);
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff, isNull);
      expect(
        tester.widget<AppSelectField<String?>>(getDepartmentSelect()).value,
        isNull,
      );
    },
  );

  testWidgets(
    'mobile large text and dark theme keep filters and cards usable',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(
        tester,
        const StaffManagementPage(),
        size: StaffPageHarness.mobile,
        textScaler: const TextScaler.linear(1.5),
        dark: true,
      );
      await harness.load(tester);
      expect(find.text('Ada Kaya'), findsOneWidget);
      await selectDepartment(tester, 'Kardiyoloji');
      expect(find.text('Ali Veli Demir'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
