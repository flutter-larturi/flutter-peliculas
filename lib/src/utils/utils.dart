import 'package:flutter/material.dart';

import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';
import 'package:peliculas/src/widgets/serie_horizontal_widget.dart';

genericHorizontalWidget(
    BuildContext context, 
    String titulo, 
    Stream stream, 
    Function siguiente, 
    String seccion,
    String tipo
) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            padding: EdgeInsets.only(left: 20.0, top: 15.0),
            child: Text(titulo, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
          ),

          SizedBox(height: 12.0),
          
          // Crea el StreamBuilder con el dataset de peliculas
          StreamBuilder(
            
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if(snapshot.hasData) {
                // Por cada pelicula arma la tarjeta con link a la pagina de detalle
                
                if(tipo == 'peliculas') {
                    return MovieHorizontal(
                      peliculas: snapshot.data,
                      siguientePagina: siguiente,
                      seccion: seccion
                    );
                } else {
                    return SerieHorizontal(
                      series: snapshot.data,
                      siguientePagina: siguiente,
                      seccion: seccion
                    );
                } 
                
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );

}