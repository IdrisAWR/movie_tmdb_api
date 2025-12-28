import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- FITUR FAVORITE ---

  // Menambah atau Menghapus Favorite (Toggle)
  Future<void> toggleFavorite(String uid, Movie movie, bool isCurrentlyFavorite) async {
    final docRef = _db.collection('favorites').doc(uid).collection('user_favorites').doc(movie.id.toString());

    if (isCurrentlyFavorite) {
      // Jika sudah favorit, hapus
      await docRef.delete();
    } else {
      // Jika belum, simpan data filmnya
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'poster_path': movie.posterPath,
        'vote_average': movie.voteAverage,
        'added_at': FieldValue.serverTimestamp(),
      });
    }
  }

  // Cek apakah film ini ada di favorite user?
  Future<bool> isFavorite(String uid, int movieId) async {
    final doc = await _db.collection('favorites').doc(uid).collection('user_favorites').doc(movieId.toString()).get();
    return doc.exists;
  }

  // --- FITUR WATCHLIST ---

  Future<void> toggleWatchlist(String uid, Movie movie, bool isCurrentlyInWatchlist) async {
    final docRef = _db.collection('watchlist').doc(uid).collection('user_watchlist').doc(movie.id.toString());

    if (isCurrentlyInWatchlist) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'poster_path': movie.posterPath,
        'vote_average': movie.voteAverage,
        'status': 'planned', // default status
        'added_at': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isInWatchlist(String uid, int movieId) async {
    final doc = await _db.collection('watchlist').doc(uid).collection('user_watchlist').doc(movieId.toString()).get();
    return doc.exists;
  }

  // --- AMBIL DATA (STREAM) ---
  
  // Ambil daftar Favorite secara Realtime
  Stream<QuerySnapshot> getFavorites(String uid) {
    return _db
        .collection('favorites')
        .doc(uid)
        .collection('user_favorites')
        .orderBy('added_at', descending: true)
        .snapshots();
  }

  // Ambil daftar Watchlist secara Realtime
  Stream<QuerySnapshot> getWatchlist(String uid) {
    return _db
        .collection('watchlist')
        .doc(uid)
        .collection('user_watchlist')
        .orderBy('added_at', descending: true)
        .snapshots();
  }
}