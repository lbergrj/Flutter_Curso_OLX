import 'package:brasil_fields/brasil_fields.dart';
import "package:flutter/material.dart";

class Configuracoes {
  static bool firtItemSelectable = false;
  //Retorna lista de categorias
  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> listaItemsCategorias = [];


    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Categoria",
            style: TextStyle(
              color:Color(0xff9c27b0),
            ),
          ),
          value:  firtItemSelectable? "": null,
        )
    );

    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Automóvel"), value: "auto",)
    );

    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Imóvel"), value: "imovel",)
    );

    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro",)
    );

    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Moda"), value: "moda",)
    );

    listaItemsCategorias.add(
        DropdownMenuItem(child: Text("Esportes"), value: "esportes",)
    );
    return listaItemsCategorias;
  }


  //Retorna lista de estados
  //É recomendável criar as categorias no banco de dados e não no código
  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> listaItemsEstados = [];
    listaItemsEstados.add(DropdownMenuItem(child: Text("Região",
        style: TextStyle(
            color:Color(0xff9c27b0),
          ),
        ),
       value:  firtItemSelectable? "": null,
      ),
    );
    for(var estado in Estados.listaEstadosSigla) {
      listaItemsEstados.add(DropdownMenuItem(child: Text(estado), value: estado));
    }
    return  listaItemsEstados;
  }


}



