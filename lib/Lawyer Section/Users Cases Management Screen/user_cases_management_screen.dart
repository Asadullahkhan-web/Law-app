import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserCaseManagementScreen extends StatefulWidget {
  const UserCaseManagementScreen({super.key});

  @override
  State<UserCaseManagementScreen> createState() =>
      _UserCaseManagementScreenState();
}

class _UserCaseManagementScreenState extends State<UserCaseManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int progress = 0;
  String additionalMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Case Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cases_assigning_request')
            .where('progressOfCase',
                isLessThan: 100) // Filter where progressOfCase is less than 100
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final cases = snapshot.data!.docs;

            if (cases.isEmpty) {
              return const Center(child: Text('No cases available'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    final caseData =
                        cases[index].data() as Map<String, dynamic>;
                    final title = caseData['title'] ?? '';
                    final requestSenderId = caseData['senderId'] ?? '';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(requestSenderId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                          ));
                        } else if (userSnapshot.hasError) {
                          return const Text('Error fetching user data');
                        } else if (userSnapshot.hasData) {
                          final userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          final imageUrl = userData['imageUrl'] ?? '';
                          final name = userData['name'] ?? '';

                          return ListTile(
                            title: Text(name),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                            subtitle: Text(title),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        title: const Text('Add Case Progress'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Slider(
                                              activeColor: Colors.green,
                                              value: progress.toDouble(),
                                              min: 0,
                                              max: 100,
                                              divisions: 10,
                                              label: '$progress%',
                                              onChanged: (value) {
                                                setState(() {
                                                  progress = value.round();
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                              maxLength: 100,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter additional message',
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  additionalMessage = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _updateCase(
                                                caseId: cases[index].id,
                                                progress: progress,
                                                additionalMessage:
                                                    additionalMessage,
                                              );
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: const Text('Submit'),
                                          ),
                                          if (progress == 100)
                                            ElevatedButton(
                                              onPressed: () {
                                                _finishCase(
                                                  caseId: cases[index].id,
                                                  progress: progress,
                                                  additionalMessage:
                                                      additionalMessage,
                                                  currentUserId:
                                                      _auth.currentUser!.uid,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Finish'),
                                            ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return const Text('No user data available');
                        }
                      },
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateTime.isAfter(today)) {
      return 'Today, ${DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime)}';
    } else if (dateTime.isAfter(yesterday) && dateTime.isBefore(today)) {
      return 'Yesterday, ${DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime);
    }
  }

  void _updateCase({
    required String caseId,
    required int progress,
    required String additionalMessage,
  }) {
    final currentDateTime = DateTime.now();
    FirebaseFirestore.instance
        .collection('cases_assigning_request')
        .doc(caseId)
        .update({
      'progressOfCase': progress,
      'additionalMessage': additionalMessage,
      'dateTime': formatDateTime(currentDateTime), // Format the date/time
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case progress updated')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating case progress: $error')),
      );
    });
  }

  void _finishCase({
    required String caseId,
    required int progress,
    required String additionalMessage,
    required String currentUserId,
  }) {
    FirebaseFirestore.instance
        .collection('cases_assigning_request')
        .doc(caseId)
        .update({
      'progressOfCase': progress,
      'additionalMessage': additionalMessage,
      'caseOfSuccess': true, // Mark the case as successful
    }).then((_) {
      // Increment the successful cases count for the lawyer
      FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'successfulCases': FieldValue.increment(1),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Case finished')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error updating successful cases count: $error')),
        );
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finishing case: $error')),
      );
    });
  }
}
