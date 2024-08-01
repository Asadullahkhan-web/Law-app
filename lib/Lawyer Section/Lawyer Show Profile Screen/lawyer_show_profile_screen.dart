// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Common%20Resources/Widgets/build_profile_screen_widget.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';

class LawyerShowProfileScreen extends StatefulWidget {
  const LawyerShowProfileScreen({super.key});

  @override
  State<LawyerShowProfileScreen> createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerShowProfileScreen> {
  bool isLoading = false;
  late Map<String, dynamic> userProfileData;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadUserProfileData();
  }

  Future<void> loadUserProfileData() async {
    setState(() {
      isLoading = true;
    });

    userProfileData = await UserProfileService().getCurrentUserData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : buildProfileScreen(context, userProfileData),
    );
  }
}
