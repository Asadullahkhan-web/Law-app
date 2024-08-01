// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lawyers_application/Client%20Section/Client%20Chat%20Screen/each_chat_screen.dart';
// import 'package:shimmer/shimmer.dart';

// class ClientChatScreen extends StatefulWidget {
//   const ClientChatScreen({super.key});

//   @override
//   State<ClientChatScreen> createState() => _ClientChatScreenState();
// }

// class _ClientChatScreenState extends State<ClientChatScreen> {
//   var currentUserUid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Inbox',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('chat_requests')
//             .where('user_id', isEqualTo: currentUserUid)
//             .where('status', isEqualTo: 'accepted')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.green,
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           final acceptedRequests = snapshot.data?.docs;
//           if (acceptedRequests == null || acceptedRequests.isEmpty) {
//             return const Center(
//               child: Text('No accepted requests found.'),
//             );
//           }
//           return ListView.builder(
//             itemCount: acceptedRequests.length,
//             itemBuilder: (context, index) {
//               final request = acceptedRequests[index];
//               final lawyerId = request['lawyer_id'];

//               // Fetch additional details of the lawyer using lawyerId
//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(lawyerId)
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // While data is loading, show a loading indicator

// // Inside your widget build method or wherever you want to display the placeholder
//                     return ListTile(
//                       leading: const CircleAvatar(
//                         backgroundImage: NetworkImage(''),
//                       ),
//                       title: Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           height: 16,
//                           width: 100,
//                           color: Colors.white,
//                         ),
//                       ),
//                       subtitle: Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           height: 16,
//                           width: 150,
//                           color: Colors.white,
//                         ),
//                       ),
//                       // You can add more UI elements here if needed
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     // If an error occurs, display an error message
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   }
//                   final lawyerData =
//                       snapshot.data?.data() as Map<String, dynamic>?;
//                   if (lawyerData == null) {
//                     // If no data is available, display a message indicating it
//                     return const Center(
//                       child: Text('No lawyer details available.'),
//                     );
//                   }
//                   // If data is available, display it in the UI
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => EachChatScreen(
//                             otherUserUid: lawyerId,
//                             otherUserPersonalDetails: lawyerData,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.green.shade200, width: 2),
//                                 borderRadius: BorderRadius.circular(25)),
//                             child: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                 lawyerData['imageUrl'] ?? 'No Image',
//                               ),
//                             ),
//                           ),
//                           title: Text(lawyerData['name'] as String),
//                           subtitle: Text(lawyerData['email'] as String),
//                           // You can add more UI elements here if needed
//                         ),
//                         Divider(
//                           color: Colors.grey.shade50,
//                           indent: 0,
//                           endIndent: 0,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Client%20Section/Client%20Chat%20Screen/each_chat_screen.dart';
import 'package:shimmer/shimmer.dart';

class ClientChatScreen extends StatefulWidget {
  const ClientChatScreen({super.key});

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inbox',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_requests')
            .where('user_id', isEqualTo: currentUserUid)
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
              final lawyerId = request['lawyer_id'];

              // Fetch additional details of the lawyer using lawyerId
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(lawyerId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is loading, show a loading indicator
                    return ListTile(
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
                      // You can add more UI elements here if needed
                    );
                  }
                  if (snapshot.hasError) {
                    // If an error occurs, display an error message
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final lawyerData =
                      snapshot.data?.data() as Map<String, dynamic>?;
                  if (lawyerData == null) {
                    // If no data is available or the document is deleted,
                    // return an empty SizedBox to skip rendering this user's details
                    return const SizedBox.shrink();
                  }
                  // If data is available, display it in the UI
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EachChatScreen(
                            otherUserUid: lawyerId,
                            otherUserPersonalDetails: lawyerData,
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
                                borderRadius: BorderRadius.circular(25)),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                lawyerData['imageUrl'] ?? 'No Image',
                              ),
                            ),
                          ),
                          title: Text(lawyerData['name'] as String),
                          subtitle: Text(lawyerData['email'] as String),
                          // You can add more UI elements here if needed
                        ),
                        Divider(
                          color: Colors.grey.shade50,
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
