// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lawyers_application/Authentication/Screens/login_screen.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  //  Variable that are required inside, for UI Logic.
  bool isEmailFilled = false;
  bool _isValidEmailAddress = false;

  // this function help us to reset the password using link.
  Future<void> _resetPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validate the email field
      if (_emailController.text.isEmpty) {
        throw Exception('Please enter your email address.');
      }

      // Send a password reset email
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      // Show a success message or navigate to a success screen
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while resetting your password.';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email address.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  // this function is used to validate Your Email on the bases of Given Pattran.
  bool _isValidEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@gmail\.com$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(email);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content: const Text(
            'A password reset email has been sent to your email address. Please follow the instructions in the email to reset your password.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "Reset Password!",
            style: GoogleFonts.aDLaMDisplay(
                fontSize: 25,
                textStyle: Theme.of(context).textTheme.bodyLarge,
                decorationColor: Colors.black,
                color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/background.jpg',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormFieldWidget(
                          controller: _emailController,
                          onChanged: (value) {
                            setState(() {
                              isEmailFilled = value.isNotEmpty;
                              _isValidEmailAddress =
                                  _isValidEmail(_emailController.text);
                            });
                          },
                          suffixIcon: Icon(Icons.check,
                              color: _isValidEmailAddress
                                  ? Colors.green
                                  : Colors.grey),
                          hint: 'Email',
                          prefixIcon: Ionicons.mail_outline,
                          obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: _resetPassword,
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.green),
                          child: _isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: LoadingIndicator(
                                      // this is package to show loading indicator when submitt is loading.
                                      indicatorType: Indicator.lineScale,
                                      colors: [Colors.white],
                                      strokeWidth: 0.5,

                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'CONFIRM',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
