import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/components/components.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../blocs/tasks_cubit/tasks_cubit.dart';
import '../screens/task_creation_screen.dart';
import '../widgets/task_widget.dart';

class TaskList extends StatefulWidget {
  final HomeEntity home;
  final TaskType type;
  const TaskList({
    Key? key,
    required this.home,
    required this.type,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final errorMessage = widget.type == TaskType.chore
        ? context.translator.noChores
        : context.translator.noShoppingList;
    final title = widget.type == TaskType.chore
        ? context.translator.chores
        : context.translator.shoppingList;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.companyColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return BlocProvider.value(
              value: BlocProvider.of<TasksCubit>(context),
              child: TaskCreationScreen(type: widget.type, home: widget.home),
            );
          },
        )),
        child: const Icon(Icons.add),
      ),
      body: NestedScrollView(headerSliverBuilder: (context, _) {
        return [
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: theme.standardPadding.copyWith(top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: theme.spacing.large,
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20).copyWith(
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              )),
                              builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: theme.spacing.medium),
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 5,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                      const FilterTasksDialog(),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.sort))
                  ],
                ),
              ),
            ]),
          ),
        ];
      }, body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          final list =
              widget.type == TaskType.chore ? state.chores : state.shoppingList;
          if (state.status == TasksStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == TasksStatus.error) {
            return Center(
              child: Text(
                  state.error?.message ?? context.translator.somethingWentWrong,
                  style: theme.informationTextStyle.copyWith(color: theme.bad)),
            );
          }
          if (list.isEmpty) {
            return Center(
              child: Text(errorMessage),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: list.length,
            itemBuilder: (context, index) {
              final entity = list[index];
              return TaskWidget(
                task: entity,
                onPressed: () => context
                    .read<TasksCubit>()
                    .toggleTask(entity, context.translator),
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (modalContext) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                onTap: () {
                                  context
                                      .read<TasksCubit>()
                                      .toggleTask(entity, context.translator);
                                  Navigator.pop(modalContext);
                                },
                                title: Text(entity.isCompleted
                                    ? context.translator.markUncomplete
                                    : context.translator.markComplete),
                                leading: const Icon(Icons.done)),
                            ListTile(
                              title: Text(context.translator.edit),
                              leading: const Icon(Icons.edit),
                              onTap: () => Navigator.pop(modalContext),
                            ),
                            ListTile(
                              onTap: () {
                                context
                                    .read<TasksCubit>()
                                    .deleteTask(entity, context.translator);
                                Navigator.pop(modalContext);
                              },
                              title: Text(context.translator.delete,
                                  style: const TextStyle(color: Colors.red)),
                              leading:
                                  const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      )),
    );
  }
}

class FilterTasksDialog extends StatelessWidget {
  const FilterTasksDialog({
    super.key,
  });

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
                  isSelected: true,
                  label: 'Creation date',
                  onPressed: () {},
                ),
                SizedBox(height: theme.spacing.medium),
                SortOption(
                  isSelected: false,
                  label: 'Deadline',
                  onPressed: () {},
                ),
                SizedBox(height: theme.spacing.medium),
                SortOption(
                  isSelected: false,
                  label: 'Importance',
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: theme.spacing.medium),
            Text("Filter by asignee", style: theme.subtitleTextStyle),
            SizedBox(height: theme.spacing.small),
            StringDropdownTextField(
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

class StringDropdownTextField extends StatefulWidget {
  final List<String> options;

  final Function(String) onChanged;
  final String hint;
  final String? error;
  final IconData? leading;
  final Color? backgroundColor;
  final String? initialValue;
  final TextInputType? keyboardType;

  const StringDropdownTextField({
    Key? key,
    required this.options,
    required this.onChanged,
    required this.hint,
    this.error,
    this.leading,
    this.backgroundColor,
    this.initialValue,
    this.keyboardType,
  }) : super(key: key);

  @override
  _StringDropdownTextFieldState createState() =>
      _StringDropdownTextFieldState();
}

class _StringDropdownTextFieldState extends State<StringDropdownTextField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue!);
      },
      items: widget.options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor:
            widget.backgroundColor ?? const Color.fromARGB(255, 212, 212, 212),
        filled: true,
        hintText: widget.hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        prefixIcon: widget.leading == null ? null : Icon(widget.leading),
        errorStyle: TextStyle(fontSize: theme.spacing.mediumLarge),
        errorText: widget.error,
      ),
    );
  }
}
