class Task_Info {
  Task_Info({required this.time, required this.uWillNeeed});

  String time;
  List<String> uWillNeeed;

  String returnItemsNeeded() {
    if (uWillNeeed.isEmpty) {
      return 'No additional items needed for this task';
    }
    var neededItems = '';
    var counter = 1;
    for (String item in uWillNeeed) {
      neededItems += '${counter}. ${item} \n';
      counter += 1;
    }
    return neededItems;
  }
}
