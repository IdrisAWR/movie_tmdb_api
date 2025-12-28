import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/movie_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';

class DetailPage extends StatefulWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  
  bool _isFavorite = false;
  bool _isInWatchlist = false;
  bool _isLoading = true; // Loading status tombol

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  // Cek status Favorite & Watchlist saat halaman dibuka
  Future<void> _checkStatus() async {
    final uid = context.read<AuthProvider>().user?.uid;
    
    // Jika user tidak login, matikan loading agar tombol muncul (tapi nanti fungsinya akan gagal/minta login)
    if (uid == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final favStatus = await _firestoreService.isFavorite(uid, widget.movie.id);
      final watchStatus = await _firestoreService.isInWatchlist(uid, widget.movie.id);

      if (mounted) {
        setState(() {
          _isFavorite = favStatus;
          _isInWatchlist = watchStatus;
        });
      }
    } catch (e) {
      print("Error checking status: $e");
      // Opsional: Tampilkan pesan error ke user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat status: $e")),
        );
      }
    } finally {
      // APAPUN HASILNYA (Sukses/Gagal), matikan Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // Fungsi saat tombol Favorite ditekan
  Future<void> _toggleFavorite() async {
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) return;

    // Ubah tampilan UI dulu biar responsif (Optimistic UI)
    setState(() => _isFavorite = !_isFavorite);

    try {
      await _firestoreService.toggleFavorite(uid, widget.movie, !_isFavorite); // !_isFavorite karena logic toggle terbalik dengan state baru
    } catch (e) {
      // Jika gagal, kembalikan state
      setState(() => _isFavorite = !_isFavorite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengupdate favorite")));
      }
    }
  }

  // Fungsi saat tombol Watchlist ditekan
  Future<void> _toggleWatchlist() async {
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) return;

    setState(() => _isInWatchlist = !_isInWatchlist);

    try {
      await _firestoreService.toggleWatchlist(uid, widget.movie, !_isInWatchlist);
    } catch (e) {
      setState(() => _isInWatchlist = !_isInWatchlist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar yang bisa memanjang dengan gambar background
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Backdrop (Latar Belakang)
                  widget.movie.backdropPath.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: '${Constants.imageBaseUrl}${widget.movie.backdropPath}',
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[800]),
                  // Efek gradasi hitam di bawah agar tulisan terbaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Konten Detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Rating & Rilis
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.movie.voteAverage.toStringAsFixed(1)} / 10",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Rilis: ${widget.movie.releaseDate}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi (Favorite & Watchlist)
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _toggleFavorite,
                            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                            label: Text(_isFavorite ? "Favorit" : "Tambah Favorit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFavorite ? Colors.pink : Colors.grey[800],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _toggleWatchlist,
                            icon: Icon(_isInWatchlist ? Icons.bookmark : Icons.bookmark_border),
                            label: Text(_isInWatchlist ? "Disimpan" : "Watchlist"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isInWatchlist ? Colors.blue : Colors.grey[800],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Sinopsis
                  const Text(
                    "Sinopsis",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}