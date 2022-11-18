import 'package:flutter/material.dart';
import 'package:home_improvement/User/User.dart';
import 'package:home_improvement/User/UserManager.dart';
import 'package:home_improvement/User/UserValidation.dart';

import '';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final _emailText = TextEditingController();
  Widget body(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            width: 200,
            child: Row(
              children: [
                Text(
                  "Reset password",
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _emailText,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your email',
                  //errorText: emailErrorMsg,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          Container(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () async {
                  ResetPassowrdStatus? status =
                      await UserManager.changePassword(
                          UserObject('', '', _emailText.text));
                  if (status != ResetPassowrdStatus.successful) {
                    showAlertDialog(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send password link'),
              ),
            ),
          ),
        ]));
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: const Text(
          "Failed to send a new password link, please try entering another email"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reset password"),
        ),
        body: body(context));
  }
}
