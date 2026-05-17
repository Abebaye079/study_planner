import 'package:dio/dio.dart';
import '../models/task.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/todos');
      // Return empty list instead of fake data
      return [];
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await _dio.post(
        '/todos',
        data: task.toJson(),
      );
      return Task.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final validId = task.id > 100 ? 1 : task.id;
      final response = await _dio.put(
        '/todos/$validId',
        data: task.toJson(),
      );
      return task;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final validId = id > 100 ? 1 : id;
      await _dio.delete('/todos/$validId');
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Try again.';
    }
  }
}