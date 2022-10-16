import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:home_improvement/Database.dart';
import 'package:home_improvement/FurnitureEditButton.dart';
import 'package:home_improvement/FurnitureListPopUp.dart';
import 'package:home_improvement/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_improvement/RoomListPopUp.dart';
import 'FurnitureTemplate.dart';
import 'RoomTemplate.dart';
import 'firebase_options.dart';

enum EditingMode { room, furniture }

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

  RoomListPopUpController roomListPopUpController = RoomListPopUpController();

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
  var shouldHideFurnitureControls = false;

  var isFurnitureEditWindowIsEnabled = false;
  var isEditingFurniture = false;
  var shouldDisableAddButton = false;

  EditingMode? currentEditingMode;

  String? editingFurnitureName;
  String? editingFurnitureID;

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
                onTapDown: (details) => {
                  //Show account actions
                  showMenuOptions(details, context)
                },
                child: const Icon(Icons.account_circle_outlined),
              ),
            ),
          ],
        ),
        body: Stack(
          children:
              this.isEditing ? setUpEditingWindow() : disableEditingWindow(),
        ));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> showMenuOptions(
      TapDownDetails details, BuildContext context) async {
    int? selectedValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          details.globalPosition.dx, details.globalPosition.dy, 0, 0),
      elevation: 2,
      items: [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: const [
                Icon(Icons.edit),
                SizedBox(
                  width: 10,
                ),
                Text("Edit account info")
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              children: const [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text("Logout")
              ],
            ))
      ],
    );
    if (selectedValue == 2) {
      _signOut();
    }
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

    fetchFurniture();
  }

  void fetchFurniture() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      //Fetch furnitures
      String jsonFurnitures = await Database.fetchFurnitures(user!.uid);
      //Add furnitures to unity
      this._unityWidgetController.postMessage(
          'FurnitureAdder', 'recieveFurnituresFromDatabase', jsonFurnitures);
    });
  }

  void fetchRoom() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      String jsonRooms = await Database.fetchRooms(user!.uid);

      this
          ._unityWidgetController
          .postMessage('RoomAdder', 'recieveRoomsFromDatabase', jsonRooms);
    });
  }

  void onUnityMessage(message) {
    String mes = message as String;
    String key = mes.substring(0, mes.indexOf(':'));
    mes = mes.substring(mes.indexOf(':') + 1, mes.length);

    if (key == 'movement') {
      this.shouldHideFurnitureControls = mes.toLowerCase() == 'true';
      setState(() {});
    } else if (key == 'saveFurniture') {
      Database.saveFurniture(
          (FirebaseAuth.instance.currentUser == null
              ? ""
              : FirebaseAuth.instance.currentUser!.uid),
          mes,
          false);
    } else if (key == 'updateFurniture') {
      Database.saveFurniture(
          (FirebaseAuth.instance.currentUser == null
              ? ""
              : FirebaseAuth.instance.currentUser!.uid),
          mes,
          true);
    } else if (key == 'saveRoom') {
    } else if (key == 'inside') {
      setState(() {
        this.shouldDisableAddButton = !(mes.toLowerCase() == 'true');
      });
    } else if (key == 'enableFurnitureEditing') {
      Map<String, dynamic> furnitureData = jsonDecode(mes);

      editingFurnitureName = furnitureData['name'];
      editingFurnitureID = furnitureData['id'];

      this.isEditingFurniture = true;
      this.setFurnitureEditingState(true);
    } else if (key == 'presentRoomPopUp') {
      roomListPopUpController.updateState(true);
    }
  }

  //Set is editing, add 'Add' button
  void setIsEditing() {
    bool editing = !this.isEditing;
    furnitureListPopUpController.selectedTemplate = null;
    roomListPopUpController.selectedTemplate = null;
    _unityWidgetController.postMessage(
        'UIManager', 'changeEditingStatus', '$editing');
    if (editing == false) {
      cancelFurnitureEditing();
    }
    setState(() {
      this.isEditing = !this.isEditing;
    });
  }

  //Set current selected template options
  void setFurnitureEditingState(bool shouldEdit) {
    currentEditingMode = EditingMode.furniture;
    if (!shouldEdit) {
      this.isEditingFurniture = false;
      this.currentEditingMode = null;
    }
    isFurnitureEditWindowIsEnabled = shouldEdit;

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
    this.editingFurnitureID = null;
    this.editingFurnitureName = null;
    _unityWidgetController.postMessage(
        'UIManager', 'cancelFurnitureEditing', '');
    setFurnitureEditingState(false);
  }

  void deleteFurniture() {
    _unityWidgetController.postMessage(
        'UIManager', 'deleteFurniture', editingFurnitureID);
    if (editingFurnitureID != null && editingFurnitureName != null) {
      String id = editingFurnitureID!;
      String name = editingFurnitureName!;
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        Database.removeFurniture(user!.uid, id, name);
      });
    }

    cancelFurnitureEditing();
  }

  //Create edit furniture buttons
  Widget createEditFurnitureButtons() {
    return SafeArea(
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          width: 340,
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
              (this.isEditingFurniture
                  ? FurnitureEditButton(
                      icon: const Icon(Icons.delete, size: 40),
                      pressed: () {
                        deleteFurniture();
                      },
                      foregroundColor: Colors.red,
                    )
                  : SizedBox.shrink()),
              this.isEditingFurniture ? const Spacer() : SizedBox.shrink(),
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
                  setFurnitureEditingState(false);
                },
                icon: const Icon(
                  Icons.check,
                  size: 40,
                ),
                isDisabled: shouldDisableAddButton,
              )
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
          child: (this.isFurnitureEditWindowIsEnabled == true)
              ? (this.shouldHideFurnitureControls
                  ? null
                  : createEditFurnitureButtons())
              : createPlusButton()),
      Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              FurnitureListPopUp(
                controller: furnitureListPopUpController,
                onTemplateSelect: (FurnitureTemplate template) {
                  //Assign selected template and hide list popup

                  _unityWidgetController
                      .postJsonMessage('UIManager', 'addNewFurniture', {
                    'furnitureName': template.furnitureName,
                    'furnitureImage': template.imageName,
                  });

                  setFurnitureEditingState(true);
                  furnitureListPopUpController.updateState(false);
                },
              ),
              RoomListPopUp(
                  controller: roomListPopUpController,
                  onTemplateSelect: (RoomTemplate template) {})
            ],
          )),
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
