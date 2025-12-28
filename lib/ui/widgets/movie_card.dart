import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/movie_model.dart';
import '../../utils/constants.dart';
import '../detail/detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isHorizontal; // Mode tampilan: Horizontal (Home) atau Vertikal (Search)

  const MovieCard({
    super.key,
    required this.movie,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(movie: movie)),
        );
      },
      child: Container(
        // Hapus margin vertical agar pas di Grid, gunakan padding GridView saja
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0), 
        width: isHorizontal ? 140 : double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12, // Tambah background sedikit agar terlihat kotaknya
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN GAMBAR
            // Gunakan Expanded agar gambar mengisi sisa ruang yang ada
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: movie.posterPath.isEmpty
                    ? Container(
                        color: Colors.grey,
                        child: const Center(child: Icon(Icons.movie, size: 50)),
                      )
                    : CachedNetworkImage(
                        imageUrl: '${Constants.imageBaseUrl}${movie.posterPath}',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
              ),
            ),
            
            // BAGIAN TEKS (Judul & Rating)
            Padding(
              padding: const EdgeInsets.all(8.0), // Beri jarak dalam
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1, // Pastikan cuma 1 baris
                    overflow: TextOverflow.ellipsis, // Titik-titik jika kepanjangan
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}