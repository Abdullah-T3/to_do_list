import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/View/Auth/login/login_view.dart';
import 'package:to_do_list_zagsystem/View/home/home_view.dart';
import 'package:to_do_list_zagsystem/routing/routs.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return null;
    }
  }
}
