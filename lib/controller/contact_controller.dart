import 'dart:developer';
import 'dart:io';

import 'package:contactlist/view/form_page.dart';
import 'package:contactlist/view/read_page.dart';
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
import 'package:contactlist/utils/vcard/vcard.dart';

class ContactController extends GetxController {
  //listOfContacts é uma lista observável, quando sofrer atualizações
  //ela mesma comunica os compomentes que estão utilizando
  var listOfContacts = []
      .obs; //.obs é responsável por informar ao Getx que a variável é observável e toda vez que ele sofrer alterações, deve ser comunicado os componentes que estão dentro do Obx()
  //declaração dos controladores de textos do formulário
  TextEditingController nomeContactController = TextEditingController();
  TextEditingController descricaoContactController = TextEditingController();
  TextEditingController emailContactController = TextEditingController();
  TextEditingController telefoneContactController = TextEditingController();
  TextEditingController siteContactController = TextEditingController();
  TextEditingController latitudeContactController = TextEditingController();
  TextEditingController longitudeContactController = TextEditingController();

  GlobalKey<FormState> form = GlobalKey<FormState>();

  var image = ''
      .obs; //criado uma variável observável para armazenar o caminho da foto no celular e notificar a view para apresentar em tela
  final picker = ImagePicker(); //instancia o plugin de captura de imagem

  @override
  void onInit() {
    //ao executar o controlador, busca os dados na base de dados
    getList();
    super.onInit();
  }

  void getList() {
    //busca os registros na base de dados ao abrir o app
    DatabaseHelper.instance.queryAllRows().then((value) {
      //percorre os registros inserindo na lista atual que é
      //exibida para o usuário
      value.forEach((element) {
        listOfContacts.add(
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

  void saveContactFromFormORQrcode() async {
    var lastId = await DatabaseHelper.instance.insert(
      ContactModel(
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
    //insere os dados na lista atual que é exibida em tela
    //evitando o reload da tabela
    listOfContacts.insert(
      0, //repassa o zero para o item aparecer no inicio da lista sempre que for adicionado
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
    clearFieldsAction(); //limpa os campos
  }

  void launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  void shareOnWhatsapp(msg) async {
    await FlutterShareMe().shareToWhatsApp(msg: msg);
  }

  Future scanQRCodeAction() async {
    clearFieldsAction();
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

    saveContactFromFormORQrcode();
  }

  String toPersonalVCard(ContactModel fullContact) {
    ///Create a new vCard
    var vCard = PersonalVCard();

    ///Set properties
    vCard.firstName = fullContact.nome;
    vCard.workPhone = fullContact.telefone;
    vCard.email = fullContact.email;
    vCard.url = fullContact.site;
    //return String vCard for generate QRCode
    return vCard.getFormattedString();
  }

  void addContactForm() {
    clearFieldsAction();
    Get.to(() => FormPage());
  }

  void addContactAction() async {
    if (form.currentState.validate()) {
      if (image.value.isEmpty) {
        Get.snackbar(
          'warningTitlePhotoRequired'.tr,
          'warningTextPhotoRequired'.tr,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //grava na base de dados
      latitudeContactController.text = position.latitude.toString();
      longitudeContactController.text = position.longitude.toString();
      saveContactFromFormORQrcode();
      //fecha o formulário de cadastro
      Get.back();
    }
  }

  void editContactForm(ContactModel fullContact, int index) async {
    clearFieldsAction();
    nomeContactController.text = fullContact.nome;
    descricaoContactController.text = fullContact.descricao;
    emailContactController.text = fullContact.email;
    telefoneContactController.text = fullContact.telefone;
    siteContactController.text = fullContact.site;
    latitudeContactController.text = fullContact.latitude;
    longitudeContactController.text = fullContact.longitude;
    image.value = fullContact.foto;
    log(fullContact.id.toString());
    Get.to(
      () => FormPage(
        inEdition: fullContact
            .id, //repassa o ID do banco de dados para a tela de atualização
        index:
            index, //repassa o indice da lista para a tela de atualização saber qual posição da lista deve ser modificada
      ),
    );
  }

  void editContactAction(int id, int index) async {
    if (form.currentState.validate()) {
      if (image.value.isEmpty) {
        //valida a imagem, sempre vai ter
        Get.snackbar(
          'warningTitlePhotoRequired'.tr,
          'warningTextPhotoRequired'.tr,
        );
        return;
      }
      await DatabaseHelper.instance.update(
        id,
        ContactModel(
          id: id,
          nome: nomeContactController.text,
          descricao: descricaoContactController.text,
          site: siteContactController.text,
          telefone: telefoneContactController.text,
          email: emailContactController.text,
          foto: image.value,
        ),
      );

      //modifica as propriedades do item da lista
      listOfContacts[index].nome = nomeContactController.text;
      listOfContacts[index].descricao = descricaoContactController.text;
      listOfContacts[index].site = siteContactController.text;
      listOfContacts[index].telefone = telefoneContactController.text;
      listOfContacts[index].email = emailContactController.text;
      listOfContacts[index].foto = image.value;
      listOfContacts
          .refresh(); //atualiza a lista para comunicar ao OBX() que deve ser atualizado em tela
      //fecha o formulário de alteracao
      Get.back();
    }
  }

  void readContactPage(ContactModel fullContact) {
    Get.to(() => ReadPage(fullContact));
  }

  //recebe como parâmetro o id do registro no db e o caminho da foto, assim não precisa buscar o registro para resgatar o caminho da foto:
  void deleteContactAction(int id, String foto, int index) {
    //adiciona a confirmação no ato de exclsuão
    Get.defaultDialog(
      radius: 10,
      barrierDismissible:
          false, //somente deixa fechar o pop-pup clicando nos botões de ação
      textConfirm: 'deleteContactConfirmButton'.tr,
      textCancel: 'deleteContactCancelButton'.tr,
      title: 'deleteContactTitle'.tr,
      content: Text('deleteContactText'.tr),
      onConfirm: () async {
        //adiciona automaticamente o botão OK
        //apaga do banco de dados o registro
        await DatabaseHelper.instance.delete(id);
        //remove os dados na lista atual que é exibida em tela
        //evitando o reload da tabela
        listOfContacts.removeAt(index);
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

  Future getImageAction() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera); //abre a câmera
    if (pickedFile != null) {
      image.value = pickedFile
          .path; //se o usuário tirou a foto e confirmou, armazena o caminho da foto na variável imagem
    } else {
      Get.snackbar(
        'warningTitlePhotoNotTaken'.tr,
        'warningTextPhotoNotTaken'.tr,
      ); //se não confirmou a imagem, exibe um snackbar
    }
  }

  void clearFieldsAction() {
    //limpa os campos do formulário
    nomeContactController.clear();
    descricaoContactController.clear();
    emailContactController.clear();
    telefoneContactController.clear();
    siteContactController.clear();
    image.value = '';
  }
}
