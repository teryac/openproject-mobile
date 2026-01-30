import 'package:flutter_bloc/flutter_bloc.dart';

/// State of versions expansion (read more) in change log,
/// Map<String version, bool expanded>
class ChangelogVersionExpansionCubit extends Cubit<Map<String, bool>> {
  ChangelogVersionExpansionCubit() : super({});

  void toggleExpansion(String version) {
    final newState = {...state};

    final isExpanded = newState[version];
    newState[version] = isExpanded == null ? true : !isExpanded;

    emit(newState);
  }
}
