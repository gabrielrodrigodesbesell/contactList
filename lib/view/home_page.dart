import 'dart:io';
import 'package:contactlist/controller/contact_controller.dart';
import 'package:contactlist/model/contact_model.dart';
import 'package:contactlist/view/add_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  //injeta o controllador ContactController na classe AddPage
  //deixando-o acessível na variável _contactController
  final ContactController _contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Contact list"),
        actions: [
          TextButton(
            child: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () => _contactController.scan(),
          )
        ],
      ),
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
                                          ""
                                      ? Image.file(File(_contactController
                                          .contactModel[index].foto))
                                      : Image.asset('assets/contato.png')),
                          title:
                              Text(_contactController.contactModel[index].nome),
                          subtitle: Text(
                            _contactController.contactModel[index].descricao,
                          ),
                          trailing: IconButton(
                              icon: FaIcon(FontAwesomeIcons.addressBook),
                              onPressed: () => (bottomMenu(_contactController
                                      .contactModel[
                                  index]))), //passando os dois parâmetros para a função de exclusão
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

bottomMenu(ContactModel contact) {
  Get.bottomSheet(
    SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    contact.nome,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
          contact.telefone != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.phone),
                  'Call on phone',
                  'tel:' + contact.telefone,
                )
              : Container(),
          contact.email != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.envelope),
                  'Write a e-mail',
                  'mailto:' + contact.email,
                )
              : Container(),
          contact.nome != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.whatsapp),
                  'Share on Whastsapp',
                  'whats',
                  whatsMessage: 'Olá ' + contact.nome,
                )
              : Container(),
          contact.site != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.globe),
                  'Open website',
                  contact.site,
                )
              : Container(),
          contact.id != null
              ? optionMenu(contact.id, FaIcon(FontAwesomeIcons.eye),
                  'Ver contato', 'read',
                  fullContact: contact)
              : Container(),
          contact.id != null
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.eraser, color: Colors.white),
                  'Apagar contato',
                  'delete',
                  foto: contact.foto,
                )
              : Container(),
        ],
      ),
    ),
    backgroundColor: Colors.white,
  );
}

optionMenu(
  int id,
  Widget icon,
  String title,
  String action, {
  String foto,
  String whatsMessage,
  ContactModel fullContact,
}) {
  final ContactController _contactController = Get.put(ContactController());
  if (action == null) {
    return;
  }
  final colorText = action == 'delete' ? Colors.white : Colors.black;
  return ListTile(
    tileColor: action == 'delete' ? Colors.red : Colors.white,
    leading: icon,
    title: Text(
      title,
      style: TextStyle(
        color: colorText,
      ),
    ),
    onTap: () => {
      Get.back(),
      if (action == 'read')
        {_contactController.readContact(fullContact)}
      else if (action == 'delete')
        {_contactController.deleteContact(id, foto)}
      else if (action == 'whats')
        {_contactController.shareOnWhatsapp(whatsMessage)}
      else if (action != null)
        {
          _contactController.launchURL(action),
        }
      //
    },
  );
}
