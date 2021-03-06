import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var sender = TextEditingController();
  var password = TextEditingController();
  var recipent = TextEditingController();
  var subject = TextEditingController();
  var ccRecipent= TextEditingController();
  var  bccRecipent= TextEditingController();
  var text = TextEditingController();
  var html = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            TextField(
                decoration: InputDecoration(hintText: "Enter sender's mail id"),
                controller: sender),
            TextField(
                obscureText: true,
                decoration:
                    InputDecoration(hintText: "Enter sender's mail password"),
                controller: password),
            TextField(
              decoration: InputDecoration(hintText: "Recipent"),
              controller: recipent,
            ),
            TextField(decoration: InputDecoration(hintText: "Message")),
            ElevatedButton(
                onPressed: () async {
                  sendMessage();
                },
                child: Text("Send message"))
          ],
        )),
      ),
    );
  }

  Future<void> sendMessage() async {
    String username = 'mailchittadeep@gmail.com';
    String password = 'forgottenpassword';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'e_mailer')
      ..recipients.add('mailchittadeep@gmail.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: ???? :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

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

    await connection.send(message);

    Fluttertoast.showToast(
        msg: "Message is sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
