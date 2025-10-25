import 'package:open_project/core/models/user.dart';
import '../../core/models/work_package_status.dart';

class WorkPackage {
  final int id;
  final String subject;
  final User author;
  final User? assignee;
  final DateTime? dueDate;
  final WorkPackageStatus status;

  const WorkPackage({
    required this.id,
    required this.subject,
    required this.author,
    this.assignee,
    this.dueDate,
    required this.status,
  });

  /// Creates a WorkPackage instance from a JSON map.
  factory WorkPackage.fromJson(Map<String, dynamic> json) {
    // Access the nested _links object for related resources.
    final links = json['_links'] as Map<String, dynamic>;

    // Handle nullable assignee field.
    final assigneeJson = links['assignee'] as Map<String, dynamic>?;

    // Handle nullable date field.
    final dueDateString = json['dueDate'] as String?;

    return WorkPackage(
        id: json['id'] as int,
        subject: json['subject'] as String,
        author: User.fromJson(links['author']),
        assignee: assigneeJson != null ? User.fromJson(assigneeJson) : null,
        dueDate: dueDateString != null ? DateTime.parse(dueDateString) : null,
        status: WorkPackageStatus(
          id: 0,
          name: 'Test',
          isClosed: false,
          colorHex: '#2392D4',
          isDefault: false,
          position: 0,
          isReadonly: false,
        )
        // TODO: Fix
        // status: WorkPackageStatus.fromJson(links['status']),
        );
  }
}
