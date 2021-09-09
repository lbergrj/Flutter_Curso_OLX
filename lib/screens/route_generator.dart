import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/screens/screen_detalhes_anuncio.dart';
import 'package:olx/screens/screen_meus_anuncios.dart';
import 'package:olx/screens/screen_novo_anuncio.dart';
import 'screen_anuncios.dart';
import 'screen_login.dart';

class RouteGenerator{

  static Route<dynamic>generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case  "/":
        return MaterialPageRoute(
            builder: (_) => ScreenAnuncios()
        );

      case  "/login":
        return MaterialPageRoute(
            builder: (_) => ScreenLogin()
        );

      case  "/meus_anuncios":
        return MaterialPageRoute(
            builder: (_) => ScreenMeusAuncios()
        );

      case  "/novo_anuncio":
        return MaterialPageRoute(
            builder: (_) => ScreenNovoAnuncio()
        );
      case  "/detalhes_anuncio":
        return MaterialPageRoute(
            builder: (_) => ScreenDetalhesAnuncio(args)
        );

      default: _erroRota();

    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder:(_){
        return Scaffold(
          appBar: AppBar (
            title: Text("Tela não encontrada"),
          ),
          body: Center(
            child: Text("Tela não encontrada"),
          ),
        );
      }
    );
  }
}