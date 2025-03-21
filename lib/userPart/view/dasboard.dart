import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/helper.dart';
import '../core/routes.dart';
import '../domain/sharedPre.dart';
import '../models/hive_series_model.dart';
import '../repostory/localDb_repository.dart';
import '../widgets/internetchecker.dart';
import '../widgets/seriesWideget.dart';
import 'custom_drawer.dart';

class UserDasboard extends StatefulWidget {
  const UserDasboard({super.key});

  @override
  State<UserDasboard> createState() => _UserDasboardState();
}

class _UserDasboardState extends State<UserDasboard> {
  @override
  String? userName;
  String? userEmail;
  String? profilePicUrl;
  List<SeriesModel> seriesList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInternet();
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName = await SharedPrefs().getName();
    userEmail = await SharedPrefs().getEmail();
    profilePicUrl = await SharedPrefs().getImage();
    setState(() {});
  }

  void _checkInternet() {
    final internetService =
        Provider.of<InternetService>(context, listen: false);

    if (!InternetService.isInternetAvailable) {
      showCustomToast(
          message: 'online mode is active',
          color: AppColor.redColor.withOpacity(0.9),
          context);
    }

    // Listen for future changes in connectivity
    internetService.addListener(() {
      if (!InternetService.isInternetAvailable) {
        showCustomToast(
            message: 'Offline mode active',
            color: AppColor.theme.withOpacity(0.9),
            context);
      }
      readDataFromHive();
    });
  }

  Future<void> readDataFromHive() async {
    HiveRepository hiveRepository = HiveRepository();
    List<SeriesModel> storedData = await hiveRepository.getSeriesData();

    setState(() {
      seriesList = storedData;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      drawer: CustomDrawer(
        userName: userName.toString(),
        userEmail: userEmail.toString(),
        profilePicUrl: profilePicUrl.toString(), // Pass a URL if available
      ),
      appBar: AppBar(
        title: Text('Mock Series '),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: !InternetService.isInternetAvailable
            ? Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: seriesList.isEmpty
                    ? const Center(child: Text("No Data Found"))
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Wrap(
                            spacing: 20.0, // Horizontal spacing
                            runSpacing: 20.0, // Vertical spacing
                            children: List.generate(seriesList.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.subjectMockList,
                                    arguments: {
                                      'subjectName':
                                          seriesList[index].subjectName,
                                      'index': index,
                                    },
                                  );
                                },
                                child: CustomSeriesWidget(
                                    subject: seriesList[index].subjectName),
                              );
                            }),
                          ),
                        ),
                      ),
              )
            : StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('series').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Folders Added'));
                  }
                  for (var doc in snapshot.data!.docs) {
                    print("🔥 Series Data: ${doc.data()}");
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ), // Add padding around the grid
                    child: Wrap(
                      spacing: 20.0, // Horizontal spacing between items
                      runSpacing: 20.0, // Vertical spacing between rows
                      children:
                          snapshot.data!.docs.asMap().entries.map((entry) {
                        int index = entry.key; // Extract the index
                        var doc = entry.value; // Extract the document

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.subjectMockList,
                              arguments: {
                                'subjectName': doc['name'],
                                'index': index,
                              },
                            );
                          },
                          child: CustomSeriesWidget(subject: doc['name']),
                        );
                      }).toList(), // Convert the mapped widgets to a list
                    ),
                  );
                },
              ),
      ),
    );
  }
}
