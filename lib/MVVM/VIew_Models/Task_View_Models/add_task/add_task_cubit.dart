import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  final _supabase = Supabase.instance.client;

  Future<void> addTask(TaskModel task) async {
    print("------------------- Adding Task -------------------");
    emit(AddTaskLoading());
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

      emit(AddTaskSuccess());
    } catch (e) {
      print(e);
      emit(AddTaskFailure(message: e.toString()));
    }
  }

}

class _supabase {
}
