import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/task_filtering/task_filtering_cubit.dart';
import 'package:homeapp/core/components/components.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../blocs/tasks_cubit/tasks_cubit.dart';
import '../screens/task_creation_screen.dart';
import '../widgets/task_widget.dart';
import 'filter_tasks_bottom_sheet.dart';

class TaskList extends StatelessWidget {
  final TaskType type;
  const TaskList({
    Key? key,
    required this.type,
  }) : super(key: key);

  String getErrorMessage(Translator translator) {
    return type == TaskType.chore
        ? translator.noChores
        : translator.noShoppingList;
  }

  String getTitle(Translator translator) {
    return type == TaskType.chore ? translator.chores : translator.shoppingList;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.companyColor,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TasksCubit>(),
                child: TaskCreationScreen(
                  home: context.read<TasksCubit>().home,
                  type: type,
                ),
              ),
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
                      getTitle(context.translator),
                      style: TextStyle(
                        color: theme.secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: theme.spacing.large,
                      ),
                    ),
                    BlocBuilder<TaskFilteringCubit, TaskFilteringState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                              color:
                                  state.isFiltered ? theme.companyColor : null,
                              shape: BoxShape.circle),
                          child: IconButton(
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
                                    builder: (_) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                height: theme.spacing.medium),
                                            Center(
                                              child: Container(
                                                width: 30,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            ),
                                            BlocProvider.value(
                                              value: context
                                                  .read<TaskFilteringCubit>()
                                                ..makeCheckpoint(),
                                              child: FilterTasksBottomSheet(
                                                  home: context
                                                      .read<TasksCubit>()
                                                      .home,
                                                  type: type),
                                            ),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.sort,
                                color: state.isFiltered
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        );
                      },
                    )
                  ],
                ),
              ),
            ]),
          ),
        ];
      }, body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
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
          if (state.tasks.isEmpty) {
            return Center(
              child: Text(getErrorMessage(context.translator)),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskWidget(
                task: task,
                onPressed: () => context
                    .read<TasksCubit>()
                    .toggleTask(task, context.translator),
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<TasksCubit>(),
                        child: TaskOptionsBottomSheet(task: task),
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

class TaskOptionsBottomSheet extends StatelessWidget {
  const TaskOptionsBottomSheet({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              onTap: () {
                context.read<TasksCubit>().toggleTask(task, context.translator);
                Navigator.pop(context);
              },
              title: Text(task.isCompleted
                  ? context.translator.markUncomplete
                  : context.translator.markComplete),
              leading: const Icon(Icons.done)),
          ListTile(
            title: Text(context.translator.edit),
            leading: const Icon(Icons.edit),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            onTap: () {
              context.read<TasksCubit>().deleteTask(task, context.translator);
              Navigator.pop(context);
            },
            title: Text(context.translator.delete,
                style: const TextStyle(color: Colors.red)),
            leading: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
