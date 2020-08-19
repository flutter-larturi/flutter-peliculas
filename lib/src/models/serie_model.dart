import 'package:peliculas/src/config/config.dart';

class Series {
  List<Serie> items = new List();

  Series();

  Series.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return; 

    bool esTvShow;

    for (var item in jsonList) {
      final serie = new Serie.fromJsonMap(item);
      esTvShow = false;

      // Generos de TV a eliminar
      // https://developers.themoviedb.org/3/genres/get-tv-list

      if (serie.genres.length == 0) {
        esTvShow = true;
      }

      for (var i = 0; i < serie.genres.length; i++) {
        if (serie.genres[i] == 10763 || 
            serie.genres[i] == 10764 ||
            serie.genres[i] == 30769 ||
            serie.genres[i] == 10767
            ) {
              esTvShow = true;
        } 
      }

      if (!esTvShow) {
        items.add(serie);
      }

    }

  }

}

class Serie {
  
  String uniqueId;

  String backdropPath;
  String firstAirDate;
  List<dynamic> genres;
  String homepage;
  int id;
  bool inProduction;
  dynamic lastAirDate;
  dynamic lastEpisodeToAir;
  String name;
  double numberOfEpisodes;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  List<Season> seasons;
  String status;
  String type;
  double voteAverage;
  double voteCount;

  Serie({
        this.backdropPath,
        this.firstAirDate,
        this.genres,
        this.homepage,
        this.id,
        this.inProduction,
        this.lastAirDate,
        this.lastEpisodeToAir,
        this.name,
        this.numberOfEpisodes,
        this.originalLanguage,
        this.originalName,
        this.overview,
        this.popularity,
        this.posterPath,
        this.seasons,
        this.status,
        this.type,
        this.voteAverage,
        this.voteCount,
    });


  Serie.fromJsonMap(Map<String, dynamic> json) {
    backdropPath          = json['backdrop_path'];
    firstAirDate          = json['first_air_date'];
    genres                = json['genre_ids'];
    homepage              = json['homepage'];
    id                    = json['id'];
    inProduction          = json['in_production'];
    lastAirDate           = json['last_air_date'];
    lastEpisodeToAir      = json['last_episode_to_air'];
    name                  = json['name'];
    numberOfEpisodes      = json['episode_count'] / 1;
    originalLanguage      = json['original_language'];
    originalName          = json['original_name'];
    overview              = json['overview'];
    popularity            = json['popularity'] / 1;
    posterPath            = json['poster_path'];
    seasons               = json['seasons'];
    status                = json['status'];
    type                  = json['type'];
    voteAverage           = json['vote_average'] / 1;
    voteCount             = json['vote_count'] / 1;
    
  }

  getPosterImg() {
    if (posterPath == null || posterPath == 'null') {
        return ConfigApp().noImagePictureUrl;
    } else {
        return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg() {
    if (posterPath == null || posterPath == 'null') {
      return ConfigApp().noImagePictureUrl;
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

}

class Season {
    String airDate;
    int episodeCount;
    int id;
    String name;
    String overview;
    dynamic posterPath;
    int seasonNumber;

    Season({
        this.airDate,
        this.episodeCount,
        this.id,
        this.name,
        this.overview,
        this.posterPath,
        this.seasonNumber,
    });
}