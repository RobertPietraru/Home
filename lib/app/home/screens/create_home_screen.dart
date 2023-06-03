import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/cubit/homes_cubit.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/utils/translator.dart';
import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/components/buttons/long_button.dart';
import '../../../core/components/input_fields/checkbox_input_field.dart';
import '../../../core/components/input_fields/text_input_field.dart';
import '../../../injection.dart';
import '../blocs/home_creation_cubit/home_creation_cubit.dart';

class CreateHomeScreen extends StatelessWidget {
  const CreateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HomeCreationCubit(
        locator(),
        homesCubit: context.read<HomesCubit>(),
      ),
      child: const _CreateHomeScreen(),
    );
  }
}

class _CreateHomeScreen extends StatelessWidget {
  const _CreateHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocConsumer<HomeCreationCubit, HomeCreationState>(
        listener: (context, state) {
          if (state.isSuccessful) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translator.toCreateAHome,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      NameTextField(
                        state: state,
                      ),
                      const SizedBox(height: 20),
                      CheckboxInputField(
                          title: context.translator.iPlanOnUsingWithFamily,
                          value: state.usesWithSomeoneElse,
                          onChanged: (e) {
                            context.read<HomeCreationCubit>().updateCheckbox(
                                  usesWithSomeoneElse: e,
                                );
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        context.translator.iPlanOnUsingFor,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      CheckboxInputField(
                          value: state.usesForChores,
                          title: context.translator.managingChores,
                          onChanged: (e) {
                            context.read<HomeCreationCubit>().updateCheckbox(
                                  usesForChores: e,
                                );
                          }),
                      CheckboxInputField(
                          title: context.translator.managingAShoppingList,
                          value: state.usesForShoppingList,
                          onChanged: (e) {
                            context.read<HomeCreationCubit>().updateCheckbox(
                                  usesForShoppingList: e,
                                );
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      LongButton(
                        label: context.translator.create,
                        isLoading: state.isLoading,
                        error: state.failure?.message,
                        onPressed: () => context
                            .read<HomeCreationCubit>()
                            .createHome(
                                context.read<AuthBloc>().state.userEntity!.id,
                                context.translator),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(context.translator.cancel)),
                    ],
                  ),
                ]),
          );
        },
      ),
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({
    Key? key,
    required this.state,
  }) : super(key: key);
  final HomeCreationState state;

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      hint: 'Home name',
      leading: Icons.home,
      onChanged: (e) {
        context.read<HomeCreationCubit>().homeNameChanged(e);
      },
    );
  }
}
