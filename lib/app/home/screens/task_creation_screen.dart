// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/core/global/styles.dart';
import 'package:pietrocka_home/core/presentation/navigation/navigation_cubit.dart';
import 'package:pietrocka_home/core/presentation/widgets/buttons/long_button.dart';
import 'package:pietrocka_home/core/presentation/widgets/inputfields/text_input_field.dart';
import 'package:pietrocka_home/core/presentation/widgets/pietrocka_appbar.dart';
import 'package:pietrocka_home/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:pietrocka_home/features/tasks/domain/entities/home_entity.dart';
import 'package:pietrocka_home/features/tasks/domain/entities/task_entity.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/task_creation_cubit/task_creation_cubit.dart';
import 'package:pietrocka_home/core/config/injection.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TaskCreationScreen extends StatelessWidget {
  final TaskType type;
  final HomeEntity home;
  const TaskCreationScreen({super.key, required this.type, required this.home});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PietrockaAppBar(
          trailing: Icon(type == TaskType.chore
              ? Icons.cleaning_services
              : Icons.shopping_bag)),
      body: BlocProvider(
        create: (context) => TaskCreationCubit(
          locator(),
          tasksCubit: context.read<TasksCubit>(),
        ),
        child: TaskCreationChildScreen(
          type: type,
          home: home,
        ),
      ),
    );
  }
}

class TaskCreationChildScreen extends StatelessWidget {
  final TaskType type;
  final HomeEntity home;
  const TaskCreationChildScreen(
      {super.key, required this.type, required this.home});

  String indicatorBasedOnPosition(double position) {
    if (position < 0.4) {
      return "Unimportant";
    }
    if (position < 0.6) {
      return "Quite important";
    }
    return "Very important";
  }

  Color indicatorColorBasedOnPosition(double position) {
    if (position < 0.4) {
      return Colors.green;
    }
    if (position < 0.6) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCreationCubit, TaskCreationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInputField(
                  onChanged: context.read<TaskCreationCubit>().titleChanged,
                  hint: "Title",
                  prefixIcon: Icons.home,
                  error: state.homebodyErrorMessage,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Importance:",
                      style: Styles.titleStyle1,
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorColor:
                              indicatorColorBasedOnPosition(state.importance),
                          thumbColor:
                              indicatorColorBasedOnPosition(state.importance),
                          trackHeight: 10,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 15,
                            pressedElevation: 20,
                            elevation: 10 * state.importance,
                          ),
                          activeTrackColor:
                              indicatorColorBasedOnPosition(state.importance),
                          valueIndicatorTextStyle:
                              const TextStyle(fontSize: 18)),
                      child: Slider(
                          label: indicatorBasedOnPosition(state.importance),
                          min: 0,
                          max: 1,
                          value: state.importance,
                          onChanged: (val) {
                            context
                                .read<TaskCreationCubit>()
                                .importanceChanged(val);
                          }),
                    )
                  ],
                ),
                SfDateRangePicker(
                  onSelectionChanged: (fuck) {
                    context
                        .read<TaskCreationCubit>()
                        .deadlineChanged(fuck.value as DateTime);
                  },
                ),
                LongButton(
                    text: "Create",
                    onPressed: context.read<AuthBloc>().state.isAuthenticated
                        ? () async {
                            final userState = context.read<AuthBloc>().state;
                            String? error;

                            final itWorked = await context
                                .read<TaskCreationCubit>()
                                .createTask(
                                    homeId: home.id,
                                    userId: userState.userId!,
                                    type: type);
                            error = itWorked ? null : state.error?.message;
                            if (itWorked) {
                              context.read<NavigationCubit>().pop(context);
                              return;
                            }

                            if (error != null) {
                              context
                                  .read<NavigationCubit>()
                                  .showSnackbarErrorWithMessage(error, context);
                            }
                          }
                        : null),
                const SizedBox()
              ]),
        );
      },
    );
  }
}
