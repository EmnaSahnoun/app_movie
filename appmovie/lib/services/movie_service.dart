import 'dart:convert';
import 'package:appmovie/models/movie_preview.dart';
import 'package:appmovie/models/movie_details.dart';
import '../services/api_client.dart';
import '../models/actor.dart';

class MovieService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches a list of movies or TV series previews based on the type ('movies' or 'series').
  Future<List<MoviePreview>> fetchMovies(String type) async {
    String endpoint;

    // Determine the appropriate endpoint based on the 'type' argument
    if (type == 'movies') {
      endpoint = '/movie/popular'; // Popular movies endpoint
    } else if (type == 'series') {
      endpoint = '/tv/popular'; // Popular TV series endpoint
    } else {
      throw Exception('Invalid type: $type');
    }

    // Fetch data from API and map the response to MoviePreview objects
    final data = await _apiClient.getRequest(endpoint);
    return (data['results'] as List)
        .map((movie) => MoviePreview.fromJson(movie))
        .toList();
  }

  /// Fetches detailed information about a specific movie or TV series by its ID.
  Future<MovieDetails> fetchMovieDetails(int id, {bool isTv = false}) async {
    final endpoint = isTv ? '/tv/$id' : '/movie/$id';
    final data = await _apiClient.getRequest(endpoint);
    return MovieDetails.fromJson(data);
  }

  /// Adds a rating to a movie or TV series.
  Future<void> addRating(int movieId, double rating, {bool isTv = false}) async {
    final endpoint = isTv ? '/tv/$movieId/rating' : '/movie/$movieId/rating';
    await _apiClient.postRequest(endpoint, {'value': rating});
  }

  /// Deletes a rating for a movie or TV series.
  Future<void> deleteRating(int movieId, {bool isTv = false}) async {
    final endpoint = isTv ? '/tv/$movieId/rating' : '/movie/$movieId/rating';
    await _apiClient.deleteRequest(endpoint);
  }

  /// Fetches the list of actors for a specific movie or TV series.
  Future<List<Actor>> fetchMovieActors(int movieId, {bool isTv = false}) async {
    final endpoint = isTv 
        ? '/tv/$movieId/credits' 
        : '/movie/$movieId/credits';
    
    // Fetch data from API and map the response to Actor objects
    try {
      final data = await _apiClient.getRequest(endpoint);
      final cast = data['cast'] as List;
      return cast.map((actor) => Actor.fromJson(actor)).toList();
    } catch (e) {
      throw Exception('Failed to load movie actors: $e');
    }
  }
}
