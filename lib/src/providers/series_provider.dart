
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/config/config.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/serie_model.dart';

class SeriesProvider {

  String _apiKey   = ConfigApp().apiKey;
  String _url      = ConfigApp().url;
  String _language = ConfigApp().language;

  // Series del Actor
  int _seriesActorPage = 0;
  bool _cargandoSeriesActor = false;
  List<Serie> _seriesActor = new List();
  final _seriesActorStreamController = StreamController<List<Serie>>.broadcast();
  Function(List<Serie>) get seriesActorSink => _seriesActorStreamController.sink.add;
  Stream<List<Serie>> get seriesActorStream => _seriesActorStreamController.stream;

  void disposeStreams() {
    _seriesActorStreamController?.close();
  }

  Future<List<Serie>> _procesarRespuestaSeriesActor(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final series = new Series.fromJsonList(decodeData['cast']);
    return series.items;
  }

// ==============================================================
// Get Series del actor
// ==============================================================

Future<List<Serie>> getSeriesActor(Actor actor) async {

    if (_cargandoSeriesActor) return [];

    _cargandoSeriesActor = true;

    _seriesActorPage++;

    final url = Uri.https(_url, '3/person/${actor.id}/tv_credits', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _seriesActorPage.toString(),
    });

    final resp = await _procesarRespuestaSeriesActor(url);

    _seriesActor.addAll(resp);

    seriesActorSink(_seriesActor);

    _cargandoSeriesActor = false;
    return resp;

  }


}