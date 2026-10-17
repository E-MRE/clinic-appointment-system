// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> _tr_TR = {
    "appName": "Klinik Randevu Sistemi",
    "common": {
      "appName": "Klinik Randevu Sistemi",
      "themeToggle": "Tema Değiştir",
      "language": "Dil",
      "turkish": "Türkçe",
      "english": "İngilizce",
      "save": "Kaydet",
      "cancel": "İptal",
      "delete": "Sil",
      "edit": "Düzenle",
      "back": "Geri",
      "retry": "Tekrar Dene",
      "loading": "Yükleniyor...",
      "search": "Ara",
      "confirm": "Onayla",
    },
    "roles": {
      "patient": "Hasta",
      "doctor": "Doktor",
      "staff": "Personel",
      "technician": "Teknisyen",
      "admin": "Yönetici",
    },
    "appointment": {
      "title": "Randevu",
      "appointments": "Randevular",
      "newAppointment": "Yeni Randevu",
      "cancelAppointment": "Randevuyu İptal Et",
      "appointmentTime": "Randevu Zamanı",
      "serviceFee": "Hizmet Ücreti",
      "status": {
        "pending": "Beklemede",
        "approved": "Onaylandı",
        "rejected": "Reddedildi",
        "completed": "Tamamlandı",
        "noShow": "Gelmedi",
        "cancelled": "İptal Edildi",
      },
    },
    "services": {
      "title": "Hizmetler",
      "examination": "Muayene",
      "radiology": "Radyoloji",
      "labTest": "Laboratuvar Testi",
    },
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {"tr_TR": _tr_TR};
}
