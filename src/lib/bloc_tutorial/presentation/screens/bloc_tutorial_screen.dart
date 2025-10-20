import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/projects_cubit.dart';
import 'package:open_project/bloc_tutorial/presentation/widgets/counter_buttons.dart';
import 'package:open_project/bloc_tutorial/presentation/widgets/counter_view.dart';
import 'package:open_project/bloc_tutorial/presentation/widgets/projects_view.dart';
import 'package:open_project/bloc_tutorial/presentation/widgets/work_packages_view.dart';

class BlocTutorialScreen extends StatelessWidget {
  const BlocTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // As soon as the screen builds, get products
    // You can also run this in the `ProjectsCubit`
    // constructor to run the `getProjects` function
    // as soon as the cubit gets created
    context.read<ProjectsCubit>().getProjects();

    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CounterView(),
          CounterButtons(),
          SizedBox(height: 16),
          ProjectsView(),
          WorkPackagesView(),
        ],
      ),
    );
  }
}
