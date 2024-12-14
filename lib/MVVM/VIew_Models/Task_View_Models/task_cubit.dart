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
      final response = await _supabase.from('tasks').select();
      final tasks = (response as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      emit(TaskLoaded(tasks)); // Emit loaded state with data
    } catch (e) {
      emit(TaskError('Exception while fetching tasks: $e'));
    }
  }

  Future<void> addTask(TaskModel task) async {
    print("------------------- Adding Task -------------------");
    emit(TaskLoading());
    try {
      print("into try");
      final response = await _supabase.from('tasks').insert({
        "task_content": task.taskContent,
        "is_done": task.isDone,
        "user_id": Supabase.instance.client.auth.currentUser?.id,
        "start_date": task.startDate,
        "end_date": task.endDate,
        "reminder": task.reminder,
        "repeat": task.repeat,
        "title": task.title,
        "place": task.place
      });
      print("TaskData : $task[0]");
      print("Response: $response");
      emit(TaskUpdated());
      print("Task added successfully!");
    } catch (e) {
      emit(TaskError('Exception while adding task: $e'));
    }
  }

  Future<void> deleteTask(int taskId) async {
    print("------------------- Deleting Task -------------------");
    emit(TaskLoading());
    try {
      final response = await _supabase.from('tasks').delete().eq('id', taskId);
      if (response != null) {
        fetchTasks(); // Refresh the tasks list
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
      final response = await _supabase.from('tasks').update(task.toJson()).eq('id', task.id as Object);
      if (response != null) {
        fetchTasks(); // Refresh the tasks list
      } else {
        emit(TaskError('Failed to update task.'));
      }
    } catch (e) {
      emit(TaskError('Exception while updating task: $e'));
    }
  }

  void changeDate(String date) {
    emit(pickedDateTask(date));
  }
}
