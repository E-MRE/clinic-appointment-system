part of 'app_picker_field.dart';

/// Interactive themed input for a picker field.
final class _AppPickerFieldControl extends StatelessWidget {
  const _AppPickerFieldControl({required this.field});
  final AppPickerField field;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: field.enabled,
      onTap: field.enabled ? field.onTap : null,
      label: field.label,
      value: field.value,
      child: ExcludeSemantics(
        child: InkWell(
          key: field.fieldKey,
          onTap: field.enabled ? field.onTap : null,
          child: SizedBox(
            height: AppSizes.s48,
            child: InputDecorator(
              isEmpty: field.isHint,
              decoration: InputDecoration(
                enabled: field.enabled,
                fillColor: context.screenSize.select(
                  mobile: context.colorScheme.surfaceContainerLow,
                  tablet: context.colorScheme.surface,
                  desktop: context.colorScheme.surface,
                ),
                enabledBorder: field.hasError
                    ? OutlineInputBorder(
                        borderRadius: const AppRadius.medium(),
                        borderSide: BorderSide(
                          color: context.colorScheme.error,
                        ),
                      )
                    : null,
                suffixIcon: Icon(field.icon),
              ),
              child: AppText.bodyLarge(
                field.value,
                tone: field.isHint ? TextTone.muted : TextTone.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
