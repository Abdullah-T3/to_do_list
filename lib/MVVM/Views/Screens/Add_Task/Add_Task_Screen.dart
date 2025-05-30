import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../theming/styles.dart';
import '../../../Models/Tasks_Models/task_model.dart';
import '../../../VIew_Models/Task_View_Models/home/home_cubit.dart'
    show
        HomeCubit,
        HomeState,
        TaskUpdated,
        pickedReminderTask,
        pickedRepeatTask;
import '../../Widgets/Add_Task_Widgets/InkWellWidget.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../helpers/extantions.dart';
import '../../Widgets/Add_Task_Widgets/Radio_Button_Widget.dart';
import '../Edit_task/Edit_task_Screen.dart';
import '../../../../helpers/notification_helper.dart'; // Import NotificationHelper

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is TaskUpdated) {
                  context.pop();
                }
                if (state is pickedRepeatTask) {
                  selectedRepeatOption = state.pickedRepeat;
                }
                if (state is pickedReminderTask) {
                  selectedReminderOption_index = state.reminder;
                }
              },
              child: IconButton(
                onPressed: () async {
                  final task = TaskModel(
                    title: titleController.text,
                    startDate: startDate.toString(),
                    endDate: endDate.toString(),
                    repeat: selectedRepeatOption,
                    reminder: selectedReminderOption_index,
                    place: placeController.text,
                    taskContent: notesController.text,
                  );

                  context.read<HomeCubit>().addTask(task);

                  await NotificationHelper.scheduleNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                    title: titleController.text,
                    body: notesController.text,
                    scheduledTime: startDate!,
                    repeatInterval: RepeatInterval.daily,
                  );
                },
                icon: const Icon(Icons.check),
              ),
            ),
          ],
          iconTheme: IconThemeData(
              color: Colors.grey, size: deviceinfo.screenWidth * 0.07),
        ),
        body: SafeArea(
          top: false,
          child: Container(
            width: deviceinfo.screenWidth,
            height: deviceinfo.screenHeight,
            decoration: MainBackgroundAttributes.MainBoxDecoration,
            padding: EdgeInsetsDirectional.only(
                top: deviceinfo.screenHeight * 0.12,
                start: deviceinfo.screenWidth * 0.05,
                end: deviceinfo.screenWidth * 0.05),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Schedule',
                        style: TextStyle(
                            fontSize: deviceinfo.screenWidth * 0.045,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    SizedBox(
                      width: deviceinfo.screenWidth * 0.9,
                      height: deviceinfo.screenHeight * 0.05,
                      child: TextField(
                        decoration: TextFieldStyles.inputDecoration(
                            deviceinfo: deviceinfo, hintText: 'Title'),
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
                          context.read<HomeCubit>().changeDate(
                              "${picked.year}-${picked.month}-${picked.day}");
                        }
                      },
                    ),
                    InkWellWidget(
                      OptionName: 'Finish',
                      InitialData: endDate.toString().substring(0, 10),
                      OnTap: () async {
                        final DateTime? picked = await DatePicker(context);
                        if (picked != null) {
                          endDate = picked;
                          context.read<HomeCubit>().changeDate(
                              "${picked.year}-${picked.month}-${picked.day}");
                        }
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
                              itemsList: const [
                                'One Time',
                                'Daily',
                                'Weekly',
                                'Monthly'
                              ],
                              deviceinfo: deviceinfo,
                              initialIndex: [
                                'One Time',
                                'Daily',
                                'Weekly',
                                'Monthly'
                              ].indexOf(selectedRepeatOption),
                              onSelected: (int index) {
                                context.read<HomeCubit>().changeRepeat([
                                      'One Time',
                                      'Daily',
                                      'Weekly',
                                      'Monthly'
                                    ][index]);
                              },
                            );
                          },
                        );
                      },
                    ),
                    InkWellWidget(
                      OptionName: 'Reminder',
                      InitialData:
                          'Before $selectedReminderOption_index Minutes',
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
                              initialIndex: [5, 10, 15, 20]
                                  .indexOf(selectedReminderOption_index),
                              onSelected: (int index) {
                                context
                                    .read<HomeCubit>()
                                    .changeReminder([5, 10, 15, 20][index]);
                              },
                            );
                          },
                        );
                      },
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
