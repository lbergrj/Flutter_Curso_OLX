import 'package:flutter/material.dart';
import 'package:olx/screens/route_generator.dart';
import 'package:olx/screens/screen_anuncios.dart';
import 'package:olx/screens/screen_login.dart';


final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff9c27b0),
  accentColor: Color(0xff7b1fa2),

);

void main() {
  runApp(MaterialApp(
    title: "OLX",
    debugShowCheckedModeBanner: false,
    home:ScreenAnuncios(),
    theme:  temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

