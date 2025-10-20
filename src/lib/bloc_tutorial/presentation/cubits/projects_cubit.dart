import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/data/bloc_tutorial_repo.dart';
import 'package:open_project/bloc_tutorial/models/project.dart';

class ProjectsCubit extends Cubit<List<Project>?> {
  final BlocTutorialRepo _repo;
  ProjectsCubit({required BlocTutorialRepo repo})
      : _repo = repo,
      // Default value is loading
        super(null);

        
  // ! This approach has a weakpoint, which is 
  // ! inability to handle error cases, to see
  // ! the workaround, checkout the work packages
  // ! cubit
  Future<void> getProjects() async {
    // Indicates loading state
    emit(null);

    final result = await _repo.getProjects();

    // Update UI with new projects list
    emit(result);
  }
}
