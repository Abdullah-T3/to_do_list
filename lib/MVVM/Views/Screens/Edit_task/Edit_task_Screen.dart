import 'package:flutter/material.dart';

import '../../../../theming/colors.dart';

class EditTaskScreen extends StatelessWidget {
  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: ColorsManager.buttonColor,
    ));
  }
}
