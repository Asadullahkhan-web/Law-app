// File will be change used when the user want to change their Old password from inside the app ,

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

// Error Storing Variables...
  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;
  bool _isLoading = false;
  late bool isPasswordVisible = false;

  Future<void> _changePassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Reauthenticate the user with their current password
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the user's password
      await user.updatePassword(newPasswordController.text);

      // Show a success message or navigate to a success screen
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while changing your password.';

      switch (e.code) {
        case 'requires-recent-login':
          errorMessage =
              'For security reasons, you need to sign in again before changing your password.';
          break;
        case 'wrong-password':
          errorMessage = 'The current password is incorrect.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      // _showErrorDialog(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('');
    }
  }

  bool validateFields() {
    setState(() {
      oldPasswordError = null;
      newPasswordError = null;
      confirmPasswordError = null;

      if (_oldPasswordController.text.isEmpty) {
        oldPasswordError = 'Please enter an old password.';
      } else if (_oldPasswordController.text.length < 6) {
        oldPasswordError = 'Please enter a valid old password.';
      }
      if (newPasswordController.text.isEmpty) {
        newPasswordError = 'Please enter a new password.';
      } else if (newPasswordController.text.length < 6) {
        newPasswordError = 'Password must be at least 6\n     characters long.';
      }
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = 'Please confirm your new password.';
      } else if (newPasswordController.text != confirmPasswordController.text) {
        confirmPasswordError = 'Passwords do not match.';
      }
    });

    if (oldPasswordError != null ||
        newPasswordError != null ||
        confirmPasswordError != null) {
      String errorMessage = 'Please correct the following errors:\n\n';
      if (oldPasswordError != null) errorMessage += '➡ $oldPasswordError\n';
      if (newPasswordError != null) errorMessage += '➡ $newPasswordError\n';
      if (confirmPasswordError != null) {
        errorMessage += '➡ $confirmPasswordError\n';
      }

      _showErrorDialog(errorMessage);
    }
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade50,
          title: const Text('Password Changed'),
          content: const Text('Your password has been successfully changed.'),
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
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 30,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          title: const Align(
            alignment: Alignment.center,
            child: Text('Error Found!'),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF345FB4)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Change Password',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/background.jpg',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 180, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormFieldWidget(
                controller: _oldPasswordController,
                hint: 'Current Password',
                obscureText: true,
                prefixIcon: Ionicons.lock_open_outline,
              ),
              TextFormFieldWidget(
                controller: newPasswordController,
                hint: 'New Password',
                obscureText: !isPasswordVisible,
                prefixIcon: Ionicons.lock_closed_outline,
                onChanged: (value) {},
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    size: 25,
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: isPasswordVisible ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              TextFormFieldWidget(
                controller: confirmPasswordController,
                hint: 'Confirm New Password',
                obscureText: !isPasswordVisible,
                prefixIcon: Ionicons.lock_closed_outline,
              ),
              const SizedBox(
                height: 20,
              ),
              loginAndSignUpButtonWidget(
                  _isLoading ? 'LOADING...' : 'CHANGE PASSWORD', () async {
                if (validateFields()) {
                  setState(() {
                    _isLoading =
                        true; // Set isLoading to true to show loading indicator
                  });
                  await _changePassword(); // Assuming _changePassword is an asynchronous function
                  setState(() {
                    _isLoading =
                        false; // Set isLoading to false after operation completes
                  });

                  // Clear the fields
                  _oldPasswordController.clear();
                  newPasswordController.clear();
                  confirmPasswordController.clear();
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
