// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:test_app/login.dart';
import 'package:test_app/resetPassword.dart';
import 'adminAnalysis.dart';
import 'survey.dart';
import 'viewSurveys.dart';

/* This class is responsible for acting as a "HomePage" for administrative users. 
This page is a fallback page when functions such as survey completion or a password change is completed.*/

class userHome extends StatefulWidget {
  String username;
  bool isAdmin;

  userHome(this.username, this.isAdmin);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {
  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    bool isAdmin = widget.isAdmin;

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF5F7360),
            centerTitle: true,
            title: Text('Surveyor Home Page'),
            actions: <Widget>[
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
                  SizedBox(
                      width: 200,
                      height: 150,
                      child: Image.asset('asset/images/images.png')),
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
                              builder: (BuildContext context) =>
                                  viewSurveys(widget.username, widget.isAdmin)),
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
                              builder: (BuildContext context) => adminAnalysis(
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
          drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF5F7360)),
                child: Text(
                    style: TextStyle(fontSize: 36, color: Colors.white),
                    'Settings'),
              ),
              /*
              ListTile(
                  title: Text(
                      style: TextStyle(fontSize: 18),
                      'View Closed Response Data'),
                  onTap: () {
                    /*
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            //userFixedDataTable(),
                      ),
                      (Route route) => true,
                    );
                  */
                  }),
              ListTile(
                  title: Text(
                      style: TextStyle(fontSize: 18),
                      'View Open Response Data'),
                  onTap: () {
                    /*
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            //userOpenDataTable(),
                      ),
                      (Route route) => true,
                    );
                  */
                  }),*/
              ListTile(
                title: Text(style: TextStyle(fontSize: 18), 'Change Password'),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          resetPassword(widget.username, widget.isAdmin),
                    ),
                    (Route route) => true,
                  );
                },
              )
            ]),
          ),
        ),
      ],
    );
  }
}
