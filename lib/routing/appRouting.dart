import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_zagsystem/View/Auth/login/login_view.dart';
import 'package:to_do_list_zagsystem/View/home/home_view.dart';
import 'package:to_do_list_zagsystem/VieweModel/taskCubit/task_cubit.dart';
import 'package:to_do_list_zagsystem/routing/routs.dart';

import '../View/Auth/signUp/singUp_view.dart';

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
