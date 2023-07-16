// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/survey.dart';
import 'fireData.dart';

/*This class is responsible for displaying a data table for users with advanced
functionality for querying/sorting/ and analysis purposes*/

class userOpenDataTable extends StatefulWidget {
  String username;
  bool isAdmin;

  userOpenDataTable(this.username, this.isAdmin);

  @override
  _userOpenDataTableState createState() => _userOpenDataTableState();
}

class _userOpenDataTableState extends State<userOpenDataTable> {
  late readAllOpenFirebase allOpenFirebase;
  List<questionSurveyForm> surveyData = [];

  //read all from database for user use
  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref("Surveys").get();
    return value;
  }

  //SFDataGrid to be built
  Widget _buildDataGrid() {
    return FutureBuilder(
      future: getDataFromDatabase(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var showData = snapshot.data;
          Map<dynamic, dynamic> values = showData.value;
          List<dynamic> key = values.keys.toList();
          for (int i = 0; i < key.length; i++) {
            final data = values[key[i]];

            var surveyID = data['surveyID'];
            String q1 = data['Q1'];
            String q2 = data['Q2'];
            String q3 = data['Q3'];
            String q4 = data['Q4'];
            String q5 = data['Q5'];
            String surveyorID = data['surveyorID'];
            if (surveyorID == widget.username) {
              surveyData.add(questionSurveyForm(surveyID, q1, q2, q3, q4, q5));
            }
          }

          allOpenFirebase = readAllOpenFirebase(surveyData);
          return SfDataGrid(
            horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
            columnWidthMode: ColumnWidthMode.fill,
            headerRowHeight: 100,
            rowHeight: 100,
            defaultColumnWidth: 200,
            allowSorting: true,
            allowFiltering: false,
            source: allOpenFirebase,
            columns: <GridColumn>[
              GridColumn(
                  allowFiltering: false,
                  columnName: 'Survey ID',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Survey ID',
                        maxLines: 1,
                        minFontSize: 10,
                      ))),
              GridColumn(
                  allowSorting: false,
                  columnName: 'Question 1',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'What is your Spiritual Background? What does it look like now?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowSorting: false,
                  columnName: 'Question 2',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'What do you think happens when you die? (If atheist, ask "why", then skip to last question.)',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowSorting: false,
                  columnName: 'Question 3',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'What do you think it takes to go to heaven?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowSorting: false,
                  columnName: 'Question 4',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Suppose you were to stand before God today and He asked you, why should I let you into heaven? What would you say?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowSorting: false,
                  columnName: 'Question 5',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Can I show you an illustration about what I believe it means to have a relatioship with God?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //main widget build. Calls SFDataGrid()
  @override
  Widget build(BuildContext context) {
    return Container(child: _buildDataGrid());
  }
}
