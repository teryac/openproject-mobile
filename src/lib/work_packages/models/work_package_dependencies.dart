class WorkPackageDependencies {
  final List<WorkPackageStatus> workPackageStatuses;
  final List<WorkPackageType> workPackageTypes;
  final List<WorkPackagePriority> workPackagePriorities;

  WorkPackageDependencies({
    required this.workPackageStatuses,
    required this.workPackageTypes,
    required this.workPackagePriorities,
  });

  factory WorkPackageDependencies.fromJson(Map<String, dynamic> json) {
    return WorkPackageDependencies(
      workPackageStatuses: (json['statuses'] as List)
          .map((e) => WorkPackageStatus.fromJson(e))
          .toList(),
      workPackageTypes: (json['types'] as List)
          .map((e) => WorkPackageType.fromJson(e))
          .toList(),
      workPackagePriorities: (json['priorities'] as List)
          .map((e) => WorkPackagePriority.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'statuses': workPackageStatuses.map((e) => e.toJson()).toList(),
        'types': workPackageTypes.map((e) => e.toJson()).toList(),
        'priorities': workPackagePriorities.map((e) => e.toJson()).toList(),
      };
}

class WorkPackageStatus {
  final int id;
  final String name;
  final bool isClosed;
  final String colorHex;
  final bool isDefault;
  final int position;
  final bool isReadonly;

  WorkPackageStatus({
    required this.id,
    required this.name,
    required this.isClosed,
    required this.colorHex,
    required this.isDefault,
    required this.position,
    required this.isReadonly,
  });

  /// Creates a WorkPackageStatus from a single JSON map (an element).
  factory WorkPackageStatus.fromJson(Map<String, dynamic> json) {
    return WorkPackageStatus(
      id: json['id'] as int,
      name: json['name'] as String,
      isClosed: json['isClosed'] as bool,
      // Note: Mapping the 'color' JSON key to your 'colorHex' field.
      colorHex: json['color'] as String,
      isDefault: json['isDefault'] as bool,
      position: json['position'] as int,
      isReadonly: json['isReadonly'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isClosed': isClosed,
      'color': colorHex,
      'isDefault': isDefault,
      'position': position,
      'isReadonly': isReadonly,
    };
  }
}

class WorkPackageType {
  final int id;
  final String name;
  final String colorHex;
  final int position;
  final bool isMilestone;

  WorkPackageType({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.position,
    required this.isMilestone,
  });

  factory WorkPackageType.fromJson(Map<String, dynamic> json) {
    return WorkPackageType(
      id: json['id'] as int,
      name: json['name'] as String,
      colorHex: json['color'] as String,
      position: json['position'] as int,
      isMilestone: json['isMilestone'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': colorHex,
      'position': position,
      'isMilestone': isMilestone,
    };
  }
}

class WorkPackagePriority {
  final int id;
  final String name;
  final int position;
  final String colorHex;
  final bool isDefault;
  final bool isActive;

  WorkPackagePriority({
    required this.id,
    required this.name,
    required this.position,
    required this.colorHex,
    required this.isDefault,
    required this.isActive,
  });

  factory WorkPackagePriority.fromJson(Map<String, dynamic> json) {
    return WorkPackagePriority(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      colorHex: json['color'],
      isDefault: json['isDefault'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'color': colorHex,
      'isDefault': isDefault,
      'isActive': isActive,
    };
  }
}
