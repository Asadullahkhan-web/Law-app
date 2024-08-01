// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/Lawyer%20Details%20And%20Connect%20Screen/lawyer_details_connect_screen.dart';

class ClientSearchByCategoryScreen extends StatefulWidget {
  const ClientSearchByCategoryScreen({
    super.key,
    required this.lawyerDetailsFuture,
    required this.appBarTitle,
  });

  final Future<List<Map<String, dynamic>>?> lawyerDetailsFuture;
  final appBarTitle;

  @override
  State<ClientSearchByCategoryScreen> createState() =>
      _ClientSearchByCategoryScreenState();
}

class _ClientSearchByCategoryScreenState
    extends State<ClientSearchByCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.appBarTitle} lawyers',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: widget.lawyerDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading, show a loading indicator
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // If data is available, display the list of lawyer details
            List<Map<String, dynamic>> lawyerDetailsList = snapshot.data!;
            return ListView.builder(
              itemCount: lawyerDetailsList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> lawyerDetails = lawyerDetailsList[index];
                String isVerified = lawyerDetails['isVerified'].toString();

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LawyerDetailsAndConnectScreen(
                              // Pass the selected lawyer's details as a list with a single item
                              lawyerDetailsFuture: Future.value([
                                lawyerDetailsList[index],
                              ]),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.green.shade200, width: 2),
                              borderRadius: BorderRadius.circular(25)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              lawyerDetails['imageUrl'] ?? 'No Image',
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(lawyerDetails['name']),
                            if (isVerified == 'Verified')
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 15.0,
                              ),
                            if (isVerified == 'Un-Verified')
                              const Icon(
                                Icons.verified,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            if (isVerified == 'null')
                              const Icon(
                                Icons.verified,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                            if (isVerified == "")
                              const Icon(
                                Icons.verified,
                                color: Colors.grey,
                                size: 15.0,
                              ),
                          ],
                        ),
                        subtitle: Text(
                          lawyerDetails['gender'],
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Rating',
                              style: TextStyle(fontSize: 8),
                            ),
                            Text(
                              '${double.parse(lawyerDetails['rating'].toString()).toStringAsFixed(1)}⭐',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // If no data is available, display a message indicating no lawyer details found
            return const Center(child: Text('No lawyer In current category.'));
          }
        },
      ),
    );
  }
}
