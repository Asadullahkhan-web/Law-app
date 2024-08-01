import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Home%20Screen/lawyer_home_screen.dart';

class LawyerUnVerifiedScreen extends StatefulWidget {
  const LawyerUnVerifiedScreen({super.key});

  @override
  State<LawyerUnVerifiedScreen> createState() => _LawyerUnVerifiedScreenState();
}

class _LawyerUnVerifiedScreenState extends State<LawyerUnVerifiedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  tryAgain() {
    // Create a new document in the "lawyers_verification" collection with admin UID as document ID
    FirebaseFirestore.instance
        .collection('lawyers_verification')
        .doc(_auth.currentUser!.uid) // Use user's UID as document ID
        .delete()
        .then((value) {
      // Document created or updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 2,
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
          content: Text(
            'You are eligible for next attemp.',
          ),
        ),
      );
      // You can navigate to another screen or show a success message here
    }).catchError((error) {
      // Error occurred while sending request
      // You can show an error message or handle the error in another way
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Failed',
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 70,
          ),
          const Center(
            child: Opacity(
              opacity: 0.7,
              child: Image(
                height: 170,
                width: 170,
                image: AssetImage(
                  'assets/unVerified.png',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Un-Verified',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Oops! Your account has been marked Un-verified due to fake or wrong informations.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: GestureDetector(
              onTap: () {
                tryAgain();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LawyerHomeScreen(),
                  ),
                );
              }, // this will dynamic for each button,
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
