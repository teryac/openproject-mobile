import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/data/bloc_tutorial_repo.dart';
import 'package:open_project/bloc_tutorial/models/work_package.dart';
import 'package:open_project/core/util/failure.dart';

class WorkPackagesCubit
    extends Cubit<AsyncValue<List<WorkPackage>, NetworkFailure>> {
  final BlocTutorialRepo _repo;
  WorkPackagesCubit({required BlocTutorialRepo repo})
      : _repo = repo,
        // Default value is loading
        super(const AsyncValue.loading());

  Future<void> getWorkPackages() async {
    // Indicates loading state
    emit(const AsyncValue.loading());

    final result = await _repo.getWorkPackages();

    if (result.isData) {
      emit(AsyncValue.data(data: result.data!));
    } else {
      // if not `isData`, an error has been thrown
      emit(AsyncValue.error(error: result.error!));
    }
  }
}
