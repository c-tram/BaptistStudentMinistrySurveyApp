// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:test_app/adminHome.dart';
import 'package:test_app/forgotPassword.dart';
import 'package:test_app/userHome.dart';
import 'fireData.dart';

//Class acts as "Main". default page for app launch
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class loginInfo {
  var username;

  loginInfo(this.username);
}

class _loginState extends State<login> {
  //main widget build. creates login page
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF5F7360),
        title: Text("BSM Secure Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('asset/images/images.png')),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: ''),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 50)),
                ElevatedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    var loginCheck = await (checkLogin(username, password));
                    //admin login
                    if (loginCheck == 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success!"),
                            content: Text("Logging in."),
                            actions: [
                              MaterialButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          adminHome(username, true),
                                    ),
                                    (Route route) => false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );

                      //user login
                    } else if (loginCheck == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success!"),
                            content: Text("Logging in."),
                            actions: [
                              MaterialButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          userHome(username, false),
                                    ),
                                    (Route route) => false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Invalid Password"),
                            content: Text("Try Again."),
                            actions: [
                              MaterialButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      usernameController.clear();
                      passwordController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5F7360),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                ElevatedButton(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => forgotPassword(),
                      ),
                      (Route route) => true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5F7360),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
