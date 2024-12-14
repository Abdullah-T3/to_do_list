import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_zagsystem/MVVM/Models/Tasks_Models/task_model.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';

import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../../../VIew_Models/Task_View_Models/task_cubit.dart';
import '../../Widgets/Add_Task_Widgets/InkWellWidget.dart';

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({super.key, required this.task});

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController reminderController = TextEditingController();
  final TaskModel task;
  TaskModel? updatedTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final updatedTask = TaskModel(
                id: task.id,
                title: titleController.text.isNotEmpty ? titleController.text : task.title,
                taskContent: contentController.text.isNotEmpty ? contentController.text : task.taskContent,
                startDate: task.startDate,
                endDate: task.endDate,
                repeat: repeatController.text.isNotEmpty ? repeatController.text : task.repeat,
                place: placeController.text.isNotEmpty ? placeController.text : task.place,
                isDone: task.isDone,
              );

              // Update the task before popping the screen
              context.read<TaskCubit>().updateTask(updatedTask);

              // Navigate back after the update is successful
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check, color: Colors.white),
          )
        ],
        title: Text('Edit Task', style: TextStyles.appBarStyle),
        backgroundColor: ColorsManager.buttonColor,
      ),
      body: Infowidget(
        builder: (context, deviceinfo) {
          return Container(
            color: ColorsManager.primaryColor,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05, top: deviceinfo.screenHeight * 0.02, bottom: deviceinfo.screenHeight * 0.05),
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  return Column(
                    spacing: deviceinfo.screenHeight * 0.01,
                    children: [
                      TextField(
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Task Title'),
                        controller: task.title == null ? titleController : TextEditingController(text: task.title),
                      ),
                      TextField(
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Place'),
                        controller: task.place == null ? placeController : TextEditingController(text: task.place),
                      ),
                      InkWellWidget(
                        OptionName: 'Repeat',
                        InitialData: task.repeat ?? 'One Time',
                        OnTap: () async {
                          final selectedRepeat = await radioButtons(
                            context: context,
                            deviceinfo: deviceinfo,
                            title: 'Repeat',
                            ItemsList: [
                              'One Time',
                              'Daily',
                              'Weekly',
                              'Monthly'
                            ],
                          );
                          if (selectedRepeat != null) {
                            repeatController.text = selectedRepeat;
                          }
                        },
                      ),
                      InkWellWidget(
                        OptionName: 'Reminder',
                        InitialData: task.reminder.toString() ?? 'Before 5 Minutes',
                        OnTap: () async {
                          final selectedReminder = await radioButtons(
                            context: context,
                            deviceinfo: deviceinfo,
                            title: 'Reminder',
                            ItemsList: [
                              'Before 5 Minutes',
                              'Before 10 Minutes',
                              'Before 15 Minutes',
                              'Before 20 Minutes'
                            ],
                          );
                          if (selectedReminder != null) {
                            reminderController.text = selectedReminder;
                          }
                        },
                      ),
                      InkWellWidget(
                        OptionName: 'Start Date',
                        InitialData: task.startDate ?? "",
                        OnTap: () async {
                          final DateTime? picked = await DatePicker(context);
                          if (picked != null) {
                            print("${task.startDate} start date");
                            task.startDate = picked.toString().substring(0, 10);
                            final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                            context.read<TaskCubit>().changeDate(formattedDate);
                          }
                          print(picked);
                        },
                      ),
                      InkWellWidget(
                        OptionName: 'Finish',
                        InitialData: task.endDate ?? "",
                        OnTap: () async {
                          final DateTime? picked = await DatePicker(context);
                          if (picked != null) {
                            task.endDate = picked.toString().substring(0, 10);
                            final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                            context.read<TaskCubit>().changeDate(formattedDate);
                          }
                          print(picked);
                        },
                      ),
                      

                      Container(
                          height: deviceinfo.screenHeight * 0.55,
                          width: deviceinfo.screenWidth * 0.8,
                          padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.03, end: deviceinfo.screenWidth * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                            color: ColorsManager.textFieldColor,
                          ),
                          child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            controller: task.taskContent == null ? contentController : TextEditingController(text: task.taskContent),                          )),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<DateTime?> DatePicker(BuildContext context) {
  return showDatePicker(
    context: context,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: ColorsManager.buttonColor, // header background color
            onSurface: Colors.white, // body text color

            surfaceContainerHigh: Colors.grey.shade900,
          ),
        ),
        child: child!,
      );
    },
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
  );
}

Future<String?> radioButtons({
  required BuildContext context,
  required Deviceinfo deviceinfo,
  required List<String> ItemsList,
  required String title,
}) async {
  int? selectedValue;
  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.05)),
        backgroundColor: Colors.grey.shade900,
        scrollable: false,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: ItemsList.length,
              itemBuilder: (context, index) {
                return RadioListTile<int>(
                  title: Text(ItemsList[index], style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)),
                  value: index,
                  groupValue: selectedValue,
                  onChanged: (int? value) {
                    selectedValue = value;
                  },
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.buttonColor),
              onPressed: () {
                Navigator.pop(context, selectedValue != null ? ItemsList[selectedValue!] : null);
              },
              child: Text('Done', style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)),
            ),
          ],
        ),
      );
    },
  );
}
