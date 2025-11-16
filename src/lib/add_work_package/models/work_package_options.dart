import 'package:flutter/foundation.dart';

import 'package:open_project/add_work_package/models/work_package_properties.dart';

class WorkPackageOptions {
  final List<WPType> types;
  final List<WPStatus> statuses;
  final List<WPPriority> priorities;
  final List<WPCategory> categories;
  final List<WPVersion> versions;

  const WorkPackageOptions({
    this.types = const [],
    this.statuses = const [],
    this.priorities = const [],
    this.categories = const [],
    this.versions = const [],
  });

  factory WorkPackageOptions.fromJson(Map<String, dynamic> json) {
    List<dynamic> getObjectsList(String objectName) {
      return json['_embedded']!['schema']![objectName]!['_embedded']![
          'allowedValues']!;
    }

    return WorkPackageOptions(
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
    );
  }

  WorkPackageOptions copyWith({
    List<WPType>? types,
    List<WPStatus>? statuses,
    List<WPPriority>? priorities,
    List<WPCategory>? categories,
    List<WPVersion>? versions,
    List<WPUser>? assignees,
    List<WPUser>? responsibles,
  }) {
    return WorkPackageOptions(
      types: types ?? this.types,
      statuses: statuses ?? this.statuses,
      priorities: priorities ?? this.priorities,
      categories: categories ?? this.categories,
      versions: versions ?? this.versions,
    );
  }

  @override
  bool operator ==(covariant WorkPackageOptions other) {
    if (identical(this, other)) return true;

    return listEquals(other.types, types) &&
        listEquals(other.statuses, statuses) &&
        listEquals(other.priorities, priorities) &&
        listEquals(other.categories, categories) &&
        listEquals(other.versions, versions);
  }

  @override
  int get hashCode {
    return types.hashCode ^
        statuses.hashCode ^
        priorities.hashCode ^
        categories.hashCode ^
        versions.hashCode;
  }
}
