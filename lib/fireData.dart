// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:test_app/followUp.dart';
import 'package:test_app/login.dart';
import 'package:test_app/mailer.dart';
import 'package:test_app/survey.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/*All Firebase interactions are included within this class. 
Highly coupled and a dependancy for most of this project.
*/

//=================================================

void deleteLogin(String username) async {
  //get database snapshot
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Users/').get();

  //convert snapshot to map
  Map<dynamic, dynamic> values = snapshot.value as Map;
  List<dynamic> key = values.keys.toList();

  for (int i = 0; i < key.length; i++) {
    final data = values[key[i]];
    String checkedUsername = data['Username'];
    String convertedKey = key[i].toString();

    if (username == checkedUsername) {
      final deleteRef = FirebaseDatabase.instance.ref('Users/$convertedKey');
      deleteRef.remove();
      return;
    }
  }
}

//=================================================
//Create a new login within adminAccountControls
void createNewLogin(String username, String password, bool? isAdmin) async {
  var bytes = ascii.encode(password);
  var digest = sha256.convert(bytes);
  String toAdd = digest.toString();

//update object to be written
  final loginData = {
    'Username': username,
    'HashedPassword': toAdd,
    'isAdmin': isAdmin,
  };

  // Generate unique account identification key
  final newPostKey = FirebaseDatabase.instance.ref().child('Users').push().key;

  //write to account tree
  final Map<String, Map> updates = {};
  updates['Users/$newPostKey'] = loginData;
  return FirebaseDatabase.instance.ref().update(updates);
}

//=================================================

//Verify a correct login has been entered for access to user/Admin home pages

Future<int> checkLogin(String usernameAttempt, String passwordAttempt) async {
  //password attempt hashed
  var bytes = ascii.encode(passwordAttempt);
  var digest = sha256.convert(bytes);
  String hashedPasswordAttempt = digest.toString();

  //get database snapshot
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Users/').get();

  //convert snapshot to map
  Map<dynamic, dynamic> values = snapshot.value as Map;
  List<dynamic> key = values.keys.toList();

  //read map for login
  for (int i = 0; i < key.length; i++) {
    final data = values[key[i]];
    String username = data['Username'];
    String hashedPassword = data['HashedPassword'];
    bool isAdmin = data['isAdmin'];

    if (usernameAttempt == username &&
        hashedPassword == hashedPasswordAttempt &&
        isAdmin == true) {
      return 1; // is admin and correct login
    } else if ((usernameAttempt == username &&
        hashedPassword == hashedPasswordAttempt &&
        isAdmin == false)) {
      return 2; // is user and correct login
    }
  }

  return 3; // incorrect login
}
//=================================================

//Function is used to change a forgottenpassword via the login page.

void forgottenPassword(String username) async {
  //get database snapshot
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Users/').get();

  //convert snapshot to map
  Map<dynamic, dynamic> values = snapshot.value as Map;
  List<dynamic> key = values.keys.toList();

  //read map for checking if exists
  for (int i = 0; i < key.length; i++) {
    final data = values[key[i]];
    String databaseUsername = data['Username'];

    if (username == databaseUsername) {
      //generate new password
      String newPassword = generatePassword(32);

      //email new password
      forgottenPasswordMessage(username, newPassword);

      //set new hashed password in database
      var bytes = ascii.encode(newPassword);
      var digest = sha256.convert(bytes);
      String hashedPasswordAttempt = digest.toString();
      String convertedKey = key[i].toString();
      FirebaseDatabase.instance
          .ref('Users/$convertedKey/HashedPassword')
          .set(hashedPasswordAttempt);
    }
  }
}

//=================================================

//Function is used to autogenerate a new password for creating users / forgotten passwords

String generatePassword(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!?#\$';
  Random rnd = Random.secure();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return getRandomString(length);
}

//=================================================

