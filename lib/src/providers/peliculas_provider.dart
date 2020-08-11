import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {

  String _apiKey   = 'a6c660c309daa96a66064788072ed995';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  int _topRatedPage = 0;

  bool _cargandoPopulares = false;
  bool _cargandoTopRated = false;

  List<Pelicula> _populares = new List();
  List<Pelicula> _topRated = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  final _topRatedStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  Function(List<Pelicula>) get topRatedSink => _topRatedStreamController.sink.add;
  Stream<List<Pelicula>> get topRatedStream => _topRatedStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
    _topRatedStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language': _language
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apiKey,
      'language': _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if (_cargandoPopulares) return [];

    _cargandoPopulares = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);

    popularesSink(_populares);

    _cargandoPopulares = false;
    return resp;

  }

  Future<List<Pelicula>> getTopRated() async {

    if (_cargandoTopRated) return [];

    _cargandoTopRated = true;

    _topRatedPage++;

    final url = Uri.https(_url, '3/movie/top_rated', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _topRatedPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _topRated.addAll(resp);

    topRatedSink(_topRated);

    _cargandoTopRated = false;
    return resp;

  }
  
}