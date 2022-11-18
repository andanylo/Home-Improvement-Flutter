import 'package:flutter/material.dart';

class RoomTemplate {
  late String key_word;
  late String roomName;
}

class RoomTemplateWidget extends StatelessWidget {
  RoomTemplate template;
  RoomTemplateWidget({required this.template});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.blue),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset("assets/images/" + template.key_word + ".png"),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            template.roomName,
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}
