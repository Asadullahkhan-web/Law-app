// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lawyers_application/Common%20Resources/Widgets/build_profile_screen_widget.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';

class ClientShowProfileScreen extends StatelessWidget {
  const ClientShowProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Map<String, dynamic>>(
        future: UserProfileService().getCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userProfileData = snapshot.data!;
            return buildProfileScreen(context, userProfileData);
          }
        },
      ),
    );
  }
}
