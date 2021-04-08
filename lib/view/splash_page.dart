import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SplashScreen(
            seconds: 4,
            navigateAfterSeconds:
                HomePage(), //redireciona para a HomePage após 4 segundos
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
          Positioned(
            //posiciona o Elemento na base da tela
            bottom: 20.0,
            child: new Container(
              width: Get
                  .width, //define o container com a largura total da tela, para alinhar o texto ao centro
              height: 20.0,
              child: FutureBuilder<PackageInfo>(
                //usa-se FutureBuilde pois não é uma informação instantânea
                future:
                    PackageInfo.fromPlatform(), //obtem informações do pacote
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Text(
                        '${snapshot.data.version}.${snapshot.data.buildNumber}',
                        textAlign: TextAlign.center,
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
