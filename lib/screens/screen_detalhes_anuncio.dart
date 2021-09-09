import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/models/anuncio.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenDetalhesAnuncio extends StatefulWidget {
  Anuncio anuncio;

  ScreenDetalhesAnuncio(this.anuncio);


  @override
  _ScreenDetalhesAnuncioState createState() => _ScreenDetalhesAnuncioState();
}

class _ScreenDetalhesAnuncioState extends State<ScreenDetalhesAnuncio> {
  Anuncio _anuncio;

  List<Widget> _getListaImagens(){
    List<String> listaUlImagens = _anuncio.fotos;
    return listaUlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth,
          ),
        ),
      );
      }).toList();
  }

 Future  _ligarTelefone(String telefone)async{
    //telefone = "https://www.google.com";
    if(await canLaunch("tel:$telefone")){
        await launch("tel:$telefone");
    }
    else{
      print("Não pode fazer a ligação");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anuncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Carousel(
                  images:_getListaImagens(),
                  dotSize: 8,
                  dotColor: Colors.white70,
                  dotBgColor: Colors.transparent,
                  autoplay: false,
                  dotIncreasedColor: temaPadrao.primaryColor,
                  //dotIncreaseSize:temaPadrao,
                ),
              ),

              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("R\$ ${_anuncio.preco}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor,
                      ),
                    ),

                    Text("${_anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text("Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text("${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,

                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text("Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text("${_anuncio.telefone}",
                      style: TextStyle(
                        fontSize: 18,

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),

                    ),
                    Padding(
                       padding: EdgeInsets.only(bottom: 66),

                    ),


                  ],
                ),

              ),
            ],
          ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: temaPadrao.primaryColor,
                    borderRadius: BorderRadius.circular(30),

                  ),

                  child: Text(
                    "Ligar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: (){
                 setState(() {
                   _ligarTelefone(_anuncio.telefone);
                 });
                },
              ),
          ),
        ],

      ),
    );
  }
}
