// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:lawyers_application/Client%20Section/Add%20Review%20To%20Lawyer/lawyer_review_submittion_screen.dart';
// import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/Lawyer_Call_Screen/video_call_screen.dart';
// import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/Lawyer_Call_Screen/audio_call_screen.dart';
// import 'package:rxdart_ext/not_replay_value_stream.dart';
// import 'package:rxdart/rxdart.dart';

// class EachChatScreen extends StatefulWidget {
//   final String otherUserUid;
//   final dynamic otherUserPersonalDetails;

//   const EachChatScreen({
//     super.key, // Add key parameter to the constructor
//     required this.otherUserUid,
//     required this.otherUserPersonalDetails,
//   });

//   @override
//   _EachChatScreenState createState() => _EachChatScreenState();
// }

// class _EachChatScreenState extends State<EachChatScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();
//   final picker = ImagePicker();
//   File? _image;
//   String? _downloadURL;
//   var documentId = '';

//   Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream() {
//     var currentUserUid = _auth.currentUser!.uid;
//     var otherUserUid = widget.otherUserUid;

//     var documentId = '${currentUserUid}_$otherUserUid';

//     var currentUserDocId = '${currentUserUid}_$otherUserUid';
//     var otherUserDocId = '${otherUserUid}_$currentUserUid';

//     var currentUserStream = FirebaseFirestore.instance
//         .collection('message')
//         .doc(currentUserDocId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     var otherUserStream = FirebaseFirestore.instance
//         .collection('message')
//         .doc(otherUserDocId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     return Rx.concat([currentUserStream, otherUserStream]);
//   }

//   String documentIdOfBothLawyerAndClient() {
//     var currentUserUid = _auth.currentUser!.uid;
//     var otherUserUid = widget.otherUserUid;

//     documentId = '${otherUserUid}_$currentUserUid';
//     return documentId;
//   }

