import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_fab.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet_presentation.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_sheet_actions.dart';
import 'package:clinic_appointment_system/core/widgets/checkbox_tile/app_checkbox_tile.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice_controls.dart';
import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel_layout.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
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
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'availability_components_preview.dart';
part 'preview_label.dart';
part 'preview_viewport.dart';
part 'preview_themed_viewport.dart';
part 'preview_selector.dart';
part 'preview_width.dart';
part 'preview_theme.dart';
part 'preview_theme_data.dart';
part 'preview_section.dart';
part 'preview_section_content.dart';
part 'preview_section_view.dart';
part 'text_section.dart';
part 'text_section_sample.dart';
part 'surface_section.dart';
part 'status_section.dart';
part 'header_section.dart';
part 'states_section.dart';
part 'loading_section.dart';
part 'list_section.dart';
part 'data_table_section.dart';
part 'preview_appointment.dart';
part 'preview_appointments_table.dart';
part 'preview_appointments_header.dart';
part 'preview_appointment_patient_cell.dart';
part 'preview_service.dart';
part 'preview_services_table.dart';
part 'preview_service_cell.dart';
part 'avatar_section.dart';
part 'fields_section.dart';
part 'fields_content.dart';
part 'fields_text_fields.dart';
part 'fields_basic_text_fields.dart';
part 'fields_feedback_text_fields.dart';
part 'fields_select_fields.dart';
part 'fields_basic_select_fields.dart';
part 'fields_error_select_field.dart';
part 'choices_section.dart';
part 'choices_filter_chips.dart';
part 'choices_segmented_control.dart';
part 'navigation_section.dart';
part 'navigation_preview_shell.dart';
part 'other_section.dart';
part 'shared_actions_preview.dart';
part 'other_section_viewport_preview.dart';
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
