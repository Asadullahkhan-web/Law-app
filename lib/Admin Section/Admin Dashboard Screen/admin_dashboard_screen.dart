import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyers_application/Common%20Resources/Widgets/reuseContainer.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';
import 'package:lawyers_application/Utilities/constants.dart';
import 'package:lawyers_application/Utilities/utility.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserProfileService _profileService = UserProfileService();
  Map<String, dynamic> _userData = {};
  int _totalLawyers = 0;
  int _totalClients = 0;
  int _totalLawyersCases = 0;
  int _totalSuccessfulLawyersCases = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getUsersCount();
    _getLawyersCases();
  }

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

  Future<void> _getUsersCount() async {
    try {
      final lawyersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Lawyer')
          .get();
      setState(() {
        _totalLawyers = lawyersSnapshot.docs.length;
      });

      final clientsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Client')
          .get();
      setState(() {
        _totalClients = clientsSnapshot.docs.length;
      });
    } catch (error) {
      //
    }
  }

  Future<void> _getLawyersCases() async {
    try {
      QuerySnapshot<Map<String, dynamic>> lawyersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'Lawyer')
              .get();
      int totalCases = 0;
      int successfulCases = 0;

      for (var doc in lawyersSnapshot.docs) {
        if (doc.data().containsKey('totalCases')) {
          int cases = doc['totalCases'] ?? 0;

          totalCases += cases;
        }
      }
      for (var doc in lawyersSnapshot.docs) {
        if (doc.data().containsKey('successfulCases')) {
          int successCases = doc['successfulCases'] ?? 0;
          successfulCases += successCases;
        }
      }

      setState(() {
        _totalLawyersCases = totalCases;
        _totalSuccessfulLawyersCases = successfulCases;
      });
    } catch (error) {
      //
    }
  }

  int calculateProgressiveCases(int totalCases, int successfulCases) {
    return totalCases - successfulCases;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
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
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_userData['imageUrl']),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: Constants.screenHeight(context) * 0.3,
                width: Constants.screenWidth(context) * 0.48,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    child: PieChart(
                      dataMap: <String, double>{
                        'Total Lawyers': _totalLawyers.toDouble(),
                        'Total Clients': _totalClients.toDouble(),
                      },
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.left,
                      ),
                      chartRadius: MediaQuery.of(context).size.width / 3,
                      chartType: ChartType.ring,
                      animationDuration: const Duration(seconds: 1),
                      colorList: const [Colors.green, Colors.blue],
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reuseContainer(
                name: 'Total Lawyers',
                value: '$_totalLawyers',
                height: 0.1,
                width: 0.225,
                context: context,
              ),
              const SizedBox(
                width: 10,
              ),
              reuseContainer(
                name: 'Total Clients',
                value: '$_totalClients',
                height: 0.1,
                width: 0.225,
                context: context,
              ),
            ],
          ),
          SizedBox(
            height: Constants.screenHeight(context) * 0.020,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reuseContainer(
                name: 'Total Cases',
                value: '$_totalLawyersCases',
                height: 0.1,
                width: 0.225,
                context: context,
              ),
              const SizedBox(
                width: 10,
              ),
              reuseContainer(
                  name: 'Total Progress cases',
                  value:
                      '${calculateProgressiveCases(_totalLawyersCases, _totalSuccessfulLawyersCases)}',
                  height: 0.1,
                  width: 0.225,
                  context: context)
            ],
          ),
          SizedBox(
            height: Constants.screenHeight(context) * 0.025,
          ),
          reuseContainer(
            context: context,
            name: 'Total Successful Cases',
            value: '$_totalSuccessfulLawyersCases',
            height: 0.1,
            width: 0.47,
          ),
          SizedBox(
            height: Constants.screenHeight(context) * 0.1,
          ),
        ],
      ),
    );
  }
}
