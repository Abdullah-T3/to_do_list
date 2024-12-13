import 'package:flutter/material.dart';

import '../../../../theming/colors.dart';
import '../../../Models/Tasks_Models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsManager.buttonColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(task.taskContent ?? 'No content', style: const TextStyle(color: Colors.white)),
        subtitle: Text(task.createdAt?.toString() ?? '', style: const TextStyle(color: Colors.grey)),
        trailing: Icon(
          task.isDone == true ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isDone == true ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
