import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_zagsystem/MVVM/VIew_Models/Task_View_Models/edit_task/edit_task_cubit.dart';
import 'package:to_do_list_zagsystem/MVVM/Views/Screens/splash/Splash_Screen.dart';
import '../MVVM/Models/Tasks_Models/task_model.dart';
import '../MVVM/VIew_Models/Task_View_Models/home/home_cubit.dart';
import '../MVVM/Views/Screens/Add_Task/Add_Task_Screen.dart';
import '../MVVM/Views/Screens/Edit_task/Edit_task_Screen.dart';
import '../test_notifcation.dart';
import 'routs.dart';
import '../MVVM/VIew_Models/Auth_View_Models/auth_cubit.dart';
import '../MVVM/Views/Screens/Auth/Login_Screen/login_view.dart';
import '../MVVM/Views/Screens/Auth/SignUp_Screen/singUp_view.dart';
import '../MVVM/Views/Screens/Home_Screen/home_view.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthCubit(),
                  child: const LoginView(),
                ));
      case Routes.homePage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeView(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthCubit(),
                  child: const SingupView(),
                ));

      case Routes.addTaskScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(),
            child: const Add_Task_Screen(),
          ),
        );
      case Routes.editTaskScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => EditTaskCubit(),
            child: EditTaskScreen(
              task: settings.arguments as TaskModel,
            ),
          ),
        );
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.testScreen:
        return MaterialPageRoute(
            builder: (_) => const TestNotificationScreen());
      default:
        return null;
    }
  }
}
