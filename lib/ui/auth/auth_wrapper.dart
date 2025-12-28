import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// import '../home/home_page.dart';
import '../main_page.dart';
import 'login_page.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan user di AuthProvider
    final authProvider = context.watch<AuthProvider>();

    // Jika user sudah login, arahkan ke Home
    if (authProvider.user != null) {
      return const MainPage();
    } 
    
    // Jika belum login, arahkan ke Login Page
    return const LoginPage();
  }
}