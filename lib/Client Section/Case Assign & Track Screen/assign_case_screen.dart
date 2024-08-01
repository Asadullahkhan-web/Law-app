import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import DateFormat for date formatting
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';

class AssignCaseScreen extends StatelessWidget {
  final String currentUserId;
  final String receiverId;

  const AssignCaseScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Assign Case',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AssignCaseForm(
          currentUserId: currentUserId,
          receiverId: receiverId,
        ),
      ),
    );
  }
}

class AssignCaseForm extends StatefulWidget {
  final String currentUserId;
  final String receiverId;

  const AssignCaseForm({
    super.key,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  _AssignCaseFormState createState() => _AssignCaseFormState();
}

class _AssignCaseFormState extends State<AssignCaseForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool isPending = false;
  bool isCaseAccepted = false;

  @override
  void initState() {
    super.initState();
    checkIfRequestPending();
  }

  void checkIfRequestPending() {
    final firestore = FirebaseFirestore.instance;
    final docId = '${widget.currentUserId}_${widget.receiverId}';

    firestore
        .collection('cases_assigning_request')
        .doc(docId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          isPending = true;
          isCaseAccepted = docSnapshot.data()?['isCaseAccepted'] ?? false;
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking case request status')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: isPending
          ? isCaseAccepted
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      'The lawyer has Accept your case.\nTo obtain further details, you should track its progress.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Already Pending',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                loginAndSignUpButtonWidget('Submit ➩', () {
                  if (_formKey.currentState!.validate()) {
                    _submitCaseRequest();
                  }
                })
              ],
            ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateTime.isAfter(today)) {
      return 'Today, ${DateFormat('hh:mm a').format(dateTime)}';
    } else if (dateTime.isAfter(yesterday)) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime);
    }
  }

  void _submitCaseRequest() {
    final firestore = FirebaseFirestore.instance;
    final docId = '${widget.currentUserId}_${widget.receiverId}';
    final currentDateTime = DateTime.now();

    firestore
        .collection('cases_assigning_request')
        .doc(docId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          isPending = true;
          isCaseAccepted = docSnapshot.data()?['isCaseAccepted'] ?? false;
        });
      } else {
        final data = {
          'senderId': widget.currentUserId,
          'receiverId': widget.receiverId,
          'title': _titleController.text,
          'category': _categoryController.text,
          'dateTime': formatDateTime(currentDateTime), // Format the date/time
          'isCaseAccepted': false,
        };

        firestore
            .collection('cases_assigning_request')
            .doc(docId)
            .set(data)
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Case request submitted')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error submitting case request')),
          );
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking case request status')),
      );
    });
  }
}
