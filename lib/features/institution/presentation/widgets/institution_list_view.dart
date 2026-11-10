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
import 'package:flutter_bloc/flutter_bloc.dart';

part 'institution_list_failure.dart';
part 'institution_list_empty.dart';

/// Applies the same loading, failure and empty views to institution lists.
final class InstitutionListView<
  T,
  C extends StateStreamable<InstitutionListState<T>>
>
    extends StatelessWidget {
  const InstitutionListView({
    required this.emptyTitle,
    required this.emptyMessage,
    required this.onRetry,
    required this.loadedBuilder,
    this.emptyAction,
    this.loadingVariant = LoadingStateVariant.skeletonList,
    super.key,
  });

  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget Function(List<T>) loadedBuilder;
  final Widget? emptyAction;
  final LoadingStateVariant loadingVariant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, InstitutionListState<T>>(
      builder: (context, state) => _buildChild(state),
    );
  }

  Widget _buildChild(InstitutionListState<T> state) {
    if (state is InstitutionListFailure<T>) {
      return _InstitutionListFailure(
        message: state.code.message,
        onRetry: onRetry,
      );
    }

    if (state is InstitutionListLoaded<T>) {
      if (state.items.isEmpty) {
        return _InstitutionListEmpty(
          title: emptyTitle,
          message: emptyMessage,
          action: emptyAction,
        );
      }
      return loadedBuilder(state.items);
    }

    return LoadingState(
      variant: loadingVariant,
      label: LocaleKeys.institution_loading.tr(),
    );
  }
}
