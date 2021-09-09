import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/util/configuracoes.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';
import 'package:validadores/Validador.dart';
import 'package:image_picker/image_picker.dart';


class ScreenNovoAnuncio extends StatefulWidget {
  @override
  _ScreenNovoAnuncioState createState() => _ScreenNovoAnuncioState();
}

class _ScreenNovoAnuncioState extends State<ScreenNovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaItemsEstados = [];
  List<DropdownMenuItem<String>> _listaItemsCategorias = [];
  String _estadoSelecionado;
  String _categoriaSelecionada;
  BuildContext _dialogContext;

  Anuncio _anuncio;

  TextEditingController  _tituloController =  TextEditingController();
  TextEditingController  _precoController =  TextEditingController();
  TextEditingController  _telefoneController =  TextEditingController();
  TextEditingController  _descricaoeController =  TextEditingController();

  _selecionarImagem() async{
    PickedFile imagemSelecionada;
    ImagePicker imagePicker = ImagePicker();
    imagemSelecionada  = await imagePicker.getImage(source:ImageSource.gallery );

    if(imagemSelecionada != null){
      setState(() {
        File file =  File(imagemSelecionada.path);
        _listaImagens.add(file);
      });
    }
  }

  _loadItens(){
    Configuracoes.firtItemSelectable = false;
    _listaItemsEstados = Configuracoes.getEstados();
    _listaItemsCategorias = Configuracoes.getCategorias();

    }


   Future _uploadImagens() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens){
      int i = 0;
      //String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      Reference  arquivo = pastaRaiz
      .child("meus_anuncios")
      .child(_anuncio.id)
      .child("image${i}");
      i++;

      UploadTask uploadTask = arquivo.putFile(imagem);
      String url = await uploadTask.then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      _anuncio.fotos.add(url);

    }
   }

  _salvarAnuncio() async{

    _abrirDialog(_dialogContext);
      // Uploas das imagnes
    await _uploadImagens();
    //print("Lista imagens ${_anuncio.fotos.toString()}");

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;

    //Salvar anuncio no Firestore
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(usuarioLogado.uid)
    .collection("anuncios")
    .doc(_anuncio.id)
    .set(_anuncio.toMap()).then((_) {
      db.collection("anuncios")
      .doc(_anuncio.id)
      .set(_anuncio.toMap()).then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
      


    });

  }

  _abrirDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio..."),
              ],
            ),
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItens();
    _anuncio = Anuncio.gerarId();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Novo Anúncio"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch ,
                children: [

                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens){
                    if(imagens.length == 0){
                      return "É necessário selecionar uma imagem";
                    }
                    return null;
                  },
                  builder: (state){
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemCount: _listaImagens.length + 1,
                              scrollDirection: Axis.horizontal ,
                              itemBuilder: (context, index){
                                if(index == _listaImagens.length){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                           Icon(
                                             Icons.add_a_photo,
                                             size: 40,
                                             color: Colors.grey[100],
                                           ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                color: Colors.grey[100],
                                              ),

                                            )
                                          ],
                                        ),

                                      ),
                                      onTap: _selecionarImagem,
                                    ),
                                  );
                                }
                                if(_listaImagens.length > 0){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(_listaImagens[index]),
                                                FlatButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        _listaImagens.removeAt(index);
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                    child: Text("Excluir")
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_listaImagens[index]),
                                        child: Container(
                                          color: Color.fromRGBO(255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete, color: Colors.red),
                                        ),

                                      ),
                                    ) ,
                                  );
                                }
                                return Container();

                              },
                          ),
                        ),
                        if(state.hasError)
                          Container(
                            child: Text(
                              "${state.errorText}",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),


                      ],
                    );
                  },
                ),


                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            hint: Text("Estados"),
                            onSaved: (valor){
                              _anuncio.estado = valor;
                            },
                            value: _estadoSelecionado,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                            ),
                            items: _listaItemsEstados,
                            validator: (valor){
                              return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                                .valido(valor);
                            },
                            onChanged: (valor){
                              setState(() {
                                _estadoSelecionado = valor;
                              });
                            },
                          ),

                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            hint: Text("Categorias"),
                            onSaved: (valor){
                              _anuncio.categoria = valor;
                            },
                            value: _categoriaSelecionada,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            items: _listaItemsCategorias,
                            validator: (valor){
                              return Validador()
                                  .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                                  .valido(valor);
                            },
                            onChanged: (valor){
                              setState(() {
                                _categoriaSelecionada = valor;
                              });
                            },
                          ),

                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child:  InputCustomizado(
                      hint: "Título",
                      controller: _tituloController,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                            .valido(valor);
                      },
                      onSaved: (valor){
                        _anuncio.titulo = valor;
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15,),
                    child:  InputCustomizado(
                      type: TextInputType.number,
                      hint: "Preço",
                      onSaved: (valor){
                        _anuncio.preco = valor;
                      },
                      inputFormarters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],

                      controller: _precoController,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                            .valido(valor);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15,),
                    child:  InputCustomizado(
                      type: TextInputType.phone,
                      hint: "Telefone",
                      onSaved: (valor){
                        _anuncio.telefone = valor;
                      },
                      inputFormarters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],

                      controller: _telefoneController,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                            .valido(valor);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child:  InputCustomizado(
                      hint: "Descrição (até 200 caractéres)",
                      onSaved: (valor){
                        _anuncio.descricao = valor;
                      },
                      maxLines: null,
                      controller:_descricaoeController,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                            .maxLength(200, msg: "Máximo de 200 caractéres")
                            .valido(valor);
                      },
                    ),
                  ),


                  BotaoCustomizado(
                      texto: "Cadastrar",
                      onPressed: () {
                        if (_formKey.currentState.validate()) {

                          _formKey.currentState.save();

                          // Configura dialogContext
                          _dialogContext = context;
                          _salvarAnuncio();
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
