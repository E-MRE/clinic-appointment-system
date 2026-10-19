[English](README.md) | **Türkçe**

# Klinik Randevu Sistemi

Hastane ve klinik randevularını yönetmek için geliştirilen Flutter uygulaması (web ve Android).

## Kullanıcı rolleri

- **Hasta:** hizmet ve doktorları inceleyebilir, uygun randevu saatlerini görebilir, randevu talep
  edebilir veya randevusunu iptal edebilir.
- **Doktor / Personel:** çalışma uygunluğunu tanımlayabilir, talepleri onaylayabilir ya da
  reddedebilir, randevuları tamamlandı veya gelmedi olarak işaretleyebilir.
- **Yönetici:** kliniği, şubeleri, bölümleri, hizmetleri ve personeli yönetebilir; tüm randevuları
  görüntüleyebilir ve gerektiğinde talepleri onaylayabilir.

## Planlanan özellikler

- Klinik, şubeler, bölümler ve çalışma saatleri.
- Muayene, radyoloji ve laboratuvar testleri gibi süre ve ücret bilgisi olan hizmetler.
- Personel için uygunluk zaman aralıkları.
- Yalnızca personelin uygun olduğu saatlerde randevu oluşturma ve çakışma denetimi.
- Onay akışı ve randevu yaşam döngüsünün yönetimi.

## Planlanan alan modeli

Sınıf adları koddaki adlarla aynı kalması için İngilizcedir.

```mermaid
classDiagram
  User <|-- Patient
  User <|-- Staff
  User <|-- Admin
  Staff <|-- Doctor
  Staff <|-- Technician

  MedicalService <|-- Examination
  MedicalService <|-- RadiologyService
  MedicalService <|-- LabTest

  Clinic "1" --> "*" Branch
  Branch "1" --> "*" Department
  Appointment --> Patient : hasta
  Appointment --> Staff : atanan personel
  Appointment --> MedicalService : hizmet
  Appointment --> AppointmentStatus : durum

  AppointmentRule <|-- WithinAvailabilityRule
  AppointmentRule <|-- NoStaffOverlapRule
  AppointmentRule <|-- NoPatientOverlapRule
  AppointmentRule <|-- StaffProvidesServiceRule

  class User {
    <<abstract>>
  }
  class Staff {
    <<abstract>>
  }
  class MedicalService {
    <<abstract>>
  }
  class AppointmentRule {
    <<abstract>>
  }
```

## Planlanan randevu yaşam döngüsü

```mermaid
stateDiagram-v2
  state "Beklemede (Pending)" as Pending
  state "Onaylandı (Approved)" as Approved
  state "Reddedildi (Rejected)" as Rejected
  state "Hasta iptal etti (CancelledByPatient)" as CancelledByPatient
  state "Personel iptal etti (CancelledByStaff)" as CancelledByStaff
  state "Tamamlandı (Completed)" as Completed
  state "Gelmedi (NoShow)" as NoShow
  [*] --> Pending
  Pending --> Approved
  Pending --> Rejected
  Pending --> CancelledByPatient
  Approved --> Completed
  Approved --> NoShow
  Approved --> CancelledByPatient
  Approved --> CancelledByStaff
```

İzin verilen bekleme süresi geçtikten sonra doktor, hastanın gelmediğini elle işaretler.

## Teknoloji yığını

- Flutter (web, Android) ve Dart
- Firebase Authentication ve Cloud Firestore
- flutter_bloc (Cubit), get_it ve go_router
- easy_localization (İngilizce ve Türkçe)
- Testler için mocktail, fake_cloud_firestore ve firebase_auth_mocks

## Mimari

Uygulama, özellik bazlı temiz mimariyle geliştirilecek:

```text
lib/
  core/        # tema, tasarım token'ları, yerelleştirme, DI, yönlendirici, hatalar
  features/
    <feature>/
      domain/        # varlıklar, değer nesneleri, kurallar, repository arayüzleri (saf Dart)
      data/          # Firestore/Auth uygulamaları, DTO'lar
      presentation/  # cubit'ler, sayfalar, bileşenler
test/          # lib/ yapısını yansıtır
```

## Yol haritası

- [ ] Depo, CI ve temel altyapı
- [ ] Kimlik doğrulama ve roller
- [ ] Kurum yapısı, hizmetler ve personel uygunluğu
- [ ] Randevular, kurallar, transaction ve yaşam döngüsü
- [ ] Rollere özel ekranlar
- [ ] Dokümantasyon, UML ve sunum
- [ ] Ek çalışma: dört hastalık senaryo simülasyonu—biri randevusunu iptal eder, biri randevusunu tamamlar, birinin randevusu personel tarafından iptal edilir, biri randevusuna gelmez

## Başlarken

Ön koşul: Flutter 3.41.9.

```sh
flutter pub get
flutter run -d chrome
flutter test
flutter analyze
```

## Katkıda bulunma

İzlenecek yol: issue → branch → `main` dalına pull request. Conventional Commits biçiminde PR başlığı
kullanın; rebase veya merge commit ile birleştirin, squash kullanmayın. Ayrıntılar için
[Katkı rehberine](.github/CONTRIBUTING.md) bakın.

## Lisans

MIT. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
