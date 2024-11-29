import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiClient {
  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint?api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<void> deleteRequest(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint?api_key=$apiKey'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }
}
