import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyers_application/Client%20Section/Client%20Dashboard%20Screen/Lawyer%20Details%20And%20Connect%20Screen/lawyer_details_connect_screen.dart';
import 'package:lawyers_application/Common%20Resources/Services/get_lawyers_details.dart';

class AdminSearchView extends StatefulWidget {
  const AdminSearchView({super.key});

  @override
  _AdminSearchViewState createState() => _AdminSearchViewState();
}

class _AdminSearchViewState extends State<AdminSearchView> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _lawyersStream;
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchQuery = '';
    _lawyersStream = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Lawyer')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: SizedBox(
          height: 40,
          width: 400,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search your Lawyer',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _lawyersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final lawyers = snapshot.data!.docs;
            final filteredLawyers = lawyers.where((lawyer) {
              final name = (lawyer.data() as Map<String, dynamic>)['name'];
              return name.toString().toLowerCase().contains(_searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredLawyers.length,
              itemBuilder: (context, index) {
                final lawyerData =
                    filteredLawyers[index].data() as Map<String, dynamic>;
                String isVerified = lawyerData['isVerified'].toString();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FutureBuilder<List<Map<String, dynamic>>>(
                          future: getLawyerDetails(lawyerData['userId']),
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
                                child: Text('Restart App: ${snapshot.error}'),
                              );
                            } else {
                              return LawyerDetailsAndConnectScreen(
                                lawyerDetailsFuture:
                                    Future.value(snapshot.data),
                              );
                            }
                          },
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
                          lawyerData['imageUrl'] ?? 'No Image',
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(lawyerData['name']),
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
                      lawyerData['gender'],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                          '${double.parse(lawyerData['rating'].toString()).toStringAsFixed(1)}⭐',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
