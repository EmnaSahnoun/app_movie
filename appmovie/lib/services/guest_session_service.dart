import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class GuestSessionService {
  final ApiClient _apiClient = ApiClient();
  final String _sessionKey = "guest_session_id";

  Future<String?> getStoredSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  Future<void> storeSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, sessionId);
  }

  Future<String> createGuestSession() async {
    final response = await _apiClient.getRequest('/authentication/guest_session/new');
    if (response['success'] == true) {
      final sessionId = response['guest_session_id'];
      await storeSession(sessionId); // Sauvegarder la session localement
      return sessionId;
    } else {
      throw Exception('Failed to create guest session.');
    }
  }

  /// Initialise la session (vérifie ou crée si nécessaire)
  Future<String> initializeSession() async {
    final existingSession = await getStoredSession();
    if (existingSession != null) {
      return existingSession;
    } else {
      return await createGuestSession();
    }
  }
}
