import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String nameDb = "servicosNew.db";
final String nomeTable = "qruTable";

final String codeQruColuna = "codeQruColuna";
final String osQruColuna = "osQruColuna";
final String operadoraQruColuna = "operadoraQruColuna";
final String seguradoQruColuna = "seguradoQruColuna";
final String tipoServicoQrucoluna = "tipoServicoQruColuna";
final String enderecoQruColuna = "enderecoQruColuna";
final String obsQruColuna = "obsQrucoluna";
final String valorQruColuna = "valorQruColuna";
final String dataQruColuna = "dataQruCluna";
final String horaQruColuna = "horaQruColuna";
final String tecnicoQruColuna = "tecnicoQruColuna";
final String imgLaudoQruColuna = "imgLaudoQruColuna";

class ContactHelpers{

  static final ContactHelpers _instance = ContactHelpers.internal();
  factory ContactHelpers() => _instance;
  ContactHelpers.internal();

  Database _db;

  Future<Database>get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }
  //função abre o banco e criar tabela
  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join (databasesPath, "$nameDb");
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $nomeTable("
              "$codeQruColuna INTEGER PRIMARY KEY,"
              "$osQruColuna TEXT,"
              "$operadoraQruColuna TEXT,"
              "$seguradoQruColuna TEXT,"
              "$tipoServicoQrucoluna TEXT,"
              "$enderecoQruColuna TEXT,"
              "$obsQruColuna TEXT,"
              "$valorQruColuna TEXT,"
              "$dataQruColuna TEXT,"
              "$horaQruColuna TEXT,"
              "$tecnicoQruColuna TEXT,"
              "$imgLaudoQruColuna TEXT)"
      );
    });
  }

  //função salvar na tabela
  Future<Contact> saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.codeQru = await dbContact.insert(nomeTable, contact.toMap());
    return contact;
  }

  //função mostrar iten da tabela
  Future<Contact>getContact(int id) async{
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(nomeTable,
        columns: [
          codeQruColuna,
          osQruColuna,
          operadoraQruColuna,
          seguradoQruColuna,
          tipoServicoQrucoluna,
          enderecoQruColuna,
          obsQruColuna,
          valorQruColuna,
          dataQruColuna,
          horaQruColuna,
          tecnicoQruColuna,
          imgLaudoQruColuna],
        where: "$codeQruColuna = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    }else{
      return null;
    }
  }
  //função deletar iten na tabela
  deleteContact(int id) async{
    Database dbContact = await db;
    return await dbContact.delete(nomeTable,
        where: "$codeQruColuna = ?",
        whereArgs: [id]);
  }
  // função alterar iten na tabela
  updateContact(Contact contact) async{
    Database dbContact = await db;
    dbContact.update(nomeTable,
        contact.toMap(),
        where: "$codeQruColuna = ?",
        whereArgs: [contact.codeQru]);
  }

  //função mostrar todos os itens da tabela
  Future<List>getAllContacts() async{
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $nomeTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  //função exibir quantidade de itens na tabla
  getNumber() async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $nomeTable"));
  }

  getDataNumber(String dataQru) async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $nomeTable WHERE $dataQru"));
  }

  //função fechar banco de dados
  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }
}

// classe que molda o contato
class Contact {

  int codeQru;
  String osQru;
  String operadoraQru;
  String seguradoQru;
  String tipoServicoQru;
  String enderecoQru;
  String obsQru;
  String valorQru;
  String dataQru;
  String horaQru;
  String tecnicoQru;
  String imgLaudoQru;

  Contact ();

  Contact.fromMap(Map map){
    codeQru = map[codeQruColuna];
    osQru = map[osQruColuna];
    operadoraQru = map[operadoraQruColuna];
    seguradoQru = map[seguradoQruColuna];
    tipoServicoQru = map[tipoServicoQrucoluna];
    enderecoQru = map[enderecoQruColuna];
    obsQru = map[obsQruColuna];
    valorQru = map[valorQruColuna];
    dataQru = map[dataQruColuna];
    horaQru = map[horaQruColuna];
    tecnicoQru = map[tecnicoQruColuna];
    imgLaudoQru = map[imgLaudoQruColuna];
  }

  /*
    codeQru;
    osQru;
    operadoraQru;
    seguradoQru;
    tipoServicoQru;
    enderecoQru;
    obsQru;
    valorQru;
    dataQru;
    horaQru;
    tecnicoQru;
    imgLaudoQru;
*/


  Map toMap () {
    Map<String, dynamic> map = {
      codeQruColuna: codeQru,
      osQruColuna: osQru,
      operadoraQruColuna: operadoraQru,
      seguradoQruColuna: seguradoQru,
      tipoServicoQrucoluna: tipoServicoQru,
      enderecoQruColuna: enderecoQru,
      obsQruColuna: obsQru,
      valorQruColuna: valorQru,
      dataQruColuna: dataQru,
      horaQruColuna: horaQru,
      tecnicoQruColuna: tecnicoQru,
      imgLaudoQruColuna: imgLaudoQru,

    };
    if (codeQru != null) {
      map[codeQruColuna] = codeQru;
    }
    return map;
  }

  @override
  String toString () {
    return "Contact("
        "codeQru: $codeQru,"
        "osQru: $osQru,"
        "operadoraQru: $operadoraQru,"
        "seguradoQru: $seguradoQru,"
        "tipoServicoQru: $tipoServicoQru,"
        "enderecoQru: $enderecoQru,"
        "obsQru: $obsQru,"
        "valorQru: $valorQru,"
        "dataQru: $dataQru,"
        "horaQru: $horaQru,"
        "tecnicoQru: $tecnicoQru,"
        "imgLaudoQru: $imgLaudoQru)";
  }
}

