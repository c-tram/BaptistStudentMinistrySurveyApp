// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:test_app/adminAccountControls.dart';
import 'package:test_app/resetPassword.dart';
import 'package:test_app/viewSurveys.dart';
import 'login.dart';
import 'survey.dart';
import 'adminAnalysis.dart';

/* This class is responsible for acting as a "HomePage" for administrative users. 
This page is a fallback page when functions such as survey completion or a password change is completed.*/
class adminHome extends StatefulWidget {
  String username;
  bool isAdmin;

  adminHome(this.username, this.isAdmin);

  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    bool isAdmin = widget.isAdmin;

    //main stack of UI
    return Stack(
      children: <Widget>[
        Container(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xFF5F7360),
              title: Text('Admin Home Page'),
              actions: <Widget>[
                //logout button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5F7360)),
                  child: Icon(Icons.logout),
                  onPressed: () {
                    Navigator.of(context).pop();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => login(),
                      ),
                      (Route route) => false,
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //background picture
                    SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/images/images.png')),
                    //start new survey container with routing
                    Container(
                      padding: EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(400, 80),
                          backgroundColor: Color(0xFF5F7360).withOpacity(0.95),
                        ), //style
                        child: Text(
                          'Start New Survey',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  survey(username, isAdmin),
                            ),
                            (Route route) => true,
                          );
                        },
                      ),
                    ),
                    //view all surveys with routing
                    Container(
                      padding: EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(400, 80),
                          backgroundColor: Color(0xFF5F7360).withOpacity(0.95),
                        ), //style
                        child: Text(
                          'View Past Surveys',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => viewSurveys(
                                    widget.username, widget.isAdmin)),
                            (Route route) => true,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(400, 80),
                          backgroundColor: Color(0xFF5F7360).withOpacity(0.95),
                        ), //style
                        child: Text(
                          'Statistics on Surveys',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    adminAnalysis(
                                        widget.username, widget.isAdmin)),
                            (Route route) => true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //appbar side menu. contains change password and admin account controls
            drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF5F7360)),
                  child: Text(
                      style: TextStyle(fontSize: 36, color: Colors.white),
                      'Settings'),
                ),
                //admin account controls routing
                ListTile(
                  title: Text(
                      style: TextStyle(fontSize: 18),
                      'Manage Account Authorizations'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            adminAccountControls(username, isAdmin),
                      ),
                      (Route route) => true,
                    );
                  },
                ),
                //reset password routing
                ListTile(
                  title:
                      Text(style: TextStyle(fontSize: 18), 'Change Password'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            resetPassword(username, isAdmin),
                      ),
                      (Route route) => true,
                    );
                  },
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
