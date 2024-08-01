// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCasesRequestScreen extends StatefulWidget {
  const NewCasesRequestScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
  });

  final String currentUserId;
  final String receiverId;

  @override
  State<NewCasesRequestScreen> createState() => _NewCasesRequestScreenState();
}

class _NewCasesRequestScreenState extends State<NewCasesRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          'Pending Cases',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cases_assigning_request')
            .where('senderId', isEqualTo: widget.receiverId)
            .where('isCaseAccepted', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending cases'));
          } else {
            final cases = snapshot.data!.docs;
            return ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final data = cases[index].data() as Map<String, dynamic>;
                final title = data['title'] ?? '';
                final category = data['category'] ?? '';

                return ListTile(
                  title: Text(title),
                  subtitle: Text(category),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _acceptCase(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rejectCase(),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _acceptCase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docId = '${widget.receiverId}_${widget.currentUserId}';

      await firestore.collection('cases_assigning_request').doc(docId).update({
        'isCaseAccepted': true,
        'progressOfCase': 0,
        'caseSuccess': true,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Case accepted')));

      await firestore.collection('users').doc(widget.currentUserId).update({
        'totalCases': FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Total cases updated')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _rejectCase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docId = '${widget.receiverId}_${widget.currentUserId}';

      await firestore.collection('cases_assigning_request').doc(docId).update({
        'isCaseAccepted': false,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Case rejected')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
