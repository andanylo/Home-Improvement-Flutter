import 'dart:ffi';

import 'User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserValidation {
  //Check if user input valid
  static Future<bool> validateUser(UserObject user) async {
    //Throw error if user email is empty or password is empty
    if (user.email.isEmpty) {
      throw UserError.userIsEmpty;
    } else if (user.password.isEmpty) {
      throw UserError.passwordIsEmpty;
    }

    //Check credentials with Firebase
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      return Future<bool>.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        throw UserError.userNotFound;
      } else if (e.code == 'wrong-password') {
        throw UserError.wrongPassword;
      } else {
        throw UserError.userNotFound;
      }
    }
  }
}

enum UserError { userNotFound, wrongPassword, userIsEmpty, passwordIsEmpty }
