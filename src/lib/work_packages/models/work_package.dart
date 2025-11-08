import 'package:open_project/core/models/user.dart';
import 'package:open_project/core/util/duration_extension.dart';

class WorkPackage {
  final int id;
  final String subject;
  final User author;
  final User? accountable;
  final User? assignee;
  final DateTime? startDate;
  final DateTime? dueDate;
  final Duration? estimatedTime;
  final int statusId;
  final int typeId;
  final int priorityId;
  final int percentageDone;
  final String? versionName;
  final String? categoryName;

  const WorkPackage({
    required this.id,
    required this.subject,
    required this.author,
    required this.statusId,
    required this.typeId,
    required this.priorityId,
    required this.percentageDone,
    this.estimatedTime,
    this.accountable,
    this.assignee,
    this.startDate,
    this.dueDate,
    this.versionName,
    this.categoryName,
  });

  /// Creates a WorkPackage instance from a JSON map.
  factory WorkPackage.fromJson(Map<String, dynamic> json) {
    // Access the nested _links object for related resources.
    final links = json['_links'] as Map<String, dynamic>;
    final statusId = int.parse(
      links['status']!['href']!.split('/').last,
    );
    final typeId = int.parse(
      links['type']!['href']!.split('/').last,
    );
    final priorityId = int.parse(
      links['priority']!['href']!.split('/').last,
    );

    // Handle nullable assignee field.
    // `href` under "assignee" can also be null, that's why
    // the extra check is made
    final assigneeJson = links['assignee']['href'] == null
        ? null
        : links['assignee'] as Map<String, dynamic>?;
    final accountableJson = links['responsible']['href'] == null
        ? null
        : links['responsible'] as Map<String, dynamic>?;

    final versionJson = links['version']['href'] == null
        ? null
        : links['version'] as Map<String, dynamic>?;
    final categoryJson = links['category']['href'] == null
        ? null
        : links['category'] as Map<String, dynamic>?;

    // Handle nullable date field.
    final startDateString = json['startDate'] as String?;
    final dueDateString = json['dueDate'] as String?;

    return WorkPackage(
      id: json['id'] as int,
      subject: json['subject'] as String,
      author: User.fromJson(links['author']),
      estimatedTime: json['estimatedTime'] != null
          ? Iso8601Duration.fromIso8601(json['estimatedTime'] as String)
          : null,
      percentageDone: json['percentageDone'],
      accountable:
          accountableJson != null ? User.fromJson(accountableJson) : null,
      assignee: assigneeJson != null ? User.fromJson(assigneeJson) : null,
      startDate:
          startDateString != null ? DateTime.parse(startDateString) : null,
      dueDate: dueDateString != null ? DateTime.parse(dueDateString) : null,
      statusId: statusId,
      typeId: typeId,
      priorityId: priorityId,
      versionName: versionJson != null ? versionJson['title'] : null,
      categoryName: categoryJson != null ? categoryJson['title'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      'percentageDone': percentageDone,
      if (estimatedTime != null) 'estimatedTime': estimatedTime!.toIso8601(),
      '_links': {
        'status': {
          'href': '/api/v3/statuses/$statusId',
        },
        'type': {
          'href': '/api/v3/types/$typeId',
        },
        'priority': {
          'href': '/api/v3/priorities/$priorityId',
        },
        'author': author.toJson(),
        // This is how the API returns null user values, this case
        // is handled in the `fromJson` function
        'assignee': assignee?.toJson() ?? {'href': null},
        'responsible': accountable?.toJson() ?? {'href': null},
        // This is the needed information by the Veiw work package screen,
        // the "placeholder" doesn't change anything as long as it's not null
        'version': versionName != null
            ? {'href': 'placeholder', 'title': versionName}
            : {'href': null},
        'category': categoryName != null
            ? {'href': 'placeholder', 'title': categoryName}
            : {'href': null},
      },
    };
  }
}
