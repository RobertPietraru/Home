import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/task_filtering/task_filtering_cubit.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../core/components/components.dart';

class FilterTasksBottomSheet extends StatelessWidget {
  final HomeEntity home;
  final TaskType type;
  const FilterTasksBottomSheet(
      {super.key, required this.home, required this.type});

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
                    Text(context.translator.filter, style: theme.titleTextStyle),
                    FilledButton(
                        onPressed: state.canReset
                            ? () {
                                Navigator.pop(context);
                                context.read<TaskFilteringCubit>().reset();
                              }
                            : null,
                        child: Text(
                          context.translator.reset,
                          style: theme.actionTextStyle,
                        )),
                  ],
                ),
                SizedBox(height: theme.spacing.medium),
                Text(context.translator.sortBy, style: theme.subtitleTextStyle),
                SizedBox(height: theme.spacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SortOption(
                      label: context.translator.creationDate,
                      isSelected: state.sortFilters
                          .contains(TaskSortFilter.creationDate),
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.creationDate),
                    ),
                    SizedBox(height: theme.spacing.medium),
                    SortOption(
                      isSelected:
                          state.sortFilters.contains(TaskSortFilter.deadline),
                      label: context.translator.deadline,
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.deadline),
                    ),
                    SizedBox(height: theme.spacing.medium),
                    SortOption(
                      isSelected:
                          state.sortFilters.contains(TaskSortFilter.importance),
                      label: context.translator.importance,
                      onPressed: () => context
                          .read<TaskFilteringCubit>()
                          .toggleSortFilter(TaskSortFilter.importance),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.medium),
                // Text("Filter by asignee", style: theme.subtitleTextStyle),
                // SizedBox(height: theme.spacing.small),
                // DropdownPickerInputField(
                //   options: assignees,
                //   leadingIcon: Icons.person,
                //   onChanged: (e) => context.read<TaskFilteringCubit>().selectAssignee(e),
                //   hint: 'Nobody is selected',
                //   initialValue: state.selectedAsignee,
                //   getChild: (option) => Text(option.name),
                // ),
                CheckboxInputField(
                    value: state.showCompletedTasks,
                    title: context.translator.showCompletedTasks,
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
                        child:  Text(context.translator.cancel)),
                    SizedBox(width: theme.spacing.small),
                    FilledButton(
                        onPressed: () {
                          context
                              .read<TaskFilteringCubit>()
                              .apply(context.translator);
                          Navigator.pop(context);
                        },
                        child: Text(context.translator.apply, style: theme.actionTextStyle)),
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
