import 'dart:io';

import 'package:contactlist/database/database_fetch.dart';
import 'package:contactlist/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ContactController extends GetxController {
  //ContactModel é uma lista observável, quando sofrer atualizações
  //ela mesma comunica os compomentes que estão utilizando
  var contactModel = []
      .obs; //.obs é responsável por informar ao Getx que a variável é observável e toda vez que ele sofrer alterações, deve ser comunicado os componentes que estão dentro do Obx()
  //declaração dos controladores de textos do formulário
  TextEditingController nomeContactController = TextEditingController();
  TextEditingController descricaoContactController = TextEditingController();
  TextEditingController emailContactController = TextEditingController();
  TextEditingController telefoneContactController = TextEditingController();
  TextEditingController latitudeContactController = TextEditingController();
  TextEditingController longitudeContactController = TextEditingController();
  TextEditingController siteContactController = TextEditingController();

  GlobalKey<FormState> form = GlobalKey<FormState>();

  var image = ''.obs;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.value = pickedFile.path;
    } else {
      Get.snackbar('Aviso', 'Imagem não selecionada');
    }
  }

  @override
  void onInit() {
    //ao executar o controlador, busca os dados na base de dados
    _getData();
    super.onInit();
  }

  void _getData() {
    //busca os registros na base de dados ao abrir o app
    DatabaseHelper.instance.queryAllRows().then((value) {
      //percorre os registros inserindo na lista atual que é
      //exibida para o usuário
      value.forEach((element) {
        contactModel.add(ContactModel(
            id: element['id'],
            nome: element['nome'],
            descricao: element['descricao']));
      });
    });
  }

  void addData() async {
    if (form.currentState.validate()) {
      //grava na base de dados
      var lastId = await DatabaseHelper.instance.insert(ContactModel(
        nome: nomeContactController.text,
        descricao: descricaoContactController.text,
        site: siteContactController.text,
        telefone: telefoneContactController.text,
        email: emailContactController.text,
        foto: image.value,
      ));
      //insere os dados na lista atual que é exibida em tela
      //evitando o reload da tabela
      contactModel.insert(
          0,
          ContactModel(
              id: lastId,
              nome: nomeContactController.text,
              descricao: descricaoContactController.text,
              site: siteContactController.text,
              telefone: telefoneContactController.text,
              email: emailContactController.text,
              foto: image.value));
      //limpa os campos do formulário
      nomeContactController.clear();
      descricaoContactController.clear();
      emailContactController.clear();
      telefoneContactController.clear();
      siteContactController.clear();
      image.value = '';
      //fecha o formulário de cadastro
      Get.back();
    }
  }

  void deleteContact(int id, String foto) {
    Get.defaultDialog(
      radius: 10,
      barrierDismissible: false,
      textConfirm: "Apagar",
      textCancel: "Cancelar",
      title: 'Confirma?',
      content: Text('Deseja realmente apagar'),
      onConfirm: () async {
        //apaga do banco de dados o registro
        await DatabaseHelper.instance.delete(id);
        //remove os dados na lista atual que é exibida em tela
        //evitando o reload da tabela
        contactModel.removeWhere((element) => element.id == id);
        await File(foto).delete();
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }
}
