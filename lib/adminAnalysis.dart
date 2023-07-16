// ignore_for_file: unnecessary_new, unused_local_variable

import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/*This class is responsible for Admin users with advanced functionality to do data analysis*/

class adminAnalysis extends StatefulWidget {
  String username;
  bool isAdmin;

  adminAnalysis(this.username, this.isAdmin);
  @override
  _adminAnalysisState createState() => _adminAnalysisState();
}

class _adminAnalysisState extends State<adminAnalysis> {
  //calculates admin statistics
  getFollowUpData() async {
    var value = FirebaseDatabase.instance.ref("Follow Ups").get();
    return value;
  }

  getSurveyUpData() async {
    var value = FirebaseDatabase.instance.ref("Surveys").get();
    return value;
  }

  //main widget build. Calls SFDataGrid()
  @override
  Widget build(BuildContext context) {
    int submittedFollowups = 0;
    int inviteBSM = 0;
    int inviteAwaken = 0;
    int shared3Circles = 0;
    int intrestedInDiscipleship = 0;
    int totalSurveys = 0;
    double percentSubmittedFollowups = 0;
    double percentInviteBSM = 0;
    double percentInviteAwaken = 0;
    double percentShared3Circles = 0;
    double percentIntrestedInDiscipleship = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F7360),
        title: const Text("Analysis Page"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder(
                future: getFollowUpData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    var showData = snapshot.data;
                    Map<dynamic, dynamic> values = showData.value;
                    List<dynamic> key = values.keys.toList();
                    for (int i = 0; i < key.length; i++) {
                      final data = values[key[i]];
                      submittedFollowups += 1;
                      bool Q5 = data['Q5'];
                      bool Q6 = data['Q6'];
                      bool Q7 = data['Q7'];
                      bool Q8 = data['Q8'];

                      if (Q5 == true) {
                        inviteBSM += 1;
                      }
                      if (Q6 == true) {
                        inviteAwaken += 1;
                      }
                      if (Q7 == true) {
                        shared3Circles += 1;
                      }
                      if (Q8 == true) {
                        intrestedInDiscipleship += 1;
                      }
                    }
                  }
                  return Container(
                      alignment: Alignment.centerLeft,
                      child: new Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Number of Submitted Follow Ups: $submittedFollowups',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Number Invited to BSM: $inviteBSM',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Number Invited to Awaken: $inviteAwaken',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            // ignore: prefer_const_constructors
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Number Shared 3 Cicles: $shared3Circles',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Number Interested in Discipleship: $intrestedInDiscipleship',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                          ],
                        ),
                      ));
                }),
            const Padding(padding: EdgeInsets.all(25)),
            FutureBuilder(
                future: getSurveyUpData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    var showData = snapshot.data;
                    Map<dynamic, dynamic> values = showData.value;
                    List<dynamic> key = values.keys.toList();
                    for (int i = 0; i < key.length; i++) {
                      final data = values[key[i]];
                      totalSurveys += 1;
                    }

                    percentSubmittedFollowups =
                        submittedFollowups / totalSurveys * 100;
                    percentInviteBSM = inviteBSM / totalSurveys * 100;
                    percentInviteAwaken = inviteAwaken / totalSurveys * 100;
                    percentShared3Circles = shared3Circles / totalSurveys * 100;
                    percentIntrestedInDiscipleship =
                        intrestedInDiscipleship / totalSurveys * 100;
                  }
                  return Container(
                      alignment: Alignment.centerRight,
                      child: new Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Number of Submitted Surveys: $totalSurveys',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Percent Invited to BSM: $percentInviteBSM',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Percent Invited to Awaken: $percentInviteAwaken',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Percent Shared 3 Cicles: $percentShared3Circles',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            const Text(
                              '============================',
                              style: TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Text(
                              'Percent Interested in Discipleship: $percentIntrestedInDiscipleship',
                              style: const TextStyle(
                                fontSize: 20,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF5F7360),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                          ],
                        ),
                      ));
                })
          ])),
    );
  }
}
