import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_track/product/model/recipe.dart';

class FireBaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Some error occured');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Some error occured');
    }
    return null;
  }

  /// Signs out the currently signed-in user.
  ///
  /// Returns true if the sign-out is successful, otherwise returns false.
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Sign out failed: $e');
      return false;
    }
  }

  Future<User?> signUpWithEmailAndPasswordAndAddToFirestore(
    String email,
    String password,
    String username,
  ) async {
    try {
      // Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user from credential
      User? user = credential.user;

      if (user != null) {
        // Add user details to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'profilePictureUrl':
              'https://firebasestorage.googleapis.com/v0/b/foodtrackdbctis470.appspot.com/o/7309681-removebg-preview.png?alt=media&token=5cbec9b9-9b60-4979-b31d-578e1fe1057a',
          'id': user.uid,
        });
      }

      return user;
    } catch (e) {
      // Catch and handle specific FirebaseAuthException
      if (e is FirebaseAuthException) {
        print('Error: ${e.message}');
      } else {
        print('An unknown error occurred: $e');
      }
      return null;
    }
  }

  /// Şu anki kullanıcının bilgilerini Firestore'dan çeker.
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  // Mevcut kullanıcı id'sine göre tarifleri almak için metot
  Future<List<Recipe>> getUserRecipes() async {
    User? user = _auth.currentUser;
    //final userData = await getCurrentUserData();
    var userData = user?.uid;
    final userId = userData;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('recipetutorial')
        .where('userid', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList();
  }

  // Tarif silmek için metot (title kullanarak)
  Future<void> deleteRecipeByTitle(String title) async {
    final snapshot = await _firestore
        .collection('recipetutorial')
        .where('title', isEqualTo: title)
        .get();

    for (var doc in snapshot.docs) {
      await _firestore.collection('recipetutorial').doc(doc.id).delete();
    }
  }
}
