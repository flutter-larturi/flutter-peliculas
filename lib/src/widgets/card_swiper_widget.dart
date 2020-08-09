import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 25.0),
      height: 400.0,
      child: new Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.6,
          itemHeight: _screenSize.height * 0.99,
          itemBuilder: (BuildContext context,int index){

            peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: peliculas.length,
          // pagination: new SwiperPagination(),
          // control: new SwiperControl(),
        ),
    );
  }

}