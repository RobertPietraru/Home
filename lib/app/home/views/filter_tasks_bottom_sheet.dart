import 'package:flutter/material.dart';
import 'package:homeapp/core/utils/translator.dart';

import '../../../core/components/components.dart';

class FilterTasksBottomSheet extends StatelessWidget {
  const FilterTasksBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
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
                    onPressed: () {},
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
                    isSelected: true, label: 'Creation date', onPressed: () {}),
                SizedBox(height: theme.spacing.medium),
                SortOption(
                    isSelected: false, label: 'Deadline', onPressed: () {}),
                SizedBox(height: theme.spacing.medium),
                SortOption(
                    isSelected: false, label: 'Importance', onPressed: () {}),
              ],
            ),
            SizedBox(height: theme.spacing.medium),
            Text("Filter by asignee", style: theme.subtitleTextStyle),
            SizedBox(height: theme.spacing.small),
            DropdownPickerInputField(
              leadingIcon: Icons.person,
              options: const ['Bob', 'John', 'Mark'],
              onChanged: (e) {},
              hint: 'Nobody is selected',
            ),
            CheckboxInputField(
                value: true, title: 'Show completed tasks', onChanged: (e) {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.translator.cancel)),
                SizedBox(width: theme.spacing.small),
                FilledButton(
                    onPressed: () {},
                    child: Text("Apply", style: theme.actionTextStyle)),
              ],
            ),
          ]),
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
