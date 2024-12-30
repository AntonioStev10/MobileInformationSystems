import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://official-joke-api.appspot.com';

  /// Fetch all available joke types from the API.
  Future<List<String>> fetchJokeTypes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/types'));
      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body));
      } else {
        throw HttpException(
          'Failed to load joke types. Status Code: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Error fetching joke types: $error');
    }
  }

  /// Fetch jokes of a specific type. Returns a list of jokes.
  Future<List<dynamic>> fetchJokesByType(String type) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Failed to load jokes for type "$type". Status Code: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Error fetching jokes for type "$type": $error');
    }
  }

  /// Fetch a random joke from the API.
  Future<Map<String, dynamic>> fetchRandomJoke() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random_joke'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Failed to load random joke. Status Code: ${response.statusCode}',
        );
      }
    } catch (error) {
      throw Exception('Error fetching random joke: $error');
    }
  }
}

/// Custom exception for HTTP errors.
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => 'HttpException: $message';
}
