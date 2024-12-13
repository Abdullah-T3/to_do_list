import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_zagsystem/routing/routs.dart';

import '../MVVM/VIew_Models/Task_View_Models/task_cubit.dart';
import '../MVVM/Views/Screens/Auth/Login_Screen/login_view.dart';
import '../MVVM/Views/Screens/Auth/SignUp_Screen/singUp_view.dart';
import '../MVVM/Views/Screens/Home_Screen/home_view.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.homePage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => TaskCubit(),
            child: const HomeView(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (_) => const SingupView());
      default:
        return null;
    }
  }
}
