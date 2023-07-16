// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void forgottenPasswordMessage(String email, String newPassword) async {
  String username = dotenv.env['username'] ?? '';
  String password = dotenv.env['password'] ?? '';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'BSM Admin')
    ..recipients.add(email)
    ..subject = 'Notice: Your Forgotten Password Reset Request'
    ..text = ''
    ..html =
        "<head><title></title></head><body><h2>Regarding Your Account</h2><p>By request, we have generated a new password for your account.<br /><br />Your new password is as follows:<br /><br />$newPassword&nbsp;<br /><br />If this request was not made by you. Please contact a BSM admin immediately by email or in-person.<br /><br />Contact us at txbsm.testing@gmail.com</p></body>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  var connection = PersistentConnection(smtpServer);
  //await connection.send(message);
  await connection.close();
}
