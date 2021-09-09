import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';

class ItemAnuncio extends StatelessWidget {

  Anuncio anuncio;
  VoidCallback onTap;
  VoidCallback onDelete;


  ItemAnuncio({
      @ required this.anuncio,
      this.onTap,
      this.onDelete,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              //Imagem
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(anuncio.fotos[0],
                  fit: BoxFit.cover,
                ),
              ),

              //Primeiro expended ocupa 3/4 do espaço e segundo 1/4
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("R\$ ${anuncio.preco}"),

                    ],
                  ),
                ),
              ),

             if(this.onDelete != null) Expanded(
                flex: 1,
                child: IconButton(
                  padding: EdgeInsets.all(10),
                  icon: Icon(Icons.delete, color: Colors.red),
                  iconSize: 36,
                  tooltip: "Delete",
                  onPressed: this.onDelete,
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
