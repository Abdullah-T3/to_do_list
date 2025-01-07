import 'package:flutter/material.dart';
import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../../theming/colors.dart';


class RadioButtonWidget extends StatefulWidget {
  final String title;
  final List<String> itemsList;
  final Deviceinfo deviceinfo;
  final int initialIndex;
  final ValueChanged<int> onSelected;

  const RadioButtonWidget({
    super.key,
    required this.title,
    required this.itemsList,
    required this.deviceinfo,
    required this.onSelected,
    this.initialIndex = 0,
  });

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.deviceinfo.screenWidth * 0.05,
        ),
      ),
      backgroundColor: Colors.grey.shade900,
      scrollable: false,
      content: SizedBox(
        height: widget.deviceinfo.screenHeight * 0.33,
        width: widget.deviceinfo.screenWidth * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.itemsList.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text(
                      widget.itemsList[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.deviceinfo.screenWidth * 0.03,
                      ),
                    ),
                    value: index,
                    groupValue: selectedValue,
                    fillColor: WidgetStateProperty.all(ColorsManager.buttonColor),
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonColor,
              ),
              onPressed: () {
                widget.onSelected(selectedValue);
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.deviceinfo.screenWidth * 0.03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
