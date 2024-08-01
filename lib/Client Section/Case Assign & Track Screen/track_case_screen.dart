// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lawyers_application/Utilities/utility.dart';

// class TrackCaseScreen extends StatelessWidget {
//   final String docId;

//   const TrackCaseScreen({super.key, required this.docId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Case Progress',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('cases_assigning_request')
//             .doc(docId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.green,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (snapshot.hasData && snapshot.data!.exists) {
//             final responseData = snapshot.data!.data() as Map<String, dynamic>;
//             final percentage = responseData['progressOfCase'];
//             final additionalMessage = responseData['additionalMessage'];
//             final title = responseData['title'];
//             final dateTime = responseData['dateTime'];

//             var isPercentageHundred = responseData['progressOfCase'];

//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: DefaultTextStyle(
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.blueGrey.shade700,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.3,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         color: Color.fromARGB(255, 232, 232, 232),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Title Of the Case:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               title ?? 'No title available',
//                               style: const TextStyle(fontSize: 15),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Divider(
//                               color: Colors.grey.shade400,
//                               indent: 5,
//                               endIndent: 5,
//                             ),
//                             Text(
//                               'Percentage: $percentage%',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             const Text(
//                               'Case Progress in Percentage:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Slider(
//                               value: percentage.toDouble(),
//                               min: 0,
//                               max: 100,
//                               onChanged: null,
//                               divisions: 10,
//                               label: '$percentage%',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Additional Message:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Stack(children: [
//                         Text(
//                           additionalMessage ??
//                               'No additional message available',
//                           style: const TextStyle(fontSize: 16),
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Positioned(
//                             child: Container(
//                           height: Constants.screenHeight(context) * 0.2,
//                           // decoration: ,
//                         ))
//                       ]),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.2),
//                     const Divider(
//                       indent: 30,
//                       endIndent: 30,
//                       color: Colors.blueGrey,
//                     ),
//                     Center(child: Text(dateTime))
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return const Center(
//               child: Text('No response data found'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyers_application/Utilities/utility.dart';

class TrackCaseScreen extends StatelessWidget {
  final String docId;

  const TrackCaseScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Case Progress',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('cases_assigning_request')
            .doc(docId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            final responseData = snapshot.data!.data() as Map<String, dynamic>;
            final percentage = responseData['progressOfCase'];
            final additionalMessage = responseData['additionalMessage'];
            final title = responseData['title'];
            final dateTime = responseData['dateTime'];

            var isPercentageHundred = responseData['progressOfCase'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey.shade700,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color.fromARGB(255, 232, 232, 232),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title Of the Case:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title ?? 'No title available',
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                              indent: 5,
                              endIndent: 5,
                            ),
                            Text(
                              'Percentage: $percentage%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Case Progress in Percentage:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: (percentage ?? 0).toDouble(),
                              min: 0,
                              max: 100,
                              onChanged: null,
                              divisions: 10,
                              label: '${percentage ?? 0}%',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Additional Message:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(children: [
                        Text(
                          additionalMessage ??
                              'Still no progress in this case.',
                          style: const TextStyle(fontSize: 16),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Positioned(
                            child: Container(
                          height: Constants.screenHeight(context) * 0.2,
                          // decoration: ,
                        ))
                      ]),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const Divider(
                      indent: 30,
                      endIndent: 30,
                      color: Colors.blueGrey,
                    ),
                    Center(child: Text(dateTime))
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No response data found'),
            );
          }
        },
      ),
    );
  }
}
