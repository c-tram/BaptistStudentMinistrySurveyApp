// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names, sort_child_properties_last

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/fireData.dart';
import 'package:test_app/login.dart';
import 'fireData.dart';
import 'adminHome.dart';

/*This Class has Administrative controls over users of the application

Functions of this class include:

Adding new users to the application
Managing user information and privileges for the application

*/

class adminAccountControls extends StatefulWidget {
  String username;
  bool isAdmin;

  adminAccountControls(this.username, this.isAdmin);
  @override
  _adminAccountControlState createState() => _adminAccountControlState();
}

class _adminAccountControlState extends State<adminAccountControls> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool makeAdmin = false;

  late readAllLogin allLoginFirebase;
  List<loginInfo> loginData = [];

  //database read for user data.
  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref("Users").get();
    return value;
  }

  //ui function for checkbox colors.
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color.fromARGB(217, 2, 139, 54); //Color(0xFF5F7360)
    }
    return Color(0xFF5F7360); //Color.fromARGB(217, 2, 139, 54)
  }

  //UI portion of this class. Creates a SFData grid for use with build()
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
            String username = data['Username'];

            loginData.add(loginInfo(username));
          }

          allLoginFirebase = readAllLogin(loginData);
          return SfDataGrid(
            horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
            columnWidthMode: ColumnWidthMode.fill,
            isScrollbarAlwaysShown: true,
            allowColumnsResizing: true,
            allowFiltering: true,
            source: allLoginFirebase,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'Username',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Username',
                      ))),
              GridColumn(
                  columnName: 'Manage Login',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Manage Login',
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

  //main function call of this class
  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    bool isAdmin = widget.isAdmin;
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
              backgroundColor:
                  Colors.white.withOpacity(.95), //background color of scaffold
              appBar: AppBar(
                title: Text("Account Authorizations Page"), //title of app
                backgroundColor:
                    Color(0xFF5F7360), //background color of app bar
              ),
              body: Column(children: [
                _buildDataGrid(), //call to SFDataGrid()
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(217, 2, 139, 54)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                children: <Widget>[
                                  Positioned(
                                    right: -40.0,
                                    top: -40.0,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.close),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: '(Username)',
                                            ),
                                            controller: usernameController,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                hintText: '(Enter Password)',
                                              ),
                                              controller: passwordController),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                hintText: '(Confirm Password)',
                                              ),
                                              controller:
                                                  confirmPasswordController),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                        ),
                                        const Text('Admin?'),
                                        StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Checkbox(
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor), 
                                              value: makeAdmin,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  makeAdmin = value!;
                                                });
                                              });
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            //Button does a boolean check for
                                            // account creation and functions accordingly
                                            child: Text("Submit"),
                                            onPressed: () {
                                              if ((passwordController.text ==
                                                      confirmPasswordController
                                                          .text) &&
                                                  (checkPassword(
                                                          passwordController
                                                              .text) &&
                                                      checkPassword(
                                                          confirmPasswordController
                                                              .text)) && (usernameCheck(usernameController.text))) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Creation Success."),
                                                      content: Text(
                                                          "Login Created."),
                                                      actions: [
                                                        MaterialButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    adminHome(
                                                                        username,
                                                                        isAdmin),
                                                              ),
                                                              (Route route) =>
                                                                  false,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                //create new login if form filled out correctly
                                                createNewLogin(
                                                    usernameController.text,
                                                    passwordController.text,
                                                    makeAdmin);
                                              } else {
                                                //error dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Creation Failed."),
                                                      content: Text(
                                                          "Invalid Username/Password Combination\nMake sure password contains more than 4 characters,"
                                                          "has at least one letter, number, and special character (!@#\$\nUsername must be valid email address."),
                                                      actions: [
                                                        MaterialButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text('Add/Remove Login'))
              ])),
        ),
      ],
    );
  }
}
