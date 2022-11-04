import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:home_improvement/TaskValuesPopUp.dart';

import 'Database.dart';

class TaskPopUp extends StatefulWidget {
  TaskPopUp({super.key, required this.shouldShowButton});

  bool shouldShowButton;
  String? currentClosestFurniture = null;
  late TaskValuesPopUp taskValues;

  VoidCallback? didCompleteTask;

  @override
  State<TaskPopUp> createState() => _TaskPopUp();
}

class _TaskPopUp extends State<TaskPopUp> {
  //bool isVisible = true;
  //bool onFinalPage = false;
  PageController _pageController = PageController(initialPage: 0);

  List<Image> returnImages() {
    List<Image> images = [];

    for (String imageLink in widget.taskValues.task_demo.images) {
      images.add(Image.network(
        imageLink,
        fit: BoxFit.cover,
      ));
    }
    return images;
  }

  List<Widget> returnTaskPages() {
    return <Widget>[
      //Page 1
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SafeArea(
                child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'It has come time that you need to ${widget.taskValues.taskIntro.opening_Statement.toLowerCase()}  \n\n',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const TextSpan(
                      text: 'Why? \n',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'RobotoSerif-Bold')),
                  TextSpan(
                      text: '${widget.taskValues.taskIntro.why_Statement} \n\n',
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Roboto')),
                  const TextSpan(
                      text: 'When? \n',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'RobotoSerif-Bold')),
                  TextSpan(
                      text:
                          '${widget.taskValues.taskIntro.when_Statement} \n\n',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Roboto')),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                        "assets/images/sign-g1554ec01b_1280.png",
                        width: 90,
                        height: 90,
                      )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                          '${widget.taskValues.taskIntro.warning_Statement}'),
                    ),
                  ),
                ],
              ),
            ),
            //       _buildIntroPageRow()
          ],
        ),
      ),

      //Page 2
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                          "assets/images/hammer-gbc7ca48d1_1280.png",
                          width: 90,
                          height: 90)),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('You will need:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              //fontFamily: 'Roboto',
                              fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  //color: Colors.blue
                  child: SizedBox(
                    height: 100,
                    width: 250,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              widget.taskValues.taskInfo.returnItemsNeeded()),
                        )),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                          "assets/images/icon-gda2206041_1280.png",
                          width: 90,
                          height: 90)),
                  const Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Time:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              //fontFamily: 'Roboto',
                              fontSize: 20),
                        )),
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  //color: Colors.blue
                  child: SizedBox(
                    //border:
                    height: 100,
                    width: 250,

                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(widget.taskValues.taskInfo.time),
                        )),
                  ),
                )),
          ],
        ),
      ),

      //Page 3
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Demonstration:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontFamily: 'Roboto',
                    fontSize: 35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 200,
                child: ImageSlideshow(
                  initialPage: 0,
                  indicatorRadius: 8,
                  indicatorColor: Colors.blue,
                  indicatorBackgroundColor: Colors.grey,
                  children: returnImages(),
                ),
              ),
            ),
            const Text(
              "Steps:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontFamily: 'Roboto',
                  fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Align(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.all(0),

                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //color: Colors.blue
                    child: SizedBox(
                      //border:
                      height: 100,
                      width: 250,

                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child:
                              Text(widget.taskValues.task_demo.returnSteps()),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),

      //"page4"
      Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Well Done!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontFamily: 'Roboto',
                    fontSize: 35),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: new Image.asset(
                    "assets/images/check-mark-g11239e8e9_1280.png"),
              ),
              const Text(
                "You Have Completed This Task!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontFamily: 'Roboto',
                    fontSize: 20),
              ),
            ],
          )),
    ];
  }

  // final List<Widget> _taskPages = <Widget>[
  //   //Page 1
  //   Container(
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: <Widget>[
  //         SafeArea(
  //             child: RichText(
  //           text: TextSpan(
  //             children: <TextSpan>[
  //               TextSpan(
  //                   text:
  //                       'It has come time that you need to ${widget.taskValues.taskIntro.opening_Statement}  \n\n',
  //                   style:
  //                       TextStyle(color: Colors.black, fontFamily: 'Roboto')),
  //               TextSpan(
  //                   text: 'Why? \n',
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                       fontFamily: 'RobotoSerif-Bold')),
  //               TextSpan(
  //                   text:
  //                       'during the harsh winter, water and collect up inside and freeze in its coils. This may save you money in repairs. \n\n',
  //                   style:
  //                       TextStyle(color: Colors.black, fontFamily: 'Roboto')),
  //               TextSpan(
  //                   text: 'When? \n',
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                       fontFamily: 'RobotoSerif-Bold')),
  //               TextSpan(
  //                   text:
  //                       'this should be done at least the middle of fall \n\n',
  //                   style:
  //                       TextStyle(color: Colors.black, fontFamily: 'Roboto')),
  //             ],
  //           ),
  //         )),
  //         Padding(
  //           padding: EdgeInsets.all(0),
  //           child: new Row(
  //             children: <Widget>[
  //               Padding(
  //                   padding: const EdgeInsets.only(top: 0),
  //                   child: new Image.asset(
  //                     "assets/images/sign-g1554ec01b_1280.png",
  //                     width: 90,
  //                     height: 90,
  //                   )),
  //               const Expanded(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 16),
  //                   child: Text(
  //                       'If this is not done, your airconditioner will be damaged to point you will need to have it repaired or replaced!'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         //       _buildIntroPageRow()
  //       ],
  //     ),
  //   ),

  //   //Page 2
  //   Container(
  //     child: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
  //           child: new Row(
  //             children: <Widget>[
  //               new Padding(
  //                   padding: EdgeInsets.only(top: 0),
  //                   child: new Image.asset(
  //                       "assets/images/hammer-gbc7ca48d1_1280.png",
  //                       width: 90,
  //                       height: 90)),
  //               const Expanded(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 16),
  //                   child: Text('You will need:',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           //fontFamily: 'Roboto',
  //                           fontSize: 20)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //             padding: EdgeInsets.all(20),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.blue.withOpacity(0.5),
  //                   borderRadius: BorderRadius.all(Radius.circular(10))),
  //               //color: Colors.blue
  //               child: const SizedBox(
  //                 height: 100,
  //                 width: 250,
  //                 child: SingleChildScrollView(
  //                     scrollDirection: Axis.vertical,
  //                     child: Padding(
  //                       padding: EdgeInsets.all(10),
  //                       child: Text("Lorem Ipsum is simply dummy text"),
  //                     )),
  //               ),
  //             )),
  //         Padding(
  //           padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
  //           child: new Row(
  //             children: <Widget>[
  //               new Padding(
  //                   padding: EdgeInsets.only(top: 0),
  //                   child: new Image.asset(
  //                       "assets/images/icon-gda2206041_1280.png",
  //                       width: 90,
  //                       height: 90)),
  //               const Expanded(
  //                 child: Padding(
  //                     padding: EdgeInsets.only(left: 16),
  //                     child: Text(
  //                       'Time:',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           //fontFamily: 'Roboto',
  //                           fontSize: 20),
  //                     )),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //             padding: EdgeInsets.all(20),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.blue.withOpacity(0.5),
  //                   borderRadius: BorderRadius.all(Radius.circular(10))),
  //               //color: Colors.blue
  //               child: const SizedBox(
  //                 //border:
  //                 height: 100,
  //                 width: 250,

  //                 child: SingleChildScrollView(
  //                     scrollDirection: Axis.vertical,
  //                     child: Padding(
  //                       padding: EdgeInsets.all(10),
  //                       child: Text("Lorem Ipsum is simply dummy text"),
  //                     )),
  //               ),
  //             )),
  //       ],
  //     ),
  //   ),

  //   //Page 3
  //   Container(
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         const Align(
  //           alignment: Alignment.center,
  //           child: Text(
  //             "Demonstration:",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 //fontFamily: 'Roboto',
  //                 fontSize: 35),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(20),
  //           child: SizedBox(
  //             height: 200,
  //             child: ImageSlideshow(
  //               initialPage: 0,
  //               indicatorRadius: 8,
  //               indicatorColor: Colors.blue,
  //               indicatorBackgroundColor: Colors.grey,
  //               children: [
  //                 Image.asset(
  //                   'images/Sunken_Condos.jpg',
  //                   fit: BoxFit.cover,
  //                 ),
  //                 Image.asset(
  //                   'images/The_Nightfly.jpg',
  //                   fit: BoxFit.cover,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const Text(
  //           "Steps:",
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               //fontFamily: 'Roboto',
  //               fontSize: 20),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(30),
  //           child: Align(
  //               alignment: Alignment.center,
  //               //padding: EdgeInsets.all(0),

  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     color: Colors.blue.withOpacity(0.5),
  //                     borderRadius: BorderRadius.all(Radius.circular(10))),
  //                 //color: Colors.blue
  //                 child: const SizedBox(
  //                   //border:
  //                   height: 100,
  //                   width: 250,

  //                   child: SingleChildScrollView(
  //                     scrollDirection: Axis.vertical,
  //                     child: Padding(
  //                       padding: EdgeInsets.all(10),
  //                       child: Text("Lorem Ipsum is simply dummy text"),
  //                     ),
  //                   ),
  //                 ),
  //               )),
  //         ),
  //       ],
  //     ),
  //   ),

  //   //"page4"
  //   Container(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         //crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Well Done!",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 //fontFamily: 'Roboto',
  //                 fontSize: 35),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(top: 50, bottom: 50),
  //             child: new Image.asset(
  //                 "assets/images/check-mark-g11239e8e9_1280.png"),
  //           ),
  //           const Text(
  //             "You Have Completed This Task!",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 //fontFamily: 'Roboto',
  //                 fontSize: 20),
  //           ),
  //         ],
  //       )),
  // ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Align(
      alignment: Alignment.bottomLeft,
      child: widget.shouldShowButton
          ? Padding(
              padding: EdgeInsets.only(left: 15),
              child: ElevatedButton(
                  onPressed: () async {
                    TaskValuesPopUp? taskValuesPopUp =
                        await getTaskValuesPopUp();
                    if (taskValuesPopUp != null) {
                      widget.taskValues = taskValuesPopUp;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return _taskPopup(context, setState);
                              },
                            );
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    'Interact',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )))
          : Container(),
    )); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<TaskValuesPopUp?> getTaskValuesPopUp() async {
    if (widget.currentClosestFurniture != null) {
      TaskValuesPopUp? values =
          await Database.fetchTaskComponents(widget.currentClosestFurniture!);
      return values;
    }
    return null;
  }

  bool reachedEnd = false;
  Widget _taskPopup(
      BuildContext context, void Function(void Function()) setState) {
    // _currentPage = 0;
    // _pageController.jumpToPage(0);
    var _taskPages = returnTaskPages();
    return Dialog(
      insetPadding:
          const EdgeInsets.only(top: 40, bottom: 40, left: 10, right: 10),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.taskValues.title),
          centerTitle: true,
        ),
        body: PageView(
          children: _taskPages,
          onPageChanged: (pageNum) {
            _currentPage = pageNum;

            if (_currentPage == _taskPages.length - 1) {
              reachedEnd = true;
              print(reachedEnd);
            } else {
              reachedEnd = false;
            }
            setState(() {});
          },
          controller: _pageController,
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  onPressed: () {
                    if (_currentPage != 0) {
                      print("jump backward");
                      _pageController.jumpToPage(_currentPage - 1);
                    } else {
                      print("reached beginning");
                      _pageController.jumpToPage(0);
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text("Back"),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (_currentPage != _taskPages.length - 1) {
                      print("jump ahead");
                      _pageController.jumpToPage(_currentPage + 1);
                    } else {
                      if (widget.didCompleteTask != null) {
                        widget.didCompleteTask!();
                      }

                      _pageController.jumpToPage(_taskPages.length - 1);

                      Navigator.pop(context, true);
                    }
                  },
                  icon: reachedEnd
                      ? Icon(Icons.check)
                      : Icon(Icons.arrow_forward),
                  label: reachedEnd ? Text("Complete") : Text("Next"),
                ),
              ]),
        ),
      ),
    );
  }
}
