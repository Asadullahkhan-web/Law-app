// ignore_for_file: file_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lawyers_application/Authentication/Screens/login_screen.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // Variables
  String userRole = '';
  bool _isLoading = false;
  late bool isPasswordVisible = false;
  bool isNameFilled = false;
  bool isEmailFilled =
      false; // this is used to check that either user has enter their email or not,.
  bool _isValidEmailAddress =
      false; // this variable is used to match user email with predefine pattran.
  bool _isPasswordMatch = false;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? selectedRoleError;

  Future<void> _register() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Create a new user in Firebase Authentication...
      await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.toString(),
      )
          .then((value) async {
        User? user = _auth.currentUser;
        // Send email verification
        await user!.sendEmailVerification();

        // Post user details to Firestore
        postDetailsToFirestore(
          _emailController.text,
          userRole,
          user.uid,
        );
      });

      setState(() {
        // Clear text fields
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // After User Registration Icons variables will become false. Will show in Grey color.
        isPasswordVisible = false;
        isNameFilled = false;
        _isValidEmailAddress = false;
        _isPasswordMatch = false;
        _isLoading = false;
      });

      // Show snackbar to inform the user to confirm their email
      showConfirmationSnackbar();

      // Do not navigate to the login screen here
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while registering.';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'Unable-to-establish-connection':
          errorMessage = 'Please fill all the required fields.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      showSuccessSnackbar(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('$e');
    }
  }

  // Future<void> _register() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     // Getting Current user from firebase.
  //     User? user = _auth.currentUser;

  //     // Create a new user in Firebase Authentication...
  //     await _auth
  //         .createUserWithEmailAndPassword(
  //       email: _emailController.text.trim().toLowerCase(),
  //       password: _passwordController.text.toString(),
  //     )
  //         .then((value) async {
  //       // Send email verification
  //       await user!.sendEmailVerification();

  //       // Post user details to Firestore
  //       postDetailsToFirestore(
  //         _emailController.text,
  //         userRole,
  //         user.uid,
  //       );
  //     });

  //     setState(() {
  //       // Clear text fields
  //       _emailController.clear();
  //       _passwordController.clear();
  //       _confirmPasswordController.clear();

  //       // After User Registration Icons variables will become false. Will show in Grey color.
  //       isPasswordVisible = false;
  //       isNameFilled = false;
  //       _isValidEmailAddress = false;
  //       _isPasswordMatch = false;
  //       _isLoading = false;
  //     });

  //     // Show snackbar to inform the user to confirm their email
  //     showConfirmationSnackbar();

  //     // Navigate to the next screen or perform other actions
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     String errorMessage = 'An error occurred while registering.';

  //     switch (e.code) {
  //       case 'weak-password':
  //         errorMessage = 'The password provided is too weak.';
  //         break;
  //       case 'email-already-in-use':
  //         errorMessage = 'An account already exists for this email.';
  //         break;
  //       case 'invalid-email':
  //         errorMessage = 'The email address is not valid.';
  //         break;
  //       case 'Unable-to-establish-connection':
  //         errorMessage = 'Please fill all the required fields.';
  //         break;
  //       default:
  //         errorMessage = e.message ?? errorMessage;
  //     }

  //     showSuccessSnackbar(errorMessage);
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     _showErrorDialog('$e');
  //   }
  // }

// Show snackbar informing the user to confirm their email
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please confirm your email address.'),
        duration: const Duration(seconds: 30),
        action: SnackBarAction(
          label: 'Resend',
          onPressed: () async {
            // Resend verification email
            User? user = _auth.currentUser;
            if (user != null && !user.emailVerified) {
              await user.sendEmailVerification();
            }
          },
        ),
      ),
    );
  }

