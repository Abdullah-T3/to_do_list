import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/MVVM/Views/Widgets/Add_Task_Widgets/InkWellWidget.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/Responsive/models/DeviceInfo.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';


import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';

class Add_Task_Screen extends StatelessWidget {
  const Add_Task_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceinfo) {
      return Scaffold(

        extendBodyBehindAppBar: true, // Makes the body extend behind the AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0, // Removes shadow

          actions: [
            IconButton(onPressed: (){
            //Navigate to Task Content Screen

            }, icon:  Icon(Icons.check)),
          ],
          iconTheme: IconThemeData(color: Colors.grey,size: deviceinfo.screenWidth * 0.07), // For back button or menu icon
        ),
        body: SafeArea(
            top: false,

            child: Container(
              width: deviceinfo.screenWidth,
              height: deviceinfo.screenHeight,

              decoration: MainBackgroundAttributes.MainBoxDecoration,
              padding: EdgeInsetsDirectional.only(top: deviceinfo.screenHeight * 0.12, start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05),

              child: Column(
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

                  InkWellWidget(OptionName: 'Start Date', InitialData: 'Mon, 20 Sep 2022, 12:00 AM', OnTap: () async {
                    final DateTime? picked  = await DatePicker(context);

                  print(picked);
                  }),
                  InkWellWidget(OptionName: 'Finish', InitialData: 'Mon, 20 Sep 2022, 12:00 AM', OnTap: () async {
                    final DateTime? picked  = await DatePicker(context);

                    print(picked);
                  }),
                  InkWellWidget(OptionName: 'Repeat', InitialData: 'One Time', OnTap: () async {

                    await radioButtons(context: context, deviceinfo: deviceinfo, title: 'Repeat', ItemsList: ['One Time', 'Daily', 'Weekly', 'Monthly']);

                  }),
                  InkWellWidget(OptionName: 'Reminder', InitialData: 'Before 5 Minutes', OnTap: () async {

                    await radioButtons(context: context, deviceinfo: deviceinfo, title: 'Reminder', ItemsList: ['Before 5 Minutes', 'Before 10 Minutes', 'Before 15 Minutes', 'Before 20 Minutes']);

                  }),


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
              ),
            )),
      );
    });
  }

}



Future<DateTime?> DatePicker(BuildContext context){
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
    firstDate:  DateTime.now().subtract(Duration(days: 365)),
    lastDate: DateTime.now().add(Duration(days: 365*2)), );
}




radioButtons(
     {required BuildContext context,
      required Deviceinfo deviceinfo,
      required List<String> ItemsList,
      required String title}) async {

  return await showDialog(context: context, builder: (context){
    return AlertDialog(

        title: Text(title,style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.05)),
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
                    itemBuilder: (context, index){
                      return RadioListTile<int>(
                        title:  Text(ItemsList[index], style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)),
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
                  onPressed: (){

                    context.pop();

                  }, child: Text('Done',style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.03)))
            ],
          ),
        )
    );
  });
}