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
}
