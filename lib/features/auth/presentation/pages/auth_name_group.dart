part of 'auth_page.dart';

/// Name field with bottom spacing for registration forms.
final class _AuthNameGroup extends StatelessWidget {
  const _AuthNameGroup({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AuthNameField(controller: controller, enabled: enabled),
        const EmptySize.s16Height(),
      ],
    );
  }
}
