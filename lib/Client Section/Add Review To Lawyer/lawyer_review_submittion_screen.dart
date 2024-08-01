import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawyers_application/Client%20Section/Case%20Assign%20&%20Track%20Screen/assign_case_screen.dart';
import 'package:lawyers_application/Client%20Section/Case%20Assign%20&%20Track%20Screen/track_case_screen.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';

class LawyerReviewSubmissionScreen extends StatefulWidget {
  const LawyerReviewSubmissionScreen({
    super.key,
    required this.lawyerUid,
    required this.otherPersonalDetails,
  });

  final lawyerUid;
  final otherPersonalDetails;

  @override
  State<LawyerReviewSubmissionScreen> createState() =>
      _LawyerReviewSubmissionScreenState();
}

class _LawyerReviewSubmissionScreenState
    extends State<LawyerReviewSubmissionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController reviewController = TextEditingController();
  var ratingValue;
  bool checkReview = false;
  double lawyerRating = 0;

  @override
  void initState() {
    super.initState();
    checkReviewExists();
    fetchRating();
  }

  Future<void> checkReviewExists() async {
    String currentUserId = _auth.currentUser!.uid;
    String lawyerId = widget.lawyerUid;

    DocumentSnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(lawyerId)
        .collection('reviews')
        .doc(currentUserId)
        .get();

    setState(() {
      checkReview = reviewSnapshot.exists;
    });
  }

  Future<void> fetchRating() async {
    DocumentSnapshot lawyerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.lawyerUid)
        .get();

    if (lawyerSnapshot.exists) {
      setState(() {
        lawyerRating = lawyerSnapshot['rating'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.green),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Expanded(
                    child: Center(
                      child: Text(
                        !checkReview ? 'Add Review' : 'Submitted',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      // Perform navigation based on the selected value
                      if (value == 'AssignCase') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssignCaseScreen(
                                    currentUserId: _auth.currentUser!.uid,
                                    receiverId: widget.lawyerUid,
                                  )),
                        );
                      } else if (value == 'TrackCase') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            String currentUserId = _auth.currentUser!.uid;
                            String OtherUserId = widget.lawyerUid;

                            String docId = '${currentUserId}_$OtherUserId';

                            return TrackCaseScreen(docId: docId);
                          }),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'AssignCase',
                        child: Text('Assign Case'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'TrackCase',
                        child: Text('Track Your Case'),
                      ),
                    ],
                    child: const Icon(
                      Icons.menu_open_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          Column(
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: UserProfileService().getCurrentUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 2,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final userProfileData = snapshot.data!;
                    return Column(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(60)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                userProfileData['imageUrl'] ??
                                    'assets/profile.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          userProfileData['name'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade700),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Rate the care provided of your lawyer's",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueGrey.shade700),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              checkReview
                  ? Column(
                      children: [
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: lawyerRating,
                            minRating: 1,
                            maxRating: 5,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 228, 205, 3),
                            ),
                            onRatingUpdate: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.lawyerUid)
                              .collection('reviews')
                              .doc(_auth.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data!['review'],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ));
                            }
                            return const Text('No data found');
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: RatingBar.builder(
                            minRating: 1,
                            maxRating: 5,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 228, 205, 3),
                            ),
                            onRatingUpdate: (value) {
                              ratingValue = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 200,
                            constraints: const BoxConstraints(
                                maxHeight: 200, maxWidth: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ]),
                            child: TextFormField(
                              controller: reviewController,
                              cursorColor: Colors.blueGrey,
                              maxLines: 7,
                              maxLength: 120,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Additional Comments...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              reviewButton(Colors.white, 'Not Now', () {
                                Navigator.pop(context);
                              }),
                              reviewButton(Colors.green, 'Submit Review', () {
                                LawyerService().submitRating(
                                    widget.lawyerUid, ratingValue);
                                submitReview(widget.lawyerUid,
                                    reviewController.text, ratingValue);
                                reviewController.clear();
                              }),
                            ],
                          ),
                        )
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchCurrentUserFields() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = {
          'name': userSnapshot['name'],
          'imageUrl': userSnapshot['imageUrl'],
        };

        return userData;
      } else {
        return {};
      }
    } catch (error) {
      print('Error fetching current user fields: $error');
      return {};
    }
  }

  Future<void> submitReview(
      String lawyerId, String review, dynamic rating) async {
    try {
      Map<String, dynamic> currentUserData = await fetchCurrentUserFields();
      String name = currentUserData['name'];
      var imageUrl = currentUserData['imageUrl'];
      String currentUserUid = _auth.currentUser!.uid;
      DocumentReference reviewsCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(lawyerId)
          .collection('reviews')
          .doc(currentUserUid);

      DocumentSnapshot reviewSnapshot = await reviewsCollectionRef.get();
      if (reviewSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your review has already been submitted!')));
      } else {
        await reviewsCollectionRef.set({
          'review': review,
          'rating': ratingValue,
          'reviewByUser': name,
          'reviewUserImage': imageUrl,
          'timeOfsubmitt': DateTime.now(),
        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review submitted successfully!'))));
      }
    } catch (error) {
      print('Error submitting review: $error');
    }
  }

  Widget reviewButton(Color color, var buttonName, var ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        child: Center(
          child: Text(buttonName),
        ),
      ),
    );
  }
}

class LawyerService {
  Future<void> submitRating(String lawyerId, var newRating) async {
    try {
      DocumentReference lawyerDocRef =
          FirebaseFirestore.instance.collection('users').doc(lawyerId);

      DocumentSnapshot lawyerSnapshot = await lawyerDocRef.get();
      Map<String, dynamic>? lawyerData =
          lawyerSnapshot.data() as Map<String, dynamic>?;

      var currentRating = lawyerData?['rating'] ?? 0;
      var numberOfRatings = lawyerData?['numberOfRatings'] ?? 0;
      var newAverageRating =
          (currentRating * numberOfRatings + newRating) / (numberOfRatings + 1);

      await lawyerDocRef.update({
        'rating': newAverageRating,
        'numberOfRatings': numberOfRatings + 1,
      });
    } catch (error) {
      print('Error submitting rating: $error');
    }
  }
}
