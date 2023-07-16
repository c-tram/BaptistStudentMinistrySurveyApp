// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/fireData.dart';
import 'package:test_app/adminHome.dart';
import 'userHome.dart';

//Class functions as a followUp Survey Form Object. UI Portion
class followUp extends StatefulWidget {
  var surveyID;
  String username;
  bool isAdmin;

  followUp(this.surveyID, this.username, this.isAdmin);

  @override
  _followUpState createState() => _followUpState();
}

class _followUpState extends State<followUp> {
  //controllers for Survey Form Fields
  bool? didInviteToBSM = false;
  bool? didShare3Circles = false;
  bool? didAskForDShip = false;
  bool? didInviteToAwaken = false;
  late final TextEditingController q1Controller;
  late final TextEditingController q2Controller;
  late final TextEditingController q3Controller;
  late final TextEditingController q4Controller;

  @override
  void initState() {
    super.initState();
    q1Controller = TextEditingController();
    q2Controller = TextEditingController();
    q3Controller = TextEditingController();
    q4Controller = TextEditingController();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    q1Controller.dispose();
    q2Controller.dispose();
    q3Controller.dispose();
    q4Controller.dispose();
    super.dispose();
  }

  //dialog for survey submission
  void _showDialog(String username, bool isAdmin) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Success!"),
              content: const Text("Follow Up Survey Submitted!"),
              actions: [
                MaterialButton(
                  child: const Text("OK"),
                  onPressed: () {
                    //return to admin page
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
                    //return to user page
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
                )
              ]);
        });
  }

  //main widget build. creates Survey Form to be filled uot
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    int surveyID = widget.surveyID;
    String username = widget.username;
    bool isAdmin = widget.isAdmin;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(217, 2, 139, 54); //Color(0xFF5F7360)
      }
      return const Color(0xFF5F7360); //Color.fromARGB(217, 2, 139, 54)
    }

    //main stack
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/images/images.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white.withOpacity(.90),
            appBar: AppBar(
              title: const Text('Spiritual Life Follow Up Survey'),
              backgroundColor: Color(0xFF5F7360),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Follow Up Survey',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF5F7360),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Text(
                      'Spend some time just getting to know them better. How have you been since we last met?'),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextFormField(
                      controller: q1Controller,
                      decoration: const InputDecoration(
                        hintText: '(Ex. Good, Tired, Busy)',
                      )),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Text(
                      'Have you thought about what we talked about last time? Do you have any questions?'),
                  TextFormField(
                      controller: q2Controller,
                      decoration: const InputDecoration(
                        hintText: '(Ex. Does baptism save me?)',
                      )),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Text(
                      'Has anyone shared with you how to have a personal relationship with Christ?'),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextFormField(
                      controller: q3Controller,
                      decoration: const InputDecoration(
                        hintText: '(Ex. Yes/No)',
                      )),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Text(
                      'What do you think it means to have a relationship with Christ?'),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextFormField(
                      controller: q4Controller,
                      decoration: const InputDecoration(
                        hintText: '(Ex. Placing my trust in Christ...)',
                      )),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Did you invite them to the BSM?'),
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: didInviteToBSM,
                          onChanged: (bool? value) {
                            setState(() {
                              didInviteToBSM = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Did you invite them to Awaken?'),
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: didInviteToAwaken,
                          onChanged: (bool? value) {
                            setState(() {
                              didInviteToAwaken = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Did you share the Three Circles with them?'),
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: didShare3Circles,
                          onChanged: (bool? value) {
                            setState(() {
                              didShare3Circles = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Were they interested in Discipleship?'),
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: didAskForDShip,
                          onChanged: (bool? value) {
                            setState(() {
                              didAskForDShip = value!;
                            });
                          }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(15.0)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(217, 2, 139, 54)),
                      child: const Text('Submit Survey'),
                      onPressed: () {
                        _showDialog(username, isAdmin);
                        followUpSurvey(
                            surveyID,
                            username,
                            q1Controller.text,
                            q2Controller.text,
                            q3Controller.text,
                            q4Controller.text,
                            didInviteToBSM!,
                            didInviteToAwaken!,
                            didShare3Circles!,
                            didAskForDShip!);
                      }),
                  const Padding(padding: EdgeInsets.all(15.0)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
