import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';
import 'package:to_do_list_zagsystem/routing/routs.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';

import '../../../../theming/colors.dart';
import '../../../Models/Tasks_Models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceinfo) {
      return InkWell(
        onTap: () {
          context.pushNamed(Routes.editTaskScreen, arguments: task);
        },
        child: Card(
          color: ColorsManager.buttonColor,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(task.title ?? 'No title', style: const TextStyle(color: Colors.white)),
            subtitle: Text(task.createdAt?.toString() ?? '', style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold)),
            trailing: Icon(
              task.isDone == true ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isDone == true ? Colors.green : Colors.grey,
            ),
          ),
        ),
      );
    });
  }
}
