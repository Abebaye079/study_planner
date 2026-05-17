import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String subject;
  final String topic;
  final String priority;
  final String dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.subject,
    required this.topic,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      subject: json['title'] ?? '',
      topic: json['topic'] ?? '',
      priority: json['priority'] ?? 'Medium',
      dueDate: json['dueDate'] ?? '',
      isCompleted: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': subject,
      'topic': topic,
      'priority': priority,
      'dueDate': dueDate,
      'completed': isCompleted,
      'userId': 1,
    };
  }

  Task copyWith({
    int? id,
    String? subject,
    String? topic,
    String? priority,
    String? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        subject,
        topic,
        priority,
        dueDate,
        isCompleted,
      ];
}