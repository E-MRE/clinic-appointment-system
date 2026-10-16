import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const light = AppointmentStatusColors.light;
  const dark = AppointmentStatusColors.dark;

  test('copyWith replaces only the given fields', () {
    const red = Color(0xFFFF0000);
    final copy = light.copyWith(pendingBg: red);

    expect(copy.pendingBg, red);
    expect(copy.pendingFg, light.pendingFg);
    expect(copy.approvedBg, light.approvedBg);
    expect(copy.cancelledFg, light.cancelledFg);
    expect(light.copyWith(), isA<AppointmentStatusColors>());
  });

  test('lerp returns endpoints at 0 and 1', () {
    final a = light.lerp(dark, 0);
    final b = light.lerp(dark, 1);

    expect(a.pendingBg, light.pendingBg);
    expect(a.cancelledFg, light.cancelledFg);
    expect(b.pendingBg, dark.pendingBg);
    expect(b.cancelledFg, dark.cancelledFg);
  });

  test('lerp interpolates at 0.5', () {
    final mid = light.lerp(dark, 0.5);

    expect(mid.approvedBg, Color.lerp(light.approvedBg, dark.approvedBg, 0.5));
    expect(mid.approvedBg, isNot(light.approvedBg));
    expect(mid.approvedBg, isNot(dark.approvedBg));
  });

  test('lerp with null or another type returns this', () {
    expect(light.lerp(null, 0.5), same(light));
    expect(light.lerp(_OtherExtension(), 0.5), same(light));
  });

  test('resolve covers all six statuses with distinct pairs', () {
    expect(AppointmentStatus.values, hasLength(6));
    final pairs = AppointmentStatus.values.map(light.resolve).toList();

    expect(pairs.toSet(), hasLength(6));
    expect(light.resolve(AppointmentStatus.pending).bg, light.pendingBg);
    expect(light.resolve(AppointmentStatus.approved).fg, light.approvedFg);
    expect(light.resolve(AppointmentStatus.rejected).bg, light.rejectedBg);
    expect(light.resolve(AppointmentStatus.completed).fg, light.completedFg);
    expect(light.resolve(AppointmentStatus.noShow).bg, light.noShowBg);
    expect(light.resolve(AppointmentStatus.cancelled).fg, light.cancelledFg);
  });
}

final class _OtherExtension extends ThemeExtension<AppointmentStatusColors> {
  @override
  _OtherExtension copyWith() => this;

  @override
  _OtherExtension lerp(
    covariant ThemeExtension<AppointmentStatusColors>? other,
    double t,
  ) => this;
}
