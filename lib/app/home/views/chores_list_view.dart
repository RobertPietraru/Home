import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/core/presentation/navigation/navigation_cubit.dart';
import 'package:pietrocka_home/core/presentation/widgets/error/error_alert_widget.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:pietrocka_home/features/tasks/presentation/screens/task_creation_screen.dart';
import 'package:pietrocka_home/features/tasks/presentation/widgets/task_widget.dart';

import '../../domain/entities/tasks_entities.dart';

class ChoresListView extends StatefulWidget {
  final HomeEntity home;
  const ChoresListView({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  State<ChoresListView> createState() => _ChoresListViewState();
}

class _ChoresListViewState extends State<ChoresListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NavigationCubit>().navigateTo(
              context,
              BlocProvider.value(
                value: BlocProvider.of<TasksCubit>(context),
                child:
                    TaskCreationScreen(type: TaskType.chore, home: widget.home),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.status == TasksStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == TasksStatus.error) {
            return Center(
              child: ErrorAlertWidget(
                message: state.error!.message,
                code: state.error?.code,
              ),
            );
          }
          if (state.chores.isEmpty) {
            return const Center(
              child: Text("No chores"),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: state.chores.length,
            itemBuilder: (context, index) {
              final entity = state.chores[index];
              return TaskWidget(
                entity: entity,
                onPressed: () => context.read<TasksCubit>().toggleTask(entity),
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
                                  context.read<TasksCubit>().toggleTask(entity);
                                  Navigator.pop(modalContext);
                                },
                                title: Text(entity.isCompleted
                                    ? "Uncomplete"
                                    : "Complete"),
                                leading: const Icon(Icons.done)),
                            ListTile(
                              title: const Text("Edit", style: TextStyle()),
                              leading: const Icon(Icons.edit),
                              onTap: () {
                                Navigator.pop(modalContext);
                              },
                            ),
                            ListTile(
                              onTap: () {
                                context.read<TasksCubit>().deleteTask(entity);
                                Navigator.pop(modalContext);
                              },
                              title: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
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
      ),
    );
  }
}
