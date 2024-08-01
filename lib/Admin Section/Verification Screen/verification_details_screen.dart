// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Admin%20Section/Verification%20Screen/Widgets/custom_app_bar.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Show%20Profile%20Screen/Widgets/profile_fields_list_tile_widget.dart';

class VerificationDetailsScreen extends StatefulWidget {
  const VerificationDetailsScreen(
      {super.key, required this.userDataK, required this.data});

  final userDataK;
  final data;

  @override
  State<VerificationDetailsScreen> createState() =>
      _VerificationDetailsScreenState();
}

class _VerificationDetailsScreenState extends State<VerificationDetailsScreen> {
  // for updating Lawyer in the firebase
  verified() async {
    try {
      var requestSenderUid = widget.data['requestSenderUid'];
      await FirebaseFirestore.instance
          .collection('lawyers_verification')
          .doc(requestSenderUid)
          .update({
        'isVerified': 'Verified',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requestSenderUid)
          .update({
        'isVerified': 'Verified',
      });

      showSuccessSnackbar(
          '${widget.userDataK['name']} has been marked Verified');
      return true; // Return true to indicate success
    } catch (error) {
      showSuccessSnackbar(
          '${widget.userDataK['name']} please check again Error OCcured! $error');
      return false; // Return false to indicate failure
    }
  }

  unVerified() async {
    try {
      var requestSenderUid = widget.data['requestSenderUid'];
      await FirebaseFirestore.instance
          .collection('lawyers_verification')
          .doc(requestSenderUid)
          .update({
        'isVerified': 'Un-Verified',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requestSenderUid)
          .update({
        'isVerified': 'Un-Verified',
      });
      showSuccessSnackbar(
          '${widget.userDataK['name']} has been marked Un-Verified');
      return true; // Return true to indicate success
    } catch (error) {
      showSuccessSnackbar(
          '${widget.userDataK['name']} please check again Error OCcured! $error');
      return false; // Return false to indicate failure
    }
  }

  // this function is used to display success Message to user.
  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        )
        .closed
        .then((_) {
      // Navigate back to the AdminVerificationScreen
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        image: widget.userDataK['imageUrl'],
        title: '${widget.userDataK['name']}',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileFieldsListTileWidget(
              titleValue: 'Email',
              trillValue: '${widget.userDataK['email']}',
            ),
            ProfileFieldsListTileWidget(
              titleValue: 'Gender',
              trillValue: '${widget.userDataK['gender']}',
            ),
            const SizedBox(
              height: 10,
            ),
            // for User Bio

            VerifiDetailScreenBioMessageWidget(
              title: 'Bio',
              dynamicData: widget.userDataK['bio'],
            ),
            const SizedBox(
              height: 10,
            ),
            VerifiDetailScreenBioMessageWidget(
              title: 'Message',
              dynamicData: widget.data['message'],
            ),
            const SizedBox(
              height: 20,
            ),
            loginAndSignUpButtonWidget('Verified', verified),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
              child: GestureDetector(
                onTap: unVerified,
                child: Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Text(
                      'Un-Verified',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VerifiDetailScreenBioMessageWidget extends StatelessWidget {
  const VerifiDetailScreenBioMessageWidget({
    super.key,
    this.userDataK,
    this.data,
    required this.title,
    required this.dynamicData,
  });

  final userDataK;
  final data;
  final title;
  final dynamicData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.grey.shade600),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text(
                  '$dynamicData',
                  style: TextStyle(color: Colors.grey.shade700),
                  maxLines:
                      10, // Adjust this value to set the maximum number of lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
