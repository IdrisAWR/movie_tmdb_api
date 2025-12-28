import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/movie_provider.dart';
import '../../models/movie_model.dart';
import '../search/search_page.dart';
import '../widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman pertama kali dibuka
    // listen: false karena kita hanya memanggil fungsi, bukan mendengarkan perubahan UI disini
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchHomeMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie App"),
        actions: [
          // Tombol Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const SearchPage())
              );
            },
          ),
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          )
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika data kosong (bisa jadi error koneksi)
          if (provider.popularMovies.isEmpty) {
            return const Center(child: Text("Gagal memuat data / Tidak ada koneksi"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Now Playing
                _buildSectionTitle("Sedang Tayang"),
                _buildHorizontalList(provider.nowPlayingMovies),

                // 2. Trending
                _buildSectionTitle("Trending Minggu Ini"),
                _buildHorizontalList(provider.trendingMovies),

                // 3. Popular
                _buildSectionTitle("Populer"),
                _buildHorizontalList(provider.popularMovies),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget Helper untuk Judul Bagian
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget Helper untuk List Horizontal
  Widget _buildHorizontalList(List<Movie> movies) {
    return SizedBox(
      height: 280, // Tinggi area list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(movie: movie, isHorizontal: true);
        },
      ),
    );
  }
}