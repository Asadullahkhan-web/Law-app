import 'package:flutter/material.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Dashboard%20Screen/lawyer_dashboard_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/lawyer_chat_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Show%20Profile%20Screen/lawyer_show_profile_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Users%20Cases%20Management%20Screen/user_cases_management_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Verification%20Screen/lawyer_verification_screen.dart';

class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({super.key});

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  int _selectedIndex = 0;

  // Define screens for bottom navigation
  final List<Widget> _screens = [
    const LawyerDashboardScreen(),
    const LawyerChatScreen(),
    const UserCaseManagementScreen(),
    const LawyerVerificationScreen(),
    const LawyerShowProfileScreen(),
  ];

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.tealAccent[100], // Background color

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        selectedIconTheme: const IconThemeData(
            color: Colors.green), // Selected item text and icon color
        unselectedItemColor: Colors.grey.shade700
            .withOpacity(0.8), // Unselected item text and icon color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Verification',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Define HomeScreen, LawyerChatScreen, VerificationScreen, and ProfileScreen widgets

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Verification Screen'),
    );
  }
}

/* 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Lawyer%20Section/Cases%20Accept%20&%20Updates%20Screen/new_cases_request_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Dashboard%20Screen/lawyer_dashboard_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Chat%20Screen/lawyer_chat_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Show%20Profile%20Screen/lawyer_show_profile_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Users%20Cases%20Management%20Screen/user_cases_management_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Verification%20Screen/lawyer_verification_screen.dart';

class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({super.key});

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  String? _currentUserUid;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _getCurrentUserUid();
  }

  // Function to get the current user ID
  Future<void> _getCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserUid = user.uid;
        _initializeScreens();
      });
    }
  }

  // Initialize screens for bottom navigation
  void _initializeScreens() {
    _screens = [
      const LawyerDashboardScreen(),
      const LawyerChatScreen(),
      const UserCaseManagementScreen(),
      const LawyerVerificationScreen(),
      const LawyerShowProfileScreen(),
      NewCasesRequestScreen(
        currentUserId: _currentUserUid ??
            '', // Pass current user ID to NewCasesRequestScreen
        receiverId: '', // Set receiver ID as needed
      )
    ];
  }

  int _selectedIndex = 0;

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        selectedIconTheme: const IconThemeData(
          color: Colors.green,
        ),
        unselectedItemColor: Colors.grey.shade700.withOpacity(0.8),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Verification',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

*/