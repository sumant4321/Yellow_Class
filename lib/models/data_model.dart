

import 'package:yellow_class/models/model.dart';

class MovieModel extends Model {
  static String table = 'movies';

  int id;
  String movieName;
  String movieDesc;
  String moviePic;

  MovieModel({
    this.id,
    this.movieName,
    this.movieDesc,
    this.moviePic,
  });

  static MovieModel fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map["id"],
      movieName: map['movieName'].toString(),
      movieDesc: map['movieDesc'],
      moviePic: map['moviePic'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'movieName': movieName,
      'movieDesc': movieDesc,
      'moviePic': moviePic
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}