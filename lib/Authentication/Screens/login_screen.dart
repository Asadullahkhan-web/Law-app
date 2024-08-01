// ignore_for_file: empty_catches, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Home%20Screen/admin_home_screen.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Profile%20Complete%20Screen/admin_profile_screen.dart';
import 'package:lawyers_application/Authentication/Screens/forgot_password_screen.dart';
import 'package:lawyers_application/Authentication/Screens/sign_up_screen.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';
import 'package:lawyers_application/Client%20Section/Client%20Home%20Screen/client_home_screen.dart';
import 'package:lawyers_application/Client%20Section/Client%20Profile%20Complete%20Screen/client_profile_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Home%20Screen/lawyer_home_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Profile%20Complete%20Screen/lawyer_profile_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String userRole = '';
  bool _isLoading = false;
  bool isPasswordVisible = false;
  bool isEmailFilled = false;
  bool _isValidEmailAddress = false;
  String? emailError;
  String? passwordError;
  String? selectedRoleError;

  String currentUidRole = '';

  Future<void> login() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.toString(),
      );

      setState(() {
        isPasswordVisible = false;
        _isValidEmailAddress = false;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while logging in.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'role-not-matching': // Custom error code for role mismatch
          errorMessage = 'The user role does not match.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      showSuccessSnackbar(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  bool _isValidEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@gmail\.com$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(email);
  }

  bool _validateFields() {
    setState(() {
      emailError = null;
      passwordError = null;
      selectedRoleError = null;

      if (userRole.isEmpty) {
        selectedRoleError = 'Please select a role.';
      }
      if (_emailController.text.isEmpty) {
        emailError = 'Please enter an email.';
      } else if (!_isValidEmail(_emailController.text)) {
        emailError = 'Please enter a valid email.';
      }
      if (_passwordController.text.isEmpty) {
        passwordError = 'Please enter a password.';
      } else if (_passwordController.text.length < 6) {
        passwordError = 'Password must be at least 6 characters long.';
      }
    });

    if (emailError != null ||
        passwordError != null ||
        selectedRoleError != null) {
      String errorMessage = 'Please correct the following errors:\n\n';
      if (emailError != null) errorMessage += '➡ $emailError\n';
      if (passwordError != null) errorMessage += '➡ $passwordError\n';
      if (selectedRoleError != null) errorMessage += '➡ $selectedRoleError\n';

      _showErrorDialog(errorMessage);
    }
    return true;
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
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

  Future<bool> _checkUserFieldsFilled(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        final Map<String, dynamic> userData = userDoc.data()!;

        if (userData.containsKey('name') &&
            userData.containsKey('imageUrl') &&
            userData.containsKey('bio') &&
            userData.containsKey('gender')) {
          if (userData['name'] != null &&
              userData['imageUrl'] != null &&
              userData['bio'] != null &&
              userData['gender'] != null) {
            return true;
          }
        }
      }
    } catch (error) {}

    return false;
  }

  //.........
  Future<void> fetchDataForCurrentUser() async {
    try {
      final String userUid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userUid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        currentUidRole = userData['role'];
      } else {}
    } catch (error) {}
  }

  Future<String> getUserRoleFromFirestore(String userUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userUid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        return userData['role'];
      } else {
        return ''; // Return an empty string or handle the case as needed
      }
    } catch (error) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  @override
  void initState() {
    fetchDataForCurrentUser();
    super.initState();
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
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "Legal Ease",
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
              child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 22),
                  child: Text(
                    'Welcome \nBack!',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey.shade500,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      TextFormFieldWidget(
                        controller: _passwordController,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            size: 25,
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                isPasswordVisible ? Colors.green : Colors.grey,
                          ),
                        ),
                        hint: "Password",
                        prefixIcon: Ionicons.lock_closed_outline,
                        obscureText: !isPasswordVisible,
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 'Admin',
                            groupValue: userRole,
                            onChanged: (value) {
                              setState(() {
                                userRole = value.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Admin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Radio(
                            value: 'Lawyer',
                            groupValue: userRole,
                            onChanged: (value) {
                              setState(() {
                                userRole = value.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Lawyer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Radio(
                            value: 'Client',
                            groupValue: userRole,
                            onChanged: (value) {
                              setState(() {
                                userRole = value.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Client',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_validateFields()) {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setBool('isLogin', true);

                            SharedPreferences roleSharedPref =
                                await SharedPreferences.getInstance();
                            roleSharedPref.setString('userRole', userRole);

                            // Perform login operation
                            await login();

                            // Get the current user's UID
                            final userUid = _auth.currentUser!.uid;

                            // Check if the user's role matches the selected role during login
                            final currentUidRole =
                                await getUserRoleFromFirestore(userUid);
                            if (currentUidRole != userRole) {
                              // Display an error message or prevent login
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Role does not match.'),
                                ),
                              );
                              return; // Prevent further execution
                            }

                            // Check if the user has filled all profile fields
                            final isProfileFilled =
                                await _checkUserFieldsFilled(userUid);

                            // Navigate to the corresponding screen based on whether the profile is filled or not
                            if (isProfileFilled) {
                              // If the profile is filled, navigate to the home screen based on the user's role
                              switch (userRole) {
                                case 'Client':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ClientHomeScreen()),
                                  );
                                  break;
                                case 'Lawyer':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LawyerHomeScreen()),
                                  );
                                  break;
                                case 'Admin':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminHomeScreen()),
                                  );
                                  break;
                                default:
                                  // Handle unknown user roles
                                  break;
                              }
                            } else {
                              // If the profile is not filled, navigate to the profile screen based on the user's role
                              switch (userRole) {
                                case 'Client':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ClientProfileScreen()),
                                  );
                                  break;
                                case 'Lawyer':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LawyerProfileScreen()),
                                  );
                                  break;
                                case 'Admin':
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminProfileScreen()),
                                  );
                                  break;
                                default:
                                  // Handle unknown user roles
                                  break;
                              }
                            }
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green,
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.lineScale,
                                      colors: [Colors.white],
                                      strokeWidth: 0.5,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 290,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const ForgotPasswordScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = const Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 1000),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const SignUpScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = 0.0;
                                      const end = 1.0;

                                      var scaleTween = Tween<double>(
                                              begin: begin, end: end)
                                          .chain(
                                              CurveTween(curve: Curves.ease));

                                      return ScaleTransition(
                                        scale: animation.drive(scaleTween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      )
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
