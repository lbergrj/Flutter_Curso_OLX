import 'package:cloud_firestore/cloud_firestore.dart';


class Anuncio{

  String _id;
  String _estado;
  String _categoria;
  String _titulo;
  String _preco;
  String _telefone;


  Anuncio();



  Anuncio.gerarId(){
    // Cria um ID mas não salna no banco de dados, a não ser que o anuncio seja salvo

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    this.id = anuncios.doc().id;
    this.fotos = [];

  }

  Map<String, dynamic> toMap(){
    return {
      "id" : this.id,
      "estado" : this.estado,
      "categoria" : this.categoria,
      "titulo" : this.titulo,
      "preco" : this.preco,
      "telefone" : this.telefone,
      "descricao" : this.descricao,
      "fotos" : this.fotos,

    };
  }

  Anuncio.fromDocumentSnapshot(DocumentSnapshot snapshot){
    this.id = snapshot.id;
    this.estado = snapshot["estado"];
    this.categoria = snapshot["categoria"];
    this.titulo = snapshot["titulo"];
    this.preco = snapshot["preco"];
    this.telefone = snapshot["telefone"];
    this.descricao = snapshot["descricao"];
    this.fotos = List<String>.from(snapshot["fotos"]);

  }


  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String _descricao;
  List<String> _fotos;

  String get id => _id;

  set id(String value) {
    _id = value;
  }


  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }


}