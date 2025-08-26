import 'package:alzahra/common/utils/costum_loading.dart';
import 'package:alzahra/config/constants.dart';
import 'package:alzahra/features/feature_home/screens/home_screen.dart';
import 'package:alzahra/features/feature_intro/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    gotoHome();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/splash-2.jpg',
              fit: BoxFit.fill,
              height: size.height,
            ),
            const Positioned(
              bottom: 60,
              child: LoadingProgress(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotoHome() async {
    return Future.delayed(const Duration(seconds: 3), () {
      // debugPrint(Constants.getStorage.read('userData')['token'].toString());
      // debugPrint(Constants.getStorage.read('userData')['email'].toString());
      if (Constants.getStorage.hasData('userData')) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const HomePage(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      }
    });
  }
}
