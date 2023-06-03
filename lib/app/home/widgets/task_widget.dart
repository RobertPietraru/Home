import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:household/household.dart';

class TaskWidget extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  const TaskWidget({
    super.key,
    required this.task,
    required this.onPressed,
    required this.onLongPress,
  });

  double getPercentTillDeadline() {
    if (task.deadline == null) return 0;
    final creationDate = task.creationDate;
    final present = DateTime.now();
    final deadlineDate = task.deadline!;
    //// ----------------------C----------P-------------D
    if (present.isAfter(deadlineDate)) {
      /// we went over the deadline
      return 1;
    }

    final fromCreationToDeadline = present.difference(creationDate);
    final fromPresentToDeadline = deadlineDate.difference(creationDate);

    if (fromPresentToDeadline.inHours == 0) {
      return 0;
    }
    return fromCreationToDeadline.inHours / fromPresentToDeadline.inHours;
  }

  Color getColorCode() {
    final score = task.importance;

    if (score < 0.4) {
      return Colors.green;
    }
    if (score < 0.6) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return ListTile(
      contentPadding: theme.standardPadding.copyWith(bottom: 0, top: 0),
      title: Text(
        task.body,
        style: TextStyle(
            color: task.isCompleted ? Colors.grey : Colors.black,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null),
      ),
      onTap: onPressed,
      onLongPress: onLongPress,
      leading: task.type == TaskType.chore
          ? const Icon(Icons.cleaning_services)
          : const Icon(Icons.shopping_bag),
      trailing: task.isCompleted
          ? const Icon(Icons.done)
          : Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: getColorCode()),
            ),
    );
  }
}
