import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/sharedPre.dart';
import '../handleNavi/MockNavi.dart';
import '../models/hive_series_model.dart';
import '../repostory/localDb_repository.dart';
import '../widgets/internetchecker.dart';
import '../widgets/mockContainer.dart';

class Subjectmocklist extends StatefulWidget {
  final String subjectName;
  final int index;

  Subjectmocklist({required this.subjectName, required this.index});

  @override
  _SubjectmocklistState createState() => _SubjectmocklistState();
}

class _SubjectmocklistState extends State<Subjectmocklist> {
  String? userEmail;
  List<MockModel> mocks = [];

  @override
  void initState() {
    super.initState();
    fetchMocks();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    String? email = await SharedPrefs().getEmail();
    if (mounted) {
      setState(() {
        userEmail = email;
      });
    }
  }

  Future<void> fetchMocks() async {
    HiveRepository hiveRepository = HiveRepository();
    List<SeriesModel> storedData = await hiveRepository.getSeriesData();

    if (widget.index < storedData.length) {
      setState(() {
        mocks = storedData[widget.index].mocks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in InternetService
    final internetService = context.watch<InternetService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} - Mocks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: InternetService.isInternetAvailable
          ? _buildOnlineContent()
          : _buildOfflineContent(),
    );
  }

  Widget _buildOnlineContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('series')
          .doc(widget.subjectName)
          .collection('mocks')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Upcoming Soon!'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final docData = doc.data() as Map<String, dynamic>;
            final mockTestName = docData['name'];
            final bool isPaid = docData['paid'] ?? false;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userEmail)
                  .collection(widget.subjectName)
                  .doc(mockTestName)
                  .get(),
              builder: (context, scoreSnapshot) {
                double score = 0.0;
                if (scoreSnapshot.connectionState == ConnectionState.done &&
                    scoreSnapshot.hasData &&
                    scoreSnapshot.data!.exists) {
                  final scoreData =
                      scoreSnapshot.data!.data() as Map<String, dynamic>;
                  score = (scoreData['score'] ?? 0.0).toDouble();
                }

                return GestureDetector(
                  onTap: () {
                    HandleNavi.navigateToMockTestOrPayment(
                      subjectIndex: widget.index,
                      mockIndex: index,
                      context: context,
                      mockTestName: mockTestName,
                      isPaid: isPaid,
                      userEmail: userEmail.toString(),
                      subjectName: widget.subjectName,
                    );
                  },
                  child: CustomMockContainer(
                    mock: mockTestName,
                    index: index + 1,
                    subject: widget.subjectName,
                    lockIcon: isPaid,
                    score: score, // Passing the fetched score
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOfflineContent() {
    return mocks.isEmpty
        ? Center(child: Text("No saved mocks available"))
        : ListView.builder(
            itemCount: mocks.length,
            itemBuilder: (context, index) {
              final mockTestName = mocks[index].mockName;

              return GestureDetector(
                onTap: () {
                  HandleNavi.navigateToMockTestOrPayment(
                    subjectIndex: widget.index,
                    mockIndex: index,
                    context: context,
                    mockTestName: mockTestName,
                    isPaid: false, // Assume offline mocks are free
                    userEmail: userEmail.toString(),
                    subjectName: widget.subjectName,
                  );
                },
                child: CustomMockContainer(
                  mock: mockTestName,
                  index: index + 1,
                  subject: widget.subjectName,
                  lockIcon:
                      false, // No lock since offline data doesn't track payment
                  score: 0.0, // Score not available offline
                ),
              );
            },
          );
  }
}
