import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/lawyer_each_chat_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/new_chat_request_screen.dart';
import 'package:shimmer/shimmer.dart';

class LawyerChatScreen extends StatefulWidget {
  const LawyerChatScreen({super.key});

  @override
  State<LawyerChatScreen> createState() => _LawyerChatScreenState();
}

class _LawyerChatScreenState extends State<LawyerChatScreen> {
  var currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  int pendingRequestsCount = 0;

  Future<int> getPendingRequestsCount(String lawyerId) async {
    try {
      // Get the query snapshot
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('chat_requests')
              .where('lawyer_id', isEqualTo: lawyerId)
              .where('status', isEqualTo: 'pending')
              .get();

      // Return the count of documents
      return querySnapshot.size;
    } catch (e) {
      // Handle errors
      print('Error getting pending requests count: $e');
      return -1; // Return -1 to indicate an error
    }
  }

  Future<void> fetchPendingRequestsCount() async {
    try {
      String lawyerId = FirebaseAuth
          .instance.currentUser!.uid; // Replace with the lawyer's ID
      int count = await getPendingRequestsCount(lawyerId);
      setState(() {
        pendingRequestsCount = count;
      });
    } catch (e) {
      print('Error initializing pending requests count: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPendingRequestsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inbox',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NewChatRequestScreen(),
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notification_add,
                  size: 30,
                ),
                if (pendingRequestsCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        pendingRequestsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 2,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_requests')
            .where('lawyer_id', isEqualTo: currentUserUid)
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final acceptedRequests = snapshot.data?.docs;
          if (acceptedRequests == null || acceptedRequests.isEmpty) {
            return const Center(
              child: Text('No accepted requests found.'),
            );
          }
          return ListView.builder(
            itemCount: acceptedRequests.length,
            itemBuilder: (context, index) {
              final request = acceptedRequests[index];
              final userId = request['user_id'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      // Placeholder UI for loading state
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(''),
                      ),
                      title: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                          width: 150,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final userData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    return const Center(
                      child: Text('No lawyer details available.'),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LawyerEachChatScreen(
                            otherUserUid: userId,
                            otherUserPersonalData: userData,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.green.shade200, width: 2),
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(userData['name']),
                            ),
                          ),
                          title: Text(userData['name'] as String),
                          subtitle: Text(userData['email'] as String),
                          trailing: const Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              // Text(
                              //   '${request['timestamp']}',
                              //   style: const TextStyle(fontSize: 10),
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              // Conditionally display the new chat icon
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.brown.shade50,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
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
