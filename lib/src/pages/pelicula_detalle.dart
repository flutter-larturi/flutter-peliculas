import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 21.0,
                ),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),

                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Text('Cast', style: Theme.of(context).textTheme.subtitle1)
                ),

                _crearCasting(pelicula),
              ]
            ),
          )
        ],
      ),
    );
  }
}

Widget _crearAppbar(Pelicula pelicula) {
  return SliverAppBar(
    elevation: 2.0,
    backgroundColor: Colors.indigo,
    expandedHeight: 200.0,
    floating: false,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          overflow: TextOverflow.ellipsis
        ),
      ),
      background: FadeInImage(
        placeholder: AssetImage('assets/img/loading.gif'), 
        image: NetworkImage(pelicula.getBackgroundImg()),
        fadeInDuration: Duration(milliseconds: 150),
        fit: BoxFit.cover,
      ),
    
    ),
  );

}

Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
  
  return  Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: <Widget>[
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image(
              image: NetworkImage(pelicula.getPosterImg()),
              height: 150.0,
            ),
          ),
        ),
        SizedBox(width: 20.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
              Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString() + ' (' + pelicula.releaseDate.substring(0,4) + ')', style: Theme.of(context).textTheme.subtitle1),
                  
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );

}

Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text(pelicula.overview, textAlign: TextAlign.justify,),
    );
}

Widget _crearCasting(Pelicula pelicula) {

  final peliculasProvider = new PeliculasProvider();

  return FutureBuilder(
    future: peliculasProvider.getCast(pelicula.id.toString()),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      
      if(snapshot.hasData) {
        return _crearActoresPageView(snapshot.data);
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

    },
  );

}

Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1        
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
}

Widget _actorTarjeta(Actor actor) {
  return Container(
    child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'), 
            image: NetworkImage(actor.getFoto()),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          width: 100.0,
          child: Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}
