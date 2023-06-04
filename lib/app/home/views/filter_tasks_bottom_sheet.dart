import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/task_filtering/task_filtering_cubit.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../core/components/components.dart';

class FilterTasksBottomSheet extends StatelessWidget {
  final List<UserEntity> assignees;
  final HomeEntity home;
  final TaskType type;
  const FilterTasksBottomSheet(
      {super.key,
      required this.assignees,
      required this.home,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<TaskFilteringCubit, TaskFilteringState>(
      builder: (context, state) {
        return Padding(
          padding: theme.standardPadding,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filter", style: theme.titleTextStyle),
                    FilledButton(
                        onPressed: state.canReset
                            ? context.read<TaskFilteringCubit>().reset
                            : null,
                        child: Text(
                          "Reset",
                          style: theme.actionTextStyle,
                        )),
                  ],
                ),
                SizedBox(height: theme.spacing.medium),
                Text("Sort by: ", style: theme.subtitleTextStyle),
                SizedBox(height: theme.spacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SortOption(
                      label: 'Creation date',
                      isSelected:
                          state.sortFilters.contains(TaskSortFilter.creationDate),
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.creationDate),
                    ),
                    SizedBox(height: theme.spacing.medium),
                    SortOption(
                      isSelected:
                          state.sortFilters.contains(TaskSortFilter.deadline),
                      label: 'Deadline',
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.deadline),
                    ),
                    SizedBox(height: theme.spacing.medium),
                    SortOption(
                      isSelected:
                          state.sortFilters.contains(TaskSortFilter.importance),
                      label: 'Importance',
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.importance),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.medium),
                Text("Filter by asignee", style: theme.subtitleTextStyle),
                SizedBox(height: theme.spacing.small),
                DropdownPickerInputField(
                  options: assignees,
                  leadingIcon: Icons.person,
                  onChanged: (e) =>
                      context.read<TaskFilteringCubit>().selectAssignee(e),
                  hint: 'Nobody is selected',
                  initialValue: state.selectedAsignee,
                  getChild: (option) => Text(option.name),
                ),
                CheckboxInputField(
                    value: state.showCompletedTasks,
                    title: 'Show completed tasks',
                    onChanged: (e) => e == null
                        ? null
                        : context
                            .read<TaskFilteringCubit>()
                            .setShowComletedTasks(e)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          context.read<TaskFilteringCubit>().cancel();
                        },
                        child: const Text('Cancel')),
                    SizedBox(width: theme.spacing.small),
                    FilledButton(
                        onPressed: () {
                          context
                              .read<TaskFilteringCubit>()
                              .apply(type, home, context.translator);
                          Navigator.pop(context);
                        },
                        child: Text("Apply", style: theme.actionTextStyle)),
                  ],
                ),
              ]),
        );
      },
    );
  }
}

class SortOption extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  const SortOption({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Ink(
          width: 25.widthPercent,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isSelected ? theme.good : Colors.grey[400],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
              child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold),
          ))),
    );
  }
}
