import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              user?.email ?? "Tamu",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("UID: ${user?.uid ?? '-'}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Keluar Akun"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}