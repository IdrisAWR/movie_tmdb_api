import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../utils/constants.dart';

class TmdbService {
  // Fungsi Helper untuk melakukan request GET
  Future<List<Movie>> _getMovies(String endpoint) async {
    final url = Uri.parse('${Constants.baseUrl}$endpoint?api_key=${Constants.tmdbApiKey}&language=en-US&page=1');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // TMDb mengembalikan data film dalam field "results" yang berupa Array
        final List<dynamic> results = data['results'];
        
        // Konversi setiap JSON object menjadi Movie object
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to TMDb: $e');
    }
  }

  // 1. Ambil Film Populer
  Future<List<Movie>> getPopularMovies() async {
    return _getMovies('/movie/popular');
  }

  // 2. Ambil Film Trending (Mingguan)
  Future<List<Movie>> getTrendingMovies() async {
    return _getMovies('/trending/movie/week');
  }

  // 3. Ambil Film Sedang Tayang (Now Playing)
  Future<List<Movie>> getNowPlayingMovies() async {
    return _getMovies('/movie/now_playing');
  }

  // 4. Cari Film berdasarkan keyword
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('${Constants.baseUrl}/search/movie?api_key=${Constants.tmdbApiKey}&query=$query&language=en-US&page=1');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }
}