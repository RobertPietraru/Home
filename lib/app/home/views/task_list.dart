import 'package:auth/auth.dart';
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
  final HomeEntity home;
  final TaskType type;
  const TaskList({
    Key? key,
    required this.home,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final errorMessage = type == TaskType.chore
        ? context.translator.noChores
        : context.translator.noShoppingList;
    final title = type == TaskType.chore
        ? context.translator.chores
        : context.translator.shoppingList;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.companyColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return BlocProvider.value(
              value: BlocProvider.of<TasksCubit>(context),
              child: TaskCreationScreen(type: type, home: home),
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
                              builder: (_) => Column(
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
                                      BlocProvider.value(
                                        value:
                                            context.read<TaskFilteringCubit>()
                                              ..makeCheckpoint(),
                                        child: FilterTasksBottomSheet(
                                          home: home,
                                          type: type,
                                          assignees: const [
                                            UserEntity(id: 'id', name: 'John'),
                                            UserEntity(id: 'id2', name: 'Bob'),
                                          ],
                                        ),
                                      ),
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
              type == TaskType.chore ? state.chores : state.shoppingList;
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
              final task = list[index];
              return TaskWidget(
                task: task,
                onPressed: () => context
                    .read<TasksCubit>()
                    .toggleTask(task, context.translator),
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return TaskOptionsBottomSheet(task: task);
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
