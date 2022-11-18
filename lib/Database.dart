import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:home_improvement/Furniture/FurnitureTemplate.dart';
import 'package:home_improvement/Room/RoomTemplate.dart';
import 'package:home_improvement/TaskValuesPopUp.dart';
import 'package:home_improvement/Task_Demo.dart';
import 'package:home_improvement/Task_Info.dart';
import 'package:home_improvement/Task_Intro.dart';
import 'package:home_improvement/User/User.dart';

class PlayerTask {
  late String task_title;
  late String DelayTime;
  late int award;
  late String checkUpStatus;
  late bool complete_Status;

  PlayerTask();
  factory PlayerTask.fromJson(Map<String, dynamic> json) {
    PlayerTask task = PlayerTask();

    task.task_title = json['task_title'];
    task.DelayTime = json['DelayTime'];
    task.award = json['award'];
    task.checkUpStatus = json['checkUpStatus'];
    task.complete_Status = json['complete_Status'];
    return task;
  }
}

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

  //static void updatePassword(UserObject user, String uuid)

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

  //Save room to user
  static void saveRoom(String uuid, String jsonObject, bool isUpdating) {
    Map<String, dynamic> roomData = jsonDecode(jsonObject);

    String roomName = roomData['key_word'];
    String roomId = roomData['id'];

    double xPos = roomData['xPos'];
    double yPos = roomData['yPos'];

    double xRot = roomData['xRot'];
    double yRot = roomData['yRot'];

    List<dynamic> connections = roomData['connections'];
    DatabaseReference db =
        FirebaseDatabase.instance.ref("Rooms/$uuid/$roomName/$roomId");
    if (isUpdating) {
      db.update({
        "xPos": xPos,
        "yPos": yPos,
        "xRot": xRot,
        "yRot": yRot,
        "connections": connections
      });
    } else {
      db.set({
        "xPos": xPos,
        "yPos": yPos,
        "xRot": xRot,
        "yRot": yRot,
        "connections": connections
      });
    }
  }

  //Return task values pop up
  static Future<TaskValuesPopUp?> fetchTaskComponents(
      String furnitureName) async {
    DatabaseReference databaseTaskIntro =
        FirebaseDatabase.instance.ref("Task_Intro/$furnitureName");

    DatabaseReference databaseTaskInfo =
        FirebaseDatabase.instance.ref("Task_Info/$furnitureName");

    DatabaseReference databaseTaskDemo =
        FirebaseDatabase.instance.ref("Task_Demo/$furnitureName");

    final introSnapshot = await databaseTaskIntro.get();
    final infoSnapshot = await databaseTaskInfo.get();
    final demoSnapshot = await databaseTaskDemo.get();

    TaskIntro? taskIntro;
    Task_Info? task_info;
    Task_Demo? task_demo;

    //Get task intro from database
    if (introSnapshot.exists) {
      String openingStatement = '';
      String whenStatement = '';
      String whyStatement = '';
      String warningStatement = '';
      introSnapshot.children.forEach((element) {
        if (element.key == "Opening_Statement") {
          openingStatement = element.value as String;
        } else if (element.key == "Warning_Message") {
          warningStatement = element.value as String;
        } else if (element.key == "When_Statement") {
          whenStatement = element.value as String;
        } else if (element.key == "Why_Statement") {
          whyStatement = element.value as String;
        }
        taskIntro = TaskIntro(
            opening_Statement: openingStatement,
            warning_Statement: warningStatement,
            when_Statement: whenStatement,
            why_Statement: whyStatement);
      });
    }

    //Get task info
    if (infoSnapshot.exists) {
      String time = '';
      List<String> uWillNeeed = [];
      infoSnapshot.children.forEach((element) {
        if (element.key == "Time") {
          time = element.value as String;
        } else if (element.key == "UWillNeed") {
          (element.value as List<Object?>).forEach((items) {
            if (items != null) {
              uWillNeeed.add(items as String);
            }
          });
        }
      });

      task_info = Task_Info(time: time, uWillNeeed: uWillNeeed);
    }

    //Get task demo
    if (demoSnapshot.exists) {
      List<String> images = [];
      List<String> steps = [];

      demoSnapshot.children.forEach((element) {
        print(element.value);
        if (element.key == "Images") {
          (element.value as List<Object?>).forEach((image) {
            if (image != null) {
              images.add(image as String);
            }
          });
        } else if (element.key == "Steps") {
          print(element.value);
          (element.value as List<Object?>).forEach((step) {
            if (step != null) {
              steps.add(step as String);
            }
          });
        }
      });
      print(images);
      print(steps);
      task_demo = Task_Demo();
      task_demo.images = images;
      task_demo.steps = steps;
    }

    if (taskIntro != null && task_info != null && task_demo != null) {
      String title = furnitureName.replaceAll("_", " ");
      title = title[0].toUpperCase() + title.substring(1);
      return TaskValuesPopUp(
          taskInfo: task_info,
          taskIntro: taskIntro!,
          task_demo: task_demo,
          title: title);
    }
    return null;
  }

  //Save player tasks
  static Future<void> savePlayerTask(
      String uuid, String jsonObject, bool isUpdating) async {
    Map<String, dynamic> playerTask = jsonDecode(jsonObject);
    String task_title = playerTask['task_title'];
    String furnitureID = playerTask['furnitureID'];
    String delayTime = playerTask['DelayTime'];

    int award = playerTask['award'];
    String checkUpStatus = playerTask['checkUpStatus'];

    bool complete_Status = playerTask['complete_Status'];
    DatabaseReference db =
        FirebaseDatabase.instance.ref("PlayerTasks/$uuid/$furnitureID");
    if (isUpdating) {
      await db.update({
        "task_title": task_title,
        "DelayTime": delayTime,
        "award": award,
        "checkUpStatus": checkUpStatus,
        "complete_Status": complete_Status
      });
    } else {
      await db.set({
        "task_title": task_title,
        "DelayTime": delayTime,
        "award": award,
        "checkUpStatus": checkUpStatus,
        "complete_Status": complete_Status
      });
    }
  }

  //Remove furniture
  static void removeFurniture(String uuid, String id, String name) {
    DatabaseReference db =
        FirebaseDatabase.instance.ref("Furniture/$uuid/$name/$id");

    db.remove();
  }

  static void removeRoom(String uuid, String id, String name) {
    DatabaseReference db =
        FirebaseDatabase.instance.ref("Rooms/$uuid/$name/$id");

    db.remove();
  }

  static Future<void> removePlayerTask(String uuid, String furnitureID) async {
    DatabaseReference db =
        FirebaseDatabase.instance.ref("PlayerTasks/$uuid/$furnitureID");

    await db.remove();
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

  //Fetch tasks
  static Future<String> fetchTasks() async {
    DatabaseReference db = FirebaseDatabase.instance.ref("Task");
    final snapshot = await db.get();
    if (snapshot.exists) {
      String value = jsonEncode(snapshot.value);
      return value;
    }
    return "";
  }

  //Fetch player tasks
  static Future<String> fetchPlayerTasks(String uuid) async {
    DatabaseReference db = FirebaseDatabase.instance.ref("PlayerTasks/$uuid");
    final snapshot = await db.get();
    if (snapshot.exists) {
      String value = jsonEncode(snapshot.value);
      return value;
    }
    return "";
  }

  //Fetch player tasks and return player task list
  static Future<List<PlayerTask>> fetchPlayerTasksAndDecode(String uuid) async {
    Map<String, dynamic> decoded =
        jsonDecode(await Database.fetchPlayerTasks(uuid));

    List<PlayerTask> playerTasks = [];
    for (dynamic decodedTaskString in decoded.values) {
      print(decodedTaskString);
      Map<String, dynamic> dict = decodedTaskString;
      PlayerTask decodedPlayerTask = PlayerTask.fromJson(dict);
      playerTasks.add(decodedPlayerTask);
    }

    return playerTasks;
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
