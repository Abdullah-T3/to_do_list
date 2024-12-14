import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/Add_Task_Widgets/InkWellWidget.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../../helpers/extantions.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../../../Models/Tasks_Models/task_model.dart';
import '../../../VIew_Models/Task_View_Models/task_cubit.dart';

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

  int selectedReminderOption = 5;

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
                    reminder: selectedReminderOption,
                    place: placeController.text,
                    taskContent: notesController.text,
                  );
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
            padding: EdgeInsetsDirectional.only(top: deviceinfo.screenHeight * 0.12, start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05),
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
                    SizedBox(
                      width: deviceinfo.screenWidth * 0.9,
                      height: deviceinfo.screenHeight * 0.05,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: TextFieldStyles.inputDecoration(deviceinfo: deviceinfo, hintText: 'Place'),
                        maxLines: 1,
                        style: TextStyle(fontSize: deviceinfo.screenWidth * 0.03, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.text,
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
