import 'package:firebase_core/firebase_core.dart';
import 'package:home_improvement/Database.dart';

import 'User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  //Register new user
  static Future<bool> registerNewUser(UserObject user) async {
    if (user.email.isEmpty) {
      throw RegistrationError.userIsEmpty;
    } else if (user.password.isEmpty) {
      throw RegistrationError.passwordIsEmpty;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      //Save user to database
      if (credential.user != null) {
        Database.saveUser(user, credential.user!.uid);
      }
      return Future<bool>.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw RegistrationError.passwordIsTooWeak;
      } else if (e.code == 'email-already-in-use') {
        throw RegistrationError.alreadyExists;
      } else if (e.code == "invalid-email") {
        throw RegistrationError.emailIsInvalid;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<ResetPassowrdStatus?> changePassword(UserObject user) async {
    ResetPassowrdStatus? status;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: user.email)
        .then((value) => status = ResetPassowrdStatus.successful)
        .catchError((e) => status = ResetPassowrdStatus.failed);
    return status;
  }
}

enum RegistrationError {
  alreadyExists,
  passwordIsTooWeak,
  userIsEmpty,
  passwordIsEmpty,
  emailIsInvalid
}

enum ResetPassowrdStatus { successful, failed }
