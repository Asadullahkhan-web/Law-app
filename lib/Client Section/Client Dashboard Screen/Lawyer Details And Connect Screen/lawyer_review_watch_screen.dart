// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:lawyers_application/Utilities/utility.dart';

// class LawyerReviewWatchScreen extends StatefulWidget {
//   const LawyerReviewWatchScreen({super.key, required this.lawyerDetailsFuture});

//   final dynamic lawyerDetailsFuture;

//   @override
//   State<LawyerReviewWatchScreen> createState() =>
//       _LawyerReviewWatchScreenState();
// }

// class _LawyerReviewWatchScreenState extends State<LawyerReviewWatchScreen> {
//   var lawyerId;
//   String lawyerName = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 230, 230, 230),
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         title: const Text(
//           "Reviews",
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.lawyerDetailsFuture)
//             .collection('reviews')
//             .orderBy('timeOfsubmitt', descending: false)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: Colors.green,
//             ));
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No reviews found'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var review =
//                     snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                 // Ensure that review is not null before accessing its properties
//                 return ReviewTile(
//                   rating: review['rating'],
//                   reviewerName: review['reviewByUser'],
//                   review: review['review'],
//                   imageUrl: review['reviewUserImage'],
//                   timeOfsubmitt: review['timeOfsubmitt'] as Timestamp,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ReviewTile extends StatelessWidget {
//   final String review;
//   final String reviewerName;
//   final dynamic rating;
//   final dynamic imageUrl;
//   final dynamic timeOfsubmitt;

//   const ReviewTile({
//     super.key,
//     required this.review,
//     required this.reviewerName,
//     required this.rating,
//     required this.imageUrl,
//     required this.timeOfsubmitt,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String hour = (timeOfsubmitt.toDate().hour % 12).toString().padLeft(2, '0');
//     String minute = timeOfsubmitt.toDate().minute.toString().padLeft(2, '0');
//     String period = timeOfsubmitt.toDate().hour >= 12 ? 'PM' : 'AM';
//     if (hour == '00') hour = '12'; // Special case when hour is 0, show it as 12
//     String formattedTime =
//         "$hour:$minute $period\n${timeOfsubmitt.toDate().day}/${timeOfsubmitt.toDate().month}/${timeOfsubmitt.toDate().year} ";

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: Container(
//         width: Constants.screenWidth(context) * 0.80,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.green, width: 2),
//                     borderRadius: BorderRadius.circular(70)),
//                 child: CircleAvatar(
//                   maxRadius: 25,
//                   backgroundImage: NetworkImage(imageUrl),
//                 ),
//               ),
//               title: Text(reviewerName),
//               subtitle: IgnorePointer(
//                 ignoring: true, // This makes the child widget non-interactive
//                 child: RatingBar.builder(
//                   itemSize: 15,
//                   initialRating: rating.toDouble(), // Convert rating to double
//                   minRating: 1,
//                   maxRating: 5,
//                   allowHalfRating: false,
//                   itemCount: 5,
//                   itemBuilder: (context, index) => const Icon(
//                     Icons.star,
//                     color: Color.fromARGB(255, 231, 187, 8),
//                   ),
//                   onRatingUpdate: (value) {},
//                 ),
//               ),
//               trailing: Text(
//                 formattedTime,
//                 style: const TextStyle(fontSize: 9),
//               ), // Display formatted time here
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Statement:',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   Text(
//                     review,
//                     style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawyers_application/Utilities/utility.dart';

class LawyerReviewWatchScreen extends StatefulWidget {
  const LawyerReviewWatchScreen({super.key, required this.lawyerDetailsFuture});

  final dynamic lawyerDetailsFuture;

  @override
  State<LawyerReviewWatchScreen> createState() =>
      _LawyerReviewWatchScreenState();
}

class _LawyerReviewWatchScreenState extends State<LawyerReviewWatchScreen> {
  var lawyerId;
  String lawyerName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          "Reviews",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.lawyerDetailsFuture)
            .collection('reviews')
            .orderBy('timeOfsubmitt', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var review =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                dynamic timeOfsubmittRaw =
                    review['timeOfsubmitt']; // Retrieve the raw value
                Timestamp timeOfsubmitt;
                if (timeOfsubmittRaw is Timestamp) {
                  // If it's already a Timestamp, no conversion needed
                  timeOfsubmitt = timeOfsubmittRaw;
                } else if (timeOfsubmittRaw is int) {
                  // If it's an integer, convert it to a Timestamp
                  timeOfsubmitt =
                      Timestamp.fromMillisecondsSinceEpoch(timeOfsubmittRaw);
                } else {
                  timeOfsubmitt = Timestamp.now(); // Example default value
                }
                return ReviewTile(
                  rating: review['rating'],
                  reviewerName: review['reviewByUser'],
                  review: review['review'],
                  imageUrl: review['reviewUserImage'],
                  timeOfsubmitt: timeOfsubmitt,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String review;
  final String reviewerName;
  final dynamic rating;
  final dynamic imageUrl;
  final Timestamp timeOfsubmitt;

  const ReviewTile({
    super.key,
    required this.review,
    required this.reviewerName,
    required this.rating,
    required this.imageUrl,
    required this.timeOfsubmitt,
  });

  @override
  Widget build(BuildContext context) {
    String hour = (timeOfsubmitt.toDate().hour % 12).toString().padLeft(2, '0');
    String minute = timeOfsubmitt.toDate().minute.toString().padLeft(2, '0');
    String period = timeOfsubmitt.toDate().hour >= 12 ? 'PM' : 'AM';
    if (hour == '00') hour = '12'; // Special case when hour is 0, show it as 12
    String formattedTime =
        "$hour:$minute $period\n${timeOfsubmitt.toDate().day}/${timeOfsubmitt.toDate().month}/${timeOfsubmitt.toDate().year} ";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        width: Constants.screenWidth(context) * 0.80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(70)),
                child: CircleAvatar(
                  maxRadius: 25,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              title: Text(reviewerName),
              subtitle: IgnorePointer(
                ignoring: true, // This makes the child widget non-interactive
                child: RatingBar.builder(
                  itemSize: 15,
                  initialRating: rating.toDouble(), // Convert rating to double
                  minRating: 1,
                  maxRating: 5,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 231, 187, 8),
                  ),
                  onRatingUpdate: (value) {},
                ),
              ),
              trailing: Text(
                formattedTime,
                style: const TextStyle(fontSize: 9),
              ), // Display formatted time here
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statement:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    review,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
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
