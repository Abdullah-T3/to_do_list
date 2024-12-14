import 'package:flutter/material.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';

class InkWellWidget extends StatelessWidget {

  String OptionName;
  String InitialData;
  Function() OnTap;

  InkWellWidget({super.key, required this.OptionName,required this.InitialData, required this.OnTap});

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceinfo) {

     return InkWell(
       onTap: OnTap,
       child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [

             Text(OptionName, style: TextStyle(fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.w400, color: Colors.white)),

             Row(
                 children: [

                   Text(InitialData, style: TextStyle(fontSize: deviceinfo.screenWidth * 0.03, fontWeight: FontWeight.w400, color: Colors.grey[600])),

                   Icon(Icons.chevron_right,color: Colors.grey[600], size: deviceinfo.screenWidth * 0.045),
                 ])

           ]
       ),
     );
  });

}

}