// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Show%20Profile%20Screen/Widgets/profile_fields_list_tile_widget.dart';
import 'package:lawyers_application/Lawyer%20Section/Verification%20Screen/Un-Verified%20Screen/un_verified_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Verification%20Screen/Verified%20Screen/lawyer_verified_screen.dart';
import 'package:lawyers_application/Utilities/constants.dart';

class LawyerVerificationScreen extends StatefulWidget {
  const LawyerVerificationScreen({super.key});

  @override
  _LawyerVerificationScreenState createState() =>
      _LawyerVerificationScreenState();
}

class _LawyerVerificationScreenState extends State<LawyerVerificationScreen> {
  final TextEditingController messageController = TextEditingController();

  bool isLoading = true;
  late Map<String, dynamic> userProfileData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isPending = false;

  @override
  void initState() {
    super.initState();
    loadUserProfileData();
  }

  Future<void> loadUserProfileData() async {
    final userData = await UserProfileService().getCurrentUserData();
    setState(() {
      isLoading = false;
      userProfileData = userData;
    });
    _checkVerificationStatus();
  }

  void _submitVerificationRequest() async {
    final dateTime = DateTime.now();
    final newFormatter = DateFormat('h:mm a | dd_MMMM');
    final formattedDateTime = newFormatter.format(dateTime);

    final message = messageController.text.trim(); // Trim the message

    if (message.isEmpty) {
      // If message is empty, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.shade400,
          content: const Text('Type your message...'),
        ),
      );
      return; // Return from function
    }

    try {
      await FirebaseFirestore.instance
          .collection('lawyers_verification')
          .doc(_auth.currentUser!.uid)
          .set(
        {
          'message': message,
          'requestSenderUid': _auth.currentUser!.uid,
          'isVerified': '',
          'sentDateTime': formattedDateTime,
        },
        SetOptions(merge: true),
      );

      showSuccessSnackBar(
          'Verification request sent successfully!', Colors.green);
    } catch (error) {
      //
    }
  }

  void showSuccessSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        duration: const Duration(seconds: 1),
        backgroundColor: color,
        content: Text(
          message,
        ),
      ),
    );
  }

  void _checkVerificationStatus() async {
    final verificationSnapshot = await FirebaseFirestore.instance
        .collection('lawyers_verification')
        .doc(_auth.currentUser!.uid)
        .get();

    if (!verificationSnapshot.exists) {
      return;
    }

    final isVerified = verificationSnapshot['isVerified'] as String?;

    if (isVerified == 'Verified') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LawyerVerifiedScreen(),
        ),
      );
    } else if (isVerified == 'Un-Verified') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LawyerUnVerifiedScreen(),
        ),
      );
    } else if (isVerified == "") {
      setState(() {
        isPending = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Lawyer Verification', style: appBarTitleStyle),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 50,
                      backgroundImage:
                          NetworkImage(userProfileData['imageUrl'] ?? ''),
                    ),
                    ProfileFieldsListTileWidget(
                      titleValue: 'Name',
                      trillValue: userProfileData['name'] ?? '',
                    ),
                    ProfileFieldsListTileWidget(
                      titleValue: 'Email',
                      trillValue: userProfileData['email'] ?? '',
                    ),
                    ProfileFieldsListTileWidget(
                      titleValue: 'Gender',
                      trillValue: userProfileData['gender'] ?? '',
                    ),
                    ProfileFieldsListTileWidget(
                      titleValue: 'Bio',
                      subtitleValue: userProfileData['bio'] ?? '',
                      trillValue: '',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.grey,
                        controller: messageController,
                        maxLength: 300,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                          enabled: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusColor: Colors.green,
                          hintText: 'Enter your message',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isPending
                        ? loginAndSignUpButtonWidget(
                            'Request Pending',
                            () {
                              showSuccessSnackBar(
                                  'Your request is already pending.',
                                  Colors.red.shade300);
                            },
                          )
                        : loginAndSignUpButtonWidget(
                            'Submit Request',
                            _submitVerificationRequest,
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
