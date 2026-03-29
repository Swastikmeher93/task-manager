enum TaskStatus {
  pending,
  inProgress,
  completed,
}

class TaskModel {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  TaskStatus status;
  bool blockedBy;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy = false,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: TaskStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      blockedBy: (json['blockedBy'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'blockedBy': blockedBy ? 1 : 0,
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }
}
