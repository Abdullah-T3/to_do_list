import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit() : super(EditTaskInitial());

  final _supabase = Supabase.instance.client;

  Future<void> editTaskFetch(TaskModel task , int id) async {

    emit(EditTaskLoading());

    try {

      final response = await _supabase.from('tasks').select().eq('id', id);

      if (response == []) {
        throw Exception("Task not found");
      }
      emit(EditTaskLoaded(task: task));
    }
    catch (e) {
      emit(EditTaskFailure(error: e.toString()));
    }
  }
}
