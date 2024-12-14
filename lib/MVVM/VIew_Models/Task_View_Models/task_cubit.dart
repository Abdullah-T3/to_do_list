import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/Tasks_Models/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial([]));

  final _supabase = Supabase.instance.client;

  Future<void> fetchTasks() async {
    print("------------------- Fetching Tasks -------------------");
    emit(TaskLoading());
    try {
      var userId = Supabase.instance.client.auth.currentUser?.id;
      final response = await _supabase.from('tasks').select().eq('user_id', '$userId');
      if (response == []) {
        emit(NoTaske());
      }
      final tasks = (response as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Exception while fetching tasks: $e'));
    }
  }

  Future<void> addTask(TaskModel task) async {
    print("------------------- Adding Task -------------------");
    emit(TaskLoading());
    try {
      var userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Insert data into the Supabase database
      final response = await _supabase.from('tasks').insert({
        "task_content": task.taskContent, // Task content
        "is_done": task.isDone ?? false, // Boolean value
        "user_id": userId, // User ID
        "start_date": task.startDate, // Start date
        "end_date": task.endDate, // End date
        "reminder": task.reminder, // Reminder details
        "repeat": task.repeat, // Repeat configuration
        "title": task.title, // Task title
        "place": task.place, // Task location
      }).select(); // Updated: Use `select()` to fetch the inserted row

      if (response == null || response.isEmpty) {
        throw Exception("Task insert failed: Response is null or empty");
      }

      print("Task added successfully: ${response.toString()}");
      emit(TaskUpdated());
    } catch (e) {
      print("Error adding task: $e");
      emit(TaskError('Exception while adding task: $e'));
    }
  }

  Future<void> deleteTask(int taskId) async {
    print("------------------- Deleting Task -------------------");
    emit(TaskLoading());
    try {
      final response = await _supabase.from('tasks').delete().eq('id', taskId);
      if (response != null) {
        emit(TaskDeleted());
      } else {
        emit(TaskError('Failed to delete task.'));
      }
    } catch (e) {
      emit(TaskError('Exception while deleting task: $e'));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    print("------------------- Updating Task -------------------");
    emit(TaskLoading());
    try {
      if (task.id == null) {
        throw Exception("Task ID cannot be null");
      }
      print("Task ID: ${task.id}");

      // Perform the update operation
      final response = await _supabase
          .from('tasks')
          .update({
            "task_content": task.taskContent,
            "is_done": task.isDone,
            "user_id": Supabase.instance.client.auth.currentUser?.id,
            "start_date": task.startDate,
            "end_date": task.endDate,
            "reminder": task.reminder,
            "repeat": task.repeat,
            "title": task.title,
            "place": task.place,
          })
          .eq('id', task.id as Object)
          .select(); // Use .select() to return affected rows

      // Check if response is valid
      if (response == null || response.isEmpty) {
        throw Exception("Task update failed: Response is null or empty");
      }

      print("Task updated successfully: ${response.toString()}");
      await fetchTasks(); // Refresh the tasks list
    } catch (e) {
      print("Error updating task: $e");
      emit(TaskError('Exception while updating task: $e'));
    }
  }

  void changeDate(String date) {
    emit(pickedDateTask(date));
  }
}
