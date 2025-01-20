import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'home_tasks_state.dart';

class HomeTasksCubit extends Cubit<HomeTasksState> {
  HomeTasksCubit() : super(HomeTasksInitial());
  final _supabase = Supabase.instance.client;

  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = []; 

  Future<void> getTasks() async {
    emit(HomeTasksLoading());
    try {
      var userId = Supabase.instance.client.auth.currentUser?.id;
      final response = await _supabase.from('tasks').select('title, id, created_at, is_done').eq('user_id', '$userId');

      if (response.isEmpty) {
        emit(NoTasks());
        return;
      }

      _allTasks = (response as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      _filteredTasks = _allTasks; // Initialize filtered tasks with all tasks
      emit(HomeTasksLoaded(tasks: _filteredTasks));
    } catch (e) {
      emit(HomeTasksError(error: e.toString()));
    }
  }

  Future<void> getSharedTasks() async {
    emit(HomeTasksLoading());
    try {
      var userId = Supabase.instance.client.auth.currentUser?.id;

      final responseShared = await _supabase.from('shared_task').select('task_id').eq('user_id', '$userId');

      if (responseShared.isEmpty) {
        emit(NoTasks());
        return;
      }

      final sharedTaskIds = (responseShared as List<dynamic>).map((item) => item['task_id'] as String).toList();

      final responseTasks = await _supabase.from('tasks').select('title, id, created_at, is_done').eq('id', sharedTaskIds);

      if (responseTasks.isEmpty) {
        emit(NoTasks());
        return;
      }

      _allTasks = (responseTasks as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      _filteredTasks = _allTasks; // Initialize filtered tasks with all tasks
      emit(HomeTasksLoaded(tasks: _filteredTasks));
    } catch (e) {
      emit(HomeTasksError(error: e.toString()));
    }
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      _filteredTasks = _allTasks;
    } else {
      _filteredTasks = _allTasks.where((task) => task.title!.toLowerCase().contains(query.toLowerCase())).toList();
    }
    emit(HomeTasksLoaded(tasks: _filteredTasks));
  }
}
