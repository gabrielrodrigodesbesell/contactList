import 'dart:io';
import 'package:contactlist/controller/contact_controller.dart';
import 'package:contactlist/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReadPage extends StatelessWidget {
  final ContactModel fullContact; //recebe como parâmetro o objeto ContactModel
  ReadPage(this.fullContact);

  //injeta o controllador ContactController na classe ReadPage
  //deixando-o acessível na variável _contactController
  final ContactController _contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        title: Text(fullContact.nome),
        actions: [
          fullContact.foto !=
                  "" //se existir um caminho de imagem, exibe a imagem na tela
              ? Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      backgroundImage: Image.file(
                        File(fullContact.foto),
                        fit: BoxFit.cover,
                      ).image,
                    ),
                  ),
                )
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            fullContact.descricao != ""
                ? ListTile(
                    title: Text('Description'),
                    subtitle: Text(fullContact.descricao),
                  )
                : Container(),
            fullContact.telefone != ""
                ? ListTile(
                    title: Text('Phone'),
                    subtitle: Text(fullContact.telefone),
                  )
                : Container(),
            fullContact.email != ""
                ? ListTile(
                    title: Text('E-mail'),
                    subtitle: Text(fullContact.email),
                  )
                : Container(),
            fullContact.site != ""
                ? ListTile(
                    title: Text('Site'),
                    subtitle: Text(fullContact.site),
                  )
                : Container(),
            ListTile(
              title: Text('VCard'),
              subtitle: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: QrImage(
                  //monta a imagem do QRCode tem tela
                  data: _contactController.toPersonalVCard(fullContact),
                  version: QrVersions.auto,
                  gapless: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
