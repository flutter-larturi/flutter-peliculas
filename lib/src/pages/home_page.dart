import 'package:flutter/material.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/utils/utils.dart';

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
        title: Text('Peliculas', style: TextStyle(fontSize: 30.0)),
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
    return genericHorizontalWidget(
      context, 
      'Populares',
       peliculasProvider.popularesStream, 
       peliculasProvider.getPopulares,
       'populares',
       'peliculas'
    );
  }

  Widget _topRated(BuildContext context) {
    return genericHorizontalWidget(
      context, 
      'Mejor Puntuación', 
      peliculasProvider.topRatedStream, 
      peliculasProvider.getTopRated,
      'toprated',
      'peliculas'
    );
  }

  Widget _latest(BuildContext context) {
    return genericHorizontalWidget(
      context, 
      'Estrenos', 
      peliculasProvider.latestStream, 
      peliculasProvider.getLatest,
      'estrenos',
      'peliculas'
    );
  }

  Widget _upcoming(BuildContext context) {
    return genericHorizontalWidget(
      context, 
      'Proximamente', 
      peliculasProvider.upcomingStream, 
      peliculasProvider.getUpcoming,
      'proximamente',
      'peliculas'
    );
  }

  Widget _espanol(BuildContext context) {
    return genericHorizontalWidget(
      context, 
      'En español', 
      peliculasProvider.espanolStream, 
      peliculasProvider.getEspanol,
      'espanol',
      'peliculas'
    );
  }

  Widget _animadas(BuildContext context) {
    return genericHorizontalWidget(
      context, 
      'Animadas', 
      peliculasProvider.animadasStream, 
      peliculasProvider.getAnimadas,
      'animadas',
      'peliculas'
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