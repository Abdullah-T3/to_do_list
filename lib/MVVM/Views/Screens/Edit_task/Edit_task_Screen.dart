
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:to_do_list_zagsystem/MVVM/Models/Tasks_Models/task_model.dart';
import 'package:to_do_list_zagsystem/MVVM/VIew_Models/Task_View_Models/edit_task/edit_task_cubit.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';

import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;


class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key, required this.task}) {

  }

  final TaskModel task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {


  @override
  void initState() {
    super.initState();

    context.read<EditTaskCubit>().fetchTask();


  }


  @override
  Widget build(BuildContext context) {





    return BlocConsumer<EditTaskCubit, EditTaskState>(
      listener: (context, state) {
      if (state is TaskUpdated) {
        context.pop();
      }
      // } else if (state is TaskDeleted) {
      //   context.pop();
      // }
      if (state is EditTaskFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));

      }
    },
    builder: (context, state) {
        if(state is EditTaskLoaded) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {

                  final updatedTask = TaskModel(
                    id: int.parse(EditTaskCubit.taskID),
                    title: context.read<EditTaskCubit>().titleController.text,
                    taskContent: jsonEncode(context.read<EditTaskCubit>().controller.document.toDelta().toJson() as List),
                    startDate:
                        context.read<EditTaskCubit>().startDateController.text,
                    endDate:
                        context.read<EditTaskCubit>().endDateController.text,
                    repeat: context.read<EditTaskCubit>().repeatController.text,
                    place: context.read<EditTaskCubit>().placeController.text,
                    reminder: context.read<EditTaskCubit>().reminderController,
                    isDone: context.read<EditTaskCubit>().isDone,
                  );

                  context.read<EditTaskCubit>().updateTask(updatedTask);
                },
                icon: const Icon(Icons.check, color: Colors.white),
              ),

              IconButton(
                onPressed: () {
                  // context.read<EditTaskCubit>().deleteTask(widget.task.id!);
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
            title: Text(context.read<EditTaskCubit>().titleController.text,
                style: TextStyles.appBarStyle),
            backgroundColor: ColorsManager.appBarColor,
          ),
          body: Infowidget(
            builder: (context, deviceinfo) {
              return Container(
                width: deviceinfo.screenWidth,
                height: deviceinfo.screenHeight,
                child: BlocBuilder<EditTaskCubit, EditTaskState>(
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
                                controller: context.read<EditTaskCubit>().controller,
                                configurations:
                                    quill.QuillSimpleToolbarConfigurations(
                                  toolbarSize: deviceinfo.screenWidth * 0.115,
                                  showFontSize: true,
                                  showDividers: false,
                                  multiRowsDisplay: false,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.textFieldColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            deviceinfo.screenWidth * 0.02),
                                        bottomRight: Radius.circular(
                                            deviceinfo.screenWidth * 0.02)),
                                    border: BorderDirectional(
                                        bottom: BorderSide(
                                            width:
                                                deviceinfo.screenWidth * 0.017,
                                            color: Colors.grey[800]!)),
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
                                controller: context.read<EditTaskCubit>().controller,
                                configurations: quill.QuillEditorConfigurations(
                                    padding: EdgeInsetsDirectional.only(
                                        start: deviceinfo.screenWidth * 0.03,
                                        end: deviceinfo.screenWidth * 0.03,
                                        top: deviceinfo.screenHeight * 0.02,
                                        bottom: deviceinfo.screenHeight * 0.02),
                                    showCursor: true,
                                    placeholder: 'Enter your content here...',
                                    customStyles: quill.DefaultStyles(
                                      placeHolder: quill.DefaultTextBlockStyle(
                                          TextStyle(
                                              color: Colors.grey,
                                              fontSize: deviceinfo.screenWidth *
                                                  0.05),
                                          quill.HorizontalSpacing(0, 0),
                                          quill.VerticalSpacing(0, 0),
                                          quill.VerticalSpacing(0, 0),
                                          BoxDecoration()),
                                      paragraph: quill.DefaultTextBlockStyle(
                                          TextStyle(
                                              color: Colors.white,
                                              fontSize: deviceinfo.screenWidth *
                                                  0.05),
                                          quill.HorizontalSpacing(0, 0),
                                          quill.VerticalSpacing(0, 0),
                                          quill.VerticalSpacing(0, 0),
                                          BoxDecoration()),
                                    )),
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
      } else if (state is EditTaskFailure) {
        return Scaffold(
          body: Center(
            child: Text(state.error, style: TextStyle(color: Colors.red)),
          )
        );
        }else if (state is EditTaskLoading) {
          return const Scaffold(
            backgroundColor: ColorsManager.EdittextFieldColor,
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }else{
          return Container();
        }
    }
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
