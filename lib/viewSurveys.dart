// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/adminFixedDataTable.dart';
import 'package:test_app/adminFollowUpDataTable.dart';
import 'package:test_app/adminOpenDataTable.dart';
import 'package:test_app/userHome.dart';

import 'adminHome.dart';
import 'userFixedDataTable.dart';
import 'userFollowUpDataTable.dart';
import 'userOpenDataTable.dart';

//Class acts as controller for viewing various data tables for users/admins
class viewSurveys extends StatelessWidget {
  String username;
  bool isAdmin;

  viewSurveys(this.username, this.isAdmin);

  //main widget build
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5F7360),
          title: Center(child: Text("View Surveys")),
          leading: BackButton(onPressed: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            Navigator.of(context).pop();
          }),
        ),
        body: BodyWidget(username, isAdmin),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  String username;
  bool isAdmin;

  BodyWidget(this.username, this.isAdmin);
  @override
  State<StatefulWidget> createState() => BodyWidgetState();
}

enum WidgetMarker { fixed, open, followUp }

class BodyWidgetState extends State<BodyWidget> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.fixed;

  //main widget build
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF5F7360),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20)),
              child: Text("Fixed Response"),
              onPressed: () {
                setState(() {
                  selectedWidgetMarker = WidgetMarker.fixed;
                });
              },
            )),
            Expanded(
                child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF5F7360),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20)),
              child: Text("Open Response"),
              onPressed: () {
                setState(() {
                  selectedWidgetMarker = WidgetMarker.open;
                });
              },
            )),
            Expanded(
                child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF5F7360),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20)),
              child: Text("Follow Ups"),
              onPressed: () {
                setState(() {
                  selectedWidgetMarker = WidgetMarker.followUp;
                });
              },
            )),
          ],
        ),
        SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 110,
                width: MediaQuery.of(context).size.width,
                child: getCustomContainer())),
      ],
    );
  }

  Widget getInfoWidget() {
    return Container(
      height: 500,
      color: Colors.blue,
    );
  }

  //used for switching between widget containers
  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.fixed:
        if (widget.isAdmin == true) {
          return adminFixedDataTable(widget.username, widget.isAdmin);
        } else {
          return userFixedDataTable(widget.username, widget.isAdmin);
        }
      case WidgetMarker.open:
        if (widget.isAdmin == true) {
          return adminOpenDataTable(widget.username, widget.isAdmin);
        } else {
          return userOpenDataTable(widget.username, widget.isAdmin);
        }
      case WidgetMarker.followUp:
        if (widget.isAdmin == true) {
          return adminFollowUpDataTable(widget.username, widget.isAdmin);
        } else {
          return userFollowUpDataTable(widget.username, widget.isAdmin);
        }
    }
  }
}