// this function help to store the users data into firebase firestore, this will required four values here.
  postDetailsToFirestore(
    String email,
    String role,
    String userId,
  ) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    // ref.doc(user!.uid).set({
    ref.doc(user!.uid).set({
      'email': _emailController.text,
      'role': role,
      'userId': userId,
      'isVerified': ''
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  bool _validateFields() {
    setState(() {
      // Reset error messages
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      selectedRoleError = null;

      // Validate selected role
      if (userRole.isEmpty) {
        selectedRoleError = 'Please select a role.';
      }
      // Validate confirm password field
      if (_confirmPasswordController.text.isEmpty) {
        confirmPasswordError = 'Please confirm your password.';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        confirmPasswordError = 'Passwords do not match.';
      }
      // Validate email field
      if (_emailController.text.isEmpty) {
        emailError = 'Please enter an email.';
      } else if (!_isValidEmail(_emailController.text)) {
        emailError = 'Please enter a valid email.';
      }
      // Validate password field
      if (_passwordController.text.isEmpty) {
        passwordError = 'Please enter a password.';
      } else if (_passwordController.text.length < 6) {
        passwordError = 'Password must be at least 6 characters long.';
      }
    });

    // Check if any error exists
    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        selectedRoleError != null) {
      String errorMessage = 'Please correct the following errors:\n\n';
      if (emailError != null) errorMessage += '➡ $emailError\n';
      if (passwordError != null) errorMessage += '➡ $passwordError\n';
      if (confirmPasswordError != null) {
        errorMessage += '➡ $confirmPasswordError\n';
      }
      if (selectedRoleError != null) errorMessage += '➡ $selectedRoleError\n';

      _showErrorDialog(errorMessage);
      return false;
    }
    return true;
  }

  // this function is used to display success Message to user.
  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // this function is used to validate Your Email on the bases of Given Pattran.
  bool _isValidEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@gmail\.com$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(email);
  }

// used to show Error in dialogu box to user
  ///
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
              alignment: Alignment.center, child: Text('Error Found!')),
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

// the Main Body is starting from here ...

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Used to unfocus keyboard by tap outside the TextField.
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // backgroundColor: Constants.appColor,
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
              child: const Padding(
                  padding: EdgeInsets.only(top: 60.0, left: 22),
                  child: Text(
                    'Create Your\nAccount',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 185.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormFieldWidget(
                    controller: _emailController,
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        isEmailFilled = value.isNotEmpty;
                        _isValidEmailAddress =
                            _isValidEmail(_emailController.text);
                      });
                    },
                    suffixIcon: Icon(Icons.check,
                        color:
                            _isValidEmailAddress ? Colors.green : Colors.grey),
                    hint: 'Email',
                    prefixIcon: Ionicons.mail_outline,
                  ),

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
                        color: isPasswordVisible ? Colors.green : Colors.grey,
                      ),
                    ),
                    hint: 'Password',
                    prefixIcon: Ionicons.lock_closed_outline,
                    obscureText: !isPasswordVisible,
                    onChanged: (value) {},
                  ),

                  TextFormFieldWidget(
                    controller: _confirmPasswordController,
                    suffixIcon: Icon(
                      Icons.check,
                      size: 25,
                      color: !_isPasswordMatch ||
                              _confirmPasswordController.text.isEmpty
                          ? Colors.grey
                          : Colors.green,
                    ),
                    hint: 'Confirm Password',
                    prefixIcon: Ionicons.lock_closed_outline,
                    obscureText: !isPasswordVisible,
                    onChanged: (value) {
                      setState(
                        () {
                          // Compare password and confirm password
                          if (_confirmPasswordController.text ==
                              _passwordController.text) {
                            _isPasswordMatch = true;
                          } else {
                            _isPasswordMatch = false;
                          }
                        },
                      );
                    },
                  ),

                  // this Row is used for Radio Button Selection of Patient and caregiver.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Radio(
                      //   value: 'Admin',
                      //   groupValue: userRole,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       userRole = value.toString();
                      //     });
                      //   },
                      //   activeColor: Colors.green,
                      // ),
                      // const Text(
                      //   'Admin',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.blueGrey,
                      //   ),
                      // ),
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
                    onTap: () {
                      if (_validateFields()) {
                        _register();
                      }
                    },
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
                                'SIGN UP',
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
                    // height: MediaQuery.of(context).size.height * 0.28,
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 1000),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LoginScreen(), // targeted screen...
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = 0.0;
                                const end = 1.0;

                                var scaleTween =
                                    Tween<double>(begin: begin, end: end)
                                        .chain(CurveTween(curve: Curves.ease));

                                return ScaleTransition(
                                  scale: animation.drive(scaleTween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.green,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