//   @override
//   void initState() {
//     super.initState();
//     documentIdOfBothLawyerAndClient();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Image(
//               height: MediaQuery.of(context).size.height,
//               width: double.infinity,
//               image: const AssetImage('assets/chatBack.jpg'),
//               fit: BoxFit.fill,
//             ),
//             Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.10,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                           ),
//                         ),
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(
//                               widget.otherUserPersonalDetails['imageUrl']),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   LawyerReviewSubmissionScreen(
//                                 lawyerUid: widget.otherUserUid,
//                                 otherPersonalDetails:
//                                     widget.otherUserPersonalDetails,
//                               ),
//                             ));
//                           },
//                           child: Text(
//                             widget.otherUserPersonalDetails['name'],
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.20,
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => AudioCallScreen(
//                                   userId: widget.otherUserUid,
//                                   userName:
//                                       widget.otherUserPersonalDetails['name'],
//                                   callID: documentId,
//                                 ),
//                               ),
//                             );
//                             print('DocumentID====$documentId');
//                           },
//                           icon: const Icon(
//                             Icons.call,
//                             color: Colors.white,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => VideoCallScreen(
//                                   userId: widget.otherUserUid,
//                                   userName:
//                                       widget.otherUserPersonalDetails['name'],
//                                   callID: documentIdOfBothLawyerAndClient(),
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(
//                             Icons.video_call,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: _messageStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.green,
//                           ),
//                         );
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error: ${snapshot.error}'),
//                         );
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text("No messages"));
//                       }

//                       return ListView.builder(
//                         reverse: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           var message = snapshot.data!.docs[index].data();
//                           var timestamp = message['timestamp'] as Timestamp?;
//                           var messageText = message['text'] as String?;
//                           var senderUid = message['sender'] as String;
//                           var image = message['image'] as String?;

//                           // Determine if the message is sent by the current user or not
//                           bool isCurrentUser =
//                               senderUid == _auth.currentUser!.uid;

//                           // Add null check for timestamp
//                           if (timestamp == null) {
//                             return const SizedBox();
//                           }

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 12.0,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: isCurrentUser
//                                   ? CrossAxisAlignment.end
//                                   : CrossAxisAlignment.start,
//                               children: [
//                                 if (messageText != null)
//                                   Container(
//                                     constraints: BoxConstraints(
//                                       maxWidth:
//                                           MediaQuery.of(context).size.width *
//                                               0.85,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isCurrentUser
//                                           ? Colors.blue.shade50
//                                           : Colors.green.shade300,
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Text(
//                                       messageText,
//                                       style: const TextStyle(
//                                         fontSize: 16.0,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 if (image != null)
//                                   Image.network(
//                                     image,
//                                     height: 200,
//                                     width: 200,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 const SizedBox(height: 4.0),
//                                 Text(
//                                   DateFormat.yMd()
//                                       .add_jm()
//                                       .format(timestamp.toDate()),
//                                   style: const TextStyle(
//                                     fontSize: 11.0,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 _buildMessageComposer(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageComposer() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () => showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         ListTile(
//                           leading: const Icon(Icons.camera_alt),
//                           title: const Text('Camera'),
//                           onTap: () {
//                             _getImage(ImageSource.camera);
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.image),
//                           title: const Text('Gallery'),
//                           onTap: () {
//                             _getImage(ImageSource.gallery);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(5.0),
//                   child: Icon(
//                     Icons.camera_alt_outlined,
//                     size: 22,
//                   ),
//                 ),
//               ),
//               if (_image != null)
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _image = null;
//                     });
//                   },
//                   icon: const Icon(Icons.cancel_outlined),
//                 ),
//             ],
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           if (_image != null)
//             Image.memory(
//               _image!.readAsBytesSync(),
//               fit: BoxFit.cover,
//               height: 120,
//               width: 210,
//             )
//           else
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 0, right: 5),
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(30),
//                   shadowColor: Colors.grey,
//                   child: TextFormField(
//                     autovalidateMode: AutovalidateMode.always,
//                     controller: _messageController,
//                     keyboardType: TextInputType.emailAddress,
//                     textAlign: TextAlign.start,
//                     textAlignVertical: TextAlignVertical.center,
//                     cursorColor: const Color(0xFF6789CA),
//                     decoration: const InputDecoration(
//                       contentPadding:
//                           EdgeInsets.only(left: 10, right: 10, bottom: 13),
//                       border: InputBorder.none,
//                       hintText: 'Enter Your Message',
//                       hintStyle: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           const SizedBox(
//             width: 3,
//           ),
//           Container(
//             height: 40,
//             width: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(40),
//               color: Colors.green,
//             ),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.send,
//                 color: Colors.white,
//                 size: 18,
//               ),
//               onPressed: () {
//                 _image != null ? _sendImage() : _sendMessage();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _sendMessage() async {
//     dynamic text = _messageController.text.trim();
//     String senderUid = _auth.currentUser!.uid;
//     String receiverUid = widget.otherUserUid;
//     var otherUserId = receiverUid;
//     var currentUserId = senderUid;
//     documentId = '${currentUserId}_$otherUserId';

//     if (text.isNotEmpty) {
//       _messageController.clear();

//       try {
//         DocumentReference messageRef = FirebaseFirestore.instance
//             .collection('message')
//             .doc(documentId)
//             .collection('messages')
//             .doc();

//         await messageRef.set({
//           'text': text,
//           'sender': senderUid,
//           'receiver': receiverUid,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//       } catch (e) {
//         print('Error sending message: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending message: $e'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _sendImage() async {
//     String? image = _downloadURL!;
//     String senderUid = _auth.currentUser!.uid;
//     String receiverUid = widget.otherUserUid;

//     var otherUserId = receiverUid;
//     var currentUserId = senderUid;
//     documentId = '${currentUserId}_$otherUserId';

//     if (image.isNotEmpty) {
//       try {
//         DocumentReference messageRef = FirebaseFirestore.instance
//             .collection('message')
//             .doc(documentId)
//             .collection('messages')
//             .doc();

//         await messageRef.set({
//           'image': _downloadURL!,
//           'sender': senderUid,
//           'receiver': receiverUid,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         setState(() {
//           _image = null;
//           _downloadURL = null;
//         });
//       } catch (e) {
//         print('Error sending message: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending message: $e'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _uploadImageToStorage();
//       }
//     });
//   }

//   Future<String?> _uploadImageToStorage() async {
//     try {
//       if (_image != null) {
//         // Read the file into memory
//         List<int> imageBytes = await _image!.readAsBytes();

//         // Convert imageBytes to Uint8List
//         Uint8List uint8ListImageBytes = Uint8List.fromList(imageBytes);

//         // Decode the image
//         img.Image image = img.decodeImage(uint8ListImageBytes)!;

//         // Resize the image to desired dimensions
//         img.Image resizedImage = img.copyResize(image, width: 800);

//         // Encode the resized image to bytes
//         List<int> resizedImageBytes = img.encodeJpg(resizedImage);

//         // Convert resizedImageBytes to Uint8List
//         Uint8List uint8ListResizedImageBytes =
//             Uint8List.fromList(resizedImageBytes);

//         // Upload the resized image to Firebase Storage
//         final firebase_storage.Reference ref = firebase_storage
//             .FirebaseStorage.instance
//             .ref()
//             .child('chatsImages/${DateTime.now()}.jpg');

//         final firebase_storage.UploadTask task =
//             ref.putData(uint8ListResizedImageBytes);
//         final firebase_storage.TaskSnapshot snapshot =
//             await task.whenComplete(() {});
//         _downloadURL = await snapshot.ref.getDownloadURL();

//         print('<>DownloadURL : ${_downloadURL.toString()}');
//         return _downloadURL;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }
// }


import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lawyers_application/Client%20Section/Add%20Review%20To%20Lawyer/lawyer_review_submittion_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/Lawyer_Call_Screen/video_call_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/Lawyer_Call_Screen/audio_call_screen.dart';
import 'package:rxdart_ext/not_replay_value_stream.dart';
import 'package:rxdart/rxdart.dart';

class EachChatScreen extends StatefulWidget {
  final String otherUserUid;
  final dynamic otherUserPersonalDetails;

  const EachChatScreen({
    super.key, // Add key parameter to the constructor
    required this.otherUserUid,
    required this.otherUserPersonalDetails,
  });

  @override
  _EachChatScreenState createState() => _EachChatScreenState();
}

class _EachChatScreenState extends State<EachChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final picker = ImagePicker();
  File? _image;
  String? _downloadURL;
  var documentId = '';

  Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream() {
    var currentUserUid = _auth.currentUser!.uid;
    var otherUserUid = widget.otherUserUid;

    var documentId = '${currentUserUid}_$otherUserUid';

    var currentUserDocId = '${currentUserUid}_$otherUserUid';
    var otherUserDocId = '${otherUserUid}_$currentUserUid';

    var currentUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(currentUserDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    var otherUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(otherUserDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Rx.concat([currentUserStream, otherUserStream]);
  }

  String documentIdOfBothLawyerAndClient() {
    var currentUserUid = _auth.currentUser!.uid;
    var otherUserUid = widget.otherUserUid;

    documentId = '${otherUserUid}_$currentUserUid';
    return documentId;
  }

  @override
  void initState() {
    super.initState();
    documentIdOfBothLawyerAndClient();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              image: const AssetImage('assets/chatBack.jpg'),
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              widget.otherUserPersonalDetails['imageUrl']),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  LawyerReviewSubmissionScreen(
                                lawyerUid: widget.otherUserUid,
                                otherPersonalDetails:
                                    widget.otherUserPersonalDetails,
                              ),
                            ));
                          },
                          child: Text(
                            widget.otherUserPersonalDetails['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AudioCallScreen(
                                  userId: widget.otherUserUid,
                                  userName:
                                      widget.otherUserPersonalDetails['name'],
                                  callID: documentId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VideoCallScreen(
                                  userId: widget.otherUserUid,
                                  userName:
                                      widget.otherUserPersonalDetails['name'],
                                  callID: documentIdOfBothLawyerAndClient(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _messageStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No messages"));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var message = snapshot.data!.docs[index].data();
                          var timestamp = message['timestamp'] as Timestamp?;
                          var messageText = message['text'] as String?;
                          var senderUid = message['sender'] as String;
                          var image = message['image'] as String?;

                          // Determine if the message is sent by the current user or not
                          bool isCurrentUser =
                              senderUid == _auth.currentUser!.uid;

                          // Add null check for timestamp
                          if (timestamp == null) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (messageText != null)
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.85,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? Colors.blue.shade50
                                          : Colors.green.shade300,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      messageText,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                if (image != null)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                            imageUrl: image,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 4.0),
                                Text(
                                  DateFormat.yMd()
                                      .add_jm()
                                      .format(timestamp.toDate()),
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildMessageComposer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            _getImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Gallery'),
                          onTap: () {
                            _getImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    );
                  },
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 22,
                  ),
                ),
              ),
              if (_image != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          if (_image != null)
            Image.memory(
              _image!.readAsBytesSync(),
              fit: BoxFit.cover,
              height: 120,
              width: 250,
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 5),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: Colors.grey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: _messageController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: const Color(0xFF6789CA),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 10, right: 10, bottom: 13),
                      border: InputBorder.none,
                      hintText: 'Enter Your Message',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 3,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.green,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                _image != null ? _sendImage() : _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    dynamic text = _messageController.text.trim();
    String senderUid = _auth.currentUser!.uid;
    String receiverUid = widget.otherUserUid;
    var otherUserId = receiverUid;
    var currentUserId = senderUid;
    documentId = '${currentUserId}_$otherUserId';

    if (text.isNotEmpty) {
      _messageController.clear();

      try {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('message')
            .doc(documentId)
            .collection('messages')
            .doc();

        await messageRef.set({
          'text': text,
          'sender': senderUid,
          'receiver': receiverUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _sendImage() async {
    String? image = _downloadURL!;
    String senderUid = _auth.currentUser!.uid;
    String receiverUid = widget.otherUserUid;

    var otherUserId = receiverUid;
    var currentUserId = senderUid;
    documentId = '${currentUserId}_$otherUserId';

    if (image.isNotEmpty) {
      try {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('message')
            .doc(documentId)
            .collection('messages')
            .doc();

        await messageRef.set({
          'image': _downloadURL!,
          'sender': senderUid,
          'receiver': receiverUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _image = null;
          _downloadURL = null;
        });
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImageToStorage();
      }
    });
  }

  Future<String?> _uploadImageToStorage() async {
    try {
      if (_image != null) {
        // Read the file into memory
        List<int> imageBytes = await _image!.readAsBytes();

        // Convert imageBytes to Uint8List
        Uint8List uint8ListImageBytes = Uint8List.fromList(imageBytes);

        // Decode the image
        img.Image image = img.decodeImage(uint8ListImageBytes)!;

        // Resize the image to desired dimensions
        img.Image resizedImage = img.copyResize(image, width: 800);

        // Encode the resized image to bytes
        List<int> resizedImageBytes = img.encodeJpg(resizedImage);

        // Convert resizedImageBytes to Uint8List
        Uint8List uint8ListResizedImageBytes =
            Uint8List.fromList(resizedImageBytes);

        // Upload the resized image to Firebase Storage
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('chatsImages/${DateTime.now()}.jpg');

        final firebase_storage.UploadTask task =
            ref.putData(uint8ListResizedImageBytes);
        final firebase_storage.TaskSnapshot snapshot =
            await task.whenComplete(() {});
        _downloadURL = await snapshot.ref.getDownloadURL();
        return _downloadURL;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

