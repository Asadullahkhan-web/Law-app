import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyers_application/Admin%20Section/Verification%20Screen/verification_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class AdminVerificationScreen extends StatelessWidget {
  const AdminVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Verifications',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lawyers_verification')
            .where('isVerified', isEqualTo: "") // Check for empty string
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No verification requests found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var request = snapshot.data!.docs[index];
              var data = request.data() as Map<String, dynamic>?;

              if (data == null || data.isEmpty) {
                return const SizedBox(); // Skip empty data
              }

              var requestSenderUid = data['requestSenderUid'];
              if (requestSenderUid == null || requestSenderUid.isEmpty) {
                return const SizedBox(); // Skip empty requestSenderUid
              }

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(requestSenderUid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasError ||
                      userSnapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 30,
                        ),
                        title: Container(
                          color: Colors.white,
                          height: 20,
                        ),
                        subtitle: Container(
                          color: Colors.white,
                          height: 16,
                        ),
                        trailing: Container(
                          color: Colors.white,
                          height: 20,
                          width: 60,
                        ),
                      ),
                    );
                  }

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  if (userData == null || userData.isEmpty) {
                    return const SizedBox(); // Skip empty userData
                  }

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VerificationDetailsScreen(
                              userDataK: userData,
                              data: data,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundImage:
                            NetworkImage(userData['imageUrl'] ?? ''),
                      ),
                      title: Text('${userData['name'] ?? 'Unknown'}'),
                      subtitle: Text('${userData['email'] ?? 'No Email'}'),
                      trailing: Text(
                        '${data['sentDateTime'] ?? ''}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
