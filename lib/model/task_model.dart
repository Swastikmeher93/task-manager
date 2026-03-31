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
  int? blockedBy;
  DateTime? completedAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
    this.completedAt,
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
      blockedBy: (json['blockedBy'] ?? 0) == 0 ? null : json['blockedBy'] as int,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }

  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'blockedBy': blockedBy ?? 0,
      'completedAt': completedAt?.toIso8601String(),
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }
}
