import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_list_zagsystem/helpers/notification_helper.dart';
import 'routing/appRouting.dart';
import 'routing/routs.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: 'https://fvpndjsnxhtezpzsxjze.supabase.co',
    anonKey: dotenv.env['API_KEY'].toString(),
  );

  tz.initializeTimeZones();

  // const AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('@mipmap/ic_launcher');
  // final InitializationSettings initializationSettings =
  // InitializationSettings(android: initializationSettingsAndroid);
  //
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await NotificationHelper.initialize();
 await NotificationHelper.requestNotificationPermission();
  runApp(MyApp(
    appRouter: AppRouts(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouts appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.testScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
