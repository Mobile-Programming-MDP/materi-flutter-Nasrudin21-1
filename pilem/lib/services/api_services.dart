import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.themoviedb.org/3";
  //apikey
  static const String apiKey = "b0c0508e51cd1e3e708b17fd117ce865";
  //1.Mengambil list movie yang saat ini tayang
  Future <List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/now_playing?api_key=$apiKey"),
    );
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  //2.Mengambil list movie yang sedang trending minggu ini
    Future <List<Map<String, dynamic>>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trending/movie/week?api_key=$apiKey"),
    );
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  //3. mengambil list movie yang populer
    Future <List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/popular?api_key=$apiKey"),
    );
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  //4. mengambil list movie melalui pencarian
    Future <List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search/movie?query=$query&api_key=$apiKey"),
    );
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
    }
}