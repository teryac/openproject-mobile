import 'package:open_project/work_packages/models/work_package.dart';

class PaginatedWorkPackages {
  final int total;
  final int count;
  final int pageSize;
  final int page;
  final WorkPackagesFilters workPackagesFilters;
  final List<WorkPackage> workPackages;

  const PaginatedWorkPackages({
    required this.total,
    required this.count,
    required this.pageSize,
    required this.page,
    required this.workPackagesFilters,
    required this.workPackages,
  });

  factory PaginatedWorkPackages.fromJson(
    Map<String, dynamic> json, {
    required WorkPackagesFilters workPackagesFilters,
  }) {
    final embedded = json['_embedded']!['elements']! as List<dynamic>;

    return PaginatedWorkPackages(
      total: json['total']!,
      count: json['count']!,
      pageSize: json['pageSize'],
      page: json['offset'],
      workPackagesFilters: workPackagesFilters,
      workPackages: embedded.map((e) => WorkPackage.fromJson(e)).toList(),
    );
  }
}

class WorkPackagesFilters {
  final String? name;
  final bool? isOverdue;
  final int? statusId, typeId, priorityId;

  WorkPackagesFilters({
    this.name,
    this.isOverdue,
    this.statusId,
    this.typeId,
    this.priorityId,
  });

  const WorkPackagesFilters.noFilters()
      : name = null,
        isOverdue = null,
        statusId = null,
        typeId = null,
        priorityId = null;

  @override
  bool operator ==(covariant WorkPackagesFilters other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.isOverdue == isOverdue &&
        other.statusId == statusId &&
        other.typeId == typeId &&
        other.priorityId == priorityId;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      isOverdue.hashCode ^
      statusId.hashCode ^
      typeId.hashCode ^
      priorityId.hashCode;
}