bool checkPassword(String password) {
  if (password.contains(
      RegExp(r'^(?=.*[@$!#])(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!#]{4,32}$'))) {
    return true;
  } else {
    return false;
  }
}

bool usernameCheck(String username) {
  if (username.contains(RegExp(r'@\w+\.\w{2,3}'))) {
    return true;
  } else {
    return false;
  }
}

//Function is used to change a password for user/admin users that are logged in
Future<int> changePassword(
    String username, String password, String confirmPassword) async {
  //passwords do not match
  if (password != confirmPassword) {
    return 0;
  } else if (!password.contains(
      RegExp(r'^(?=.*[@$!#])(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!#]{4,32}$'))) {
    return 1;
  } else //passwords match. do password change
  {
    //hash new password
    var bytes = ascii.encode(password);
    var digest = sha256.convert(bytes);
    String hashedPasswordAttempt = digest.toString();

    //get database snapshot
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Users/').get();

    //snapshot to map
    Map<dynamic, dynamic> values = snapshot.value as Map;
    List<dynamic> key = values.keys.toList();

    //read map for username
    for (int i = 0; i < key.length; i++) {
      final data = values[key[i]];
      String firebaseUsername = data['Username'];
      String convertedKey = key[i].toString();
      //change password upon successful username identification
      if (firebaseUsername == username) {
        FirebaseDatabase.instance
            .ref('Users/$convertedKey/HashedPassword')
            .set(hashedPasswordAttempt);

        return 2; // successful password change
      }
    }
  }

  return 0; // default case. passwords do not match
}

//=================================================

//function for ensuring each submitted survey has a unique identifiable surveyID
Future<int> generateSurveyID() async {
  int surveyID = 0; // init

  //get database snapshot
  final ref = FirebaseDatabase.instance.ref();
  var snapshot = await ref.child('surveyID/currentID').get();

  //increment snapshot
  surveyID = snapshot.value as int;
  surveyID += 1;

  //set new value to database
  FirebaseDatabase.instance.ref('surveyID/currentID').set(surveyID);

  return surveyID; // return survey id in submitted survey form
}

//=================================================

//function submits a new survey to database
void newSurvey(
    int surveyID,
    String surveyorID,
    String name,
    String major,
    String location,
    String year,
    String q1,
    String q2,
    String q3,
    String q4,
    String q5,
    String date) async {
  // survey entry object
  final surveyData = {
    'surveyID': surveyID,
    'surveyorID': surveyorID,
    'Name': name,
    'Location': location,
    'Major': major,
    'Year': year,
    'Q1': q1,
    'Q2': q2,
    'Q3': q3,
    'Q4': q4,
    'Q5': q5,
    'Date Submitted': date
  };

  // Get a key for a new survey.
  final newPostKey =
      FirebaseDatabase.instance.ref().child('Surveys').push().key;

  //write to survey tree
  final Map<String, Map> updates = {};
  updates['Surveys/$newPostKey'] = surveyData;
  return FirebaseDatabase.instance.ref().update(updates);
}
//=================================================

//function submits follow up surveys to database.
void followUpSurvey(int surveyID, String username, String q1, String q2,
    String q3, String q4, bool q5, bool q6, bool q7, bool q8) async {
  final surveyData = {
    'SurveyID': surveyID,
    'SurveyorID': username,
    'Q1': q1,
    'Q2': q2,
    'Q3': q3,
    'Q4': q4,
    'Q5': q5,
    'Q6': q6,
    'Q7': q7,
    'Q8': q8,
  };

  // Get a key for a new survey.
  final newPostKey =
      FirebaseDatabase.instance.ref().child('Follow Ups').push().key;

  //write to survey tree
  final Map<String, Map> updates = {};
  updates['Follow Ups/$newPostKey'] = surveyData;
  return FirebaseDatabase.instance.ref().update(updates);
}

//=================================================

//class serves as a map for SFDataGrid
class readAllOpenFirebase extends DataGridSource {
  readAllOpenFirebase(this.surveyData) {
    _buildDataRow();
  }

