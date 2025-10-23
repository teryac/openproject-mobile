import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsListExpansionCubit extends Cubit<bool> {
  ProjectsListExpansionCubit() : super(true);

  void toggleExpansion() {
    emit(!state);
  }
}
