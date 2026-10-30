part of 'medical_services_page.dart';

/// Modal dialog hosted on tablet screens for creating and editing medical services.
final class _MedicalServiceFormDialog extends StatelessWidget {
  const _MedicalServiceFormDialog({required this.branchId, this.service});

  final MedicalService? service;
  final String? branchId;

  /// Shows the medical service dialog after providing required dependencies.
  static Future<void> show(
    BuildContext context, {
    MedicalService? service,
    String? branchId,
  }) {
    final effectiveBranchId =
        branchId ?? InstitutionSelectionScope.of(context).branchId;
    return showDialog<void>(
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<DepartmentListCubit>.value(
              value: context.read<DepartmentListCubit>(),
            ),
          ],
          child: _MedicalServiceFormDialog(
            service: service,
            branchId: effectiveBranchId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _MedicalServiceFormDialogContent(
        service: service,
        branchId: branchId,
      ),
    );
  }
}
