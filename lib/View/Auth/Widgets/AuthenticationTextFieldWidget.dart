import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';

import '../../../Responsive/models/DeviceInfo.dart';

// ignore: must_be_immutable
class AuthenticationTextFieldWidget extends StatefulWidget {
  String title;
  bool isPassword;

  AuthenticationTextFieldWidget({super.key, this.isPassword = false, required this.title});

  @override
  State<AuthenticationTextFieldWidget> createState() => _AuthenticationTextFieldWidgetState();
}

class _AuthenticationTextFieldWidgetState extends State<AuthenticationTextFieldWidget> {
  bool passInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Infowidget(
      builder: (BuildContext context, Deviceinfo deviceinfo) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(passInvisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passInvisible = !passInvisible;
                          });
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.next,
              obscureText: widget.isPassword ? passInvisible : false,
            ),
          ],
        );
      },
    );
  }
}