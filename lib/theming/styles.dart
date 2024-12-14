import 'package:flutter/material.dart';
import '../Responsive/models/DeviceInfo.dart';
import 'colors.dart';

class TextStyles {
  static const title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static const richTextBoldButtonColor = TextStyle(
    fontWeight: FontWeight.w900,
    color: ColorsManager.buttonColor,
  );
  static const richTextBoldWhite = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static const appBarStyle = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
}

class TextFieldStyles {
  static InputDecoration inputDecoration({required Deviceinfo deviceinfo, required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.03, end: deviceinfo.screenWidth * 0.03),
      hintStyle: TextStyle(color: Colors.black45, fontSize: deviceinfo.screenWidth * 0.037),
      fillColor: ColorsManager.textFieldColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.03),
      ),
    );
  }
}

class MainBackgroundAttributes {
  final Deviceinfo deviceinfo; // Marking as `final` since it is set once in the constructor.

  late final EdgeInsetsDirectional MainPadding; // Use `late final` for values initialized in the constructor.

  MainBackgroundAttributes(this.deviceinfo) {
    // Initialize `MainPadding` in the constructor.
    MainPadding = EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05, top: deviceinfo.screenHeight * 0.05, bottom: deviceinfo.screenHeight * 0.01);
  }

  static const MainBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        ColorsManager.primaryColor,
        ColorsManager.secondaryColor,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      transform: GradientRotation(3.14),
    ),
  );
}
