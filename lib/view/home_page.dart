import 'dart:io';
import 'package:contactlist/controller/contact_controller.dart';
import 'package:contactlist/model/contact_model.dart';
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
        title: Text('titleList'.tr),
        actions: [
          TextButton(
            child: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () => _contactController.scanQRCodeAction(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //abre a página do formulário
            _contactController.addContactForm();
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
              child: Obx(() => _contactController.listOfContacts.length < 1
                  ? Text('emptyList'.tr)
                  : ListView.builder(
                      itemCount: _contactController.listOfContacts.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          leading: //exibe a imagem, se existir
                              _contactController.listOfContacts[index].foto !=
                                      ""
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: CircleAvatar(
                                        backgroundImage: Image.file(
                                          File(_contactController
                                              .listOfContacts[index].foto),
                                          fit: BoxFit.cover,
                                        ).image,
                                      ),
                                    )
                                  : Image.asset('assets/contato.png'),
                          title: Text(
                              _contactController.listOfContacts[index].nome),
                          subtitle: Text(
                            _contactController.listOfContacts[index].descricao,
                          ),
                          trailing: IconButton(
                            icon: FaIcon(FontAwesomeIcons.addressBook),
                            onPressed: () => (bottomMenu(
                              _contactController.listOfContacts[index],
                              index,
                            )),
                          ), //passando os dois parâmetros para a função de exclusão
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

bottomMenu(ContactModel contact, int index) {
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
                  'menuCallOnPhone'.tr,
                  'tel:' + contact.telefone,
                )
              : Container(),
          contact.email != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.envelope),
                  'menuWriteEmail'.tr,
                  'mailto:' + contact.email,
                )
              : Container(),
          contact.nome != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.whatsapp),
                  'menuShareOnWhatsapp'.tr,
                  'whats',
                  whatsMessage: 'Olá ' + contact.nome,
                )
              : Container(),
          contact.site != ""
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.globe),
                  'menuOpenWebsite'.tr,
                  contact.site,
                )
              : Container(),
          contact.id != null
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.edit),
                  'menuUpdateContact'.tr,
                  'edit',
                  fullContact: contact,
                  index: index,
                )
              : Container(),
          contact.id != null
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.eye),
                  'menuReadContact'.tr,
                  'read',
                  fullContact: contact,
                )
              : Container(),
          contact.id != null
              ? optionMenu(
                  contact.id,
                  FaIcon(FontAwesomeIcons.eraser, color: Colors.white),
                  'menuDeleteContact'.tr,
                  'delete',
                  foto: contact.foto,
                  index: index,
                )
              : Container(),
        ],
      ),
    ),
    backgroundColor: Colors.white,
  );
}

optionMenu(int id, Widget icon, String title, String action,
    {String foto, String whatsMessage, ContactModel fullContact, int index}) {
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
      if (action == 'edit')
        {_contactController.editContactForm(fullContact, index)}
      else if (action == 'read')
        {_contactController.readContactPage(fullContact)}
      else if (action == 'delete')
        {_contactController.deleteContactAction(id, foto, index)}
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
