import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:home_improvement/Database.dart';
import 'package:home_improvement/FurnitureEditButton.dart';
import 'package:home_improvement/FurnitureListPopUp.dart';
import 'package:home_improvement/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'FurnitureTemplate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    runApp(MaterialApp(home: (user == null) ? LoginPage() : UnityDemoScreen()));
  });
}

class UnityDemoScreen extends StatefulWidget {
  UnityDemoScreen({super.key});

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  FurnitureListPopUpController furnitureListPopUpController =
      FurnitureListPopUpController();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController.dispose();
    super.dispose();
  }

  var isEditing = false;
  var shouldHideControls = false;

  Widget? unityWidget;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home improvement"),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                setIsEditing();
              },
              child: this.isEditing
                  ? const Center(
                      child: Text("  Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    )
                  : const Icon(Icons.edit)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.account_circle_outlined),
              ),
            )
          ],
        ),
        body: Stack(
          children:
              this.isEditing ? setUpEditingWindow() : disableEditingWindow(),
        ));
  }

  //Get unity widget and crete if needed
  Widget returnUnityWidget() {
    if (this.unityWidget == null) {
      this.unityWidget = UnityWidget(
        onUnityCreated: onUnityCreated,
        onUnityMessage: onUnityMessage,
        onUnitySceneLoaded: onUnitySceneLoaded,
        useAndroidViewSurface: true,
        fullscreen: false,
      );
    }
    return this.unityWidget!;
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    String mes = message as String;
    String key = mes.substring(0, mes.indexOf(':'));
    mes = mes.substring(mes.indexOf(':') + 1, mes.length);

    if (key == 'movement') {
      this.shouldHideControls = mes.toLowerCase() == 'true';
      setState(() {});
    } else if (key == 'saveFurniture') {
      Database.saveFurniture(
          (FirebaseAuth.instance.currentUser == null
              ? ""
              : FirebaseAuth.instance.currentUser!.uid),
          mes);
    }
  }

  //Set is editing, add 'Add' button
  void setIsEditing() {
    bool editing = !this.isEditing;
    furnitureListPopUpController.selectedTemplate = null;
    _unityWidgetController.postMessage(
        'UIManager', 'changeEditingStatus', '$editing');

    setState(() {
      this.isEditing = !this.isEditing;
    });
  }

  //Set current selected template options
  void setSelectedTemplateState(FurnitureTemplate? template) {
    furnitureListPopUpController.selectedTemplate = template;
    setState(() {});
  }

  //Create a plus button
  Widget createPlusButton() {
    return SafeArea(
      bottom: true,
      child: Container(
          margin: EdgeInsets.only(bottom: 30),
          child: ElevatedButton(
            onPressed: () {
              furnitureListPopUpController
                  .updateState(!furnitureListPopUpController.isShow);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
            ),
            child: Icon(Icons.add),
          )),
    );
  }

  void cancelFurnitureEditing() {
    furnitureListPopUpController.selectedTemplate = null;
    _unityWidgetController.postMessage(
        'UIManager', 'cancelFurnitureEditing', '');
    setState(() {});
  }

  //Create edit furniture buttons
  Widget createEditFurnitureButtons() {
    return SafeArea(
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          width: 300,
          child: Row(
            children: [
              FurnitureEditButton(
                icon: const Icon(
                  Icons.cancel,
                  size: 40,
                ),
                pressed: () {
                  cancelFurnitureEditing();
                },
                foregroundColor: Colors.red,
              ),
              const Spacer(),
              FurnitureEditButton(
                pressed: () {
                  _unityWidgetController.postMessage(
                      'UIManager', 'rotateBy90Degrees', 'zxcxz');
                },
                icon: const Icon(
                  Icons.rotate_left,
                  size: 40,
                ),
              ),
              const Spacer(),
              FurnitureEditButton(
                  pressed: () {
                    _unityWidgetController.postMessage(
                        'UIManager', 'saveFurniture', '');
                    cancelFurnitureEditing();
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 40,
                  ))
            ],
          ),
        ));
  }

  //Get widgets
  List<Widget> setUpEditingWindow() {
    Widget unity = returnUnityWidget();
    return [
      unity,
      Align(
          alignment: Alignment.bottomCenter,
          child: this.furnitureListPopUpController.selectedTemplate == null
              ? createPlusButton()
              : (this.shouldHideControls
                  ? null
                  : createEditFurnitureButtons())),
      Align(
        alignment: Alignment.bottomCenter,
        child: FurnitureListPopUp(
          controller: furnitureListPopUpController,
          onTemplateSelect: (FurnitureTemplate template) {
            //Assign selected template and hide list popup
            setSelectedTemplateState(template);
            furnitureListPopUpController.updateState(false);

            _unityWidgetController
                .postJsonMessage('UIManager', 'addNewFurniture', {
              'furnitureName': template.furnitureName,
              'furnitureImage': template.imageName,
            });
          },
        ),
      ),
    ];
  }

  List<Widget> disableEditingWindow() {
    Widget unity = returnUnityWidget();
    return [unity];
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    print('Received scene loaded from unity: ${scene?.name}');
    print('Received scene loaded from unity buildIndex: ${scene?.buildIndex}');
  }
}
