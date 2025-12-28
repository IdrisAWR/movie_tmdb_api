import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/movie_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../detail/detail_page.dart';

class SavedMoviesPage extends StatelessWidget {
  final String title;
  final bool isWatchlist; // False = Favorite, True = Watchlist

  const SavedMoviesPage({super.key, required this.title, required this.isWatchlist});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().user?.uid;
    final firestoreService = FirestoreService();

    if (uid == null) return const Center(child: Text("Silakan login"));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        // Pilih stream berdasarkan tipe halaman
        stream: isWatchlist 
            ? firestoreService.getWatchlist(uid) 
            : firestoreService.getFavorites(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie_filter, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text("Belum ada film di $title"),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              
              // Konversi data Firestore kembali ke object Movie sederhana
              // (Kita hanya simpan data penting saja)
              final movie = Movie(
                id: data['id'],
                title: data['title'],
                overview: "Lihat detail untuk info lengkap...", // Data overview tidak kita simpan di lite version
                posterPath: data['poster_path'] ?? '',
                backdropPath: '', // Tidak disimpan
                voteAverage: (data['vote_average'] as num?)?.toDouble() ?? 0.0,
                releaseDate: '',
              );

              return ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: '${Constants.imageBaseUrl}${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (_,__) => Container(color: Colors.grey),
                    errorWidget: (_,__,___) => const Icon(Icons.error),
                  ),
                ),
                title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Rating: ${movie.voteAverage}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Kita perlu fetch detail lengkap dari API lagi agar data overview/trailer ada
                  // Tapi untuk simplifikasi, kita oper object movie yang ada dulu.
                  // (Di aplikasi real, biasanya kita panggil API detail by ID disini)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(movie: movie)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}