import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/components/buttons/long_button.dart';
import '../../../core/components/custom_app_bar.dart';
import '../../../core/components/input_fields/text_input_field.dart';
import '../../../injection.dart';
import '../blocs/task_creation_cubit/task_creation_cubit.dart';

class TaskCreationScreen extends StatelessWidget {
  final HomeEntity home;
  final TaskType type;
  const TaskCreationScreen({super.key, required this.home, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskCreationCubit(locator(), tasksCubit: context.read<TasksCubit>()),
      child: _TaskCreationScreen(home: home, type: type),
    );
  }
}

class _TaskCreationScreen extends StatelessWidget {
  final HomeEntity home;
  final TaskType type;
  const _TaskCreationScreen({
    required this.home,
    required this.type,
  });

  String indicatorTextBasedOnPosition(double position, BuildContext context) {
    if (position < 0.3) {
      return context.translator.unimportant;
    }
    if (position < 0.8) {
      return context.translator.quiteImportant;
    }
    return context.translator.veryImportant;
  }

  Color indicatorColorBasedOnPosition(double position) {
    if (position < 0.3) {
      return Colors.green;
    }
    if (position < 0.8) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(trailing: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(type == TaskType.chore
              ? Icons.cleaning_services
              : Icons.shopping_bag),
        )
      ]),
      body: BlocConsumer<TaskCreationCubit, TaskCreationState>(
        listener: (context, state) {
          if (state.status == TaskCreationStatus.created)
            Navigator.pop(context);
        },
        builder: (context, state) {
          return Padding(
            padding: theme.standardPadding,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInputField(
                    onChanged: context.read<TaskCreationCubit>().titleChanged,
                    error: state.titleError,
                    hint: context.translator.title,
                    leading: Icons.home,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translator.importance,
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
                            label: indicatorTextBasedOnPosition(
                                state.importance, context),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translator.deadline,
                        style: theme.subtitleTextStyle,
                      ),
                      SfDateRangePicker(
                        enablePastDates: false,
                        onSelectionChanged: (s) => context
                            .read<TaskCreationCubit>()
                            .deadlineChanged(s.value as DateTime),
                      ),
                    ],
                  ),
                  LongButton(
                    error: state.fieldlessError,
                    label: context.translator.create,
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
      ),
    );
  }
}
