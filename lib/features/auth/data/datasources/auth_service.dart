import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> register({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return auth.signOut();
  }

  Future<void> forgotPassword(String email) {
    return auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return auth.signInWithCredential(credential);
  }
}