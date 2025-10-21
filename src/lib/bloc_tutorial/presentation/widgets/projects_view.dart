import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/models/project.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/projects_cubit.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Projects'),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BlocBuilder<ProjectsCubit, List<Project>?>(
            builder: (context, state) {
              // Handles loading state
              if (state == null) {
                return const Center(
                  child: Text('Loading'),
                );
              }

              // Otherwise, there is data

              return ListView.builder(
                itemCount: state.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0 ? Colors.grey : Colors.white,
                    child: Row(
                      children: [
                        Text(
                          state[index].name,
                        ),
                        const Spacer(),
                        Text(
                          'Tasks: ${state[index].tasksCount}',
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
