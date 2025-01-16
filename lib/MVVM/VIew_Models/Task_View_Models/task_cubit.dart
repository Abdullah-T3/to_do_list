import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list_zagsystem/helpers/notification_helper.dart';

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
      for(var task in tasks){
        if(task.reminder != null){
          NotificationHelper.scheduleNotification(
            id: task.id!,
            title: task.title!,
            body: task.taskContent!,
            scheduledTime: DateTime.parse(task.startDate!),
            repeatInterval: RepeatInterval.daily,
          );
        }
      }
      emit(TaskLoaded(tasks));
    } catch (e) {
      print(e);
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

      final response = await _supabase.from('tasks').insert({
        "task_content": task.taskContent,
        "is_done": task.isDone ?? false,
        "user_id": userId,
        "start_date": task.startDate,
        "end_date": task.endDate,
        "reminder": task.reminder,
        "repeat": task.repeat,
        "title": task.title,
        "place": task.place,
      }).select();

      if (response == null || response.isEmpty) {
        throw Exception("Task insert failed: Response is null or empty");
      }

      emit(TaskUpdated());
    } catch (e) {
      print(e);
      emit(TaskError('Exception while adding task: $e'));
    }
  }

  Future<void> deleteTask(int taskId) async {
    print("------------------- Deleting Task -------------------");
    emit(TaskLoading());
    try {
      final response = await _supabase.from('tasks').delete().eq('id', taskId).select();

      if (response.isEmpty) {
        emit(TaskError('No task found with the given ID.'));
      } else {
        emit(TaskDeleted());
      }
    } catch (e) {
      emit(TaskError('Exception while deleting task: $e'));
    }
  }


  void changeDate(String date) {
    emit(pickedDateTask(date));
  }
  void changeRepeat(String repeat) {
    emit(pickedRepeatTask(repeat));
  }

  void changeReminder(int reminder) {
    emit(pickedReminderTask(reminder));
  }

}
