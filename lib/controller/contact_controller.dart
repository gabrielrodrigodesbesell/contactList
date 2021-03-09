import 'package:contactlist/database/database_fetch.dart';
import 'package:contactlist/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  //ContactModel é uma lista observável, quando sofrer atualizações
  //ela mesma comunica os compomentes que estão utilizando
  var contactModel = List<ContactModel>()
      .obs; //.obs é responsável por informar ao Getx que a variável é observável e toda vez que ele sofrer alterações, deve ser comunicado os componentes que estão dentro do Obx()
  //declaração dos controladores de textos do formulário
  TextEditingController nomeContactController = TextEditingController();
  TextEditingController descricaoContactController = TextEditingController();

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
    //grava na base de dados
    await DatabaseHelper.instance.insert(ContactModel(
        nome: nomeContactController.text,
        descricao: descricaoContactController.text));
    //insere os dados na lista atual que é exibida em tela
    //evitando o reload da tabela
    contactModel.insert(
        0,
        ContactModel(
            id: contactModel.length,
            nome: nomeContactController.text,
            descricao: descricaoContactController.text));
    //limpa os campos do formulário
    nomeContactController.clear();
    descricaoContactController.clear();
    //fecha o formulário de cadastro
    Get.back();
  }

  void deleteContact(int id) async {
    //apaga do banco de dados o registro
    await DatabaseHelper.instance.delete(id);
    //remove os dados na lista atual que é exibida em tela
    //evitando o reload da tabela
    contactModel.removeWhere((element) => element.id == id);
  }
}
