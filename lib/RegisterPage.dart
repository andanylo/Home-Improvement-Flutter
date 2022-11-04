import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_improvement/User.dart';
import 'package:home_improvement/UserManager.dart';

import 'main.dart';

//Register page
class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String _title = 'Register';

  final _usernameTxt = TextEditingController();
  final _emailTxt = TextEditingController();
  final _passwordTxt = TextEditingController();

  RegistrationError? error = null;

  String? emailErrorMsg = null;
  String? passwordErrorMsg = null;

  void setError(RegistrationError error) {
    setState(() {
      this.error = error;

      emailErrorMsg = null;
      passwordErrorMsg = null;
      switch (error) {
        case RegistrationError.userIsEmpty:
          emailErrorMsg = "Enter email here";
          break;
        case RegistrationError.passwordIsEmpty:
          passwordErrorMsg = "Enter password here";
          break;
        case RegistrationError.emailIsInvalid:
          emailErrorMsg = "Invalid email, please try again";
          break;
        case RegistrationError.passwordIsTooWeak:
          passwordErrorMsg = "Password, please try again";
          break;
        case RegistrationError.alreadyExists:
          emailErrorMsg = "User already exists";
      }
    });
  }

  //Create register page
  Widget registerPage(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Title label
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
        //Enter your nickname
        Container(
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _usernameTxt,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your nickname',
              ),
            ),
          ),
        ),

        //Enter email container
        Container(
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _emailTxt,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
                errorText: emailErrorMsg,
              ),
            ),
          ),
        ),

        //Enter password container
        Container(
            constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _passwordTxt,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password",
                    errorText: passwordErrorMsg),
                obscureText: true,
              ),
            )),
        Container(
          constraints: const BoxConstraints(maxWidth: 150, minWidth: 150),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await UserManager.registerNewUser(UserObject(
                      _usernameTxt.text, _passwordTxt.text, _emailTxt.text));

                  if (!mounted) return;
                  //Navigate to unity
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnityDemoScreen()));
                } on RegistrationError catch (e, _) {
                  setError(e);
                }
              },
              child: const Text('Create an account'),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: registerPage(context));
  }
}
