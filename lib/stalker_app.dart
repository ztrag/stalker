import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:stalker/home/home_page.dart';
import 'package:stalker/notification/notification_task_controller.dart';
import 'package:stalker/theme/theme.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/edit_active_user_page.dart';

class StalkerApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const StalkerApp({super.key});

  @override
  State<StalkerApp> createState() => _StalkerAppState();
}

class _StalkerAppState extends State<StalkerApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationTaskController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationTaskController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationTaskController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationTaskController.onDismissActionReceivedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: StalkerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'stalker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: getDarkColorScheme(),
      ),
      home: _home,
    );
  }

  Widget get _home {
    return AnimatedBuilder(
      animation: ActiveUser(),
      builder: (_, __) {
        if (!ActiveUser().hasLoaded) {
          return Container();
        }
        return ActiveUser().value == null
            ? const EditActiveUserPage()
            : const HomePage();
      },
    );
  }
}
