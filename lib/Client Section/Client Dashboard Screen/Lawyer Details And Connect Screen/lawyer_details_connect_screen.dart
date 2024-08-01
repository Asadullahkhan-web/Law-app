import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawyers_application/Client%20Section/Client%20Chat%20Screen/each_chat_screen.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/Lawyer%20Details%20And%20Connect%20Screen/lawyer_review_watch_screen.dart';
import 'package:lawyers_application/Client%20Section/Search%20Lawyers/zoom_lawyer_image.dart';
import 'package:lawyers_application/Utilities/utility.dart';

class LawyerDetailsAndConnectScreen extends StatefulWidget {
  const LawyerDetailsAndConnectScreen({
    super.key,
    required this.lawyerDetailsFuture,
  });

  final dynamic lawyerDetailsFuture;

  @override
  State<LawyerDetailsAndConnectScreen> createState() =>
      _LawyerDetailsAndConnectScreenState();
}

class _LawyerDetailsAndConnectScreenState
    extends State<LawyerDetailsAndConnectScreen> {
  var lawyerId;
  Map<String, dynamic>? status;
  bool isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: widget.lawyerDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Map<String, dynamic>> lawyerDetailsList = snapshot.data!;
            return ListView.builder(
              itemCount: lawyerDetailsList.length,
              itemBuilder: (context, index) {
                lawyerId = lawyerDetailsList[index]['userId'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.green),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ZoomedImageScreen(
                                              imageUrl: lawyerDetailsList[index]
                                                      ['imageUrl'] ??
                                                  'No Image',
                                              heroTag:
                                                  'lawyer_image_$index', // Unique tag for the hero animation
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: 'lawyer_image_$index',
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              lawyerDetailsList[index]
                                                  ['imageUrl']),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${lawyerDetailsList[index]['name']}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        lawyerDetailsList[index]['email'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Gender - ${lawyerDetailsList[index]['gender']}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      Text(
                                        'Rating: ${double.tryParse(lawyerDetailsList[index]['rating'].toString())?.toStringAsFixed(1) ?? '0.0'}⭐'
                                        '(${int.tryParse(lawyerDetailsList[index]['numberOfRatings'].toString()) ?? 0})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Working Category:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${lawyerDetailsList[index]['category']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Bio:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            lawyerDetailsList[index]['bio'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 60,
                            endIndent: 60,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LawyerReviewWatchScreen(
                                      lawyerDetailsFuture: lawyerId),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'View Lawyer Reviews',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.blueGrey,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Constants.screenHeight(context) * 0.1,
                          ),
                          isAdmin
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.center,
                                  child: FutureBuilder<String?>(
                                    future: getRequestStatus(lawyerId),
                                    builder: (context, statusSnapshot) {
                                      if (statusSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          color: Colors.green,
                                        );
                                      } else if (statusSnapshot.hasError) {
                                        return Text(
                                            'Error: ${statusSnapshot.error}');
                                      } else {
                                        bool isRequestPending =
                                            statusSnapshot.data == 'pending';
                                        bool isRequestAccepted =
                                            statusSnapshot.data ==
                                                'accepted'; // Add this line

                                        return ElevatedButton(
                                          onPressed: () {
                                            if (isRequestAccepted) {
                                              // Navigate to the chat screen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EachChatScreen(
                                                            otherUserUid:
                                                                lawyerId,
                                                            otherUserPersonalDetails:
                                                                lawyerDetailsList[
                                                                    index])),
                                              );
                                            } else if (!isRequestPending &&
                                                !isRequestAccepted) {
                                              // If request is not pending and not accepted, send a new request
                                              sendChatRequestToLawyer(lawyerId);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isRequestPending
                                                ? Colors.grey
                                                : isRequestAccepted
                                                    ? Colors.green
                                                    : Colors.blue,
                                          ),
                                          child: Text(
                                            isRequestPending
                                                ? 'Request Pending'
                                                : isRequestAccepted
                                                    ? 'Start Chats...'
                                                    : 'Request for Connect',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text('No lawyer details available.'),
            );
          }
        },
      ),
    );
  }

  Future<String?> getRequestStatus(String lawyerId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_requests')
          .where('user_id', isEqualTo: userId)
          .where('lawyer_id', isEqualTo: lawyerId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        status = querySnapshot.docs[0].data() as Map<String, dynamic>?;
        if (status != null) {
          return status!['status'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching request status: $e');
      return null;
    }
  }

  void sendChatRequestToLawyer(String lawyerId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_requests')
          .where('user_id', isEqualTo: userId)
          .where('lawyer_id', isEqualTo: lawyerId)
          .get();

      // Check if a request already exists
      if (querySnapshot.docs.isEmpty) {
        final dateTime = DateTime.now();
        final newFormatter = DateFormat('h:mm a');
        final formattedDateTime = newFormatter.format(dateTime);

        // Create a new document in the 'chat_requests' collection
        await FirebaseFirestore.instance.collection('chat_requests').add({
          'user_id': userId,
          'lawyer_id': lawyerId,
          'status': 'pending',
          'timestamp': formattedDateTime
        });

        showSnackBar('Chat request sent successfully to lawyer');
      } else {
        showSnackBar('Chat request already sent to lawyer ');
      }
    } catch (e) {
      showSnackBar('Error sending chat request, Restart your app');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> getUserRole() async {
    try {
      // Get the current user ID
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // Query Firestore to get the user document
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .get();

      // Check if the document exists and contains a role field
      if (userSnapshot.exists &&
          userSnapshot.data() != null &&
          userSnapshot.data()!.containsKey('role')) {
        String role = userSnapshot.data()!['role'];

        // Check if the user is an admin
        // bool isAdminUser = role == 'Admin';
        if (role == 'Admin') {
          setState(() {
            isAdmin = true;
          });
        }

        // Now you can use the isAdmin variable as needed
        print('Is admin: $isAdmin');
      } else {
        print('User document not found or role field missing.');
      }
        } catch (error) {
      print('Error getting user role: $error');
    }
    return;
  }
}
