import 'package:flutter/foundation.dart';

class WorkPackagesFilters {
  final String? name;
  final bool? isOverdue;
  final List<int>? statusIDs, typeIDs, priorityIDs;

  WorkPackagesFilters({
    this.name,
    this.isOverdue,
    this.statusIDs,
    this.typeIDs,
    this.priorityIDs,
  });

  const WorkPackagesFilters.noFilters()
      : name = null,
        isOverdue = null,
        statusIDs = null,
        typeIDs = null,
        priorityIDs = null;

  @override
  bool operator ==(covariant WorkPackagesFilters other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.isOverdue == isOverdue &&
        listEquals(other.statusIDs, statusIDs) &&
        listEquals(other.typeIDs, typeIDs) &&
        listEquals(other.priorityIDs, priorityIDs);
  }

  @override
  int get hashCode => name.hashCode ^ isOverdue.hashCode ^ priorityIDs.hashCode;
}
