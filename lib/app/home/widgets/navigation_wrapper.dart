import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/cubit/homes_cubit.dart';
import 'package:homeapp/app/home/views/task_list.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../injection.dart';
import '../blocs/tasks_cubit/tasks_cubit.dart';
import '../screens/no_home_screen.dart';
import '../views/drawer_view.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return BlocBuilder<HomesCubit, HomesState>(
      builder: (context, homesState) {
        if (homesState.isLoading || homesState.isUninitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (homesState.homes.isEmpty) {
          return BlocProvider.value(
            value: BlocProvider.of<HomesCubit>(context),
            child: const NoHomeScreen(),
          );
        }
        return BlocProvider(
          create: (context) => TasksCubit(
            locator(),
          )..getChores(home: homesState.currentHome, translator: translator),
          child: Scaffold(
            appBar: CustomAppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.black),
                );
              }),
            ),
            drawer: DrawerView(home: homesState.currentHome),
            bottomNavigationBar: Builder(builder: (context) {
              return NavigationBar(
                  index: index,
                  onPressed: (i) {
                    setState(() => index = i);
                    context.read<TasksCubit>().getTasksForType(
                        homesState.currentHome,
                        index == 0 ? TaskType.chore : TaskType.shopping,
                        context.translator);
                  });
            }),
            body: Container(
              color: Colors.white,
              child: [
                TaskList(
                  home: homesState.currentHome,
                  type: TaskType.chore,
                ),
                TaskList(
                  home: homesState.currentHome,
                  type: TaskType.shopping,
                ),
              ][index],
            ),
          ),
        );
      },
    );
  }
}

class NavigationBar extends StatelessWidget {
  final Function(int i) onPressed;
  final int index;
  const NavigationBar({
    Key? key,
    required this.onPressed,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      currentIndex: index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (i) => onPressed(i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag,
            ),
            label: ''),
      ],
    );
  }
}
