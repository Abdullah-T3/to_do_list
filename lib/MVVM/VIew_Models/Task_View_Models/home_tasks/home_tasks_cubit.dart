import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'home_tasks_state.dart';

class HomeTasksCubit extends Cubit<HomeTasksState> {
  HomeTasksCubit() : super(HomeTasksInitial()) {
    _subscribeToRealtimeSharedTasks();
  }

  final _supabase = Supabase.instance.client;

  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = [];
  StreamSubscription? _sharedTasksSubscription;
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
      _filteredTasks = _allTasks;
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
      pragma('responseShared $responseShared');
      if (responseShared.isEmpty) {
        emit(NoTasks());
        return;
      }
      final sharedTaskIds = (responseShared as List<dynamic>).map((item) => item['task_id']).toList();

      if (sharedTaskIds.isEmpty) {
        emit(NoTasks());
        return;
      }
      final orFilter = sharedTaskIds.map((id) => 'id.eq.$id').join(',');
      final responseTasks = await _supabase.from('tasks').select('title, id, created_at, is_done').or(orFilter);
      print("$responseTasks responseTasks");
      if (responseTasks.isEmpty) {
        emit(NoTasks());
        return;
      }

      _allTasks = (responseTasks as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      _filteredTasks = _allTasks;

      emit(SharedTaskloaded(tasks: _filteredTasks));
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
    emit(SharedTaskloaded(tasks: _filteredTasks));
  }

  void _subscribeToRealtimeSharedTasks() {
    var userId = _supabase.auth.currentUser?.id;

    _sharedTasksSubscription = _supabase.from('tasks').stream(primaryKey: [
      'id'
    ]).listen((event) {
      print('Realtime event in shared_task: $event');
      getSharedTasks();
    });
  }

  @override
  Future<void> close() {
    _sharedTasksSubscription?.cancel();
    return super.close();
  }
}
