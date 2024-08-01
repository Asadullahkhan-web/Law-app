import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileBioReadScreen extends StatefulWidget {
  const ProfileBioReadScreen({super.key, required this.bio});

  final String bio;

  @override
  State<ProfileBioReadScreen> createState() => _ProfileBioReadScreenState();
}

class _ProfileBioReadScreenState extends State<ProfileBioReadScreen> {
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.bio));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'User-Bio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onLongPress: _copyToClipboard,
                child: Text(
                  widget.bio,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
