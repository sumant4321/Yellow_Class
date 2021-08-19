import 'package:yellow_class/models/data_model.dart';
import 'package:yellow_class/utils/db_helper.dart';

class DBService {
  Future<bool> addMovie(MovieModel model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.insert(MovieModel.table, model);
      isSaved = inserted == 1 ? true : false;
    }
    return isSaved;
  }

  Future<bool> updateMovie(MovieModel model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.update(MovieModel.table, model);
      isSaved = inserted == 1 ? true : false;
    }
    return isSaved;
  }

  Future<List<MovieModel>> getMovies() async {
    await DB.init();
    List<Map<String, dynamic>> movies = await DB.query(MovieModel.table);
    return movies.map((item) => MovieModel.fromMap(item)).toList();
  }

  Future<bool> deleteMovie(MovieModel model) async {
    await DB.init();
    bool isDeleted = false;
    if (model != null) {
      int deleted = await DB.delete(MovieModel.table, model);
      isDeleted = deleted == 1 ? true : false;
    }
    return isDeleted;
  }
}
