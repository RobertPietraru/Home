import 'package:flutter/material.dart';
import 'package:household/household.dart';

class TaskWidget extends StatelessWidget {
  final TaskEntity entity;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  const TaskWidget({
    super.key,
    required this.entity,
    required this.onPressed,
    required this.onLongPress,
  });

  double getPercentTillDeadline() {
    if (entity.deadline == null) return 0;
    final creationDate = entity.creationDate;
    final present = DateTime.now();
    final deadlineDate = entity.deadline!;
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
    final score = (getPercentTillDeadline() + entity.importance) / 2;
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
    return ListTile(
      title: Text(
        entity.body,
        style: TextStyle(
            color: entity.isCompleted ? Colors.grey : Colors.black,
            decoration: entity.isCompleted ? TextDecoration.lineThrough : null),
      ),
      onTap: onPressed,
      onLongPress: onLongPress,
      leading: entity.type == TaskType.chore
          ? const Icon(Icons.cleaning_services)
          : const Icon(Icons.shopping_bag),
      trailing: entity.isCompleted
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
