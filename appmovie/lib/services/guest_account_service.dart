import '../services/api_client.dart';

class GuestAccountService {
  final ApiClient _apiClient = ApiClient();

  Future<void> addFavorite(String sessionId, int movieId, bool favorite) async {
    // Ajouter les paramètres de requête à l'URL
    final url = '/account/guest_account_id/favorite?guest_session_id=$sessionId';

    await _apiClient.postRequest(
      url,
      {
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': favorite,
      },
    );
  }

  Future<void> addToWatchlist(String sessionId, int movieId, bool watchlist) async {
    final url = '/account/guest_account_id/watchlist?guest_session_id=$sessionId';

    await _apiClient.postRequest(
      url,
      {
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': watchlist,
      },
    );
  }
}
