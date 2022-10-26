// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   //bool isVisible = true;
//   //bool onFinalPage = false;
//   PageController _pageController = PageController(initialPage: 0);

//   List<Widget> _taskPages = <Widget>[
//     //Page 1
//     Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           RichText(
//             text: TextSpan(
//               children: <TextSpan>[
//                 TextSpan(
//                     text:
//                         'it has come time that you must cover your airconditioner for the winter \n\n',
//                     style:
//                         TextStyle(color: Colors.black, fontFamily: 'Roboto')),
//                 TextSpan(
//                     text: 'Why? \n',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         fontFamily: 'RobotoSerif-Bold')),
//                 TextSpan(
//                     text:
//                         'during the harsh winter, water and collect up inside and freeze in its coils. This may save you money in repairs. \n\n',
//                     style:
//                         TextStyle(color: Colors.black, fontFamily: 'Roboto')),
//                 TextSpan(
//                     text: 'When? \n',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         fontFamily: 'RobotoSerif-Bold')),
//                 TextSpan(
//                     text:
//                         'this should be done at least the middle of fall \n\n',
//                     style:
//                         TextStyle(color: Colors.black, fontFamily: 'Roboto')),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(0),
//             child: new Row(
//               children: <Widget>[
//                 new Padding(
//                     padding: EdgeInsets.only(top: 0),
//                     child: new Image.asset(
//                       "images/sign-g1554ec01b_1280.png",
//                       width: 90,
//                       height: 90,
//                     )),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 16),
//                     child: Text(
//                         'If this is not done, your airconditioner will be damaged to point you will need to have it repaired or replaced!'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //       _buildIntroPageRow()
//         ],
//       ),
//     ),

//     //Page 2
//     Container(
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
//             child: new Row(
//               children: <Widget>[
//                 new Padding(
//                     padding: EdgeInsets.only(top: 0),
//                     child: new Image.asset("images/hammer-gbc7ca48d1_1280.png",
//                         width: 90, height: 90)),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 16),
//                     child: Text('You will need:',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             //fontFamily: 'Roboto',
//                             fontSize: 20)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//               padding: EdgeInsets.all(20),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.5),
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 //color: Colors.blue
//                 child: SizedBox(
//                   height: 100,
//                   width: 250,
//                   child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text("Lorem Ipsum is simply dummy text"),
//                       )),
//                 ),
//               )),
//           Padding(
//             padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
//             child: new Row(
//               children: <Widget>[
//                 new Padding(
//                     padding: EdgeInsets.only(top: 0),
//                     child: new Image.asset("images/icon-gda2206041_1280.png",
//                         width: 90, height: 90)),
//                 Expanded(
//                   child: Padding(
//                       padding: EdgeInsets.only(left: 16),
//                       child: Text(
//                         'Time:',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             //fontFamily: 'Roboto',
//                             fontSize: 20),
//                       )),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//               padding: EdgeInsets.all(20),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.5),
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 //color: Colors.blue
//                 child: SizedBox(
//                   //border:
//                   height: 100,
//                   width: 250,

//                   child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text("Lorem Ipsum is simply dummy text"),
//                       )),
//                 ),
//               )),
//         ],
//       ),
//     ),

//     //Page 3
//     Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               "Demonstration:",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   //fontFamily: 'Roboto',
//                   fontSize: 35),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: SizedBox(
//               height: 200,
//               child: ImageSlideshow(
//                 initialPage: 0,
//                 indicatorRadius: 8,
//                 indicatorColor: Colors.blue,
//                 indicatorBackgroundColor: Colors.grey,
//                 children: [
//                   Image.asset(
//                     'images/Sunken_Condos.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                   Image.asset(
//                     'images/The_Nightfly.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             "Steps:",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 //fontFamily: 'Roboto',
//                 fontSize: 20),
//           ),
//           Padding(
//             padding: EdgeInsets.all(30),
//             child: Align(
//                 alignment: Alignment.center,
//                 //padding: EdgeInsets.all(0),

//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.5),
//                       borderRadius: BorderRadius.all(Radius.circular(10))),
//                   //color: Colors.blue
//                   child: SizedBox(
//                     //border:
//                     height: 100,
//                     width: 250,

//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text("Lorem Ipsum is simply dummy text"),
//                       ),
//                     ),
//                   ),
//                 )),
//           ),
//         ],
//       ),
//     ),

//     //"page4"
//     Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           //crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "Well Done!",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   //fontFamily: 'Roboto',
//                   fontSize: 35),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 50, bottom: 50),
//               child: new Image.asset("images/check-mark-g11239e8e9_1280.png"),
//             ),
//             Text(
//               "You Have Completed This Task!",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   //fontFamily: 'Roboto',
//                   fontSize: 20),
//             ),
//           ],
//         )),
//   ];

//   int _currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) => _taskPopup(context));
//         },
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   Widget _taskPopup(BuildContext context) {
//     return new Dialog(
//       insetPadding: EdgeInsets.only(top: 40, bottom: 40),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Air Conditioner"),
//           centerTitle: true,
//         ),
//         body: PageView(
//           children: _taskPages,
//           onPageChanged: (pageNum) {
//             setState(() {
//               _currentPage = pageNum;

//               if (_currentPage == _taskPages.length - 1) {}
//             });
//           },
//           controller: _pageController,
//         ),
//         floatingActionButton: Padding(
//           padding: EdgeInsets.only(left: 30),
//           child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 FloatingActionButton(
//                   onPressed: () {
//                     if (_currentPage != 0) {
//                       print("jump backward");
//                       _pageController.jumpToPage(_currentPage - 1);
//                     } else {
//                       print("reached beginning");
//                       _pageController.jumpToPage(0);
//                     }
//                   },
//                   child: Icon(Icons.arrow_back),
//                 ),
//                 FloatingActionButton(
//                   onPressed: () {
//                     if (_currentPage != _taskPages.length - 1) {
//                       print("jump ahead");
//                       _pageController.jumpToPage(_currentPage + 1);
//                     } else {
//                       print("end reached");
//                       _pageController.jumpToPage(_taskPages.length - 1);
//                     }
//                   },
//                   child: Icon(Icons.arrow_forward),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
// }
