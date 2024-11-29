import 'package:appmovie/models/movie_preview.dart';
import 'package:appmovie/models/movie_details.dart';
import '../services/api_client.dart';

class MovieService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MoviePreview>> fetchMovies(String type) async {
    final data = await _apiClient.getRequest('/movie/$type');
    return (data['results'] as List)
        .map((movie) => MoviePreview.fromJson(movie))
        .toList();
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final data = await _apiClient.getRequest('/movie/$id');
    return MovieDetails.fromJson(data);
  }

  Future<void> addRating(int movieId, double rating) async {
    await _apiClient.postRequest('/movie/$movieId/rating', {'value': rating});
  }

  Future<void> deleteRating(int movieId) async {
    await _apiClient.deleteRequest('/movie/$movieId/rating');
  }
}
