import 'dart:async'; // Untuk Timer (Debounce)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Fungsi ini mencegah request API setiap kali huruf diketik (Tunggu 500ms berhenti ngetik)
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MovieProvider>().searchMovies(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Cari judul film...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.searchResults.isEmpty && _searchController.text.isNotEmpty) {
            return const Center(child: Text("Film tidak ditemukan."));
          }
          
          if (_searchController.text.isEmpty) {
             return const Center(child: Text("Ketik judul film untuk mencari"));
          }

          // Menampilkan hasil pencarian dalam bentuk Grid 2 kolom
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom
              childAspectRatio: 0.5, // Rasio lebar:tinggi kartu
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];
              return MovieCard(movie: movie, isHorizontal: false); // Tampilan vertikal
            },
          );
        },
      ),
    );
  }
}