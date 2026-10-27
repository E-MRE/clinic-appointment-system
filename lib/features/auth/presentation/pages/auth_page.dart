import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_error_code_localization.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_footer_config.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_form_values.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'auth_account_link.dart';
part 'auth_account_roles.dart';
part 'auth_brand_item.dart';
part 'auth_brand_message.dart';
part 'auth_brand_panel.dart';
part 'auth_confirmation_field.dart';
part 'auth_email_field.dart';
part 'auth_feedback_message.dart';
part 'auth_form_content.dart';
part 'auth_form_feedback.dart';
part 'auth_form_fields.dart';
part 'auth_form_footer.dart';
part 'auth_form_header.dart';
part 'auth_heading.dart';
part 'auth_name_field.dart';
part 'auth_page_layout.dart';
part 'auth_password_field.dart';
part 'auth_password_fields.dart';
part 'auth_password_input.dart';
part 'auth_registration_steps.dart';
part 'auth_request_form.dart';
part 'auth_request_form_mixin.dart';
part 'auth_role_item.dart';
part 'auth_shell.dart';
part 'auth_step_item.dart';
part 'auth_submit_button.dart';

/// Template for a screen-owned request Cubit and the shared form lifecycle.
/// Subclasses provide the visual variant and invoke their concrete request.
abstract class AuthPage<C extends AuthRequestCubit> extends StatelessWidget {
  const AuthPage({required this.createCubit, super.key});

  /// Creates a request Cubit owned and disposed by this page's provider.
  final C Function() createCubit;

  /// Supplies the labels, fields and responsive layout for this screen.
  AuthFormKind get kind;

  /// Executes the concrete request with the current form input.
  Future<void> submit(C cubit, AuthFormValues values);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(
      create: (_) => createCubit(),
      child: _AuthRequestForm<C>(page: this),
    );
  }
}
