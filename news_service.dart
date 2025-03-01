import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String apiKey = "";
  final String baseUrl = "https://newsapi.org/v2";

  Future<List<Article>> fetchNewsByCategory(String category) async {
    final url = Uri.parse("https://newsapi.org/v2/top-headlines?category=$category&country=us&apiKey=apiKey");

    try {
      final response = await http.get(url);
      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['articles'] as List).map((article) => Article.fromJson(article)).toList();
      } else {
        throw Exception("Failed to load news: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<Article>> searchNews(String query) async {
    final url = Uri.parse("$baseUrl/everything?q=$query&apiKey=$apiKey");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List).map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception("Failed to search news");
    }
  }
}
