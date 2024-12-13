import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Model/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final _supabase = Supabase.instance.client;

  Future<void> fetchTasks() async {
    print("------------------- Fetching Tasks -------------------");
    emit(TaskLoading()); // Emit loading state
    try {
      print("inside try");
      final response = await _supabase.from('tasks').select();
      final tasks = (response as List<dynamic>).map((item) => TaskModel.fromJson(item)).toList();
      emit(TaskLoaded(tasks)); // Emit loaded state with data
      print('------------------- Response Result -------------------');
      print("${tasks[0]} task ");
    } catch (e) {
      print("inside catch");
      emit(TaskError('Exception while fetching tasks: $e'));
    }
  }
}
