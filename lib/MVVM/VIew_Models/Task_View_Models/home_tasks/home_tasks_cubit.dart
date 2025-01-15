import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'home_tasks_state.dart';
class HomeTasksCubit extends Cubit<HomeTasksState> {
  HomeTasksCubit() : super(HomeTasksInitial());
  final _supabase = Supabase.instance.client;

  Future<void> getTasks() async {
    emit(HomeTasksLoading());
    try {

      var userId = Supabase.instance.client.auth.currentUser?.id;
      final response = await _supabase.from('tasks').select('title ,id, created_at , is_done').eq('user_id', '$userId');
      if (response == []) {
        emit(NoTasks());
      }
      final tasks = (response as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      emit(HomeTasksLoaded(tasks: tasks));
    } catch (e) {
      emit(HomeTasksError(error: e.toString()));
    }
  }
}
