part of 'medical_service_form.dart';

/// Polymorphic slot displaying kind-specific configuration inputs.
final class _MedicalServiceFormKindSection extends StatelessWidget {
  const _MedicalServiceFormKindSection();

  @override
  Widget build(BuildContext context) {
    final kind = context.select<MedicalServiceFormCubit, MedicalServiceKind>(
      (c) => c.state.kind,
    );
    return MedicalServiceFormKind.of(kind).section();
  }
}
