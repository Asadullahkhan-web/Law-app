import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRole {
  static Future<String?> getCurrentUserRole() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        // Check if the role field exists and is not null
        if (snapshot.data() != null && snapshot.data()!.containsKey('role')) {
          return snapshot.data()!['role'];
        } else {
          // Handle case where role field is missing or null
          return null;
        }
      } else {
        // Handle case where user document doesn't exist
        return null;
      }
    } catch (error) {
      // Handle any errors that might occur during the process
      // Add this line
      return null;
    }
  }
}
