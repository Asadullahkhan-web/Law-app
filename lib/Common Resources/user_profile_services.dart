import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// With the help of this call we fetch data from firebase collection users.
// on the base of current user

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getCurrentUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data() ?? {}; // Return user data if document exists
      } else {
        throw Exception(
            'User data not found'); // Throw an exception if document doesn't exist
      }
    } else {
      throw Exception(
          'User not logged in'); // Throw an exception if user is not logged in
    }
  }
}
