import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/Tasks_Models/task_model.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit() : super(EditTaskInitial());

  final _supabase = Supabase.instance.client;

  late QuillController controller;

  static String taskID = '';

  TextEditingController titleController = TextEditingController();
  dynamic contentController = '';
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  int reminderController = 0;
  bool isDone = false;

  Future<void> fetchTask() async {
    emit(EditTaskLoading());

    try {
      final response = await _supabase.from('tasks').select().eq('id', taskID);

      final task = (response as List<dynamic>)
          .map((item) => TaskModel.fromJson(item))
          .first;

      if (response == []) {
        throw Exception("Task not found");
      }
      titleController.text = task.title ?? '';
      contentController = task.taskContent ?? '';
      startDateController.text = task.startDate ?? '';
      endDateController.text = task.endDate ?? '';
      repeatController.text = task.repeat ?? '';
      placeController.text = task.place ?? '';
      reminderController = task.reminder ?? 0;
      isDone = task.isDone ?? false;
      print(
          'isDone: $isDone, title: ${task.title}, content: ${task.taskContent}, startDate: ${task.startDate}, endDate: ${task.endDate}, repeat: ${task.repeat}, place: ${task.place}, reminder: ${task.reminder}');

      // **************** nitializing the Controller of Quill to display the Content of the Task

      if (contentController.isNotEmpty) {
        controller = QuillController(
            document:
                Document.fromJson(jsonDecode(contentController as String)),
            selection: const TextSelection.collapsed(offset: 0));
      } else {
        controller = QuillController.basic();
      }
      // Listener on the Changes of the Controller
      controller.document.changes.listen((event) {
        // print(event.before);
        print(controller.document.toDelta().toJson());
        print('---------------------------------');
        print(controller.document.toDelta().toList());
        print('---------------------------------');

        // }
      });

      emit(EditTaskLoaded());
    } catch (e) {
      emit(EditTaskFailure(error: e.toString()));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    print("------------------- Updating Task -------------------");
    emit(EditTaskLoading());
    try {
      if (task.id == null) {
        throw Exception("Task ID cannot be null");
      }
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
          .eq('id', task.id!)
          .select();
      if (response == null || response.isEmpty) {
      } else {
        emit(TaskUpdated());
      }
    } catch (e) {
      emit(EditTaskFailure(error: ('Exception while updating task: $e')));
    }
  }
}
