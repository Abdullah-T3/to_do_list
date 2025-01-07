import 'package:flutter/material.dart';

import '../../../../theming/colors.dart';

class DatePickerWidget {
  static Future<DateTime?> show(BuildContext context) {
    return showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: ColorsManager.buttonColor, // Header background color
              onSurface: Colors.white, // Body text color
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
}
