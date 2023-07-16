// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:test_app/adminHome.dart';
import 'package:test_app/fireData.dart';

import 'userHome.dart';

//class is responsible for acting as a UI for resetting a password once logging in.
//calls on fireData.ChangePassword()
class resetPassword extends StatefulWidget {
  String username;
  bool isAdmin;

  resetPassword(this.username, this.isAdmin);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    bool isAdmin = widget.isAdmin;

    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();

    return Stack(
      children: <Widget>[
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xFF5F7360),
                title: Text('Reset Password'),
                leading: BackButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              adminHome(username, true),
                        ),
                        (Route route) => false))),
            body: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text(style: TextStyle(fontSize: 20), 'New password:'),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: 'New password')),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text(
                      style: TextStyle(fontSize: 20), 'Re-enter new password:'),
                  Padding(padding: EdgeInsets.all(8)),
                  TextFormField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'New password'),
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5F7360),
                      ),
                      child: Text("Submit"),
                      onPressed: () async {
                        var a = await (changePassword(widget.username,
                            password.text, confirmPassword.text));
                        if (a == 1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Oh no!"),
                                content: Text(
                                    "This password does not meet our requirements.\nPlease make sure to include at least one number, special character: ! @ # \$"),
                                actions: [
                                  MaterialButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      if (isAdmin == true) {
                                        Navigator.of(context).pop();
                                      }
                                      if (isAdmin == false) {
                                        Navigator.of(context).pop();
 
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
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
                        } else if (a == 2) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success!"),
                                content: Text("Password Changed!"),
                                actions: [
                                  MaterialButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      if (isAdmin == true) {
                                        Navigator.of(context).pop();

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                adminHome(username, isAdmin),
                                          ),
                                          (Route route) => false,
                                        );
                                      }
                                      if (isAdmin == false) {
                                        Navigator.of(context).pop();

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Try Again."),
                                content: Text("Passwords do not match"),
                                actions: [
                                  MaterialButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      })
                ],
              )),
            ))
      ],
    );
  }
}
