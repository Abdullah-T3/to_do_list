import 'package:flutter/material.dart';
import '../../../../helpers/notification_helper.dart';

class TestNotificationScreen extends StatelessWidget {
  const TestNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Notification')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final now = DateTime.now();
            final scheduledTime = now.add(const Duration(seconds: 1));
            print('Current time: $now');
            print('Scheduled time: $scheduledTime');
           try{
            await NotificationHelper.showImmediateNotification(id: 1  , title: 'Test Notification' , body: 'This is a test notification!');
            await NotificationHelper.scheduleNotification(
              id: now.millisecondsSinceEpoch ~/ 1000,
              title: 'Test Notification schedule',
              body: 'This is a schedule test notification!',
              scheduledTime: scheduledTime,
            );}catch(e){ 
              print(e);
            }
          },
          child: const Text('Schedule Test Notification'),
        ),
      ),
    );
  }
}
