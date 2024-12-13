import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/theming/colors.dart';

import '../../Responsive/models/DeviceInfo.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Infowidget(builder: (BuildContext context, Deviceinfo deviceinfo) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorsManager.buttonColor,
          ),
        );
      }),
    );
  }
}
