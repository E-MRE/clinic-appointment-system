part of 'component_preview_page.dart';

/// Owns the catalogue's local theme and viewport choices.
final class _PreviewState extends State<ComponentPreviewPage> {
  _PreviewWidth _width = _PreviewWidth.automatic;
  _PreviewTheme _theme = _PreviewTheme.light;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          PageHeader(
            title: LocaleKeys.componentPreview_title.translate(),
            subtitle: LocaleKeys.componentPreview_subtitle.translate(),
          ),
          Wrap(
            spacing: AppSizes.s12,
            runSpacing: AppSizes.s8,
            children: [_widthSelector, _themeSelector],
          ),
          Expanded(child: _viewport()),
        ],
      ),
    );
  }

  Widget get _widthSelector {
    return _PreviewSelector<_PreviewWidth>(
      values: _PreviewWidth.values,
      selected: _width,
      label: _selectionLabel,
      onChanged: (value) {
        setState(() {
          _width = value;
        });
      },
    );
  }

  Widget get _themeSelector {
    return _PreviewSelector<_PreviewTheme>(
      values: _PreviewTheme.values,
      selected: _theme,
      label: _selectionLabel,
      onChanged: (value) {
        setState(() {
          _theme = value;
        });
      },
    );
  }

  String _selectionLabel(_PreviewLabel value) {
    return value.label;
  }

  Widget _viewport() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = _viewportSize(context, constraints);
        final screenSize = BreakpointsConstants.resolve(
          size.width,
          size.height,
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: size.width,
            child: _themedViewport(context, size, screenSize),
          ),
        );
      },
    );
  }

  Size _viewportSize(BuildContext context, BoxConstraints constraints) {
    return Size(
      _width.width ?? constraints.maxWidth,
      MediaQuery.sizeOf(context).height,
    );
  }

  Widget _themedViewport(
    BuildContext context,
    Size size,
    ScreenSize screenSize,
  ) {
    final theme = _theme.resolve(screenSize);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(size: size),
      child: Theme(
        data: theme,
        child: Material(color: theme.colorScheme.surface, child: _sectionList),
      ),
    );
  }

  Widget get _sectionList {
    return ListView(
      children: [
        for (final section in _PreviewSection.values)
          _PreviewSectionView(key: ValueKey(section.name), section: section),
      ],
    );
  }
}
