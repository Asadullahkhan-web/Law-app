import 'package:flutter/material.dart';

class ZoomedImageScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ZoomedImageScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          'Profile Image',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Hero(
          transitionOnUserGestures: true,
          tag: heroTag, // Use the same tag as in the ListView.builder
          child: GestureDetector(
            onTap: () {
              Navigator.pop(
                  context); // Close the zoomed-in image screen when tapped
            },
            child: Image.network(imageUrl), // Show the image
          ),
        ),
      ),
    );
  }
}
