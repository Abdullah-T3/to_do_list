import 'package:flutter/material.dart';
import 'routing/appRouting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'routing/routs.dart';

Future<void> main() async {
  await dotenv.load();

  await Supabase.initialize(
    url: 'https://fvpndjsnxhtezpzsxjze.supabase.co',
    anonKey: dotenv.env['API_KEY'].toString(),
  );

  //
  // final data = await supabase
  //     .from('tasks')
  //     .select('*')
  //     .eq('id', '5');
  //
  // print(data);
  // final response = await Supabase.instance.client.auth.admin.listUsers();
  // .from('auth.users')
  // .select('id, email, created_at');
//   print(response.length);
// print(response);
  runApp(MyApp(
    appRouter: AppRouts(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouts appRouter;
  const MyApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
