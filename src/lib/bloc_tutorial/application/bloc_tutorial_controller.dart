import 'dart:async';

import 'package:open_project/bloc_tutorial/presentation/cubits/projects_cubit.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/work_packages_cubit.dart';

class BlocTutorialController {
  final ProjectsCubit projectsCubit;
  final WorkPackagesCubit workPackagesCubit;
  BlocTutorialController({
    required this.projectsCubit,
    required this.workPackagesCubit,
  }) {
    // To test the controller class, we will connect
    // the two cubits by listening to the changes of
    // the projects cubit, and as soon as we get products,
    // we will start the request to get work packages.

    // This might not be a realistic case, but it's for
    // testing purposes

    // The line below means: listen to the changes
    // of the projects cubit
    _projectsCubitStreamSubscription = projectsCubit.stream.listen(
      (event) {
        // `event` above, is the state that's emitted
        // by the projects cubit

        // the `event` is of type `List<Project>?`
        // which means if `event` is null, it's a
        // loading state, otherwise, we got products

        if (event != null) {
          workPackagesCubit.getWorkPackages();
        }
      },
    );
  }

  StreamSubscription? _projectsCubitStreamSubscription;

  void dispose() {
    _projectsCubitStreamSubscription?.cancel();
  }
}
