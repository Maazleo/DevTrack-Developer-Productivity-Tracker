class Task {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime? dueDate;
  final String? projectId;
  final String? description;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.projectId,
    this.description,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    String? projectId,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
    );
  }
} 