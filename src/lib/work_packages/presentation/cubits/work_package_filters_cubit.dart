import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';

class WorkPackagesFiltersCubit extends Cubit<WorkPackagesFilters> {
  WorkPackagesFiltersCubit() : super(const WorkPackagesFilters.noFilters());

  /// Toggle "Overdue" filter
  void toggleOverdue() {
    emit(WorkPackagesFilters(
      isOverdue: !(state.isOverdue ?? false),
      name: state.name,
      statusIDs: state.statusIDs,
      typeIDs: state.typeIDs,
      priorityIDs: state.priorityIDs,
    ));
  }

  /// Helper to toggle an ID in a list field
  List<int>? _toggleID(List<int>? current, int id) {
    final list = current == null ? <int>[] : List<int>.from(current);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    return list.isEmpty ? null : list;
  }

  void toggleType(int id) {
    emit(WorkPackagesFilters(
      name: state.name,
      isOverdue: state.isOverdue,
      statusIDs: state.statusIDs,
      typeIDs: _toggleID(state.typeIDs, id),
      priorityIDs: state.priorityIDs,
    ));
  }

  void toggleStatus(int id) {
    emit(WorkPackagesFilters(
      name: state.name,
      isOverdue: state.isOverdue,
      statusIDs: _toggleID(state.statusIDs, id),
      typeIDs: state.typeIDs,
      priorityIDs: state.priorityIDs,
    ));
  }

  void togglePriority(int id) {
    emit(WorkPackagesFilters(
      name: state.name,
      isOverdue: state.isOverdue,
      statusIDs: state.statusIDs,
      typeIDs: state.typeIDs,
      priorityIDs: _toggleID(state.priorityIDs, id),
    ));
  }

  void clear() => emit(const WorkPackagesFilters.noFilters());
}
