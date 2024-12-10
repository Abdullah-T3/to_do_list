import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/theming/colors.dart';

import '../../../Responsive/models/DeviceInfo.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (BuildContext context, Deviceinfo deviceinfo) {
      return Padding(
        padding: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
        child: Container(
          height: deviceinfo.screenHeight * 0.1,
          width: deviceinfo.screenWidth * 0.9,
          decoration: BoxDecoration(
            color: ColorsManager.buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Task", style: TextStyle(fontSize: deviceinfo.screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      );
    });
  }
}
