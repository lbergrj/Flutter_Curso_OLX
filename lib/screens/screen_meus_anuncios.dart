import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class ScreenMeusAuncios extends StatefulWidget {
  @override
  _ScreenMeusAunciosState createState() => _ScreenMeusAunciosState();
}

class _ScreenMeusAunciosState extends State<ScreenMeusAuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  User _usuarioLogado;

  _recuperarUsuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    _usuarioLogado = await auth.currentUser;
  }

  Future<Stream<QuerySnapshot>> _addListenerAuncios() async{
    await _recuperarUsuarioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
    .collection("meus_anuncios")
    .doc(_usuarioLogado.uid)
    .collection("anuncios")
    .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });

  }

  _removerAnuncio(Anuncio anuncio) async {
    print("id: ${anuncio.id}");
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
        .doc(_usuarioLogado.uid)
        .collection("anuncios")
        .doc(anuncio.id)
        .delete()
        .then((_) {
      db.collection("anuncios").doc(anuncio.id).delete().then((_) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference pastaRaiz = storage.ref();
        for (String foto in anuncio.fotos) {
          int i = 0;
          Reference arquivo = pastaRaiz
              .child("meus_anuncios")
              .child(anuncio.id)
              .child("image${i}");
          arquivo.delete();
          i++;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListenerAuncios();

  }


  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
          ),
          Text("Carregando anúncios..."),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Anúncios"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Adicionar"),
        onPressed: (){
          Navigator.pushNamed(context, "/novo_anuncio");
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return  carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados"),
                );
              }
              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, index){

                  List<DocumentSnapshot>  anuncios = querySnapshot.docs.toList();
                  DocumentSnapshot documentSnapshot = anuncios[index];
                  Anuncio anuncio = Anuncio.fromDocumentSnapshot( documentSnapshot);
                  return ItemAnuncio(
                    anuncio: anuncio,
                    onDelete: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Confirmar"),
                              content: Text("Deseja excluir o anúncio?"),
                              actions: [

                                FlatButton(
                                  child: Text("Cancelar",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),

                                FlatButton(
                                  child: Text("Remover",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  onPressed: (){
                                    _removerAnuncio(anuncio);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                      );
                    },
                  );
                },
              );
              break;

          }

        },
      ),
    );
  }
}
