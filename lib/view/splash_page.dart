import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SplashScreen(
          seconds: 3,
          navigateAfterSeconds: HomePage(),
          title: Text(
            'welcome'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          image: Image(
            image: AssetImage('assets/icon.png'),
          ),
          backgroundColor: Colors.white,
          loaderColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
