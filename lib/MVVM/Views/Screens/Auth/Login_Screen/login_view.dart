import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';
import 'package:to_do_list_zagsystem/theming/colors.dart';

import '../../../../../routing/routs.dart';
import '../../../Widgets/Auth_Widgets/AuthenticationTextFieldWidget.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Infowidget(
        builder: ( context,  deviceinfo) {
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Container(
                height: deviceinfo.screenHeight,
                width: deviceinfo.screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    ColorsManager.primaryColor,
                    ColorsManager.secondaryColor,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter, transform: GradientRotation(3.14)),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05, top: deviceinfo.screenHeight * 0.05, bottom: deviceinfo.screenHeight * 0.07),
                  child: Column(
                    children: [
                      SizedBox(height: deviceinfo.screenHeight * 0.1),
                      Text("Task Manager", style: TextStyle(fontSize: deviceinfo.screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: deviceinfo.screenHeight * 0.14),
                      AuthenticationTextFieldWidget(title: 'Email', isPassword: false),
                      SizedBox(height: deviceinfo.screenHeight * 0.02),
                      AuthenticationTextFieldWidget(title: 'Password', isPassword: true),
                      Row(
                        children: [
                          TextButton(onPressed: () {}, child: Text("Forgot Password?", style: TextStyle(color: ColorsManager.buttonColor, fontSize: deviceinfo.screenWidth * 0.037, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const Spacer(),

                      Container(
                        height: deviceinfo.screenHeight * 0.06,
                        width: deviceinfo.screenWidth * 0.6,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05), color: ColorsManager.buttonColor),
                        child: MaterialButton(
                          onPressed: () {
                            context.pushNamed(Routes.homePage);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05)),
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      SizedBox(height: deviceinfo.screenHeight * 0.02),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " Sign up",
                              recognizer: TapGestureRecognizer()..onTap = () => context.pushNamed(Routes.signUpScreen),
                              style: TextStyle(color: ColorsManager.buttonColor, fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceinfo.screenHeight * 0.08),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
