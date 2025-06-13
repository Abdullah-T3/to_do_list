import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/helpers/extantions.dart';
import '../../../../routing/routs.dart';
import '../../../../theming/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      context.pushReplacementNamed(Routes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Infowidget(builder: (context, deviceinfo) {
        return Container(
          width: deviceinfo.screenWidth,
          height: deviceinfo.screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              ColorsManager.primaryColor,
              ColorsManager.secondaryColor,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(
              child: Text(
                "om.time",
                style: TextStyle(color: Colors.white, fontSize: deviceinfo.screenWidth * 0.1, fontWeight: FontWeight.bold),
              )),
        );
      }),
    );
  }
}
