import 'package:flutter/material.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/client_dashboard_screen.dart';
import 'package:lawyers_application/Client%20Section/Client%20Chat%20Screen/client_chat_screen.dart';
import 'package:lawyers_application/Client%20Section/Search%20Lawyers/search_lawyer_screen.dart';
import 'package:lawyers_application/Client%20Section/Profile%20Screen/client_show_profile_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;

  // Define screens for bottom navigation
  final List<Widget> _screens = [
    const ClientDashboardScreen(),
    const ClientChatScreen(),
    const SearchView(),
    const ClientShowProfileScreen(),
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
            icon: Icon(Icons.mail),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Lawyer',
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

// Define HomeScreen, InboxScreen, VerificationScreen, and ProfileScreen widgets


