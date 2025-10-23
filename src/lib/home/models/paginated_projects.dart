import 'package:open_project/home/models/project.dart';

class PaginatedProjects {
  final int total;
  final int count;
  final int pageSize;
  final int page;
  final ProjectsFilters projectsFilters;
  final List<Project> projects;

  const PaginatedProjects({
    required this.total,
    required this.count,
    required this.pageSize,
    required this.page,
    required this.projectsFilters,
    required this.projects,
  });

  factory PaginatedProjects.fromJson(
    Map<String, dynamic> json, {
    required ProjectsFilters projectsFilters,
  }) {
    final embedded = json['_embedded']!['elements']! as List<dynamic>;

    return PaginatedProjects(
      total: json['total']!,
      count: json['count']!,
      pageSize: json['pageSize'],
      page: json['offset'],
      projectsFilters: projectsFilters,
      projects: embedded.map((e) => Project.fromJson(e)).toList(),
    );
  }
}

class ProjectsFilters {
  final String? name;
  final bool? public;

  const ProjectsFilters({
    this.name,
    this.public,
  });

  const ProjectsFilters.noFilters()
      : name = null,
        public = null;
}
