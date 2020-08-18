import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/providers/series_provider.dart';
import 'package:peliculas/src/utils/utils.dart';

class ActorDetelle extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();
  final seriesProvider = new SeriesProvider();

  @override
  Widget build(BuildContext context) {

    final Actor actor = ModalRoute.of(context).settings.arguments;
    peliculasProvider.getPeliculasActor(actor);
    seriesProvider.getSeriesActor(actor);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         title: Text(actor.name, style: TextStyle(fontSize: 19.0)),
         backgroundColor: Colors.black12,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 30.0,
                ),
                
                _mostrarActor(actor),

                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 0.0),
                  margin: const EdgeInsets.only(bottom: 10.0),
                ),

               _mostrarPeliculas(context, actor),
               _mostrarSeries(context, actor),
                
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _mostrarActor(Actor actor) {
  
    return  Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: <Widget>[
        Hero(
          tag: actor.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(actor.getFoto()),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 20.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(actor.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              SizedBox(height: 4.0),
              Text(actor.character, style: TextStyle(color: Colors.grey, fontSize: 18.0), overflow: TextOverflow.ellipsis),
              SizedBox(height: 8.0),
            ],
          ),
        )
      ],
    ),
  );

  }

  Widget _mostrarPeliculas(BuildContext context, Actor actor) {
    return Container(
      child: _peliculasActor(context, actor)
    );
  }

  Widget _peliculasActor(BuildContext context, Actor actor) {
    return genericHorizontalWidget(
      context, 
      'Peliculas',
       peliculasProvider.peliculasActorStream, 
       peliculasProvider.getPeliculasActor,
       'peliculasActor',
       'peliculas'
    );
  }

  Widget _mostrarSeries(BuildContext context, Actor actor) {
    return Container(
      child: _seriesActor(context, actor)
    );
  }

  Widget _seriesActor(BuildContext context, Actor actor) {
    return genericHorizontalWidget(
      context, 
      'Series',
       seriesProvider.seriesActorStream, 
       seriesProvider.getSeriesActor,
       'seriesActor',
       'series'
    );
  }

}