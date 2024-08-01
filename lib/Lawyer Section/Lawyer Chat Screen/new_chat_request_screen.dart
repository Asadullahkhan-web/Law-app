// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NewChatRequestScreen extends StatefulWidget {
//   const NewChatRequestScreen({super.key});

//   @override
//   State<NewChatRequestScreen> createState() => _NewChatRequestScreenState();
// }

// class _NewChatRequestScreenState extends State<NewChatRequestScreen> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Stream<QuerySnapshot> getConnectionRequestsStream() {
//     String lawyerId = FirebaseAuth.instance.currentUser!.uid;

//     return FirebaseFirestore.instance
//         .collection('chat_requests')
//         .where('lawyer_id', isEqualTo: lawyerId)
//         .where('status', isEqualTo: 'pending')
//         .snapshots();
//   }

//   Future<void> acceptRequest(String requestId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('chat_requests')
//           .doc(requestId)
//           .update({'status': 'accepted'});
//     } catch (e) {
//       print('Error accepting connection request: $e');
//     }
//   }

//   Future<void> declineRequest(String requestId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('chat_requests')
//           .doc(requestId)
//           .update({'status': 'declined'});
//     } catch (e) {
//       print('Error declining connection request: $e');
//     }
//   }

//   Future<void> showNotification() async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails(
//       channelShowBadge: true,
//       color: Colors.green,
//       'Lawyer APP',
//       "New Request is pending",
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Connection Request',
//       'You have a new connection request from a client',
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'New Request',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: getConnectionRequestsStream(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: Colors.green,
//             ));
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No connection requests.'));
//           }

//           Future.delayed(
//               Duration.zero,
//               () =>
//                   showNotification()); // Show notification when new request comes

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot request = snapshot.data!.docs[index];
//               String requestId = request.id;
//               String clientId = request['user_id'];
//               String status = request['status'];
//               String lawyerId = request['lawyer_id'];

//               // Fetch client details from Firestore
//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(clientId)
//                     .get(),
//                 builder: (context, clientSnapshot) {
//                   if (clientSnapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     // While data is loading, show a loading indicator
//                     return const Center(
//                       child: LinearProgressIndicator(
//                         color: Colors.green,
//                       ),
//                     );
//                   } else if (clientSnapshot.hasError) {
//                     // If an error occurs, display an error message
//                     return Center(
//                         child: Text('Error: ${clientSnapshot.error}'));
//                   } else if (clientSnapshot.hasData) {
//                     // If data is available, extract client details
//                     String imageUrl = clientSnapshot.data!.get('imageUrl');
//                     String name = clientSnapshot.data!.get('name');
//                     String email = clientSnapshot.data!.get('email');

//                     // Return the ListTile with client details
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(imageUrl),
//                       ),
//                       title: Text(name),
//                       subtitle: Text(email),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () => acceptRequest(requestId),
//                             child: Container(
//                               height: 30,
//                               width: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: const Color.fromARGB(255, 247, 243, 249),
//                               ),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.check,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: () => declineRequest(requestId),
//                             child: Container(
//                               height: 30,
//                               width: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: const Color.fromARGB(255, 247, 243, 249),
//                               ),
//                               child: const Center(
//                                 child: Text('❌'),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     // If no data is available, display a placeholder or return an empty widget
//                     return const SizedBox.shrink();
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewChatRequestScreen extends StatefulWidget {
  const NewChatRequestScreen({super.key});

  @override
  State<NewChatRequestScreen> createState() => _NewChatRequestScreenState();
}

class _NewChatRequestScreenState extends State<NewChatRequestScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Stream<QuerySnapshot> getConnectionRequestsStream() {
    String lawyerId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('chat_requests')
        .where('lawyer_id', isEqualTo: lawyerId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_requests')
          .doc(requestId)
          .update({'status': 'accepted'});
    } catch (e) {
      print('Error accepting connection request: $e');
    }
  }

  Future<void> declineRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_requests')
          .doc(requestId)
          .update({'status': 'declined'});
    } catch (e) {
      print('Error declining connection request: $e');
    }
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      channelShowBadge: true,
      color: Colors.green,
      'Legal Ease',
      "New Request is pending",
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Connection Request',
      'You have a new connection request from a client',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'New Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: getConnectionRequestsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No connection requests.'));
          }

          Future.delayed(
              Duration.zero,
              () =>
                  showNotification()); // Show notification when new request comes

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot request = snapshot.data!.docs[index];
              String requestId = request.id;
              String clientId = request['user_id'];
              String status = request['status'];
              String lawyerId = request['lawyer_id'];

              // Fetch client details from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(clientId)
                    .get(),
                builder: (context, clientSnapshot) {
                  if (clientSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // While data is loading, show a loading indicator
                    return const Center(
                      child: LinearProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  } else if (clientSnapshot.hasError) {
                    // If an error occurs, display an error message
                    return Center(
                        child: Text('Error: ${clientSnapshot.error}'));
                  } else if (clientSnapshot.hasData) {
                    // If data is available, extract client details
                    Map<String, dynamic>? userData =
                        clientSnapshot.data!.data() as Map<String, dynamic>?;
                    if (userData != null && userData.containsKey('imageUrl')) {
                      // Check if 'imageUrl' exists in userData
                      String imageUrl = userData['imageUrl'];
                      String name = userData['name'];
                      String email = userData['email'];

                      // Return the ListTile with client details
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        title: Text(name),
                        subtitle: Text(email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => acceptRequest(requestId),
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color.fromARGB(255, 247, 243, 249),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => declineRequest(requestId),
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color.fromARGB(255, 247, 243, 249),
                                ),
                                child: const Center(
                                  child: Text('❌'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // 'imageUrl' doesn't exist in userData
                      // Handle this case by providing a default or placeholder value
                      return const ListTile(
                        title: Text('Name not available'),
                        subtitle: Text('Email not available'),
                      );
                    }
                  } else {
                    // If no data is available, display a placeholder or return an empty widget
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
