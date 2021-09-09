import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/painting.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/util/configuracoes.dart';
import 'package:olx/views/widgets/item_anuncio.dart';
class ScreenAnuncios extends StatefulWidget {
  @override
  _ScreenAnunciosState createState() => _ScreenAnunciosState();
}

class _ScreenAnunciosState extends State<ScreenAnuncios> {

  List<String> itensMenu =["Menu 1", "Menu 2"];

  String _estadoSelecionado = "" ;
  String _categoriaSelecionada = "" ;
  List<DropdownMenuItem<String>> _listaItemsEstados;
  List<DropdownMenuItem<String>> _listaItemsCategorias;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  User _usuarioLogado;

  _escolhaMenuItem(String itemEscolhido){
    switch (itemEscolhido) {
      case "Meus Anúncios" :
        Navigator.pushReplacementNamed(context, "/meus_anuncios");
        break;
      case "Entrar / Cadastrar" :
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case "Deslogar" :
        _deslogarusuario();
        break;
    }
  }

  _deslogarusuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future _verificarUsuarioLogado() async{
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    _usuarioLogado = await auth.currentUser;

    if(_usuarioLogado == null){
      itensMenu = ["Entrar / Cadastrar"];
    }
    else{
      itensMenu = ["Meus Anúncios", "Deslogar"];
    }

  }

  _loadItens(){
    Configuracoes.firtItemSelectable = true;
    _listaItemsEstados = Configuracoes.getEstados();
    _listaItemsCategorias = Configuracoes.getCategorias();


  }

  Future<Stream<QuerySnapshot>> _filtrarAuncios()async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");
    if(_estadoSelecionado != ""){
      query = query.where("estado", isEqualTo: _estadoSelecionado);
    }

    if(_categoriaSelecionada != ""){
      query = query.where("categoria", isEqualTo: _categoriaSelecionada);
    }
    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListnerAuncios()async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream =  db
        .collection("anuncios")
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }


  iniciar()async{
    _loadItens();
    await _verificarUsuarioLogado();
    await _adicionarListnerAuncios();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iniciar();
  }
  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircularProgressIndicator(
          ),
          Text("Carregando anúncios..."),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
        onSelected: _escolhaMenuItem,
        itemBuilder:(context){
          return itensMenu.map((String item) {
            return PopupMenuItem<String>(
              value:item,
              child: Text(item),
            );
          }).toList();
        },
      ),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        iconDisabledColor: Colors.grey,
                        value: _estadoSelecionado,
                        items: _listaItemsEstados,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        onChanged: (estado){
                          setState(() {
                            _estadoSelecionado = estado;
                            _filtrarAuncios();
                          });
                        },
                      ),
                    ),
                  ),
                ),


                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        iconDisabledColor: Colors.grey,
                        value: _categoriaSelecionada,
                        items: _listaItemsCategorias,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        onChanged: (categoria){
                          setState(() {
                            _categoriaSelecionada = categoria;
                            _filtrarAuncios();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            StreamBuilder(
              stream: _controller.stream,
                builder: (_, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return  carregandoDados;
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasError ){
                        return Center(
                          child: Text("Erro ao carregar dados",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9c27b0),
                            ),
                          ),
                        );
                      }

                      else{
                        QuerySnapshot querySnapshot = snapshot.data;

                        if (querySnapshot.docs.length == 0){
                          return Expanded(
                            child: Center(
                              child: Text("Não há anuncios",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff9c27b0),
                                ),
                              ),
                            ),
                          );
                        }
                        else{
                          return Expanded(
                            child: ListView.builder(
                                itemCount: querySnapshot.docs.length,
                                itemBuilder: (_,index){
                                  List<DocumentSnapshot>  anuncios = querySnapshot.docs.toList();
                                  DocumentSnapshot documentSnapshot = anuncios[index];
                                  Anuncio anuncio = Anuncio.fromDocumentSnapshot( documentSnapshot);
                                  return ItemAnuncio(
                                    anuncio: anuncio,
                                    onTap: (){
                                     Navigator.pushNamed(context,
                                       "/detalhes_anuncio",
                                       arguments: anuncio,
                                     );
                                    },
                                  );
                                }
                            ),

                          );
                        }


                      }
                      break;

                  }
                  return Container( );
                },
            ),


          ],
        ),
      ),

    );
  }
}
