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
      appBar: new AppBar(title: Text(fullContact.nome)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Description'),
              subtitle: Text(fullContact.descricao),
            ),
            ListTile(
              title: Text('Phone'),
              subtitle: Text(fullContact.telefone),
            ),
            ListTile(
              title: Text('E-mail'),
              subtitle: Text(fullContact.email),
            ),
            ListTile(
              title: Text('Site'),
              subtitle: Text(fullContact.site),
            ),
            ListTile(
              title: Text('Photo'),
              subtitle: Column(
                children: [
                  fullContact.foto !=
                          "" //se existir um caminho de imagem, exibe a imagem na tela
                      ? Image.file(
                          File(fullContact.foto),
                        )
                      : Text('Foto não adicionada')
                ],
              ),
            ),
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
