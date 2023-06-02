import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection.dart';
import '../blocs/home_creation_cubit/home_creation_cubit.dart';

class CreateHomeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  CreateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HomeCreationCubit(
        locator(),
        homesBloc: context.read<HomesBloc>(),
      ),
      child: ActualCreateHomeScreen(nameController: nameController),
    );
  }
}

class ActualCreateHomeScreen extends StatelessWidget {
  const ActualCreateHomeScreen({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const PietrockaLogo(),
      ),
      body: BlocConsumer<HomeCreationCubit, HomeCreationState>(
        listener: (context, state) {
          if (state.isSuccessful) {
            context.read<NavigationCubit>().pop(context);
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
                      const Text(
                        "To create a home, please fill out these fields:",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      NameTextField(
                        nameController: nameController,
                        state: state,
                      ),
                      const SizedBox(height: 20),
                      CheckboxInputField(
                          title:
                              "I plan on using this app along with other people (Family, roommates, etc)",
                          value: state.usesWithSomeoneElse,
                          onChanged: (e) {
                            context.read<HomeCreationCubit>().updateCheckbox(
                                  usesWithSomeoneElse: e,
                                );
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "I plan on using this app for: ",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      CheckboxInputField(
                          value: state.usesForChores,
                          title: "Managing chores around the house",
                          onChanged: (e) {
                            context.read<HomeCreationCubit>().updateCheckbox(
                                  usesForChores: e,
                                );
                          }),
                      CheckboxInputField(
                          title: "Managing a shopping list",
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
                        text: "Create",
                        onPressed:
                            context.read<AuthBloc>().state.isAuthenticated
                                ? () => context
                                    .read<HomeCreationCubit>()
                                    .createHome(
                                        context.read<AuthBloc>().state.userId!)
                                : null,
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<NavigationCubit>().pop(context);
                          },
                          child: const Text("Cancel")),
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
    required this.nameController,
    required this.state,
  }) : super(key: key);
  final HomeCreationState state;

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      hint: 'Home name',
      prefixIcon: Icons.home,
      error: state.homeNameErrorMessage,
      controller: nameController,
      onChanged: (e) {
        context.read<HomeCreationCubit>().homeNameChanged(e);
      },
    );
  }
}
