import 'package:flutter/material.dart';
import 'package:peliculas/src/config/config.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/serie_model.dart';

class Tarjeta extends StatelessWidget {
  
  final String tipo;
  final Pelicula pelicula;
  final Serie serie;

  Tarjeta({ @required this.tipo, this.pelicula, this.serie });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(

        transform: Matrix4.translationValues(-1.0, 0.0, 0.0),
       
        margin: EdgeInsets.only(right: 12.0),

        child: Column(

          children: <Widget>[
            Hero(
              tag: (tipo == 'pelicula') ? pelicula.uniqueId : serie.uniqueId,
              
              child: ClipRRect(
                
                borderRadius: BorderRadius.circular(4.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: (tipo == 'pelicula') ? NetworkImage(pelicula.getPosterImg()) : NetworkImage(serie.getPosterImg()),
                  fit: BoxFit.cover,
                  height: _screenSize.height * ConfigApp().screenSizeHeight * 0.8,
                  
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              child: Text(
                  (tipo == 'pelicula') ? pelicula.title : serie.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white54, fontSize: 12.0)
                ),
              
              
            )
          ],
        ),
    );
  }
}