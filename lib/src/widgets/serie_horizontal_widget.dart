import 'package:flutter/material.dart';
import 'package:peliculas/src/config/config.dart';

import 'package:peliculas/src/models/serie_model.dart';
import 'package:peliculas/src/widgets/tarjeta_widget.dart';

class SerieHorizontal extends StatelessWidget {

  final List<Serie> series;
  final Function siguientePagina;
  final String seccion;

  SerieHorizontal({ @required this.series,  @required this.siguientePagina, @required this.seccion });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: ConfigApp().viewportFractionCard,
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
      height: _screenSize.height * ConfigApp().screenSizeHeight,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: series.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, series[i], seccion);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Serie serie, String seccion) {

    serie.uniqueId = serie.id.toString() + '-' + seccion;

    final tarjeta = Tarjeta(tipo: 'serie', serie: serie);
    
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, 'detalle', arguments: serie);
      },
      child: tarjeta,
    );
  }

 }