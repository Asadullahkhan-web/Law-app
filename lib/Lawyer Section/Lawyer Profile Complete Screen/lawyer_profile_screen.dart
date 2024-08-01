// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Home%20Screen/lawyer_home_screen.dart';

class LawyerProfileScreen extends StatefulWidget {
  const LawyerProfileScreen({super.key});

  @override
  State<LawyerProfileScreen> createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  var genderSelection = '';

  final picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  bool isFilterChipSelected = false;

  String? nameError;
  String? bioError;
  String? genderSelectionError;
  String? imageError;
  String? categoryError;
  List<String> selectedCategories = [];

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageError = null;
      } else {}
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  Future<String?> _uploadImageToStorage() async {
    try {
      if (_image != null) {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now()}.jpg');

        final firebase_storage.UploadTask task = ref.putFile(_image!);
        final firebase_storage.TaskSnapshot snapshot =
            await task.whenComplete(() {});
        final String imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  bool validateName(String name) {
    name = name.trim();
    name = name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : '';

    // Check if the name contains only letters and spaces
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    return name.isNotEmpty && nameRegExp.hasMatch(name);
  }

  bool _validateFields() {
    setState(() {
      nameError = null;
      bioError = null;
      genderSelectionError = null;
      imageError = null;
      categoryError = null;

      if (_image == null) {
        imageError = ' Please upload an image.';
      }

      if (_nameController.text.isEmpty) {
        nameError = 'Please enter Name.';
      } else if (!validateName(_nameController.text)) {
        nameError = 'Please enter a valid Name.\n     Only Letters are accept ';
      }

      if (_bioController.text.isEmpty) {
        bioError = 'Please enter your Bio.';
      } else if (_bioController.text.length < 10) {
        bioError = 'Bio must be at least 10 characters\n      long.';
      }

      if (genderSelection.isEmpty) {
        genderSelectionError = 'Please select your gender.';
      }

      if (selectedCategories.isEmpty) {
        categoryError = 'Please select your category';
      }
    });

    if (nameError != null ||
        bioError != null ||
        genderSelectionError != null ||
        imageError != null ||
        categoryError != null) {
      String errorMessage = 'Please correct the following errors:\n\n';
      if (imageError != null) errorMessage += '➡$imageError\n';
      if (nameError != null) errorMessage += '➡ $nameError\n';
      if (bioError != null) errorMessage += '➡ $bioError\n';

      if (genderSelectionError != null) {
        errorMessage += '➡ $genderSelectionError\n';
      }
      if (categoryError != null) errorMessage += '➡ $categoryError\n';

      _showErrorDialog(errorMessage, 'Error Found!', Icons.error);
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message, String topMessage, IconData icons) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 30,
          icon: Icon(
            icons,
            color: Colors.red,
          ),
          title: Align(alignment: Alignment.center, child: Text(topMessage)),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text(
            "Complete Profile",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
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
                    opacity: 0.8),
              ),
            ),
            Align(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: Align(
                        alignment: Alignment.center,
                        child: Material(
                          elevation: 40,
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color:
                                    _image != null ? Colors.green : Colors.grey,
                              ),
                            ),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.grey[200],
                                  child: _image != null
                                      ? ClipOval(
                                          child: Image.file(_image!,
                                              fit: BoxFit.cover,
                                              width: 120,
                                              height: 120))
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt, size: 40),
                                            Text(
                                              'Upload Image',
                                              style: TextStyle(fontSize: 14),
                                            )
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: _nameController,

                      hint: 'Name',
                      obscureText: false,
                      prefixIcon: Ionicons.person_outline,
                      onChanged: (value) {
                        setState(() {});
                      },

                      // only for this fields
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        constraints:
                            const BoxConstraints(maxHeight: 100, maxWidth: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextFormField(
                          maxLength: 300,

                          controller: _bioController,
                          cursorColor: Colors.blueGrey,
                          maxLines: null, // Allow multiple lines
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Write a short bio...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            // Handle bio text changes
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: genderSelection,
                            onChanged: (value) {
                              setState(() {
                                genderSelection = value.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Radio(
                            value: 'Female',
                            groupValue: genderSelection,
                            onChanged: (value) {
                              setState(() {
                                genderSelection = value.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Female',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 170,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Text(
                                  'Select your category(s)',
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value:
                                        selectedCategories.contains('criminal'),
                                    onChanged: (value) {
                                      _toggleCategory('criminal');
                                    },
                                  ),
                                  const Text(
                                    'Criminal',
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value:
                                        selectedCategories.contains('business'),
                                    onChanged: (value) {
                                      _toggleCategory('business');
                                    },
                                  ),
                                  const Text(
                                    'Business',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value:
                                        selectedCategories.contains('family'),
                                    onChanged: (value) {
                                      _toggleCategory('family');
                                    },
                                  ),
                                  const Text('Family'),
                                  const SizedBox(
                                    width: 11,
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: selectedCategories
                                        .contains('immigration'),
                                    onChanged: (value) {
                                      _toggleCategory('immigration');
                                    },
                                  ),
                                  const Text('Immigration'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: selectedCategories.contains('tax'),
                                    onChanged: (value) {
                                      _toggleCategory('tax');
                                    },
                                  ),
                                  const Text('Tax'),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: selectedCategories
                                        .contains('intellectual_property'),
                                    onChanged: (value) {
                                      _toggleCategory('intellectual_property');
                                    },
                                  ),
                                  const Text('Intellectual property'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    loginAndSignUpButtonWidget(
                      _isLoading
                          ? 'LOADING...'
                          : 'SUBMIT', // Display 'LOADING...' when isLoading is true
                      () async {
                        if (_validateFields()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _showErrorDialog(
                              'Your Data is uploading!!!\nPlease wait for few seconds',
                              'Waiting!',
                              Icons.local_dining);

                          final imageUrl = await _uploadImageToStorage();

                          if (imageUrl != null) {
                            await _saveUserData(imageUrl);
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LawyerHomeScreen(),
                              ),
                            );
                          }

                          setState(() async {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveUserData(String imageUrl) async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        final String uid = user.uid;
        final DocumentReference userDocRef =
            firebaseFirestore.collection('users').doc(uid);

        // Create a batch
        WriteBatch batch = firebaseFirestore.batch();

        // Update user data in the batch
        batch.update(userDocRef, {
          'imageUrl': imageUrl,
          'name': _nameController.text,
          'bio': _bioController.text,
          'gender': genderSelection.toString(),
          'category': selectedCategories,
          'rating': 0
        });

        // Create a new document in the "lawyers" collection
        DocumentReference newLawyerDocRef =
            firebaseFirestore.collection('lawyers').doc(uid);

        // Set data for the new document
        await newLawyerDocRef.set({
          'userId': user.uid,
          'email': user.email,
          'imageUrl': imageUrl,
          'name': _nameController.text,
          'bio': _bioController.text,
          'gender': genderSelection.toString(),
          'category': selectedCategories,
          'rating': 0,
          // Add any other fields you want to include in the "lawyers" collection
        });

        // Commit the batch
        await batch.commit();
      }
    } catch (e) {
      // Handle errors
      // Show an error message to the user
    }
  }
}
