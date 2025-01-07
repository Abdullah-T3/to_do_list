import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../theming/styles.dart';
import '../../../Models/Tasks_Models/task_model.dart';
import '../../../VIew_Models/Task_View_Models/task_cubit.dart';
import '../../Widgets/Add_Task_Widgets/InkWellWidget.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../helpers/extantions.dart';

import '../../Widgets/Add_Task_Widgets/Radio_Button_Widget.dart';
import '../Edit_task/Edit_task_Screen.dart';


// ignore: must_be_immutable
class Add_Task_Screen extends StatefulWidget {
  const Add_Task_Screen({super.key});

  @override
  State<Add_Task_Screen> createState() => _Add_Task_ScreenState();
}

class _Add_Task_ScreenState extends State<Add_Task_Screen> {
  final titleController = TextEditingController();

  final placeController = TextEditingController();

  final notesController = TextEditingController();

  DateTime? startDate = DateTime.now();

  DateTime? endDate = DateTime.now();

  String selectedRepeatOption = 'One Time';

  int selectedReminderOption_index = 5;

  @override
  void dispose() {
    titleController.dispose();
    placeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceinfo) {
      return Scaffold(
        extendBodyBehindAppBar: true, // Makes the body extend behind the AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0, // Removes shadow
          actions: [
            BlocListener<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state is TaskUpdated) {
                  context.pop();
                }
              },
              child: IconButton(
                onPressed: () {
                  // Collect data from the form (title, start date, etc.)
                  final task = TaskModel(
                    title: titleController.text,
                    startDate: startDate.toString().substring(0, 10),
                    endDate: endDate.toString().substring(0, 10),
                    repeat: selectedRepeatOption,
                    reminder: selectedReminderOption_index,
                    place: placeController.text,
                    taskContent: notesController.text,
                  );
                  print("Task added: $task");
                  context.read<TaskCubit>().addTask(task);
                },
                icon: const Icon(Icons.check),
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.grey, size: deviceinfo.screenWidth * 0.07), // For back button or menu icon
        ),
        body: SafeArea(
          top: false,
          child: Container(
            width: deviceinfo.screenWidth,
            height: deviceinfo.screenHeight,
            decoration: MainBackgroundAttributes.MainBoxDecoration,
            padding: EdgeInsetsDirectional.only(
                top: deviceinfo.screenHeight * 0.12, start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05),
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return Column(
                  spacing: deviceinfo.screenHeight * 0.025,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Schedule', style: TextStyle(fontSize: deviceinfo.screenWidth * 0.045, fontWeight: FontWeight.w400, color: Colors.white)),
                    SizedBox(
                      width: deviceinfo.screenWidth * 0.9,
                      height: deviceinfo.screenHeight * 0.05,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Title'),
                        maxLines: 1,
                        style: TextStyle(fontSize: deviceinfo.screenWidth * 0.03, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.text,
                        controller: titleController,
                      ),
                    ),
                    InkWellWidget(
                      OptionName: 'Start Date',
                      InitialData: startDate.toString().substring(0, 10),
                      OnTap: () async {
                        final DateTime? picked = await DatePicker(context);
                        if (picked != null) {
                          startDate = picked;
                          final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                          context.read<TaskCubit>().changeDate(formattedDate);
                        }
                        print(picked);
                      },
                    ),
                    InkWellWidget(
                      OptionName: 'Finish',
                      InitialData: endDate.toString().substring(0, 10),
                      OnTap: () async {
                        final DateTime? picked = await DatePicker(context);
                        if (picked != null) {
                          endDate = picked;
                          final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                          context.read<TaskCubit>().changeDate(formattedDate);
                        }
                        print(picked);
                      },
                    ),
                    InkWellWidget(
                      OptionName: 'Repeat',
                      InitialData: selectedRepeatOption,
                      OnTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return RadioButtonWidget(
                              title: 'Repeat',
                              itemsList: const ['One Time', 'Daily', 'Weekly', 'Monthly'],
                              deviceinfo: deviceinfo,
                              initialIndex: ['One Time', 'Daily', 'Weekly', 'Monthly'].indexOf(selectedRepeatOption),
                              onSelected: (int index) {
                                setState(() {
                                  selectedRepeatOption = ['One Time', 'Daily', 'Weekly', 'Monthly'][index];
                                  print(selectedRepeatOption);

                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                    InkWellWidget(
                      OptionName: 'Reminder',
                      InitialData: 'Before $selectedReminderOption_index Minutes',
                      OnTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return RadioButtonWidget(
                              title: 'Reminder',
                              itemsList: const [
                                'Before 5 Minutes',
                                'Before 10 Minutes',
                                'Before 15 Minutes',
                                'Before 20 Minutes'
                              ],
                              deviceinfo: deviceinfo,
                              initialIndex: [5, 10, 15, 20].indexOf(selectedReminderOption_index),
                              onSelected: (int index) {
                                setState(() {
                                  selectedReminderOption_index = [5, 10, 15, 20][index];
                                  print(selectedReminderOption_index);
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: deviceinfo.screenWidth * 0.9,
                      height: deviceinfo.screenHeight * 0.05,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Place'),
                        maxLines: 1,
                        style: TextStyle(fontSize: deviceinfo.screenWidth * 0.03, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.text,
                        controller: placeController,
                      ),
                    ),
                    SizedBox(
                      width: deviceinfo.screenWidth * 0.9,
                      height: deviceinfo.screenHeight * 0.05,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Notes'),
                        maxLines: 1,
                        style: TextStyle(fontSize: deviceinfo.screenWidth * 0.03, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.text,
                        controller: notesController,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}




