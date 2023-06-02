import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../core/components/theme/app_theme.dart';
import '../blocs/tasks_cubit/tasks_cubit.dart';
import '../screens/task_creation_screen.dart';
import '../widgets/task_widget.dart';

class ShoppingListView extends StatelessWidget {
  final HomeEntity home;
  const ShoppingListView({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.companyColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<TasksCubit>(context),
                  child:
                      TaskCreationScreen(type: TaskType.shopping, home: home),
                ),
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
            return Center(
              child: Text(context.translator.noShoppingList),
            );
          }

          if (state.status == TasksStatus.error) {
            return Center(
              child: Text(
                  state.error?.message ?? context.translator.somethingWentWrong,
                  style: theme.informationTextStyle.copyWith(color: theme.bad)),
            );
          }
          return ListView.separated(
            itemCount: state.shoppingList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final entity = state.shoppingList[index];
              return TaskWidget(
                entity: entity,
                onPressed: () => context
                    .read<TasksCubit>()
                    .toggleTask(entity, context.translator),
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
                onTap: () {
                  Navigator.pop(modalContext);
                },
              ),
              ListTile(
                onTap: () {
                  context
                      .read<TasksCubit>()
                      .deleteTask(entity, context.translator);
                  Navigator.pop(modalContext);
                },
                title: Text(context.translator.delete,
                    style: TextStyle(color: Colors.red)),
                leading: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}
