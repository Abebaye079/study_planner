import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];

  TaskBloc() : super(const TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTask>(_onToggleTask);
  }

  Future<void> _onFetchTasks(
    FetchTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      _tasks = await _apiService.getTasks();
      emit(TaskLoaded(_tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      await _apiService.createTask(event.task);
      final localId = DateTime.now().millisecondsSinceEpoch;
      final newTask = event.task.copyWith(id: localId);
      _tasks.insert(0, newTask);
      emit(TaskActionSuccess('Task added successfully!', _tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      await _apiService.updateTask(event.task);
      final index = _tasks.indexWhere((t) => t.id == event.task.id);
      if (index != -1) {
        _tasks[index] = event.task;
      }
      emit(TaskActionSuccess('Task updated successfully!', _tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      await _apiService.deleteTask(event.id);
      _tasks.removeWhere((t) => t.id == event.id);
      emit(TaskActionSuccess('Task deleted successfully!', _tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTask(
    ToggleTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
      );
      await _apiService.updateTask(updatedTask);
      final index = _tasks.indexWhere((t) => t.id == event.task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      emit(TaskLoaded(List.from(_tasks)));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}