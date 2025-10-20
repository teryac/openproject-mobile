import 'dart:math';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:open_project/bloc_tutorial/models/project.dart';
import 'package:open_project/bloc_tutorial/models/work_package.dart';
import 'package:open_project/core/util/failure.dart';

class BlocTutorialRepo {
  Future<List<Project>> getProjects() async {
    // Waits for 1 second to add an asynchronous complexity
    // simulating the API request case
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    const projects = [
      Project(id: 'ds4mds94ms', name: 'Scrum Project', tasksCount: 3),
      Project(id: 'a0ffmw0axi', name: 'Basic Project', tasksCount: 6),
      Project(id: '0axomapdsk', name: 'Final Project', tasksCount: 2),
    ];

    return projects;
  }

  Future<AsyncResult<List<WorkPackage>, NetworkFailure>>
      getWorkPackages() async {
    // Waits for 1 second to add an asynchronous complexity
    // simulating the API request case
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    const workPackages = [
      WorkPackage(
        name: 'Develop architecture',
        type: 'Milestone',
        assignee: 'Majd Haj Hmidi',
      ),
      WorkPackage(
        name: 'Learn new architecture',
        type: 'Task',
        assignee: 'Shaaban Shaheen',
      ),
      WorkPackage(
        name: 'Manage Team',
        type: 'Phase',
        assignee: 'Yaman Kalaji',
      ),
      WorkPackage(
        name: 'App quality check',
        type: 'Task',
        assignee: 'Mohammad Haj Hmidi',
      ),
    ];

    // Throws an error randomly
    if (Random().nextBool()) {
      return const AsyncResult.error(
        error: NetworkFailure(
          statusCode: 403,
          errorMessage: 'Unauthorized',
        ),
      );
    }

    // In case no error occurred, return data
    return const AsyncResult.data(data: workPackages);
  }
}
