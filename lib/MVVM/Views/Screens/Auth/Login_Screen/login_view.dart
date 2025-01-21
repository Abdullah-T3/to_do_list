import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../VIew_Models/Auth_View_Models/auth_cubit.dart';
import '../../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../../helpers/extantions.dart';
import '../../../../../theming/colors.dart';

import '../../../../../routing/routs.dart';
import '../../../Widgets/Auth_Widgets/AuthenticationTextFieldWidget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Infowidget(
        builder: (context, deviceinfo) {
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
                  padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05, top: deviceinfo.screenHeight * 0.2, bottom: deviceinfo.screenHeight * 0.07),
                  child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.pushNamed(Routes.homePage);
                    }
                  }, builder: (context, state) {
                    return Column(
                      spacing: deviceinfo.screenHeight * 0.04,
                      children: [
                        Text("Task Manager", style: TextStyle(fontSize: deviceinfo.screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.white)),
                        AuthenticationTextFieldWidget(title: 'Email', TxtController: context.read<AuthCubit>().emailController, isPassword: false),
                        AuthenticationTextFieldWidget(title: 'Password', TxtController: context.read<AuthCubit>().passwordController, isPassword: true),
                        if (state is AuthFailure) Text(state.error, style: TextStyle(color: Colors.red, fontSize: deviceinfo.screenWidth * 0.035, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(
                          height: deviceinfo.screenHeight * 0.06,
                          width: deviceinfo.screenWidth * 0.6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05), color: ColorsManager.buttonColor),
                          child: MaterialButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    // context.pushNamed(Routes.homePage);
                                    context.read<AuthCubit>().login();
                                  },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05)),
                            child: state is AuthLoading ? const CircularProgressIndicator() : Text("Login", style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold)),
                          ),
                        ),
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
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
