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

  var image = ''
      .obs; //criado uma variável observável para armazenar o caminho da foto no celular e notificar a view para apresentar em tela
  final picker = ImagePicker(); //instancia o plugin de captura de imagem

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera); //abre a câmera
    if (pickedFile != null) {
      image.value = pickedFile
          .path; //se o usuário tirou a foto e confirmou, armazena o caminho da foto na variável imagem
    } else {
      Get.snackbar('Aviso',
          'Imagem não selecionada'); //se não confirmou a imagem, exibe um snackbar
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
        contactModel.add(
          ContactModel(
            id: element['id'],
            nome: element['nome'],
            descricao: element['descricao'],
            foto: element['foto'],
          ),
        );
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

  //recebe como parâmetro o id do registro no db e o caminho da foto, assim não precisa buscar o registro para resgatar o caminho da foto:
  void deleteContact(int id, String foto) {
    //adiciona a confirmação no ato de exclsuão
    Get.defaultDialog(
      radius: 10,
      barrierDismissible:
          false, //somente deixa fechar o pop-pup clicando nos botões de ação
      textConfirm: "Apagar",
      textCancel: "Cancelar",
      title: 'Confirma?',
      content: Text('Deseja realmente apagar'),
      onConfirm: () async {
        //adiciona automaticamente o botão OK
        //apaga do banco de dados o registro
        await DatabaseHelper.instance.delete(id);
        //remove os dados na lista atual que é exibida em tela
        //evitando o reload da tabela
        contactModel.removeWhere((element) => element.id == id);
        await File(foto).delete(); //deleta o arquivo recebido por parâmetro
        Get.back(); //fecha o pop-up
      },
      onCancel: () => Get
          .back(), //adiciona automaticamente o botão Cancelar, e ao clicar fecha o pop-up
    );
  }
}
