import 'package:firebase_database/firebase_database.dart';
import 'package:home_improvement/User.dart';

class Database {
  //Save user
  static void saveUser(UserObject user, String uuid) {
    DatabaseReference db = FirebaseDatabase.instance.ref("users/" + uuid);
    db.set({
      "email": user.email,
      "password": user.password,
      "username": user.username
    });
    print("object set");
  }
}
