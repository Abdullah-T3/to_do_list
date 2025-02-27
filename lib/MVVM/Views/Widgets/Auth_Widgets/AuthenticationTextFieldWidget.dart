import 'package:flutter/material.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';

import '../../../../Responsive/models/DeviceInfo.dart';

// ignore: must_be_immutable
class AuthenticationTextFieldWidget extends StatefulWidget {
  String title;
  bool isPassword;
  TextEditingController? TxtController;
  AuthenticationTextFieldWidget({super.key, this.isPassword = false, required this.title, this.TxtController});

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
              style: TextStyle(fontSize: deviceinfo.screenWidth * 0.035, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: deviceinfo.screenHeight * 0.01,),
            TextField(
              controller: widget.TxtController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                      color: Colors.grey,
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
