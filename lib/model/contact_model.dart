class ContactModel {
  int id;
  String nome;
  String descricao;

  //"Executa" a classe recebendo os parâmetros
  ContactModel({this.id, this.nome, this.descricao});

  //cria o mapa de dados da classe
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'descricao': descricao};
  }
}
