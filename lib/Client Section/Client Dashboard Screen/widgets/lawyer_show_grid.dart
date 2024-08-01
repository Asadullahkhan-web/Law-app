import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/Lawyer%20Details%20And%20Connect%20Screen/lawyer_details_connect_screen.dart';

class LawyerShowGrid extends StatelessWidget {
  const LawyerShowGrid({
    super.key,
    required this.lawyersList,
  });

  final List<Map<String, dynamic>> lawyersList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.8,
      ),
      itemCount: lawyersList.length,
      itemBuilder: (context, index) {
        final lawyer = lawyersList[index];
        final imageUrl =
            lawyer['imageUrl'] ?? ''; // Handle null or empty imageUrl
        final name = lawyer['name'] ?? '';
        final rating = lawyer['rating'] ?? '';
        final isVerified = lawyer['isVerified'] ?? '';
        final category = lawyer['category'];
        final gender = lawyer['gender'] ?? '';
        final usersNumberOfRating = lawyer['numberOfRatings'] ?? '';

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LawyerDetailsAndConnectScreen(
                  // Pass the selected lawyer's details directly
                  lawyerDetailsFuture: Future.value([lawyer]),
                ),
              ),
            );
          },
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 5,
                              ),
                            ) // Placeholder for missing image
                      ),
                  const Divider(),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: isVerified == 'Verified'
                            ? Colors.green
                            : Colors.grey,
                        size: 15.0,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        isVerified == 'Verified' ? 'Verified' : 'Un-Verified',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isVerified == 'Verified'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Gender: $gender',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Rating:',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        ' ${rating.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Color.fromARGB(255, 240, 220, 36),
                      ),
                      Text(
                        '($usersNumberOfRating)',
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                  Text(
                    'Category:$category',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
