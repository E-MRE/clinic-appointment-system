import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/weekday_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Seven-day editor with split ranges and domain-backed inline errors.
final class WorkingHoursEditor extends StatelessWidget {
  const WorkingHoursEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.sectionTitle(
                  LocaleKeys.institution_workingHours.tr(),
                ),
              ),
              TextButton(
                onPressed: () => context
                    .read<WorkingHoursEditorCubit>()
                    .copyToWeekdays(Weekday.monday),
                child: AppText.label(
                  LocaleKeys.institution_copyToWeekdays.tr(),
                ),
              ),
            ],
          ),
          const EmptySize.s12Height(),
          BlocBuilder<WorkingHoursEditorCubit, WorkingHoursEditorState>(
            builder: (context, state) {
              return Column(
                children: [
                  for (final day in Weekday.values) _day(context, day, state),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _day(
    BuildContext context,
    Weekday day,
    WorkingHoursEditorState state,
  ) {
    final draft = state.day(day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: AppText.bodyStrong(day.label)),
            Switch(
              value: draft.isOpen,
              onChanged: (_) =>
                  context.read<WorkingHoursEditorCubit>().toggleDay(day),
            ),
          ],
        ),
        if (draft.isOpen) ...[
          for (var index = 0; index < draft.ranges.length; index++)
            Row(
              children: [
                TextButton(
                  onPressed: () => _pick(context, day, index, true),
                  child: AppText.label(draft.ranges[index].start.toString()),
                ),
                const AppText.body('–'),
                TextButton(
                  onPressed: () => _pick(context, day, index, false),
                  child: AppText.label(draft.ranges[index].end.toString()),
                ),
                IconButton(
                  tooltip: LocaleKeys.institution_rangeRemove.tr(),
                  onPressed: () => context
                      .read<WorkingHoursEditorCubit>()
                      .removeRange(day, index),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          TextButton.icon(
            onPressed: () =>
                context.read<WorkingHoursEditorCubit>().addRange(day),
            icon: const Icon(Icons.add),
            label: AppText.label(LocaleKeys.institution_rangeAdd.tr()),
          ),
        ] else
          AppText.caption(
            LocaleKeys.institution_closed.tr(),
            tone: TextTone.muted,
          ),
        if (draft.error case final error?)
          AppText.caption(error.message, tone: TextTone.error),
        const EmptySize.s8Height(),
      ],
    );
  }

  Future<void> _pick(
    BuildContext context,
    Weekday day,
    int index,
    bool start,
  ) async {
    final editor = context.read<WorkingHoursEditorCubit>();
    final draft = editor.state.day(day).ranges[index];
    final original = start ? draft.start : draft.end;
    final chosen = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: original.hour, minute: original.minute),
    );
    if (chosen == null || !context.mounted) return;
    final time = ClockTime(hour: chosen.hour, minute: chosen.minute);
    editor.updateRange(
      day,
      index,
      start ? time : draft.start,
      start ? draft.end : time,
    );
  }
}
