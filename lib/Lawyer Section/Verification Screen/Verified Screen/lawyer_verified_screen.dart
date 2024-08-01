import 'package:flutter/material.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Home%20Screen/lawyer_home_screen.dart';
import 'package:lawyers_application/Utilities/constants.dart';

class LawyerVerifiedScreen extends StatelessWidget {
  const LawyerVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Congratulation!',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: appbarBgColor,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          const Center(
            child: Image(
              height: 170,
              width: 170,
              image: AssetImage(
                'assets/verified.png',
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Verified',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Wow!You have successfully verified the account.',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(
            height: 30,
          ),
          loginAndSignUpButtonWidget('Go to Dashboard', () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LawyerHomeScreen(),
              ),
            );
          })
        ],
      ),
    );
  }
}
