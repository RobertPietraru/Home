import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/components/buttons/long_button.dart';
import '../../../core/components/custom_app_bar.dart';
import '../../../core/components/text_input_field.dart';
import '../../../injection.dart';
import '../blocs/task_creation_cubit/task_creation_cubit.dart';
import '../blocs/tasks_cubit/tasks_cubit.dart';

class TaskCreationScreen extends StatelessWidget {
  final TaskType type;
  final HomeEntity home;
  const TaskCreationScreen({super.key, required this.type, required this.home});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(trailing: [
        Icon(type == TaskType.chore
            ? Icons.cleaning_services
            : Icons.shopping_bag)
      ]),
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
    final theme = AppTheme.of(context);
    return BlocConsumer<TaskCreationCubit, TaskCreationState>(
      listener: (context, state) {
        if (state.status == TaskCreationStatus.created) Navigator.pop(context);
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInputField(
                  onChanged: context.read<TaskCreationCubit>().titleChanged,
                  hint: "Title",
                  leading: Icons.home,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Importance:",
                      style: theme.subtitleTextStyle,
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
                  onSelectionChanged: (s) => context
                      .read<TaskCreationCubit>()
                      .deadlineChanged(s.value as DateTime),
                ),
                LongButton(
                  error: state.failure?.message,
                  label: "Create",
                  onPressed: () async {
                    final userState = context.read<AuthBloc>().state;
                    await context.read<TaskCreationCubit>().createTask(
                        homeId: home.id,
                        userId: userState.userEntity!.id,
                        type: type,
                        translator: context.translator);
                  },
                  isLoading: state.isLoading,
                ),
                const SizedBox()
              ]),
        );
      },
    );
  }
}
