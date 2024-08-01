// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Home%20Screen/admin_home_screen.dart';
import 'package:lawyers_application/Authentication/Widgets/text_form_field_widget.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Utilities/constant_functions.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => AdminProfileScreenState();
}

class AdminProfileScreenState extends State<AdminProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  var genderSelection = '';
  final picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  var nameError;
  var bioError;
  var genderSelectionError;
  var imageError;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageError = null;
      } else {}
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
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    return name.trim().isNotEmpty && nameRegExp.hasMatch(name);
  }

  bool _validateFields() {
    setState(() {
      nameError = null;
      bioError = null;
      genderSelectionError = null;
      imageError = null;

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
    });

    if (nameError != null ||
        bioError != null ||
        genderSelectionError != null ||
        imageError != null) {
      String errorMessage = 'Please correct the following errors:\n\n';
      if (imageError != null) errorMessage += '➡$imageError\n';
      if (nameError != null) errorMessage += '➡ $nameError\n';
      if (bioError != null) errorMessage += '➡ $bioError\n';
      if (genderSelectionError != null) {
        errorMessage += '➡ $genderSelectionError\n';
      }

      _showErrorDialog(errorMessage, 'Error Found!', Icons.error);
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message, String topMessage, IconData icon) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 30,
              icon: Icon(
                icon,
                color: Colors.red,
              ),
              title:
                  Align(alignment: Alignment.center, child: Text(topMessage)),
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
                    ))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text("Complete Profile",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600))),
        body: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/background.jpg'),
                        opacity: 0.8))),
            Align(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
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
                                              color: _image != null
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                          child: Stack(children: [
                                            CircleAvatar(
                                                radius: 70,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: _image != null
                                                    ? ClipOval(
                                                        child: Image.file(
                                                            _image!,
                                                            fit: BoxFit.cover,
                                                            width: 120,
                                                            height: 120))
                                                    : const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                            Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40),
                                                            Text(
                                                              'Upload Image',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            )
                                                          ]))
                                          ]))))),
                          const SizedBox(height: 20),
                          TextFormFieldWidget(
                              controller: _nameController,
                              hint: 'Name',
                              obscureText: false,
                              prefixIcon: Ionicons.person_outline,
                              onChanged: (value) {
                                setState(() {});
                              }),

                          // User bio section...
                          const SizedBox(height: 16),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                  constraints: const BoxConstraints(
                                      maxHeight: 150, maxWidth: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                3) // changes position of shadow
                                            )
                                      ]),
                                  child: TextFormField(
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
                                  ))),
                          const SizedBox(height: 10),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    const Text('Male',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    Radio(
                                        value: 'Female',
                                        groupValue: genderSelection,
                                        onChanged: (value) {
                                          setState(() {
                                            genderSelection = value.toString();
                                          });
                                        },
                                        activeColor: Colors.green),
                                    const Text('Female',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey))
                                  ])),
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
                              ConstantFunctions.showErrorDialog(
                                  'Your Data is uploading!!!',
                                  'Waiting',
                                  Icons.watch_outlined,
                                  context);

                              final imageUrl = await _uploadImageToStorage();

                              if (imageUrl != null) {
                                await _saveUserData(imageUrl);
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminHomeScreen(),
                                  ),
                                );
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          })
                        ])))
          ],
        ));
  }

  Future<void> _saveUserData(String imageUrl) async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        final String uid = user.uid;
        final DocumentReference userDocRef =
            firebaseFirestore.collection('users').doc(uid);

        await userDocRef.update({
          // 'email': user.email,
          // 'role': role,
          // 'userId': user.uid, ... these are already define in the signup page, no need to update these here,
          'imageUrl': imageUrl,
          'name': _nameController.text,
          'bio': _bioController.text,
          'gender': genderSelection.toString(),
        });
      } else {}
    } catch (e) {}
  }
}
