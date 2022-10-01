import 'package:firebase_database/firebase_database.dart';
import 'package:home_improvement/FurnitureTemplate.dart';
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

  //Fetches furniture templates from firebase database, else throw an error
  static Future<List<FurnitureTemplate>> fetchTemplates() async {
    //Get reference of the database
    DatabaseReference db = FirebaseDatabase.instance.ref();

    //Get snapshot of furniture templates
    final snapshot = await db.child("FurnitureTemplates").get();

    //Fetch each furniture and map them into custom objects
    if (snapshot.exists) {
      List<FurnitureTemplate> templates = [];
      snapshot.children.forEach((furniture) {
        //Get each value inside tempate

        FurnitureTemplate template = FurnitureTemplate();
        furniture.children.forEach((value) {
          //Get value for key name
          if (value.key == "name") {
            template.furnitureName = value.value as String;
          }
          //Get value for key imageName
          else if (value.key == "imageName") {
            template.imageName = value.value as String;
          }
        });

        templates.add(template);
      });
      return templates;
    } else {
      print("Can't find snapshot");
    }
    return [];
  }
}
