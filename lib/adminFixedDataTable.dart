// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/fireData.dart';
import 'package:test_app/survey.dart';
import 'package:auto_size_text/auto_size_text.dart';

/*This class is responsible for displaying a data table for Admin users with advanced
functionality for querying/sorting/ and analysis purposes*/

class adminFixedDataTable extends StatefulWidget {
  String username;
  bool isAdmin;

  adminFixedDataTable(this.username, this.isAdmin);
  @override
  _adminFixedDataTableState createState() => _adminFixedDataTableState();
}

class _adminFixedDataTableState extends State<adminFixedDataTable> {
  late readAllFixedFirebase allFixedFirebase;
  List<demographicSurveyForm> surveyData = [];

  //read all from database for admin use
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
            int surveyID = data['surveyID'];
            String name = data['Name'];
            String location = data['Location'];
            String year = data['Year'];
            String major = data['Major'];

            surveyData.add(
                demographicSurveyForm(surveyID, name, location, major, year));
          }

          allFixedFirebase =
              readAllFixedFirebase(surveyData, widget.username, widget.isAdmin);

          return SfDataGrid(
            horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
            columnWidthMode: ColumnWidthMode.fill,
            headerRowHeight: 50,
            rowHeight: 100,
            defaultColumnWidth: 100,
            source: allFixedFirebase,
            allowSorting: true,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'SurveyID',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'SurveyID',
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: true,
                  columnName: 'Name',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Name',
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Location',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Location',
                      ))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Year',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('Year'))),
              GridColumn(
                  allowFiltering: false,
                  allowSorting: false,
                  columnName: 'Major',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('Major'))),
              GridColumn(
                allowFiltering: false,
                allowSorting: false,
                columnName: 'Follow Up',
                label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('follow Up'),
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
    return Container(child: _buildDataGrid());
  }
}
