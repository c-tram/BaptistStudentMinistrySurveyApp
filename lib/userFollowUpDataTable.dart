// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/fireData.dart';
import 'package:test_app/survey.dart';

/*This class is responsible for displaying a data table for users with advanced
functionality for querying/sorting/ and analysis purposes*/

class userFollowUpDataTable extends StatefulWidget {
  String username;
  bool isAdmin;

  userFollowUpDataTable(this.username, this.isAdmin);

  @override
  _userFollowUpDataTableState createState() => _userFollowUpDataTableState();
}

class _userFollowUpDataTableState extends State<userFollowUpDataTable> {
  late readAllFollowUps allFollowUpFirebase;
  List<followUpSurveyForm> surveyData = [];

  //read all from database for user use
  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref("Follow Ups").get();
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
            int surveyID = data['SurveyID'];
            String q1 = data['Q1'];
            String q2 = data['Q2'];
            String q3 = data['Q3'];
            String q4 = data['Q4'];
            bool q5 = data['Q5'];
            bool q6 = data['Q6'];
            bool q7 = data['Q7'];
            bool q8 = data['Q8'];
            String surveyorID = data['SurveyorID'];

            if (surveyorID == widget.username) {
              surveyData.add(
                  followUpSurveyForm(surveyID, q1, q2, q3, q4, q5, q6, q7, q8));
            }
          }

          allFollowUpFirebase = readAllFollowUps(surveyData);
          return SfDataGrid(
            horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
            columnWidthMode: ColumnWidthMode.fill,
            headerRowHeight: 100,
            rowHeight: 100,
            defaultColumnWidth: 200,
            allowFiltering: true,
            allowSorting: true,
            source: allFollowUpFirebase,
            columns: <GridColumn>[
              GridColumn(
                  allowFiltering: false,
                  allowSorting: true,
                  columnName: 'Survey ID',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Survey ID',
                        maxLines: 1,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Q1',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'How have you been since we last met?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Q2',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Have you thought about what we talked about last time? Do you have any questions?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Q3',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Has anyone shared with you how to have a personal relationship with Christ?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Q4',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'What do you think it means to have a relationship with Christ?',
                        maxLines: 5,
                        minFontSize: 5,
                      ))),
              GridColumn(
                  allowFiltering: true,
                  allowSorting: false,
                  columnName: 'Q5',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Invite to BSM?',
                        maxLines: 1,
                        minFontSize: 3,
                      ))),
              GridColumn(
                  allowFiltering: true,
                  allowSorting: false,
                  columnName: 'Q6',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText('Invite to Awaken?',
                          maxLines: 1, minFontSize: 3))),
              GridColumn(
                  allowFiltering: true,
                  allowSorting: false,
                  columnName: 'Q7',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: AutoSizeText('Share three circles?',
                          maxLines: 1, minFontSize: 3))),
              GridColumn(
                allowFiltering: true,
                allowSorting: false,
                columnName: 'Q8',
                label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: AutoSizeText('Interested in Discipleship?',
                      maxLines: 1, minFontSize: 3),
                ),
              ),
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
    return Container(alignment: Alignment.center, child: _buildDataGrid());
  }
}
