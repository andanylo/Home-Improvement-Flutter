import 'package:home_improvement/Task_Demo.dart';
import 'package:home_improvement/Task_Intro.dart';

import 'Task_Info.dart';

class TaskValuesPopUp {
  TaskValuesPopUp(
      {required this.taskIntro,
      required this.taskInfo,
      required this.task_demo,
      required this.title});

  TaskIntro taskIntro;
  Task_Info taskInfo;
  Task_Demo task_demo;

  String title;
}
