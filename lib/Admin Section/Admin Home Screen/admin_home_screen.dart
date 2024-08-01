// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Dashboard%20Screen/admin_dashboard_screen.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Profile%20Screen/admin_show_profile_screen.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Search%20Lawyers/admin_search_view.dart';
import 'package:lawyers_application/Admin%20Section/Verification%20Screen/admin_verification_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  // Define screens for bottom navigation
  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminSearchView(),
    const AdminVerificationScreen(),
    const AdminShowProfileScreen(),
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
        unselectedItemColor: const Color.fromARGB(255, 95, 105, 109)
            .withOpacity(0.8), // Unselected item text and icon color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'pending lawyer',
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
