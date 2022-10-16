import 'package:flutter/material.dart';
import 'package:home_improvement/Database.dart';
import 'package:provider/provider.dart';

import 'RoomTemplate.dart';

//Controller with notifier
class RoomListPopUpController with ChangeNotifier {
  bool isShow = false;
  RoomTemplate? selectedTemplate;

  List<RoomTemplate> templates = [];
  void updateState(bool newState) {
    isShow = newState;
    notifyListeners();
  }

  void updateTemplates(List<RoomTemplate> templates) {
    this.templates = templates;
    notifyListeners();
  }
}

class RoomListPopUp extends StatefulWidget {
  final RoomListPopUpController controller;

  //Function to return a selected template
  final void Function(RoomTemplate) onTemplateSelect;

  RoomListPopUp({required this.controller, required this.onTemplateSelect});

  _RoomListPopUp createState() => _RoomListPopUp();
}

//Catch notifications with widget and reload if needed
class _RoomListPopUp extends State<RoomListPopUp> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();

    getTemplatesFromDatabase();
  }

  //Get templates and update controller
  Future<void> getTemplatesFromDatabase() async {
    List<RoomTemplate> templates = await Database.fetchRoomTempaltes();
    widget.controller.updateTemplates(templates);
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.isShow
        ? Container(
            alignment: Alignment.bottomCenter,
            height: 600,
            // ignore: sort_child_properties_last
            child: Column(children: [
              Stack(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Add a room",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: TextButton(
                            onPressed: () {
                              widget.controller
                                  .updateState(!widget.controller.isShow);
                            },
                            child: Text("Cancel"))),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: GridView.count(
                        childAspectRatio: 0.75,
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        children: List.generate(
                            widget.controller.templates.length, (index) {
                          RoomTemplate template =
                              widget.controller.templates[index];

                          return GestureDetector(
                              onTap: () => widget.onTemplateSelect(template),
                              child: RoomTemplateWidget(
                                template: template,
                              ));
                        }),
                      )))
            ]),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
          )
        : Container();
  }
}
