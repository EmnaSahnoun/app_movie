import '../services/api_client.dart';

class AccountService {
  final ApiClient _apiClient = ApiClient();

  Future<void> addFavorite(int accountId, int movieId, bool favorite) async {
    await _apiClient.postRequest(
      '/account/$accountId/favorite',
      {
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': favorite,
      },
    );
  }

  Future<void> addToWatchlist(int accountId, int movieId, bool watchlist) async {
    await _apiClient.postRequest(
      '/account/$accountId/watchlist',
      {
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': watchlist,
      },
    );
  }
}
