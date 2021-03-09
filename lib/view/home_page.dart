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
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              //cria um ListView observável pelo Get
              //Obx() é o responsável por atualizar o listView
              //toda vez que ouver uma mudança nas variáveis observáveis
              //no caso:  var ContactModel = List<ContactModel>().obs;
              child: Obx(() => ListView.builder(
                    itemCount: _contactController.contactModel.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Column(
                        children: [
                          Text(_contactController.contactModel[index].nome),
                          Text(_contactController.contactModel[index].descricao)
                        ],
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _contactController.deleteContact(
                              _contactController.contactModel[index].id)),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
