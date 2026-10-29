import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
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
part 'auth_brand_panel_content.dart';
part 'auth_brand_switcher.dart';
part 'auth_confirmation_field.dart';
part 'auth_email_field.dart';
part 'auth_feedback_message.dart';
part 'auth_form_content.dart';
part 'auth_forgot_password_button.dart';
part 'auth_form_actions.dart';
part 'auth_form_feedback.dart';
part 'auth_form_fields.dart';
part 'auth_name_group.dart';
part 'auth_password_group.dart';
part 'auth_form_footer.dart';
part 'auth_form_header.dart';
part 'auth_heading.dart';
part 'auth_heading_logo.dart';
part 'auth_heading_texts.dart';
part 'auth_name_field.dart';
part 'auth_page_layout.dart';
part 'auth_form_host.dart';
part 'auth_request_view.dart';
part 'auth_mobile_form.dart';
part 'auth_scrolling_form.dart';
part 'auth_form_surface.dart';
part 'auth_back_button.dart';

part 'auth_password_suffix.dart';
part 'auth_password_fields.dart';
part 'auth_password_input.dart';
part 'auth_registration_steps.dart';
part 'auth_request_form_mixin.dart';
part 'auth_role_item.dart';
part 'auth_shell.dart';
part 'auth_step_item.dart';
part 'auth_submit_button.dart';

/// Template for a screen-owned request Cubit and the shared form lifecycle.
/// Subclasses provide the visual variant and invoke their concrete request.
abstract class AuthPage<C extends AuthRequestCubit> extends StatelessWidget {
  const AuthPage({super.key});

  /// Supplies the labels, fields and responsive layout for this screen.
  AuthFormKind get kind;

  /// Executes the concrete request with the current form input.
  Future<void> submit(C cubit, AuthFormValues values);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(
      create: (_) => AppDependency.injector.get<C>(),
      child: _AuthRequestForm<C>(page: this),
    );
  }
}

/// Connects request/session listeners to the screen's form and layout.
final class _AuthRequestForm<C extends AuthRequestCubit>
    extends StatefulWidget {
  const _AuthRequestForm({required this.page});

  final AuthPage<C> page;

  @override
  State<_AuthRequestForm<C>> createState() {
    return _AuthRequestFormState<C>();
  }
}

final class _AuthRequestFormState<C extends AuthRequestCubit>
    extends State<_AuthRequestForm<C>>
    with _AuthRequestFormMixin<C> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(listener: _onSessionChanged),
        BlocListener<C, AuthRequestState>(listener: _onRequestChanged),
      ],
      child: _AuthRequestView<C>(
        kind: _kind,
        formKey: _formKey,
        fullName: _fullName,
        email: _email,
        password: _password,
        confirmation: _confirmation,
        onSubmit: _submit,
        busyStateChanged: _busyStateChanged,
      ),
    );
  }
}

/// Owns password visibility without rebuilding or replacing its controller.
final class _AuthPasswordField extends StatefulWidget {
  const _AuthPasswordField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.validator,
    required this.fieldKey,
    required this.autofillHints,
    required this.textInputAction,
    required this.onSubmitted,
    this.helper,
    this.showPrefix = false,
  });
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;
  final Key fieldKey;
  final Iterable<String> autofillHints;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;
  final String? helper;
  final bool showPrefix;

  @override
  State<_AuthPasswordField> createState() {
    return _AuthPasswordFieldState();
  }
}

final class _AuthPasswordFieldState extends State<_AuthPasswordField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      fieldKey: widget.fieldKey,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      helper: widget.helper,
      obscureText: _obscured,
      prefixIconAsset: widget.showPrefix ? Assets.images.auth.lock : null,
      suffix: _AuthPasswordSuffix(
        obscured: _obscured,
        enabled: widget.enabled,
        onPressed: _toggleObscured,
      ),
    );
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
