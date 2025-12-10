import 'package:flutter/foundation.dart';

import 'package:open_project/add_work_package/models/work_package_properties.dart';

class WorkPackageOptions {
  final List<WPType> types;
  final List<WPStatus> statuses;
  final List<WPPriority> priorities;
  final List<WPCategory> categories;
  final List<WPVersion> versions;

  final bool isSubjectWritable;
  final bool isStatusWritable;
  final bool isTypeWritable;
  final bool isDescriptionWritable;
  final bool isAccountableWritable;
  final bool isAssigneeWritable;
  final bool isPriorityWritable;
  final bool isDateWritable;
  final bool isStartDateWritable;
  final bool isDueDateWritable;
  final bool isEstimatedTimeWritable;
  final bool isVersionWritable;
  final bool isCategoryWritable;
  final bool isProgressWritable;

  /// If the work package depends on a single date (that's the case
  /// in `Milestone` types), this will be false, other than that, a
  /// date range is used (`startDate` & `dueDate`)
  final bool usingDateRange;

  const WorkPackageOptions({
    this.types = const [],
    this.statuses = const [],
    this.priorities = const [],
    this.categories = const [],
    this.versions = const [],
    required this.usingDateRange,
    required this.isSubjectWritable,
    required this.isStatusWritable,
    required this.isTypeWritable,
    required this.isDescriptionWritable,
    required this.isAccountableWritable,
    required this.isAssigneeWritable,
    required this.isPriorityWritable,
    required this.isDateWritable,
    required this.isStartDateWritable,
    required this.isDueDateWritable,
    required this.isEstimatedTimeWritable,
    required this.isVersionWritable,
    required this.isCategoryWritable,
    required this.isProgressWritable,
  });

  factory WorkPackageOptions.fromJson(Map<String, dynamic> json) {
    List<dynamic> getObjectsList(String objectName) {
      return json['_embedded']!['schema']![objectName]!['_embedded']![
          'allowedValues']!;
    }

    /// Returns if the object is writable or not
    bool getObjectWriteState(String objectName) {
      return json['_embedded']!['schema']![objectName]?['writable'] ?? false;
    }

    final dateObjectExists = json['_embedded']!['schema']!['date'] != null;

    return WorkPackageOptions(
      usingDateRange: !dateObjectExists,
      types: getObjectsList('type').map((e) => WPType.fromJson(e)).toList(),
      statuses:
          getObjectsList('status').map((e) => WPStatus.fromJson(e)).toList(),
      priorities: getObjectsList('priority')
          .map((e) => WPPriority.fromJson(e))
          .toList(),
      categories: getObjectsList('category')
          .map((e) => WPCategory.fromJson(e))
          .toList(),
      versions:
          getObjectsList('version').map((e) => WPVersion.fromJson(e)).toList(),
      isSubjectWritable: getObjectWriteState('subject'),
      isStatusWritable: getObjectWriteState('status'),
      isTypeWritable: getObjectWriteState('type'),
      isDescriptionWritable: getObjectWriteState('description'),
      isAccountableWritable: getObjectWriteState('responsible'),
      isAssigneeWritable: getObjectWriteState('assignee'),
      isPriorityWritable: getObjectWriteState('priority'),
      isDateWritable: getObjectWriteState('date'),
      isStartDateWritable: getObjectWriteState('startDate'),
      isDueDateWritable: getObjectWriteState('dueDate'),
      isEstimatedTimeWritable: getObjectWriteState('estimatedTime'),
      isVersionWritable: getObjectWriteState('version'),
      isCategoryWritable: getObjectWriteState('category'),
      isProgressWritable: getObjectWriteState('percentageDone'),
    );
  }

