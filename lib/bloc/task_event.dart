import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {
  const FetchTasks();
}

class CreateTask extends TaskEvent {
  final Task task;
  const CreateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final int id;
  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTask extends TaskEvent {
  final Task task;
  const ToggleTask(this.task);

  @override
  List<Object?> get props => [task];
}