import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/main_page.dart';
import 'call/call_page.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )
      .then((value) => FirebaseMessaging.instance.getNotificationSettings());
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.purple,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      ),
    ],
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await analytics.logAppOpen();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      color: Colors.purple,
      title: message.notification!.title,
      body: message.notification!.body,
      category: NotificationCategory.Call,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.purple,
      displayOnForeground: true,
      displayOnBackground: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'REJECT',
        label: 'Reject',
        autoDismissible: true,
        color: Colors.red,
        buttonType: ActionButtonType.Default,
      ),
      NotificationActionButton(
        key: 'ACCEPT',
        label: 'Accept',
        autoDismissible: true,
        color: Colors.green,
        buttonType: ActionButtonType.Default,
      ),
    ],
  );

  AwesomeNotifications().actionStream.listen((event) async {
    String callId = await FirebaseFirestore.instance
        .collection('Call')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()!['callId']);
    String type = await FirebaseFirestore.instance
        .collection('Call')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()!['type']);
    if (event.buttonKeyPressed == 'ACCEPT') {
      CallPage(
        callID: callId,
        callType: type,
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: FirebaseAuth.instance.currentUser!.displayName!,
      );
    } else if (event.buttonKeyPressed == 'REJECT') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 12,
          channelKey: 'basic_channel',
          color: Colors.purple,
          title: 'Rejected',
          body: 'You have rejected the call',
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.purple,
          displayOnForeground: true,
          displayOnBackground: true,
        ),
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helping Hand',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
