import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice_controls.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:clinic_appointment_system/core/widgets/system_overlay_region.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'preview_label.dart';
part 'preview_viewport.dart';
part 'preview_themed_viewport.dart';
part 'preview_selector.dart';
part 'preview_width.dart';
part 'preview_theme.dart';
part 'preview_section.dart';
part 'preview_section_view.dart';
part 'text_section.dart';
part 'surface_section.dart';
part 'status_section.dart';
part 'header_section.dart';
part 'states_section.dart';
part 'loading_section.dart';
part 'list_section.dart';
part 'data_table_section.dart';
part 'preview_appointments_table.dart';
part 'preview_services_table.dart';
part 'avatar_section.dart';
part 'fields_section.dart';
part 'navigation_section.dart';
part 'other_section.dart';
part 'tier_preview.dart';

/// Developer-facing catalogue of shared components.
final class ComponentPreviewPage extends StatefulWidget {
  /// Creates the local component catalogue.
  const ComponentPreviewPage({super.key});

  @override
  State<ComponentPreviewPage> createState() {
    return _PreviewState();
  }
}

/// Owns the catalogue's local theme and viewport choices.
final class _PreviewState extends State<ComponentPreviewPage> {
  late _PreviewWidth _width;
  late _PreviewTheme _theme;

  @override
  void initState() {
    super.initState();
    _width = _PreviewWidth.automatic;
    _theme = _PreviewTheme.light;
  }

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
          Expanded(
            child: _PreviewViewport(width: _width, theme: _theme),
          ),
        ],
      ),
    );
  }

  Widget get _widthSelector {
    return _PreviewSelector<_PreviewWidth>(
      values: _PreviewWidth.values,
      selected: _width,
      label: (value) => value.label,
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
      label: (value) => value.label,
      onChanged: (value) {
        setState(() {
          _theme = value;
        });
      },
    );
  }
}

/// Owns the editable form examples.
final class _FieldsContent extends StatefulWidget {
  @override
  State<_FieldsContent> createState() {
    return _FieldsContentState();
  }
}

/// Manages the form example controllers.
final class _FieldsContentState extends State<_FieldsContent> {
  late final TextEditingController _normal;
  late final TextEditingController _disabled;
  late final TextEditingController _error;
  late final TextEditingController _helper;

  @override
  void initState() {
    super.initState();
    _normal = TextEditingController();
    _disabled = TextEditingController();
    _error = TextEditingController();
    _helper = TextEditingController();
  }

  @override
  void dispose() {
    _normal.dispose();
    _disabled.dispose();
    _error.dispose();
    _helper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    final error = LocaleKeys.componentPreview_error.translate();
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          AppTextField(
            label: sample,
            controller: _normal,
            prefixIconAsset: Assets.images.auth.email,
          ),
          AppTextField(
            label: LocaleKeys.componentPreview_disabled.translate(),
            controller: _disabled,
            enabled: false,
          ),
          AppTextField(
            label: error,
            controller: _error,
            validator: (_) {
              return error;
            },
          ),
          AppTextField(
            label: LocaleKeys.componentPreview_helper.translate(),
            controller: _helper,
            helper: LocaleKeys.componentPreview_helper.translate(),
          ),
          AppSelectField<String>(
            label: sample,
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
          ),
          AppSelectField<String>(
            label: LocaleKeys.componentPreview_disabled.translate(),
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
            enabled: false,
          ),
          AppSelectField<String>(
            label: error,
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
            validator: (_) {
              return error;
            },
          ),
        ],
      ),
    );
  }
}

/// Displays interactive choice controls.
final class _ChoicesSection extends StatefulWidget {
  const _ChoicesSection();

  @override
  State<_ChoicesSection> createState() {
    return _ChoicesSectionState();
  }
}

/// Keeps the two example selections independent.
final class _ChoicesSectionState extends State<_ChoicesSection> {
  late _PreviewTheme _filter;
  late _PreviewTheme _segment;

  @override
  void initState() {
    super.initState();
    _filter = _PreviewTheme.light;
    _segment = _PreviewTheme.light;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        AppFilterChips(
          choices: [
            for (final theme in _PreviewTheme.values)
              AppChoice(value: theme, label: theme.label.translate()),
          ],
          selected: _filter,
          onSelected: (value) {
            setState(() {
              _filter = value;
            });
          },
        ),
        AppSegmentedControl(
          choices: [
            for (final theme in _PreviewTheme.values)
              AppChoice(value: theme, label: theme.label.translate()),
          ],
          selected: _segment,
          onSelected: (value) {
            setState(() {
              _segment = value;
            });
          },
        ),
      ],
    );
  }
}
