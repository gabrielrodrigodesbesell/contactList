import 'package:contactlist/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "contacts.db";
  static final _databaseVersion = 6;

  static final table = "contacts";

  static final columnId = 'id';
  static final columnNome = 'nome';
  static final columnDescricao = 'descricao';
  static final columnFoto = 'foto';
  static final columnEmail = 'email';
  static final columnSite = 'site';
  static final columnTelefone = 'telefone';
  static final columnLatitude = 'latitude';
  static final columnLongitude = 'longitude';

  //"Executa" a classe
  DatabaseHelper._privateConstructor();
  //retorna a instância do DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    //se o banco ainda não está aberto, abre, senão apenas retorna a
    //instancia aberta anteriormente
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //abre o banco de dados no diretório de instalação do aplicativo
  //se não existir ele cria um novo arquivo.
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //cria a tabela no banco de dados
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNome TEXT NOT NULL,
            $columnDescricao TEXT NOT NULL,
            $columnFoto TEXT,
            $columnEmail TEXT NOT NULL,
            $columnSite TEXT NOT NULL,
            $columnTelefone TEXT NOT NULL,
            $columnLatitude TEXT,
            $columnLongitude TEXT
          )
          ''');
  }

  //grava um registro na tabela
  Future<int> insert(ContactModel contact) async {
    //aguarda a instância do banco ser acessível.
    Database db = await instance.database;
    //insere os dados no banco de dados conforme o mapa de campos da
    //classe/model ContactModel
    var res = await db.insert(table, contact.toMap());
    return res;
  }

  //retorna os registros da tabela ordenado por ID
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId DESC");
    return res;
  }

  //apaga um registro na tabela
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //atualiza um registro na tabela
  Future<int> update(int id, ContactModel contact) async {
    //aguarda a instância do banco ser acessível.
    Database db = await instance.database;
    return await db.update(
      table,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
