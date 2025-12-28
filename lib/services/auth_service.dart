import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk memantau status login user secara real-time
  Stream<User?> get user => _auth.authStateChanges();

  // Sign In (Login)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Lempar error agar bisa ditangkap di UI (misal: password salah)
      throw Exception(e.message);
    }
  }

  // Sign Up (Register)
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign Out (Logout)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}