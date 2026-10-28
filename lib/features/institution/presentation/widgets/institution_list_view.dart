import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Applies the same loading, failure and empty views to institution lists.
final class InstitutionListView<T> extends StatelessWidget {
  const InstitutionListView({
    required this.state,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.onRetry,
    required this.loadedBuilder,
    this.emptyAction,
    this.loadingVariant = LoadingStateVariant.skeletonList,
    super.key,
  });

  final InstitutionListState<T> state;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget Function(List<T>) loadedBuilder;
  final Widget? emptyAction;
  final LoadingStateVariant loadingVariant;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      InstitutionListLoading<T>() => LoadingState(
        variant: loadingVariant,
        label: LocaleKeys.institution_loading.tr(),
      ),
      InstitutionListFailure<T>(:final code) => ErrorState(
        title: LocaleKeys.institution_errors_unavailable.tr(),
        message: code.message,
        icon: const Icon(Icons.error_outline),
        iconBackground: context.colorScheme.errorContainer,
        primaryAction: FilledButton(
          onPressed: onRetry,
          child: AppText.label(
            LocaleKeys.institution_retry.tr(),
            tone: TextTone.onPrimary,
          ),
        ),
      ),
      InstitutionListLoaded<T>(:final items) when items.isEmpty => EmptyState(
        title: emptyTitle,
        message: emptyMessage,
        icon: const Icon(Icons.inbox_outlined),
        iconBackground: context.colorScheme.surfaceContainerHighest,
        primaryAction: emptyAction,
      ),
      InstitutionListLoaded<T>(:final items) => loadedBuilder(items),
    };
  }
}