  List<DataGridRow> _surveyData = [];
  List<questionSurveyForm> surveyData = [];

  void _buildDataRow() {
    _surveyData = surveyData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'SurveyID', value: e.surveyID),
              DataGridCell<String>(columnName: 'Question 1', value: e.q1),
              DataGridCell<String>(columnName: 'Question 2', value: e.q2),
              DataGridCell<String>(columnName: 'Question 3', value: e.q3),
              DataGridCell<String>(columnName: 'Question 4', value: e.q4),
              DataGridCell<String>(columnName: 'Question 5', value: e.q5),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _surveyData;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
//=================================================

//=================================================

//class serves as a map for SFDataGrid
class readAllFixedFirebase extends DataGridSource {
  readAllFixedFirebase(this.surveyData, this.username, this.isAdmin) {
    _buildDataRow();
  }
  String username;
  bool isAdmin;
  List<DataGridRow> _surveyData = [];
  List<demographicSurveyForm> surveyData = [];

  void _buildDataRow() {
    _surveyData = surveyData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'surveyID', value: e.surveyID),
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<String>(columnName: 'Location', value: e.location),
              DataGridCell<String>(columnName: 'Year', value: e.year),
              DataGridCell<String>(columnName: 'Major', value: e.major),
              DataGridCell<Widget>(columnName: 'FollowUp', value: null),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _surveyData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: dataGridCell.columnName == 'FollowUp'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(217, 2, 139, 54)),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) => followUp(
                                row.getCells()[0].value as int,
                                username,
                                isAdmin),
                          ),
                          (Route route) => true,
                        );
                      },
                      child: const Text('FollowUp'));
                })
              : Text(dataGridCell.value.toString()));
    }).toList());
  }
}
//=================================================

//=================================================

//Class servers as a map for SFDataGrid
class readAllFollowUps extends DataGridSource {
  readAllFollowUps(this.followUpData) {
    _buildDataRow();
  }

  List<DataGridRow> _followUpData = [];
  List<followUpSurveyForm> followUpData = [];

  void _buildDataRow() {
    _followUpData = followUpData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'surveyID', value: e.surveyID),
              DataGridCell<String>(columnName: 'Q1', value: e.q1),
              DataGridCell<String>(columnName: 'Q2', value: e.q2),
              DataGridCell<String>(columnName: 'Q3', value: e.q3),
              DataGridCell<String>(columnName: 'Q4', value: e.q4),
              DataGridCell<bool>(columnName: 'Q5', value: e.q5),
              DataGridCell<bool>(columnName: 'Q6', value: e.q6),
              DataGridCell<bool>(columnName: 'Q7', value: e.q7),
              DataGridCell<bool>(columnName: 'Q8', value: e.q8),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _followUpData;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
//=================================================

//class serves as a map for SFDataGrid
class readAllLogin extends DataGridSource {
  readAllLogin(this.loginData) {
    _buildDataRow();
  }

  List<DataGridRow> _loginData = [];
  List<loginInfo> loginData = [];

  void _buildDataRow() {
    _loginData = loginData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'Username', value: e.username.toString()),
              DataGridCell<Widget>(columnName: 'Manage', value: null),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: dataGridCell.columnName == 'Manage'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(217, 2, 139, 54)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                alignment: Alignment.center,
                                title: Text("Caution"),
                                content: Text(
                                    "Are you sure you want to delete this login??"),
                                actions: [
                                  MaterialButton(
                                    child: Text("Yes. There is no going back."),
                                    onPressed: () {
                                      deleteLogin(
                                          row.getCells()[0].value.toString());
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  MaterialButton(
                                    child: Text("Nevermind."),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]);
                          },
                        );
                      },
                      child: const Text('Remove Login'));
                })
              : Text(dataGridCell.value.toString()));
    }).toList());
  }

  @override
  List<DataGridRow> get rows => _loginData;
}

//=================================================
