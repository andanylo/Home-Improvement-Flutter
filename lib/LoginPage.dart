import 'package:flutter/material.dart';
import 'package:home_improvement/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_improvement/User.dart';
import 'package:home_improvement/UserValidation.dart';

import 'main.dart';

//Login page
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();

  String _title = 'Login';

  UserError? validationError = null;
  String? emailErrorMsg = null;
  String? passwordErrorMsg = null;

  void setError(UserError error) {
    setState(() {
      this.validationError = error;

      emailErrorMsg = null;
      passwordErrorMsg = null;
      switch (error) {
        case UserError.userIsEmpty:
          emailErrorMsg = "Enter email here";
          break;
        case UserError.passwordIsEmpty:
          passwordErrorMsg = "Enter password here";
          break;
        case UserError.userNotFound:
          emailErrorMsg = "Invalid email, please try again";
          break;
        case UserError.wrongPassword:
          passwordErrorMsg = "Invalid password, please again";
          break;
      }
    });
  }

  Widget loginPage(BuildContext context) {
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
                _title,
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),

        //Enter email container
        Container(
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _emailText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
                errorText: emailErrorMsg,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),

        //Enter password container
        Container(
            constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _passwordText,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password",
                    errorText: passwordErrorMsg),
                obscureText: true,
              ),
            )),
        //Login button container
        Container(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () async {
                //Validate user credentials
                try {
                  await UserValidation.validateUser(
                      UserObject('', _passwordText.text, _emailText.text));

                  //Navigate to unity
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnityDemoScreen()));
                } on UserError catch (e, _) {
                  setError(e);
                }
              },
              child: const Text('Login'),
            ),
          ),
        ),
        //Forgot password button
        TextButton(onPressed: () {}, child: const Text("Forgot password?")),

        //Create a new account button
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: const Text("Don't have an account? Create one!"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: loginPage(context));
  }
}
