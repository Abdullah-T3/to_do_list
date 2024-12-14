import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../helpers/extantions.dart';

import '../../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../../Responsive/models/DeviceInfo.dart';
import '../../../../../routing/routs.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/styles.dart';
import '../../../../VIew_Models/Auth_View_Models/auth_cubit.dart';
import '../../../Widgets/Auth_Widgets/AuthenticationTextFieldWidget.dart';

class SingupView extends StatelessWidget {
  const SingupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Infowidget(
        builder: ( context, deviceinfo) {
          return SingleChildScrollView(
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
                padding: EdgeInsetsDirectional.only(start: deviceinfo.screenWidth * 0.05, end: deviceinfo.screenWidth * 0.05, top: deviceinfo.screenHeight * 0.1, bottom: deviceinfo.screenHeight * 0.07),
                child: BlocConsumer<AuthCubit, AuthState>( listener: (context, state) {
                  if (state is AuthSuccess) {
                    context.pushNamed(Routes.homePage);
                  }
                },
                  builder: (context, state) {

                    return Column(
                      spacing: deviceinfo.screenHeight * 0.03,

                      children: [

                        Text("on.time", style: TextStyle(fontSize: deviceinfo.screenWidth * 0.1, fontWeight: FontWeight.bold, color: Colors.white)),

                        AuthenticationTextFieldWidget(title: 'Email',TxtController: context.read<AuthCubit>().emailController, isPassword: false),

                        AuthenticationTextFieldWidget(title: 'Username',TxtController: context.read<AuthCubit>().DisplayNameController, isPassword: false),

                        AuthenticationTextFieldWidget(title: 'Password' ,TxtController: context.read<AuthCubit>().passwordController, isPassword: true),

                        AuthenticationTextFieldWidget(title: 'Rewrite Password',TxtController: context.read<AuthCubit>().RewritePassController, isPassword: true),


                        if(state is AuthFailure)
                          Text(state.error, style: TextStyle(color: Colors.red, fontSize: deviceinfo.screenWidth * 0.035, fontWeight: FontWeight.bold)),

                        const Spacer(),

                        Container(
                          height: deviceinfo.screenHeight * 0.06,
                          width: deviceinfo.screenWidth * 0.6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05), color: ColorsManager.buttonColor),
                          child: MaterialButton(
                            onPressed: state is AuthLoading
                                ? null: () {
                              context.read<AuthCubit>().signup();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05)),
                            child: state is AuthLoading
                                ?CircularProgressIndicator(color: Colors.white)
                                : Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.04, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Have an account? ",
                                style: TextStyles.richTextBoldWhite.copyWith(fontSize: deviceinfo.screenWidth * 0.04),
                              ),
                              TextSpan(
                                  text: "Sign in",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushReplacementNamed(Routes.loginScreen);
                                    },
                                  style: TextStyles.richTextBoldButtonColor.copyWith(fontSize: deviceinfo.screenWidth * 0.04))
                            ],
                          ),
                        ),

                      ],
                    );
                  }),
              ),
            ),
          );
        },
      ),
    );
  }
}
