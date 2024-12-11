import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/routing/appRouting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'routing/routs.dart';

Future<void> main() async {
  await dotenv.load();

  await Supabase.initialize(
    url: 'https://fvpndjsnxhtezpzsxjze.supabase.co',
    anonKey: dotenv.env['API_KEY'].toString(),
  );

  runApp(MyApp(
    appRouter: AppRouts(),
  ));

  final supabase = Supabase.instance.client;

  final AuthResponse res =await supabase.auth.signInWithPassword(password: 'aaaaaqaasda',email: 'ducnta.work@gmail.com');
  print('------------------- Response Result -------------------');
  print(res);
  print('------------------- User -------------------');
  final Session? session = res.session;
  final User? user = res.user;
  print(user);
  print('------------------- Session -------------------');
  print(session);
  print('-------------------');
  
  print('Email : ${user!.userMetadata!['email']}');
  
}



class MyApp extends StatelessWidget {
  final AppRouts appRouter;
  const MyApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.loginScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
