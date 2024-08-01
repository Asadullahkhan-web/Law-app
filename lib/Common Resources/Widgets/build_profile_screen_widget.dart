import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Authentication/Screens/change_password_screen.dart';
import 'package:lawyers_application/Authentication/Screens/login_screen.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Common%20Resources/profile_bio_read_screen.dart';
import 'package:lawyers_application/Common%20Resources/update_profile_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Show%20Profile%20Screen/Widgets/profile_fields_list_tile_widget.dart';
import 'package:lawyers_application/Utilities/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildProfileScreen(BuildContext context, Map<String, dynamic> userData) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Stack(
        children: [
          Container(
            width: double.infinity,
            height: Constants.screenHeight(context) * 0.25,
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
          ),
          Positioned(
            top: Constants.screenHeight(context) * 0.04,
            left: 120,
            child: Container(
              height: Constants.screenHeight(context) * 0.19,
              width: Constants.screenHeight(context) * 0.19,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                border: Border.all(width: 3, color: Colors.white),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(userData['imageUrl'] ?? ''),
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileFieldsListTileWidget(
                  titleValue: 'Name',
                  trillValue: userData['name'] ?? '',
                ),
                ProfileFieldsListTileWidget(
                  titleValue: 'Email',
                  trillValue: userData['email'] ?? '',
                ),
                ProfileFieldsListTileWidget(
                  titleValue: 'Role',
                  trillValue: userData['role'] ?? '',
                ),
                ProfileFieldsListTileWidget(
                  titleValue: 'Gender',
                  trillValue: userData['gender'] ?? '',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileBioReadScreen(
                          bio: userData['bio'] ?? 'Bio record not found!',
                        ),
                      ),
                    );
                  },
                  child: ProfileFieldsListTileWidget(
                    titleValue: 'Bio',
                    subtitleValue: userData['bio'] ?? '',
                    trillValue: '➜',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  child: const ProfileFieldsListTileWidget(
                    titleValue: 'Change Password',
                    trillValue: '➜',
                  ),
                ),
                const SizedBox(height: 10),
                loginAndSignUpButtonWidget(
                  'Update Profile ➜',
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      GestureDetector(
        onTap: () async {
          try {
            final FirebaseAuth auth = FirebaseAuth.instance;
            await auth.signOut();

            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.remove('isLogin');

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Account logout successful.'),
              ),
            );
          } catch (e) {
            // Handle logout error
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.logout_outlined,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    ],
  );
}
