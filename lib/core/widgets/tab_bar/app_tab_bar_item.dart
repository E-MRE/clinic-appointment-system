part of 'app_tab_bar.dart';

/// One tab label with its selection underline.
final class _AppTabBarItem<T> extends StatelessWidget {
  const _AppTabBarItem({
    required this.choice,
    required this.isSelected,
    required this.onSelected,
  });

  final AppChoice<T> choice;
  final bool isSelected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final style = isSelected.tabStyle;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => onSelected(choice.value),
        child: SizedBox(
          height: AppSizes.s48,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const AppPadding.horizontalMd(),
                    child: Center(
                      child: AppText.label(
                        choice.label,
                        tone: style.tone,
                        fontWeight: style.weight,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: AppSizes.tabIndicator,
                  color: style.indicator(context.colorScheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
