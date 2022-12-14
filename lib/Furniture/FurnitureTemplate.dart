import 'package:flutter/material.dart';

class FurnitureTemplate {
  late String imageName;
  late String furnitureName;
}

class FurnitureTemplateWidget extends StatelessWidget {
  FurnitureTemplate template;
  FurnitureTemplateWidget({required this.template});

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
            child: Image.asset("assets/images/" + template.imageName + ".png"),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            template.furnitureName,
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}
