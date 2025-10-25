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
}