  WorkPackageOptions copyWith({
    bool? usingDateRange,
    List<WPType>? types,
    List<WPStatus>? statuses,
    List<WPPriority>? priorities,
    List<WPCategory>? categories,
    List<WPVersion>? versions,
    List<WPUser>? assignees,
    List<WPUser>? responsibles,
    bool? isSubjectWritable,
    bool? isStatusWritable,
    bool? isTypeWritable,
    bool? isDescriptionWritable,
    bool? isAccountableWritable,
    bool? isAssigneeWritable,
    bool? isPriorityWritable,
    bool? isDateWritable,
    bool? isStartDateWritable,
    bool? isDueDateWritable,
    bool? isEstimatedTimeWritable,
    bool? isVersionWritable,
    bool? isCategoryWritable,
    bool? isProgressWritable,
  }) {
    return WorkPackageOptions(
      usingDateRange: usingDateRange ?? this.usingDateRange,
      types: types ?? this.types,
      statuses: statuses ?? this.statuses,
      priorities: priorities ?? this.priorities,
      categories: categories ?? this.categories,
      versions: versions ?? this.versions,
      isSubjectWritable: isSubjectWritable ?? this.isSubjectWritable,
      isStatusWritable: isStatusWritable ?? this.isStatusWritable,
      isTypeWritable: isTypeWritable ?? this.isTypeWritable,
      isDescriptionWritable:
          isDescriptionWritable ?? this.isDescriptionWritable,
      isAccountableWritable:
          isAccountableWritable ?? this.isAccountableWritable,
      isAssigneeWritable: isAssigneeWritable ?? this.isAssigneeWritable,
      isPriorityWritable: isPriorityWritable ?? this.isPriorityWritable,
      isDateWritable: isDateWritable ?? this.isDateWritable,
      isStartDateWritable: isStartDateWritable ?? this.isStartDateWritable,
      isDueDateWritable: isDueDateWritable ?? this.isDueDateWritable,
      isEstimatedTimeWritable:
          isEstimatedTimeWritable ?? this.isEstimatedTimeWritable,
      isVersionWritable: isVersionWritable ?? this.isVersionWritable,
      isCategoryWritable: isCategoryWritable ?? this.isCategoryWritable,
      isProgressWritable: isProgressWritable ?? this.isProgressWritable,
    );
  }

  @override
  bool operator ==(covariant WorkPackageOptions other) {
    if (identical(this, other)) return true;

    return other.usingDateRange == usingDateRange &&
        other.isSubjectWritable == isSubjectWritable &&
        other.isStatusWritable == isStatusWritable &&
        other.isTypeWritable == isTypeWritable &&
        other.isDescriptionWritable == isDescriptionWritable &&
        other.isAccountableWritable == isAccountableWritable &&
        other.isAssigneeWritable == isAssigneeWritable &&
        other.isPriorityWritable == isPriorityWritable &&
        other.isDateWritable == isDateWritable &&
        other.isStartDateWritable == isStartDateWritable &&
        other.isDueDateWritable == isDueDateWritable &&
        other.isEstimatedTimeWritable == isEstimatedTimeWritable &&
        other.isVersionWritable == isVersionWritable &&
        other.isCategoryWritable == isCategoryWritable &&
        other.isProgressWritable == isProgressWritable &&
        listEquals(other.types, types) &&
        listEquals(other.statuses, statuses) &&
        listEquals(other.priorities, priorities) &&
        listEquals(other.categories, categories) &&
        listEquals(other.versions, versions);
  }

  @override
  int get hashCode {
    return isSubjectWritable.hashCode ^
        isStatusWritable.hashCode ^
        isTypeWritable.hashCode ^
        isDescriptionWritable.hashCode ^
        isAccountableWritable.hashCode ^
        isAssigneeWritable.hashCode ^
        isPriorityWritable.hashCode ^
        isDateWritable.hashCode ^
        isStartDateWritable.hashCode ^
        isDueDateWritable.hashCode ^
        isEstimatedTimeWritable.hashCode ^
        isVersionWritable.hashCode ^
        isCategoryWritable.hashCode ^
        isProgressWritable.hashCode ^
        usingDateRange.hashCode ^
        types.hashCode ^
        statuses.hashCode ^
        priorities.hashCode ^
        categories.hashCode ^
        versions.hashCode;
  }
}
