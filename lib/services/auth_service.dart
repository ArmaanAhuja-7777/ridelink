import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Save user info to SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', user.displayName ?? 'No Name');
        await prefs.setString('email', user.email ?? 'No Email');
        if (user.photoURL != null) {
          await prefs.setString('photoURL', user.photoURL!);
        }
      }

      return userCredential;
    } catch (e) {
      // TODO: Handle exceptions properly in the UI
      print(e);
      return null;
    }
  }


  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      print("Error disconnecting from Google: $e");
    }
    await _googleSignIn.signOut();
    await _auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
