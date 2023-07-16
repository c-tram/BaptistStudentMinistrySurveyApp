// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';

import 'fireData.dart';
import 'login.dart';

//class responsible for forgotten passwords.
//sends email to user with new generated password
class forgotPassword extends StatefulWidget {
  const forgotPassword();

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  //confirm forgotten password dialog
  void _showDialog(String username) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              alignment: Alignment.center,
              title: Text("Caution"),
              content: Text("Are you sure you want to change your password?"),
              actions: [
                MaterialButton(
                  child: Text("Send New Password"),
                  onPressed: () {
                    forgottenPassword(username);
                    Navigator.of(context).pop(); 

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => login(),
                      ),
                      (Route route) => false,
                    );
                  },
                ),
                MaterialButton(
                  child: Text("Wait, I remembered it!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  //main widget build
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameField = TextEditingController();

    return Stack(children: <Widget>[
      Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF5F7360),
            title: Text('Reset Password'),
            leading: BackButton(onPressed: () => Navigator.of(context).pop()),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                    padding: EdgeInsets.all(60),
                  ),
                  Text(style: TextStyle(fontSize: 32), 'Enter Email'),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  TextFormField(
                      controller: usernameField,
                      decoration:
                          const InputDecoration(hintText: 'example@gmail.com')),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: Size(200, 60),
                      backgroundColor: Color(0xFF5F7360),
                    ),
                    child: const Text("Reset Password"),
                    onPressed: () {
                      _showDialog(usernameField.text);
                    },
                  ),
                ])),
          )),
    ]);
  }
}
