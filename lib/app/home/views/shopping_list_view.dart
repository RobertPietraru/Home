import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/features/tasks/domain/entities/home_entity.dart';
import 'package:pietrocka_home/features/tasks/presentation/widgets/task_widget.dart';

import '../../../../core/presentation/navigation/navigation_cubit.dart';
import '../../../../core/presentation/widgets/error/error_alert_widget.dart';
import '../../domain/entities/task_entity.dart';
import '../blocs/tasks_cubit/tasks_cubit.dart';
import '../screens/task_creation_screen.dart';

class ShoppingListView extends StatelessWidget {
  final HomeEntity home;
  const ShoppingListView({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NavigationCubit>().navigateTo(
              context,
              BlocProvider.value(
                value: BlocProvider.of<TasksCubit>(context),
                child: TaskCreationScreen(type: TaskType.shopping, home: home),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.status == TasksStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.shoppingList.isEmpty) {
            return const Center(
              child: Text("No shopping List"),
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
          return ListView.separated(
            itemCount: state.shoppingList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final entity = state.shoppingList[index];
              return TaskWidget(
                entity: entity,
                onPressed: () => context.read<TasksCubit>().toggleTask(entity),
                onLongPress: () => showBottomSheet(context, entity),
              );
            },
          );
        },
      ),
    );
  }

  void showBottomSheet(BuildContext context, TaskEntity entity) async {
    await showModalBottomSheet(
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
                  title: Text(entity.isCompleted ? "Uncomplete" : "Complete"),
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
                title:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
                leading: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}
