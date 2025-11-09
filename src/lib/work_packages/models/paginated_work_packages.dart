import 'package:open_project/work_packages/models/work_package.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';

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
