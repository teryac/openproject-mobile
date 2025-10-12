class WorkPackageModel {
  final String title;
  final DateTime? endDate;
  final String assignee;
  final String status;
  final String statusColor;

  const WorkPackageModel({
    required this.title,
    this.endDate,
    required this.assignee,
    required this.status,
    required this.statusColor,
  });
}
