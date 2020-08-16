import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  final String seccion;

  MovieHorizontal({ @required this.peliculas,  @required this.siguientePagina, @required this.seccion });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.25,
    keepPage: true
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() { 
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      } 
    });

    return Container(
      height: _screenSize.height * 0.22,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i], seccion);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula, String seccion) {

    pelicula.uniqueId = pelicula.id.toString() + '-' + seccion;

    final tarjeta = Container(

        transform: Matrix4.translationValues(-29.0, 0.0, 0.0),
       
        margin: EdgeInsets.only(right: 12.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(pelicula.getPosterImg()),
                  fit: BoxFit.cover,
                  height: 120.0,
                ),
              ),
            ),
            Column(
              
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Text(
                  pelicula.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 14.0)
                ),
              ]
              
            )
          ],
        ),
      );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }

  // No se usa luego de haber incluido el metodo _tarjeta
  List<Widget> _tarjetas(BuildContext context) {

    return peliculas.map((pelicula) {

      return Container(
        margin: EdgeInsets.only(right: 5.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

    }).toList();

  }

 }