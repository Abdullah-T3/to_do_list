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

import 'package:flutter_quill/flutter_quill.dart' as quill;


class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({super.key, required this.task}) {
    // Initialize controllers with task data
    titleController.text = task.title ?? '';
    contentController.text = task.taskContent ?? '';
    dateController.text = task.startDate ?? '';
    repeatController.text = task.repeat ?? '';
    placeController.text = task.place ?? '';
    reminderController.text = task.reminder.toString();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController repeatController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();

  final TaskModel task;
  TaskModel? updatedTask;


  @override
  Widget build(BuildContext context) {

    final quill.QuillController controller = quill.QuillController.basic();


    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocListener<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskUpdated) {
                context.pop();
              } else if (state is TaskDeleted) {
                context.pop();
              }
              if (state is TaskError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            child: IconButton(
              onPressed: () {
                final updatedTask = TaskModel(
                  id: task.id,
                  title: titleController.text.isNotEmpty ? titleController.text : task.title,
                  taskContent: contentController.text.isNotEmpty ? contentController.text : task.taskContent,
                  startDate: dateController.text.isNotEmpty ? dateController.text : task.startDate,
                  endDate: task.endDate, 
                  repeat: repeatController.text.isNotEmpty ? repeatController.text : task.repeat,
                  place: placeController.text.isNotEmpty ? placeController.text : task.place,
                  isDone: task.isDone,
                );
                context.read<TaskCubit>().updateTask(updatedTask);
              },
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<TaskCubit>().deleteTask(task.id!);
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
        title: Text('Edit Task', style: TextStyles.appBarStyle),
        backgroundColor: ColorsManager.appBarColor,
      ),
      body: Infowidget(
        builder: (context, deviceinfo) {
          return Container(

            width: deviceinfo.screenWidth,
            height: deviceinfo.screenHeight,
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    width: deviceinfo.screenWidth,
                    height: deviceinfo.screenHeight,
                    color: ColorsManager.EdittextFieldColor,
                    child: Column(
                      children: [
                        // TextField(
                        //   decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Task Title'),
                        //   controller: titleController,
                        // ),
                        // TextField(
                        //   decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Place'),
                        //   controller: placeController,
                        // ),
                        // InkWellWidget(
                        //   OptionName: 'Repeat',
                        //   InitialData: task.repeat ?? "One Time",
                        //   OnTap: () async {
                        //     await radioButtons(
                        //       context: context,
                        //       deviceinfo: deviceinfo,
                        //       title: 'Repeat',
                        //       ItemsList: [
                        //         'One Time',
                        //         'Daily',
                        //         'Weekly',
                        //         'Monthly',
                        //       ],
                        //     );
                        //   },
                        // ),
                        // InkWellWidget(
                        //   OptionName: 'Reminder',
                        //   InitialData: "Before 5 Minutes",
                        //   OnTap: () async {
                        //     await radioButtons(
                        //       context: context,
                        //       deviceinfo: deviceinfo,
                        //       title: 'Reminder',
                        //       ItemsList: [
                        //         'Before 5 Minutes',
                        //         'Before 10 Minutes',
                        //         'Before 15 Minutes',
                        //         'Before 20 Minutes',
                        //       ],
                        //     );
                        //   },
                        // ),
                        // InkWellWidget(
                        //   OptionName: 'Start Date',
                        //   InitialData: task.startDate ?? "",
                        //   OnTap: () async {
                        //     final DateTime? picked = await DatePicker(context);
                        //     if (picked != null) {
                        //       final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                        //       dateController.text = formattedDate;
                        //       context.read<TaskCubit>().changeDate(formattedDate);
                        //     }
                        //   },
                        // ),
                        // InkWellWidget(
                        //   OptionName: 'Finish',
                        //   InitialData: task.endDate ?? "",
                        //   OnTap: () async {
                        //     final DateTime? picked = await DatePicker(context);
                        //     if (picked != null) {
                        //       final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
                        //       task.endDate = formattedDate;
                        //       context.read<TaskCubit>().changeDate(formattedDate);
                        //     }
                        //   },
                        // ),

                        quill.QuillToolbar.simple(
                            controller: controller,
                            configurations: quill.QuillSimpleToolbarConfigurations(
                              toolbarSize: deviceinfo.screenWidth * 0.115,
                              showFontSize: true,
                              showDividers: false,
                              multiRowsDisplay: false,
                              decoration: BoxDecoration(color: ColorsManager.textFieldColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(deviceinfo.screenWidth * 0.02), bottomRight: Radius.circular(deviceinfo.screenWidth * 0.02)),
                                border:  BorderDirectional(bottom: BorderSide(width: deviceinfo.screenWidth * 0.017, color: Colors.grey[800]!)),
                              ),

                            )),



                        // Container(
                        //   height: deviceinfo.screenHeight,
                        //   width: deviceinfo.screenWidth ,
                        //   padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.03, end: deviceinfo.screenWidth * 0.03),
                        //   decoration: BoxDecoration(
                        //     color: Color(0xff6015b2),
                        //   ),
                        //   child: TextField(
                        //     decoration: const InputDecoration(
                        //       border: InputBorder.none,
                        //     ),
                        //     controller: contentController,
                        //   ),
                        // ),

                        Expanded(
                          child: quill.QuillEditor.basic(
                            controller: controller,
                            configurations:  quill.QuillEditorConfigurations(
                              padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.03, end: deviceinfo.screenWidth * 0.03, top: deviceinfo.screenHeight * 0.02 , bottom: deviceinfo.screenHeight * 0.02),
                              showCursor: true,
                              placeholder: 'Enter your content here...', 
                              customStyles: quill.DefaultStyles(

                                placeHolder: quill.DefaultTextBlockStyle(
                                    TextStyle(

                                    color: Colors.grey,
                                    fontSize: deviceinfo.screenWidth * 0.05
                                  ),
                                  quill.HorizontalSpacing(0, 0),
                                  quill.VerticalSpacing(0, 0),
                                  quill.VerticalSpacing(0, 0),
                                  BoxDecoration()
                                ),
                                paragraph:quill.DefaultTextBlockStyle(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceinfo.screenWidth * 0.05
                                  ),
                                    quill.HorizontalSpacing(0, 0),
                                    quill.VerticalSpacing(0, 0),
                                    quill.VerticalSpacing(0, 0),
                                    BoxDecoration()
                                ),
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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
