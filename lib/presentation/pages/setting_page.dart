import 'package:dicoding_submission_restaurant/core/services/local_notification_service.dart';
import 'package:dicoding_submission_restaurant/data/models/notification/received_notification.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/local_notification_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/payload_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/reminder_notification_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  static const route = '/setting';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      context.push('/detail/${payload}');
      //
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      context.push('/detail/${receivedNotification.payload}');
    });
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _reminderNotificationProvider(bool value) async {
    context.read<ReminderNotificationProvider>().setReminderStatus(value);
  }

  Future<void> _checkPendingNotificationRequests() async {
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);

    if (!mounted) {
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final pendingData = context.select(
            (LocalNotificationProvider provider) =>
                provider.pendingNotificationRequests);
        return AlertDialog(
          title: Text(
            '${pendingData.length} pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: IconButton(
                    onPressed: () {
                      localNotificationProvider
                        ..cancelNotification(item.id)
                        ..checkPendingNotificationRequests(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, value, child) => ListTile(
                  title: Text("Theme"),
                  subtitle: Text("Change your theme"),
                  trailing: value.isDark
                      ? Icon(
                          Icons.nightlight_round,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        ),
                  onTap: () => value.setTheme()),
            ),
            ExpansionTile(title: Text("Notification"), children: [
              Consumer<ReminderNotificationProvider>(
                  builder: (context, value, child) {
                return ListTile(
                  title: Text("Daily Reminder Notification"),
                  subtitle: Text(
                    "Notification will be sent daily at 11 AM",
                  ),
                  trailing: Switch(
                      value: value.isReminderOn,
                      onChanged: (value) async {
                        try {
                          await _requestPermission();
                          await _reminderNotificationProvider(value);
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Reminder notification has been set")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Reminder notification has been canceled")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Failed to set reminder notification")),
                          );
                        }
                      }),
                );
              }),
              ListTile(
                title: Text("Pending Notification"),
                subtitle: Text("Click for check pending notification"),
                onTap: () async {
                  // await context.read<LocalNotificationProvider>().cancelAllNotification();
                  await _checkPendingNotificationRequests();
                },
              ),
            ]),
            // ListTile(
            //   title: Text("Background Task"),
            //   subtitle: Text("Run background task"),
            //   trailing: const Icon(Icons.timer),
            //   onTap: () {
            //     _runBackgroundOneOffTask();
            //     _runBackgroundPeriodicTask();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
