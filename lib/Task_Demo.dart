class Task_Demo {
  late List<String> images;
  late List<String> steps;

  String returnSteps() {
    if (steps.isEmpty) {
      return "No steps required for this task";
    }
    String stepsString = '';
    int counter = 1;
    for (String step in steps) {
      stepsString += '${counter}. ${step} \n';
      counter += 1;
    }
    return stepsString;
  }
}
