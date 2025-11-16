class AddWorkPackageScreenConfig {
  final bool editMode;

  /// Null, if not in edit mode
  final int? workPackageId;
  final int projectId;

  const AddWorkPackageScreenConfig({
    required this.editMode,
    required this.workPackageId,
    required this.projectId,
  });
}
