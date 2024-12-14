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
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
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
                        controller: TextEditingController(text: task.taskContent),
                      ),
                      TextField(
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Place'),
                        controller: TextEditingController(text: task.place),
                      ),
                      InkWellWidget(
                        OptionName: 'Repeat',
                        InitialData: 'One Time',
                        OnTap: () async {
                          await radioButtons(
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
                        },
                      ),
                      InkWellWidget(
                        OptionName: 'Reminder',
                        InitialData: 'Before 5 Minutes',
                        OnTap: () async {
                          await radioButtons(
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

radioButtons({required BuildContext context, required Deviceinfo deviceinfo, required List<String> ItemsList, required String title}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.05)),
          backgroundColor: Colors.grey.shade900,
          scrollable: false,
          content: SizedBox(
            height: deviceinfo.screenHeight * 0.33,
            width: deviceinfo.screenWidth * 0.5,
            child: Column(
              spacing: deviceinfo.screenHeight * 0.007,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: deviceinfo.screenWidth * 0.5,
                  height: deviceinfo.screenHeight * 0.25,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ItemsList.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<int>(
                          title: Text(ItemsList[index], style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)),
                          value: index,
                          groupValue: 0,
                          fillColor: WidgetStateProperty.all(ColorsManager.buttonColor),
                          onChanged: (int? value) {
                            print(value);
                          },
                        );
                      }),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.buttonColor),
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)))
              ],
            ),
          ),
        );
      });
}
