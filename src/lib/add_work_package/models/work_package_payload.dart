import 'package:open_project/add_work_package/models/work_package_options.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/util/duration_extension.dart';

class WorkPackagePayload {
  /// Only available in edit mode
  final int? lockVersion;
  final String subject;
  final WPDescription description;
  final WPType type;
  final WPStatus status;
  final WPPriority priority;
  final WPUser? responsible;
  final WPUser? assignee;
  final DateTime? startDate;
  final DateTime? dueDate;
  final Duration? estimatedTime;
  final WPCategory? category;
  final WPVersion? version;
  final int percentageDone;

  const WorkPackagePayload({
    this.lockVersion,
    required this.subject,
    required this.description,
    required this.type,
    required this.priority,
    required this.status,
    this.responsible,
    this.assignee,
    this.startDate,
    this.dueDate,
    this.estimatedTime,
    this.category,
    this.version,
    required this.percentageDone,
  });

  factory WorkPackagePayload.fromJson(
    Map<String, dynamic> json,
    WorkPackageOptions wpOptions,
  ) {
    final payloadJson = json['_embedded']!['payload']! as Map<String, dynamic>;
    final payloadLinksJson = payloadJson['_links']! as Map<String, dynamic>;

    // The payload json doesn't provide many properties, and to assign
    // the objects needed for the payload object (WPType, WPCategory, etc.),
    // we need to access the `WorkPackageOptions` class and get the properties
    // from it, in the payload json, we have the id -along other data- which
    // is enough to access the object we need with all its properties from
    // the `WorkPackageOptions` class
    int getIdFromLink(String linkHref) {
      return int.parse(linkHref.split('/').last);
    }

    WPType getType() {
      // `href` in `type` is never null
      final typeId = getIdFromLink(payloadLinksJson['type']!['href']!);

      return wpOptions.types.firstWhere((element) => element.id == typeId);
    }

    WPStatus getStatus() {
      // `href` in `status` is never null
      final statusId = getIdFromLink(payloadLinksJson['status']!['href']!);

      return wpOptions.statuses.firstWhere((element) => element.id == statusId);
    }

    WPPriority getPriority() {
      // `href` in `priority` is never null
      final priorityId = getIdFromLink(payloadLinksJson['priority']!['href']!);

      return wpOptions.priorities
          .firstWhere((element) => element.id == priorityId);
    }

    WPCategory? getCategory() {
      final linkHref = payloadLinksJson['category']!['href'];

      if (linkHref == null) return null;

      final categoryId = getIdFromLink(linkHref);

      return wpOptions.categories
          .firstWhere((element) => element.id == categoryId);
    }

    WPVersion? getVersion() {
      final linkHref = payloadLinksJson['version']!['href'];

      if (linkHref == null) return null;

      final versionId = getIdFromLink(linkHref);

      return wpOptions.versions
          .firstWhere((element) => element.id == versionId);
    }

    WPUser? getResponsible() {
      final linkHref = payloadLinksJson['responsible']!['href'];

      if (linkHref == null) return null;

      final responsibleId = getIdFromLink(linkHref);
      final responsibleName =
          payloadLinksJson['responsible']!['title']! as String;

      return WPUser(
        id: responsibleId,
        name: responsibleName,
        link: WPLink.fromJson(payloadLinksJson['responsible']),
      );
    }

    WPUser? getAssignee() {
      final linkHref = payloadLinksJson['assignee']!['href'];

      if (linkHref == null) return null;

      final assigneeId = getIdFromLink(linkHref);
      final assigneeName = payloadLinksJson['assignee']!['title']! as String;

      return WPUser(
        id: assigneeId,
        name: assigneeName,
        link: WPLink.fromJson(payloadLinksJson['assignee']),
      );
    }

    return WorkPackagePayload(
      lockVersion: payloadJson['lockVersion'] as int?,
      subject: payloadJson['subject'],
      description: WPDescription.fromJson(payloadJson['description']),
      type: getType(),
      status: getStatus(),
      priority: getPriority(),
      responsible: getResponsible(),
      assignee: getAssignee(),
      startDate: payloadJson['startDate'] == null
          ? null
          : DateTime.parse(payloadJson['startDate']),
      dueDate: payloadJson['dueDate'] == null
          ? null
          : DateTime.parse(payloadJson['dueDate']),
      estimatedTime: payloadJson['estimatedTime'] == null
          ? null
          : Iso8601Duration.fromIso8601(
              payloadJson['estimatedTime'] as String,
            ),
      category: getCategory(),
      version: getVersion(),
      percentageDone: payloadJson['percentageDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (lockVersion != null) 'lockVersion': lockVersion,
      'subject': subject,
      'description': description.toJson(),
      if (startDate != null) 'startDate': startDate?.toIso8601String(),
      if (dueDate != null) 'dueDate': dueDate?.toIso8601String(),
      if (estimatedTime != null) 'estimatedTime': estimatedTime?.toIso8601(),
      'percentageDone': percentageDone,
      '_links': {
        'type': type.link.toJson(),
        'priority': priority.link.toJson(),
        'status': status.link.toJson(),
        if (responsible != null) 'responsible': responsible?.link.toJson(),
        if (assignee != null) 'assignee': assignee?.link.toJson(),
        if (category != null) 'category': category?.link.toJson(),
        if (version != null) 'version': version?.link.toJson(),
      },
    };
  }

  /// Using `Value` wrappers makes it possible to update a property
  /// with a null value
  WorkPackagePayload copyWith({
    Value<String> subject = const Value.absent(),
    Value<WPDescription> description = const Value.absent(),
    Value<WPType> type = const Value.absent(),
    Value<WPStatus> status = const Value.absent(),
    Value<WPPriority> priority = const Value.absent(),
    Value<WPUser?> responsible = const Value.absent(),
    Value<WPUser?> assignee = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<Duration?> estimatedTime = const Value.absent(),
    Value<WPCategory?> category = const Value.absent(),
    Value<WPVersion?> version = const Value.absent(),
    Value<int> percentageDone = const Value.absent(),
  }) {
    return WorkPackagePayload(
      lockVersion: lockVersion,
      subject: subject.hasValue ? subject.value! : this.subject,
      description: description.hasValue ? description.value! : this.description,
      type: type.hasValue ? type.value! : this.type,
      status: status.hasValue ? status.value! : this.status,
      priority: priority.hasValue ? priority.value! : this.priority,
      responsible: responsible.hasValue ? responsible.value : this.responsible,
      assignee: assignee.hasValue ? assignee.value : this.assignee,
      startDate: startDate.hasValue ? startDate.value : this.startDate,
      dueDate: dueDate.hasValue ? dueDate.value : this.dueDate,
      estimatedTime:
          estimatedTime.hasValue ? estimatedTime.value : this.estimatedTime,
      category: category.hasValue ? category.value : this.category,
      version: version.hasValue ? version.value : this.version,
      percentageDone:
          percentageDone.hasValue ? percentageDone.value! : this.percentageDone,
    );
  }
}
