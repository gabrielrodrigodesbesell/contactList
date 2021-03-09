import 'package:contactlist/database/database_fetch.dart';
import 'package:contactlist/model/contact_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  //ContactData é uma lista observável, quando sofrer atualizações
  //ela mesma comunica os compomentes que estão utilizando
  var contactData = List<ContactData>()
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
        contactData.add(ContactData(
            id: element['id'],
            nome: element['nome'],
            descricao: element['descricao']));
      });
    });
  }

  void addData() async {
    //grava na base de dados
    await DatabaseHelper.instance.insert(ContactData(
        nome: nomeContactController.text,
        descricao: descricaoContactController.text));
    //insere os dados na lista atual que é exibida em tela
    //evitando o reload da tabela
    contactData.insert(
        0,
        ContactData(
            id: contactData.length,
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
    //insere os dados na lista atual que é exibida em tela
    //evitando o reload da tabela
    contactData.removeWhere((element) => element.id == id);
  }
}
