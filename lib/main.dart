import 'package:alzahra/config/light_theme.dart';
import 'package:alzahra/config/notification.dart';
import 'package:alzahra/features/feature_intro/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottiefiles/lottieError.json',
            ),
            const Gap(10),
            Text(
              details.exception.toString(),
            ),
          ],
        ),
      ),
    );
  };
  await GetStorage.init();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("general");
  await FirebaseApi().inintNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'منصة الزهراء',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: const Locale('ar'),
      home: const SplashScreen(),
    );
  }
}
