import 'package:contactlist/view/splash_page.dart';
import 'package:contactlist/utils/Messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //retorna GetMaterialApp para possibilitar utilizar os benefícios do Getx
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashPage(), //direciona sempre para a tela de Splash
      translations: Messages(), // classe com as traduções
      locale: Get.deviceLocale, // define a tradução baseado na localização
      fallbackLocale: Locale('pt_BR', 'en_US'),
    );
  }
}
