class Project {
  final int id;
  final String name;
  final DateTime updatedAt;
  final String? status;
  final String? statusId;
  final bool public;

  const Project({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.status,
    required this.statusId,
    required this.public,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    final statusHref = json['_links']?['status']?['href'] as String?;
    final statusId = statusHref?.split('/').last;

    return Project(
      id: json['id'],
      name: json['name'],
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['createdAt']),
      status: json['_links']?['status']?['title'],
      statusId: statusId,
      public: json['public'] ?? true,
    );
  }
}
