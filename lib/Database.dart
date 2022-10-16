import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:home_improvement/FurnitureTemplate.dart';
import 'package:home_improvement/RoomTemplate.dart';
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
  static void saveFurniture(String uuid, String jsonObject, bool isUpdating) {
    Map<String, dynamic> furnitureData = jsonDecode(jsonObject);

    String furnitureName = furnitureData['name'];
    String furnitureId = furnitureData['id'];

    double xPos = furnitureData['xPos'];
    double yPos = furnitureData['yPos'];

    double xRot = furnitureData['xRot'];
    double yRot = furnitureData['yRot'];
    DatabaseReference db = FirebaseDatabase.instance
        .ref("Furniture/" + uuid + "/" + furnitureName + "/" + furnitureId);

    if (isUpdating) {
      db.update({
        "room_ID": "n/a",
        "xPos": xPos,
        "yPos": yPos,
        "xRot": xRot,
        "yRot": yRot
      });
    } else {
      db.set({
        "room_ID": "n/a",
        "xPos": xPos,
        "yPos": yPos,
        "xRot": xRot,
        "yRot": yRot
      });
    }
  }

  //Remove furniture
  static void removeFurniture(String uuid, String id, String name) {
    DatabaseReference db =
        FirebaseDatabase.instance.ref("Furniture/$uuid/$name/$id");

    db.remove();
  }

  //Fetch furnitures based on userID
  static Future<String> fetchFurnitures(String uuid) async {
    DatabaseReference db = FirebaseDatabase.instance.ref("Furniture/$uuid");

    final snapshot = await db.get();

    if (snapshot.exists) {
      String value = jsonEncode(snapshot.value);
      return value;
    }
    return "";
  }

  //Fetch rooms based on userID
  static Future<String> fetchRooms(String uuid) async {
    DatabaseReference db = FirebaseDatabase.instance.ref("Rooms/$uuid");

    final snapshot = await db.get();

    if (snapshot.exists) {
      String value = jsonEncode(snapshot.value);
      return value;
    }
    return "";
  }

  //Fetches furniture templates from firebase database, else throw an error
  static Future<List<FurnitureTemplate>> fetchFurnitureTemplates() async {
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

  //Fetches room templates from firebase database, else throw an error
  static Future<List<RoomTemplate>> fetchRoomTempaltes() async {
    //Get reference of the database
    DatabaseReference db = FirebaseDatabase.instance.ref();

    //Get snapshot of furniture templates
    final snapshot = await db.child("RoomTemplates").get();

    //Fetch each room and map them into custom objects
    if (snapshot.exists) {
      List<RoomTemplate> templates = [];
      snapshot.children.forEach((furniture) {
        //Get each value inside tempate

        RoomTemplate template = RoomTemplate();
        furniture.children.forEach((value) {
          //Get value for key name
          if (value.key == "key_word") {
            template.key_word = value.value as String;
          }
          //Get value for key imageName
          else if (value.key == "roomName") {
            template.roomName = value.value as String;
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
