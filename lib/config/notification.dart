import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late List<String> titleContent;
late List<String> bodyContent;
late List<String> dateContent;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> inintNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint("TOKEN :$fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("title :${message.notification?.title}");
  debugPrint("body :${message.notification?.body}");
  debugPrint("payload :${message.data}");

  saveNotif(
    title: message.notification?.title ?? '',
    body: 'xxxxx',
    date: DateTime.now().toString(),
  );
}

saveNotif({String? body, String? title, String? date}) async {
  _getContents();
  titleContent.add(title!);
  bodyContent.add(body!);
  dateContent.add(date!);

  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setStringList("titleContent", titleContent);
  await pref.setStringList("bodyContent", bodyContent);
  await pref.setStringList("dateContent", dateContent);

  debugPrint(titleContent.toString());
  debugPrint(bodyContent.toString());

  // List notifList = Constants.getStorageNotif.read('notifs') ?? [];
  // debugPrint('--->' + notifList.toString());
  // notifList.add({'body': body, 'title': title, 'date': date});
  // Constants.getStorageNotif.write('notifs', notifList);
}

_getContents() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  titleContent = pref.getStringList("titleContent") ?? [];
  bodyContent = pref.getStringList("bodyContent") ?? [];
  dateContent = pref.getStringList("dateContent") ?? [];
}
