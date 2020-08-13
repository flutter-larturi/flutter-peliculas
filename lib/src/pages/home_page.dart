import 'package:flutter/material.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  get pi => null;

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();
    peliculasProvider.getTopRated();
    peliculasProvider.getLatest();
    peliculasProvider.getUpcoming();
    peliculasProvider.getEspanol();
    peliculasProvider.getAnimadas();

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('Peliculas', style: TextStyle(color: Colors.white, fontSize: 30.0)),
        centerTitle: false,
        backgroundColor: Colors.black26,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch(),
              );
            }
          )
        ],
      ),
      body: Stack(
        children: <Widget> [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // _swiperTarjetas(),
                _populares(context),
                _topRated(context),
                _latest(context),
                _upcoming(context),
                _espanol(context),
                _animadas(context),
              ],
            ),
          ),
        ]
        
      ),
    );
  }

  Widget _populares(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Populares',
       peliculasProvider.popularesStream, 
       peliculasProvider.getPopulares,
       'populares'
    );
  }

  Widget _topRated(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Mejor Puntuación', 
      peliculasProvider.topRatedStream, 
      peliculasProvider.getTopRated,
      'toprated'
    );
  }

  Widget _latest(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Estrenos', 
      peliculasProvider.latestStream, 
      peliculasProvider.getLatest,
      'estrenos'
    );
  }

  Widget _upcoming(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Proximamente', 
      peliculasProvider.upcomingStream, 
      peliculasProvider.getUpcoming,
      'proximamente'
    );
  }

  Widget _espanol(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'En español', 
      peliculasProvider.espanolStream, 
      peliculasProvider.getEspanol,
      'espanol'
    );
  }

  Widget _animadas(BuildContext context) {
    return _genericHorizontalWidget(
      context, 
      'Animadas', 
      peliculasProvider.animadasStream, 
      peliculasProvider.getAnimadas,
      'animadas'
    );
  }

  Widget _genericHorizontalWidget(
    BuildContext context, 
    String titulo, 
    Stream stream, 
    Function siguiente, 
    String seccion
) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[

          Container(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(titulo, style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold))
          ),

          SizedBox(height: 10.0),
          
          // Crea el StreamBuilder con el dataset de peliculas
          StreamBuilder(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if(snapshot.hasData) {
                // Por cada pelicula arma la tarjeta con link a la pagina de detalle
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: siguiente,
                  seccion: seccion
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );

  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );

  }


}