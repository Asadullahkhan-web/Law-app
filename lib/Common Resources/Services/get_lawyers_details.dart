import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getLawyerDetails(String lawyerId) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(lawyerId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return [data];
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching lawyer details: $e');
    rethrow;
  }
}
