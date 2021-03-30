import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:contactlist/database/database_fetch.dart';
import 'package:contactlist/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:simple_vcard_parser/simple_vcard_parser.dart';

class ContactController extends GetxController {
  //ContactModel é uma lista observável, quando sofrer atualizações
  //ela mesma comunica os compomentes que estão utilizando
  var contactModel = []
      .obs; //.obs é responsável por informar ao Getx que a variável é observável e toda vez que ele sofrer alterações, deve ser comunicado os componentes que estão dentro do Obx()
  //declaração dos controladores de textos do formulário
  TextEditingController nomeContactController =
      TextEditingController(text: 'Gabriel Rodrigo');
  TextEditingController descricaoContactController =
      TextEditingController(text: 'Mobile developer');
  TextEditingController emailContactController =
      TextEditingController(text: 'gabriel@actsistemas.com.br');
  TextEditingController telefoneContactController =
      TextEditingController(text: '4936214859');
  TextEditingController siteContactController =
      TextEditingController(text: 'https://actsistemas.com');
  TextEditingController latitudeContactController = TextEditingController();
  TextEditingController longitudeContactController = TextEditingController();

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
            telefone: element['telefone'],
            email: element['email'],
            latitude: element['latitude'],
            longitude: element['longitude'],
            site: element['site'],
          ),
        );
      });
    });
  }

  void addData() async {
    if (form.currentState.validate()) {
      if (image.value.isEmpty) {
        Get.snackbar('Aviso', 'Tire uma foto para seu contato');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //grava na base de dados
      latitudeContactController.text = position.latitude.toString();
      longitudeContactController.text = position.longitude.toString();
      saveData();
      //fecha o formulário de cadastro
      Get.back();
    }
  }

  void saveData() async {
    var lastId = await DatabaseHelper.instance.insert(ContactModel(
      nome: nomeContactController.text,
      descricao: descricaoContactController.text,
      site: siteContactController.text,
      telefone: telefoneContactController.text,
      email: emailContactController.text,
      foto: image.value,
      latitude: latitudeContactController.text,
      longitude: longitudeContactController.text,
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
        foto: image.value,
        latitude: latitudeContactController.text,
        longitude: longitudeContactController.text,
      ),
    );
    //limpa os campos do formulário
    nomeContactController.clear();
    descricaoContactController.clear();
    emailContactController.clear();
    telefoneContactController.clear();
    siteContactController.clear();
    image.value = '';
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
        if (foto != "") {
          //só remove um arquivo se existir imagem, pois pode ter sido importado contato via qrCode que não possui imagem.
          await File(foto).delete(); //deleta o arquivo recebido por parâmetro
        }
        Get.back(); //fecha o pop-up
      },
      onCancel: () => Get
          .back(), //adiciona automaticamente o botão Cancelar, e ao clicar fecha o pop-up
    );
  }

  void launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  void shareOnWhatsapp(msg) async =>
      await FlutterShareMe().shareToWhatsApp(msg: msg);

  Future scan() async {
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    VCard vc = VCard(cameraScanResult);
    nomeContactController.text = vc.formattedName;
    siteContactController.text = vc.typedURL[0][0];
    telefoneContactController.text = vc.typedTelephone[0][0];
    emailContactController.text = vc.typedEmail[0][0];

    descricaoContactController.text = 'sem descricao';
    image.value = '';
    latitudeContactController.text = '';
    longitudeContactController.text = '';

    saveData();
  }
}
