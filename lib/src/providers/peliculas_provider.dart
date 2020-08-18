import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/config/config.dart';

class PeliculasProvider {

  String _apiKey   = ConfigApp().apiKey;
  String _url      = ConfigApp().url;
  String _language = ConfigApp().language;

  // Populares
  int _popularesPage = 0;
  bool _cargandoPopulares = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  // Top Rated
  int _topRatedPage = 0;
  bool _cargandoTopRated = false;
  List<Pelicula> _topRated = new List();
  final _topRatedStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get topRatedSink => _topRatedStreamController.sink.add;
  Stream<List<Pelicula>> get topRatedStream => _topRatedStreamController.stream;

  // Latests
  int _latestPage = 0;
  bool _cargandoLatest = false;
  List<Pelicula> _latest = new List();
  final _latestStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get latestSink => _latestStreamController.sink.add;
  Stream<List<Pelicula>> get latestStream => _latestStreamController.stream;

  // Upcoming
  int _upcomingPage = 0;
  bool _cargandoUpcoming = false;
  List<Pelicula> _upcoming = new List();
  final _upcomingStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get upcomingSink => _upcomingStreamController.sink.add;
  Stream<List<Pelicula>> get upcomingStream => _upcomingStreamController.stream;

  // Español
  int _espanolPage = 0;
  bool _cargandoEspanol = false;
  List<Pelicula> _espanol = new List();
  final _espanolStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get espanolSink => _espanolStreamController.sink.add;
  Stream<List<Pelicula>> get espanolStream => _espanolStreamController.stream;

  // Animadas
  int _animadasPage = 0;
  bool _cargandoAnimadas = false;
  List<Pelicula> _animadas = new List();
  final _animadasStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get animadasSink => _animadasStreamController.sink.add;
  Stream<List<Pelicula>> get animadasStream => _animadasStreamController.stream;
  
  // Peliculas del Actor
  int _peliculasActorPage = 0;
  bool _cargandoPeliculasActor = false;
  List<Pelicula> _peliculasActor = new List();
  final _peliculasActorStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get peliculasActorSink => _peliculasActorStreamController.sink.add;
  Stream<List<Pelicula>> get peliculasActorStream => _peliculasActorStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
    _topRatedStreamController?.close();
    _latestStreamController?.close();
    _upcomingStreamController?.close();
    _espanolStreamController?.close();
    _animadasStreamController?.close();
    _peliculasActorStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> _procesarRespuestaPeliculasActor(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['cast']);
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

// ==============================================================
// Get Peliculas by Category
// ==============================================================

  Future<List<Pelicula>> getPopulares() async {

    if (_cargandoPopulares) return [];

    _cargandoPopulares = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
      'sort_by': 'popularity.desc'
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
      'page': _topRatedPage.toString(),
      'sort_by': 'popularity.desc'
    });

    final resp = await _procesarRespuesta(url);

    _topRated.addAll(resp);

    topRatedSink(_topRated);

    _cargandoTopRated = false;
    return resp;

  }
  
  Future<List<Pelicula>> getLatest() async {

    if (_cargandoLatest) return [];

    _cargandoLatest = true;

    _latestPage++;

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _latestPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _latest.addAll(resp);

    latestSink(_latest);

    _cargandoLatest = false;
    return resp;

  }

  Future<List<Pelicula>> getUpcoming() async {

    if (_cargandoUpcoming) return [];

    _cargandoUpcoming = true;

    _upcomingPage++;

    final url = Uri.https(_url, '3/movie/upcoming', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _upcomingPage.toString(),
      'sort_by': 'vote_average.desc'
    });

    final resp = await _procesarRespuesta(url);

    _upcoming.addAll(resp);

    upcomingSink(_upcoming);

    _cargandoUpcoming = false;
    return resp;

  }

  Future<List<Pelicula>> getEspanol() async {

    if (_cargandoEspanol) return [];

    _cargandoEspanol = true;

    _espanolPage++;

    final url = Uri.https(_url, '3/discover/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'with_original_language': 'es',
      'page': _espanolPage.toString(),
      'sort_by': 'vote_average.desc'
    });

    final resp = await _procesarRespuesta(url);

    _espanol.addAll(resp);

    espanolSink(_espanol);

    _cargandoEspanol = false;
    return resp;

  }

  Future<List<Pelicula>> getAnimadas() async {

    if (_cargandoAnimadas) return [];

    _cargandoAnimadas = true;

    _animadasPage++;

    final url = Uri.https(_url, '3/movie/top_rated', {
      'api_key' : _apiKey,
      'language': _language,
      'with_genres': '16',
      'page': _animadasPage.toString(),
      'sort_by': 'vote_average.desc'
    });

    final resp = await _procesarRespuesta(url);

    _animadas.addAll(resp);

    animadasSink(_animadas);

    _cargandoAnimadas = false;
    return resp;

  }


// ==============================================================
// Get Peliculas del actor
// ==============================================================

Future<List<Pelicula>> getPeliculasActor(Actor actor) async {

    if (_cargandoPeliculasActor) return [];

    _cargandoPeliculasActor = true;

    _peliculasActorPage++;

    final url = Uri.https(_url, '3/person/${actor.id}/movie_credits', {
      'api_key' : _apiKey,
      'language': _language,
      'page': _peliculasActorPage.toString(),
    });

    final resp = await _procesarRespuestaPeliculasActor(url);

    _peliculasActor.addAll(resp);

    peliculasActorSink(_peliculasActor);

    _cargandoPeliculasActor = false;
    return resp;

  }


}