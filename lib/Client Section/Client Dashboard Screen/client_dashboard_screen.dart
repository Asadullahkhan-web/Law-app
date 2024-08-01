import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Search%20Lawyers/zoom_lawyer_image.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/Client%20Search%20By%20Category/client_search_by_category_screen.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/widgets/lawyer_show_grid.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';
import 'package:lawyers_application/Utilities/constants.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  final UserProfileService _profileService = UserProfileService();
  Map<String, dynamic> _userData = {};
  final List<String> categories = [
    'criminal',
    'business',
    'family',
    'immigration',
    'tax',
    'intellectual_property',
  ];

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData =
          await _profileService.getCurrentUserData();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      // Handle errors here
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${_userData['name'] ?? ''}', style: appBarTitleStyle),
            const Text("Welcome to Legal Ease", style: appBarSubTitleStyle),
          ],
        ),
        actions: [
          if (_userData.isNotEmpty && _userData['imageUrl'] != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ZoomedImageScreen(
                        imageUrl: _userData['imageUrl'],
                        heroTag: 'bounce',
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_userData['imageUrl']),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search lawyers by category...',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categories.length, (index) {
                        final category = categories[index];
                        final imageURL = getCategoryImageURL(category);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              fetchLawyersDetails(category);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClientSearchByCategoryScreen(
                                    lawyerDetailsFuture:
                                        fetchLawyersDetails(category),
                                    appBarTitle: category,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.network(
                                    imageURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    category,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Lawyers',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: fetchAllLawyersDetailsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final List<Map<String, dynamic>> lawyersList =
                              snapshot.data!;
                          return LawyerShowGrid(lawyersList: lawyersList);
                        } else {
                          return const Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCategoryImageURL(String category) {
    switch (category) {
      case 'criminal':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5Om8hQOAMAbMmO0hCy17HSjIAMZmyN-4qGyvmf0QrS-jKtd9uJm8TO_TpsXnbGDmLTfA&usqp=CAU';
      case 'business':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoJKRXzIfLUNabbxfvPjvubD6uQl2nOVd9MQ&s';
      case 'family':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKdauqBeRfhDHlenYsC_8jashIXFscUnUnqbeugTGYpA&s';
      case 'immigration':
        return 'https://c8.alamy.com/comp/2RCR4YE/vintage-green-color-round-label-banner-with-word-immigration-on-white-background-2RCR4YE.jpg';
      case 'tax':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKtCbYauAOTzqKoxVN4VJivFgbqWdl37zU_acADTUWpQ&s';
      case 'intellectual_property':
        return 'https://banner2.cleanpng.com/20180215/heq/kisspng-lawyer-law-office-of-michael-robert-cerrie-law-fir-blind-justice-tattoo-5a864b086adc06.1751761615187504724377.jpg';
      default:
        return '';
    }
  }

  Future<List<Map<String, dynamic>>?> fetchLawyersDetails(
      clientSearchCategory) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Lawyer')
          .where('category', arrayContains: clientSearchCategory)
          .get();

      List<Map<String, dynamic>> lawyersList = [];

      for (var doc in querySnapshot.docs) {
        lawyersList.add(doc.data() as Map<String, dynamic>);
      }

      return lawyersList;
    } catch (e) {
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> fetchAllLawyersDetailsStream() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Lawyer')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}
