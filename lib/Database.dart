import 'dart:convert';

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
  }

  //Save furniture to user
  static void saveFurniture(String uuid, String jsonObject) {
    Map<String, dynamic> furnitureData = jsonDecode(jsonObject);

    String furnitureName = furnitureData['name'];
    String furnitureId = furnitureData['id'];

    double xPos = furnitureData['xPos'];
    double yPos = furnitureData['yPos'];

    double xRot = furnitureData['xRot'];
    double yRot = furnitureData['yRot'];
    DatabaseReference db = FirebaseDatabase.instance
        .ref("Furniture/" + uuid + "/" + furnitureName + "/" + furnitureId);

    db.set({
      "room_ID": "n/a",
      "xPos": xPos,
      "yPos": yPos,
      "xRot": xRot,
      "yRot": yRot
    });
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
