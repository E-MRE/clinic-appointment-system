import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_form_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/staff_page_harness.dart';

void main() {
  late StaffPageHarness harness;

  setUp(() async {
    harness = StaffPageHarness();
    await harness.initialize();
  });

  testWidgets('create page displays a new staff form', (tester) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(
      tester,
      const StaffFormPage(),
      size: StaffPageHarness.mobile,
    );
    await harness.emitBranches(tester);
    expect(find.text('Personel ekle'), findsOneWidget);
    expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff, isNull);
    expect(find.text('Geçici şifre'), findsOneWidget);
  });

  testWidgets('edit waits for staff and resolves an existing identifier', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(
      tester,
      const StaffFormPage(staffId: 'ada'),
      size: StaffPageHarness.mobile,
    );
    expect(find.byType(LoadingState), findsOneWidget);
    await harness.load(tester);
    expect(find.text('Personeli düzenle'), findsOneWidget);
    expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff?.id, 'ada');
    expect(find.text('Ada Kaya'), findsOneWidget);
    expect(find.text('Geçici şifre'), findsNothing);
  });

  testWidgets('unknown identifier displays the shared not-found view', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(
      tester,
      const StaffFormPage(staffId: 'unknown'),
      size: StaffPageHarness.mobile,
    );
    await harness.load(tester);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Personel bulunamadı'), findsOneWidget);
    expect(find.byType(StaffForm), findsNothing);
  });

  testWidgets('empty staff stream resolves to not-found', (tester) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(
      tester,
      const StaffFormPage(staffId: 'ada'),
      size: StaffPageHarness.mobile,
    );
    await harness.emitStaff(tester, const DataResult.success(data: []));
    expect(find.text('Personel bulunamadı'), findsOneWidget);
  });
}
