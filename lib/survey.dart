// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, prefer_typing_uninitialized_variables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:test_app/adminHome.dart';
import 'package:test_app/fireData.dart';
import 'package:test_app/userHome.dart';
import 'package:intl/intl.dart';

//demographic Survey object. Used for SFDataGrid
class demographicSurveyForm {
  var surveyID;
  var name;
  var major;
  var location;
  var year;

  demographicSurveyForm(this.surveyID, this.name, String this.location,
      String this.major, String this.year);
}

//open Survey Object. Used for SFDataGrid
class questionSurveyForm {
  var surveyID;
  var q1;
  var q2;
  var q3;
  var q4;
  var q5;

  questionSurveyForm(this.surveyID, this.q1, String this.q2, String this.q3,
      String this.q4, String this.q5);
}

//follow up survey object. Used for SFDataGrid
class followUpSurveyForm {
  var surveyID;
  var q1;
  var q2;
  var q3;
  var q4;
  late bool? q5;
  late bool? q6;
  late bool? q7;
  late bool? q8;

  followUpSurveyForm(this.surveyID, this.q1, this.q2, this.q3, this.q4, this.q5,
      this.q6, this.q7, this.q8);
}

//class is used for submitting a completed survey to firebase.
class survey extends StatefulWidget {
  String username;
  bool isAdmin;

  survey(this.username, this.isAdmin);
  @override
  _surveyState createState() => _surveyState();
}

class _surveyState extends State<survey> {
  //dialog for a completed survey
  void _showDialog(String username, bool isAdmin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success!"),
          content: Text("Survey Submitted!"),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                //redirect to admin page
                if (isAdmin == true) {
                  Navigator.of(context).pop();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          adminHome(username, isAdmin),
                    ),
                    (Route route) => false,
                  );
                }
                //redirect to user page
                if (isAdmin == false) {
                  Navigator.of(context).pop();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          userHome(username, isAdmin),
                    ),
                    (Route route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  //main widget builder
  @override
  Widget build(BuildContext context) {
    //survey text controllers
    TextEditingController nameController = TextEditingController();
    TextEditingController majorController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController yearController = TextEditingController();
    TextEditingController q1Controller = TextEditingController();
    TextEditingController q2Controller = TextEditingController();
    TextEditingController q3Controller = TextEditingController();
    TextEditingController q4Controller = TextEditingController();
    TextEditingController q5Controller = TextEditingController();
    var dateFormatter = new DateFormat.yMEd();

    String username = widget.username;
    bool isAdmin = widget.isAdmin;

    //main ui stack
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/images/images.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white.withOpacity(.90),
            appBar: AppBar(
              title: Text('Spiritual Life Survey'),
              backgroundColor: Color(0xFF5F7360),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 35,
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF5F7360),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text('What is your name?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: '(Ex. John Smith)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text('Where are you from?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: '(Ex. Houston, TX)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text('What is your major?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: majorController,
                    decoration: const InputDecoration(
                      hintText: '(Ex. Mass Communications)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text('What year are you?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(
                      hintText: '(Ex. Freshman)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(23.0),
                  ),
                  Text(
                    'Spiritual Information',
                    style: TextStyle(
                      fontSize: 35,
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF5F7360),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text(
                      'What is your spiritual background? What does it look like now?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: q1Controller,
                    decoration: const InputDecoration(
                      hintText: '(Ex. I grew up in church)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text(
                      'What do you think happens when you die? (If atheist, ask "why?", then skip to question 9)?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: q2Controller,
                    decoration: const InputDecoration(
                      hintText:
                          '(Ex. I believe there is a heaven, but not sure how to get there.)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text('What do you think it takes to get to heaven?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: q3Controller,
                    decoration: const InputDecoration(
                      hintText:
                          '(Ex. Good works? Being a nice person? Going to church?)',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text(
                      'Suppose you were to stand before God today and He asked you, "Why should I let you into heaven?" What would you say?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: q4Controller,
                    decoration: const InputDecoration(
                        hintText:
                            '(Ex. Well He should let me into heaven because I was a nice guy)'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text(
                      'Can I show you an illustration about what I believe it means to have a relationship with God?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  TextFormField(
                    controller: q5Controller,
                    decoration: const InputDecoration(
                        hintText: '(General response to illustration...)'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(217, 2, 139, 54)),
                    child: const Text('Submit Survey'),
                    onPressed: () async {
                      // create new survey
                      _showDialog(username, isAdmin);
                      newSurvey(
                        (await (generateSurveyID())),
                        username,
                        nameController.text,
                        majorController.text,
                        locationController.text,
                        yearController.text,
                        q1Controller.text,
                        q2Controller.text,
                        q3Controller.text,
                        q4Controller.text,
                        q5Controller.text,
                        dateFormatter.format(DateTime.now()), //date submitted
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
