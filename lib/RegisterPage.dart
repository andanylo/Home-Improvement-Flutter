import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Register page
class RegisterPage extends StatelessWidget {
  String _title = 'Register';

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
          child: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your nickname',
              ),
            ),
          ),
        ),

        //Enter email container
        Container(
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
          child: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
              ),
            ),
          ),
        ),

        //Enter password container
        Container(
            constraints: const BoxConstraints(maxWidth: 200, minWidth: 150),
            child: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password"),
                obscureText: true,
              ),
            )),
        Container(
          constraints: const BoxConstraints(maxWidth: 150, minWidth: 150),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () {},
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
