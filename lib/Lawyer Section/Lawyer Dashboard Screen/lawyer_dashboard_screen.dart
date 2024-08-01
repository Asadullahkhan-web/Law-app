import 'package:flutter/material.dart';
import 'package:lawyers_application/Authentication/Widgets/login_signup_button_widget.dart';
import 'package:lawyers_application/Common%20Resources/Widgets/reuseContainer.dart';
import 'package:lawyers_application/Common%20Resources/user_profile_services.dart';
import 'package:lawyers_application/Lawyer%20Section/Users%20Cases%20Management%20Screen/user_cases_management_screen.dart';
import 'package:lawyers_application/Utilities/constants.dart';
import 'package:lawyers_application/Utilities/utility.dart';
import 'package:pie_chart/pie_chart.dart';

class LawyerDashboardScreen extends StatefulWidget {
  const LawyerDashboardScreen({super.key});

  @override
  State<LawyerDashboardScreen> createState() => _LawyerDashboardScreenState();
}

class _LawyerDashboardScreenState extends State<LawyerDashboardScreen> {
  final UserProfileService _profileService = UserProfileService();
  Map<String, dynamic> _userData = {};
  int totalCases = 0;
  int successfulCases = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData =
          await _profileService.getCurrentUserData();
      setState(() {
        _userData = userData;
        totalCases = _userData['totalCases'] ?? 0;
        successfulCases = _userData['successfulCases'] ?? 0;
      });
    } catch (e) {
      // Handle errors here
    }
  }

  int calculateProgressiveCases(int totalCases, int successfulCases) {
    return totalCases - successfulCases;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.width / 1,
                      child: PieChart(
                        dataMap: <String, double>{
                          'Total Cases': totalCases.toDouble(),
                          'Progressive Cases': calculateProgressiveCases(
                                  totalCases, successfulCases)
                              .toDouble(),
                          'Successful Cases': successfulCases.toDouble(),
                        },
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left,
                        ),
                        chartRadius: MediaQuery.of(context).size.width / 3,
                        chartType: ChartType.ring,
                        animationDuration: const Duration(seconds: 1),
                        colorList: const [
                          Colors.grey,
                          Colors.blue,
                          Colors.green
                        ],
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Constants.screenHeight(context) * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reuseContainer(
                  name: 'Total Cases',
                  value: '$totalCases',
                  height: 0.1,
                  width: 0.2,
                  context: context),
              const SizedBox(width: 10),
              reuseContainer(
                  name: 'Progressive Cases',
                  value:
                      '${calculateProgressiveCases(totalCases, successfulCases)}',
                  context: context,
                  height: 0.1,
                  width: 0.2),
            ],
          ),
          SizedBox(height: Constants.screenHeight(context) * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.screenWidth(context) * 0.02),
            child: reuseContainer(
                name: 'Successful Cases',
                value: '$successfulCases',
                context: context,
                height: 0.1,
                width: 0.0),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          loginAndSignUpButtonWidget(
            'Manage User Cases',
            () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UserCaseManagementScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
