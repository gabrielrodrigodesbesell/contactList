class ContactModel {
  int id;
  String nome;
  String descricao;
  String foto;
  String email;
  String site;
  String telefone;
  String latitude;
  String longitude;

  //"Executa" a classe recebendo os parâmetros
  ContactModel(
      {this.id,
      this.nome,
      this.descricao,
      this.foto,
      this.email,
      this.site,
      this.telefone,
      this.latitude,
      this.longitude});

  //cria o mapa de dados da classe
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'foto': foto,
      'email': email,
      'site': site,
      'telefone': telefone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
