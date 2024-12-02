import '../models/tv_series_preview.dart';
import '../models/tv_series_details.dart';
import '../services/api_client.dart';
import '../models/actor.dart';

class SeriesService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches a list of series previews based on the type (e.g., "popular", "now_playing").
  Future<List<SeriesPreview>> fetchSeries(String type) async {
    final endpoint = '/tv/$type'; // Example: popular, now_playing
    final data = await _apiClient.getRequest(endpoint);

    return (data['results'] as List)
        .map((series) => SeriesPreview.fromJson(series))
        .toList();
  }

  /// Fetches detailed information about a specific series by its ID.
  Future<TvSeriesDetails> fetchSeriesDetails(int id) async {
    final endpoint = '/tv/$id';
    final data = await _apiClient.getRequest(endpoint);

    return TvSeriesDetails.fromJson(data);
  }

  /// Fetches the list of actors for a specific TV series.
  Future<List<Actor>> fetchSeriesActors(int seriesId) async {
    final endpoint = '/tv/$seriesId/credits';
    try {
      final data = await _apiClient.getRequest(endpoint);

      // Extract and map the cast list
      final cast = data['cast'] as List;
      return cast.map((actor) => Actor.fromJson(actor)).toList();
    } catch (e) {
      throw Exception('Failed to load series actors: $e');
    }
  }
}
