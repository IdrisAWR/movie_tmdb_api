import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/tmdb_service.dart';

class MovieProvider with ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();

  // List untuk menampung data film
  List<Movie> _popularMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _searchResults = [];

  // Status loading
  bool _isLoading = false;

  // Getters (untuk diakses oleh UI)
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Fungsi untuk memuat data Home Page sekaligus
  Future<void> fetchHomeMovies() async {
    _isLoading = true;
    notifyListeners(); // Beritahu UI bahwa sedang loading

    try {
      // Menggunakan Future.wait agar request berjalan paralel (lebih cepat)
      final results = await Future.wait([
        _tmdbService.getPopularMovies(),
        _tmdbService.getTrendingMovies(),
        _tmdbService.getNowPlayingMovies(),
      ]);

      _popularMovies = results[0];
      _trendingMovies = results[1];
      _nowPlayingMovies = results[2];

    } catch (e) {
      print("Error fetching movies: $e");
      // Di real app, kita bisa set variabel error message disini
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI bahwa data sudah siap
    }
  }

  // Fungsi Search
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _tmdbService.searchMovies(query);
    } catch (e) {
      print("Error searching: $e");
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}