import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeTasksInitial()) {}

  final _supabase = Supabase.instance.client;

  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = [];
  StreamSubscription? _sharedTasksSubscription;
  StreamSubscription? _tasksSubscription;

  Future<void> getTasks() async {
    emit(HomeTasksLoading());
    try {
      var userId = Supabase.instance.client.auth.currentUser?.id;
      final response = await _supabase
          .from('tasks')
          .select('title, id, created_at, is_done')
          .eq('user_id', '$userId');

      if (response.isEmpty) {
        emit(NoTasks());
        return;
      }

      _allTasks = (response as List<dynamic>)
          .map((item) => TaskModel.fromJson(item))
          .toList();
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

      final responseShared = await _supabase
          .from('shared_task')
          .select('task_id')
          .eq('user_id', '$userId');
      pragma('responseShared $responseShared');
      if (responseShared.isEmpty) {
        emit(NoTasks());
        return;
      }
      final sharedTaskIds = (responseShared as List<dynamic>)
          .map((item) => item['task_id'])
          .toList();

      if (sharedTaskIds.isEmpty) {
        emit(NoTasks());
        return;
      }
      final orFilter = sharedTaskIds.map((id) => 'id.eq.$id').join(',');
      final responseTasks = await _supabase
          .from('tasks')
          .select('title, id, created_at, is_done')
          .or(orFilter);
      print("$responseTasks responseTasks");
      if (responseTasks.isEmpty) {
        emit(NoTasks());
        return;
      }

      _allTasks = (responseTasks as List<dynamic>)
          .map((item) => TaskModel.fromJson(item))
          .toList();
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
      _filteredTasks = _allTasks
          .where(
              (task) => task.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(SharedTaskloaded(tasks: _filteredTasks));
  }

  void subscribeToRealtimeSharedTasks() {
    var userId = _supabase.auth.currentUser?.id;
    _tasksSubscription =
        _supabase.from('tasks').stream(primaryKey: ['id']).listen((event) {
      print('Realtime event in task: $event');
      getSharedTasks();
    });
    _sharedTasksSubscription = _supabase
        .from('shared_task')
        .stream(primaryKey: ['id']).listen((event) {
      print('Realtime event in shared_task: $event');
      getSharedTasks();
    });
  }

  Future<void> addTask(TaskModel task) async {
    print("------------------- Adding Task -------------------");
    emit(HomeTasksLoading());
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
      emit(HomeTasksError(error: 'Exception while adding task: $e'));
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    emit(HomeTasksLoading());
    try {
      await _supabase.from('tasks').delete().eq('id', task.id!).select();
      emit(TaskDeleted());
    } catch (e) {
      emit(HomeTasksError(error: 'Exception while deleting task: $e'));
    }
  }

  Future<void> getAllusers() async {
    emit(HomeTasksLoading());
    try {
      final response = await _supabase.from('users').select();
      emit(AllUsersLoaded(users: response));
    } catch (e) {
      emit(HomeTasksError(error: 'Exception while getting users: $e'));
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

  @override
  Future<void> close() {
    _sharedTasksSubscription?.cancel();
    return super.close();
  }
}
