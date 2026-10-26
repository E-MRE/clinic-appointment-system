import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice_controls.dart';
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

part 'preview_state.dart';
part 'preview_label.dart';
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
part 'avatar_section.dart';
part 'fields_section.dart';
part 'fields_content.dart';
part 'fields_content_state.dart';
part 'choices_section.dart';
part 'choices_section_state.dart';
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
