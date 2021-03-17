import 'dart:io';

import 'package:contactlist/controller/contact_controller.dart';
import 'package:contactlist/view/add_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  //injeta o controllador ContactController na classe AddPage
  //deixando-o acessível na variável _contactController
  final ContactController _contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Meus contatos")),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //abre a página do formulário
            Get.to(AddPage());
          },
          child: Icon(Icons.add)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              //cria um ListView observável pelo Get
              //Obx() é o responsável por atualizar o listView
              //toda vez que ouver uma mudança nas variáveis observáveis
              //no caso:  var ContactModel = List<ContactModel>().obs;
              child: Obx(() => _contactController.contactModel.length < 1
                  ? Text('Nenhum contato adicionado em sua lista!')
                  : ListView.builder(
                      itemCount: _contactController.contactModel.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          leading: Expanded(
                              flex: 1,
                              child: //exibe a imagem, se existir
                                  _contactController.contactModel[index].foto !=
                                          null
                                      ? Image.file(File(_contactController
                                          .contactModel[index].foto))
                                      : Container()),
                          title:
                              Text(_contactController.contactModel[index].nome),
                          subtitle: Text(
                            _contactController.contactModel[index].descricao,
                          ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _contactController.deleteContact(
                                  _contactController.contactModel[index].id,
                                  _contactController.contactModel[index]
                                      .foto)), //passando os dois parâmetros para a função de exclusão
                        ),
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
