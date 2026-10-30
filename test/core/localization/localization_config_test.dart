import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localization_test_app.dart';

void main() {
  group('LocalizationConfig', () {
    test('path points to assets/translations', () {
      expect(LocalizationConfig.path, 'assets/translations');
    });

    test('tr locale is tr_TR', () {
      expect(LocalizationConfig.tr, const Locale('tr', 'TR'));
    });

    test('fallback locale is tr_TR', () {
      expect(LocalizationConfig.fallbackLocale, const Locale('tr', 'TR'));
    });

    test('supportedLocales contains tr_TR', () {
      expect(
        LocalizationConfig.supportedLocales,
        contains(const Locale('tr', 'TR')),
      );
    });
  });

  group('LocaleKeys & Translations', () {
    testWidgets('translates appName in Turkish', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.appName.tr(), 'Klinik Randevu Sistemi');
    });

    testWidgets('translates common keys', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.common_themeToggle.tr(), 'Tema Değiştir');
      expect(LocaleKeys.common_save.tr(), 'Kaydet');
      expect(LocaleKeys.common_cancel.tr(), 'İptal');
      expect(LocaleKeys.common_search.tr(), 'Ara');
    });

    testWidgets('translates role keys', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.roles_patient.tr(), 'Hasta');
      expect(LocaleKeys.roles_doctor.tr(), 'Doktor');
      expect(LocaleKeys.roles_staff.tr(), 'Personel');
      expect(LocaleKeys.roles_admin.tr(), 'Yönetici');
    });

    testWidgets('translates appointment status keys', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.appointment_status_pending.tr(), 'Beklemede');
      expect(LocaleKeys.appointment_status_approved.tr(), 'Onaylandı');
      expect(LocaleKeys.appointment_status_rejected.tr(), 'Reddedildi');
      expect(LocaleKeys.appointment_status_completed.tr(), 'Tamamlandı');
      expect(LocaleKeys.appointment_status_noShow.tr(), 'Gelmedi');
      expect(LocaleKeys.appointment_status_cancelled.tr(), 'İptal Edildi');
    });

    testWidgets('translates medical service keys', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.services_all.tr(), 'Tümü');
      expect(LocaleKeys.services_examination.tr(), 'Muayene');
      expect(LocaleKeys.services_radiology.tr(), 'Radyoloji');
      expect(LocaleKeys.services_labTest.tr(), 'Laboratuvar Testi');
    });
  });

  group('LocalizationExtension', () {
    testWidgets('translate extension translates keys', (tester) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.appName.translate(), 'Klinik Randevu Sistemi');
    });

    testWidgets('isTranslateExists returns true for existing keys', (
      tester,
    ) async {
      await loadTestTranslations(tester);
      expect(LocaleKeys.appName.isTranslateExists(), isTrue);
      expect('non_existent_key_xyz'.isTranslateExists(), isFalse);
    });
  });
}
