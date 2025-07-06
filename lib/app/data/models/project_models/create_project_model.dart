class CreateProjectModel {
  final String name;
  final String projectNo;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int> taskIds;

  CreateProjectModel({
    required this.name,
    required this.projectNo,
    this.startDate,
    this.endDate,
    required this.taskIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'projectNo': projectNo,
      'startDate': startDate != null
          ? DateTime.utc(startDate!.year, startDate!.month, startDate!.day)
              .toIso8601String()
          : null,
      'endDate': endDate != null
          ? DateTime.utc(endDate!.year, endDate!.month, endDate!.day)
              .toIso8601String()
          : null,
      'taskIds': taskIds,
    };
  }
}
