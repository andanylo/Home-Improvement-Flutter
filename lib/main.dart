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
import 'package:home_improvement/TaskPopUp.dart';
import 'package:home_improvement/TaskValuesPopUp.dart';
import 'FurnitureTemplate.dart';
import 'RoomTemplate.dart';
import 'firebase_options.dart';

enum EditingMode { room, furniture }

bool isRunning = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (isRunning == false) {
      runApp(MaterialApp(home: LoginPage()));
    }
    isRunning = true;
  });
}

class UnityDemoScreen extends StatefulWidget {
  UnityDemoScreen({super.key});

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen>
    with SingleTickerProviderStateMixin {
  final navigatorKey = GlobalKey<NavigatorState>();

  FurnitureListPopUpController furnitureListPopUpController =
      FurnitureListPopUpController();

  RoomListPopUpController roomListPopUpController = RoomListPopUpController();

  dynamic currentPopUpController;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;

  TaskPopUp? taskPopUp;

  @override
  void initState() {
    super.initState();

    //Set animation controllers

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          // Start animation at begin

          if (currentPopUpController is FurnitureListPopUpController) {
            furnitureListPopUpController.updateState(true);
            print(currentPopUpController);
          } else if (currentPopUpController is RoomListPopUpController) {
            roomListPopUpController.updateState(true);
          }
        } else if (status == AnimationStatus.dismissed) {
          // To hide widget, we need complete animation first
          roomListPopUpController.updateState(false);
          furnitureListPopUpController.updateState(false);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _unityWidgetController.dispose();
    super.dispose();
  }

  var isEditing = false;
  var shouldHideControls = false;
  var shouldShowInteractButton = false;

  var shouldDisableAddButton = false;
  var isEditingObject = false;

  EditingMode? currentEditingMode;

  String? editingFurnitureName;
  String? editingFurnitureID;

  String? editingRoomKeyWord;
  String? editingRoomID;

  bool? roomCanBeEdited;

  String? currentClosestFurniture;

  Widget? unityWidget;

  int points = 0;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home maintenance"),
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
          children: isEditing ? setUpEditingWindow() : disableEditingWindow(),
        ));
  }

  Future<void> _signOut() async {
    _unityWidgetController.postMessage('UIManager', 'resetApp', ' ');

    await FirebaseAuth.instance.signOut();

    Navigator.pop(context);
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
  Future<void> onUnityCreated(controller) async {
    controller.resume();
    _unityWidgetController = controller;

    await _unityWidgetController.isLoaded();
    fetchFurniture();
    fetchRoom();
  }

  void fetchFurniture() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      //Fetch furnitures
      String jsonFurnitures = await Database.fetchFurnitures(user!.uid);
      //Add furnitures to unity
      _unityWidgetController.postMessage(
          'FurnitureAdder', 'recieveFurnituresFromDatabase', jsonFurnitures);
    });
  }

  void fetchRoom() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      String jsonRooms = await Database.fetchRooms(user!.uid);

      _unityWidgetController.postMessage(
          'RoomAdder', 'recieveRoomsFromDatabase', jsonRooms);
    });
  }

  Future<void> onUnityMessage(message) async {
    String mes = message as String;
    String key = mes.substring(0, mes.indexOf(':'));
    mes = mes.substring(mes.indexOf(':') + 1, mes.length);

    if (key == 'movement') {
      shouldHideControls = mes.toLowerCase() == 'true';
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
    } else if (key == 'deleteFurniture') {
      Map<String, dynamic> furnitureData = jsonDecode(mes);
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        Database.removeFurniture(
            user!.uid, furnitureData['id'], furnitureData['name']);
      });
    } else if (key == 'saveRoom') {
      if (roomCanBeEdited != false) {
        Database.saveRoom(
            (FirebaseAuth.instance.currentUser == null
                ? ""
                : FirebaseAuth.instance.currentUser!.uid),
            mes,
            false);
      } else {
        cancelRoomEditing();
      }
    } else if (key == 'updateRoom') {
      if (roomCanBeEdited != false) {
        Database.saveRoom(
            (FirebaseAuth.instance.currentUser == null
                ? ""
                : FirebaseAuth.instance.currentUser!.uid),
            mes,
            true);
      } else {
        cancelRoomEditing();
      }
    } else if (key == 'inside') {
      setState(() {
        this.shouldDisableAddButton = !(mes.toLowerCase() == 'true');
      });
    } else if (key == 'intersectsWithOtherRooms') {
      setState(() {
        this.shouldDisableAddButton = mes.toLowerCase() == 'true';
      });
    } else if (key == 'enableFurnitureEditing') {
      Map<String, dynamic> furnitureData = jsonDecode(mes);

      editingFurnitureName = furnitureData['name'];
      editingFurnitureID = furnitureData['id'];

      isEditingObject = true;
      setEditingMode(true, EditingMode.furniture);
    } else if (key == 'enableRoomEditing') {
      Map<String, dynamic> roomData = jsonDecode(mes);

      editingRoomKeyWord = roomData['key_word'];
      editingRoomID = roomData['id'];
      roomCanBeEdited = !(roomData['hasConnections'].toLowerCase() == 'true');

      isEditingObject = true;
      setEditingMode(true, EditingMode.room);
    } else if (key == 'presentRoomPopUp') {
      currentPopUpController = roomListPopUpController;
      if (_controller.isDismissed) {
        _controller.forward();
      }
      //roomListPopUpController.updateState(true);
    } else if (key == 'getTasks') {
      String json = await Database.fetchTasks();
      _unityWidgetController.postMessage('UIManager', 'didGetTasks', json);
    } else if (key == 'getPlayerTasks') {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        String json = await Database.fetchPlayerTasks(user!.uid);
        _unityWidgetController.postMessage(
            'UIManager', 'didGetPlayerTasks', json);
      });
    } else if (key == 'savePlayerTask') {
      Database.savePlayerTask(
          (FirebaseAuth.instance.currentUser == null
              ? ""
              : FirebaseAuth.instance.currentUser!.uid),
          mes,
          false);
    } else if (key == 'updatePlayerTask') {
      Database.savePlayerTask(
          (FirebaseAuth.instance.currentUser == null
              ? ""
              : FirebaseAuth.instance.currentUser!.uid),
          mes,
          true);
    } else if (key == 'taskButtonStatus') {
      bool willShow = mes.toLowerCase() == 'true';
      if (willShow != shouldShowInteractButton) {
        setState(() {
          shouldShowInteractButton = mes.toLowerCase() == 'true';
        });
      }
    } else if (key == 'currentClosestFurniture') {
      currentClosestFurniture = mes.isEmpty ? null : mes;
    } else if (key == 'didCompleteTaskWithAward') {
      int taskPoints = int.parse(mes);
      points += taskPoints;
      setState(() {});
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

  void setEditingMode(bool shouldEdit, EditingMode? editingMode) {
    currentEditingMode = editingMode;
    if (!shouldEdit) {
      isEditingObject = false;
    }

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
              currentPopUpController = furnitureListPopUpController;
              if (_controller.isDismissed) {
                _controller.forward();
              }
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
    shouldDisableAddButton = false;
    _unityWidgetController.postMessage(
        'UIManager', 'cancelFurnitureEditing', '');
    setEditingMode(false, null);
  }

  void cancelRoomEditing() {
    editingRoomID = null;
    editingFurnitureName = null;
    roomCanBeEdited = null;

    _unityWidgetController.postMessage('UIManager', 'cancelRoomEditing', '');
    shouldDisableAddButton = false;
    setEditingMode(false, null);
  }

  void deleteFurniture() {
    _unityWidgetController.postMessage(
        'UIManager', 'deleteFurniture', editingFurnitureID);
    if (editingFurnitureID != null && editingFurnitureName != null) {
      String id = editingFurnitureID!;
      String name = editingFurnitureName!;
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        Database.removeFurniture(user!.uid, id, name);
        Database.removePlayerTask(user!.uid, id);
      });
    }

    cancelFurnitureEditing();
  }

  void deleteRoom() {
    _unityWidgetController.postMessage(
        'UIManager', 'deleteRoom', editingRoomID);

    if (editingRoomID != null && editingRoomKeyWord != null) {
      String id = editingRoomID!;
      String name = editingRoomKeyWord!;
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        Database.removeRoom(user!.uid, id, name);
      });

      cancelRoomEditing();
    }
  }

  //Create edit room buttons
  Widget createEditRoomButtons() {
    return SafeArea(
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          width: 340,
          child: Row(
            children: [
              EditButton(
                icon: const Icon(
                  Icons.cancel,
                  size: 40,
                ),
                pressed: () {
                  cancelRoomEditing();
                },
                foregroundColor: Colors.red,
              ),
              const Spacer(),
              (isEditingObject
                  ? EditButton(
                      icon: const Icon(Icons.delete, size: 40),
                      pressed: () {
                        deleteRoom();
                      },
                      isDisabled: roomCanBeEdited == false,
                      foregroundColor: Colors.red,
                    )
                  : SizedBox.shrink()),
              isEditingObject ? const Spacer() : SizedBox.shrink(),
              EditButton(
                pressed: () {
                  _unityWidgetController.postMessage(
                      'UIManager', 'rotateRoom', '');
                },
                icon: const Icon(
                  Icons.rotate_left,
                  size: 40,
                ),
                isDisabled: roomCanBeEdited == false,
              ),
              const Spacer(),
              EditButton(
                icon: const Icon(Icons.check, size: 40),
                pressed: () {
                  _unityWidgetController.postMessage(
                      'UIManager', 'saveRoom', '');
                  setEditingMode(false, null);
                },
                isDisabled: shouldDisableAddButton,
              )
            ],
          ),
        ));
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
              EditButton(
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
              (isEditingObject
                  ? EditButton(
                      icon: const Icon(Icons.delete, size: 40),
                      pressed: () {
                        deleteFurniture();
                      },
                      foregroundColor: Colors.red,
                    )
                  : SizedBox.shrink()),
              isEditingObject ? const Spacer() : SizedBox.shrink(),
              EditButton(
                pressed: () {
                  _unityWidgetController.postMessage(
                      'UIManager', 'rotateFurniture', '');
                },
                icon: const Icon(
                  Icons.rotate_left,
                  size: 40,
                ),
              ),
              const Spacer(),
              EditButton(
                pressed: () {
                  _unityWidgetController.postMessage(
                      'UIManager', 'saveFurniture', '');
                  setEditingMode(false, null);
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
      //Game
      unity,
      //Controls
      Align(alignment: Alignment.bottomCenter, child: getControls()),

      //Presenter
      Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: FurnitureListPopUp(
                  controller: furnitureListPopUpController,
                  onTemplateSelect: (FurnitureTemplate? template) {
                    _controller.reverse();
                    currentPopUpController = null;
                    if (template == null) {
                      return;
                    }
                    //Assign selected template and hide list popup
                    _unityWidgetController
                        .postJsonMessage('UIManager', 'addNewFurniture', {
                      'furnitureName': template.furnitureName,
                      'furnitureImage': template.imageName,
                    });

                    setEditingMode(true, EditingMode.furniture);
                  },
                ),
              ),
              SlideTransition(
                  position: _offsetAnimation,
                  child: RoomListPopUp(
                      controller: roomListPopUpController,
                      onTemplateSelect: (RoomTemplate? template) {
                        //If canceled
                        _controller.reverse();
                        currentPopUpController = null;
                        if (template == null) {
                          return;
                        }
                        _unityWidgetController.postJsonMessage('UIManager',
                            'addRoom', {'key_word': template.key_word});

                        setEditingMode(true, EditingMode.room);
                      })),
            ],
          )),
    ];
  }

  List<Widget> disableEditingWindow() {
    Widget unity = returnUnityWidget();

    taskPopUp = TaskPopUp(shouldShowButton: shouldShowInteractButton);
    taskPopUp?.currentClosestFurniture = currentClosestFurniture;
    taskPopUp?.didCompleteTask = () {
      _unityWidgetController.postMessage('UIManager', 'didCompleteTask', '');
    };

    return [
      unity,
      Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: Text(
                    "Points: $points",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          )),
      taskPopUp ?? Container()
    ];
  }

  //Returns controls based on editing mode
  Widget? getControls() {
    if (currentEditingMode == null) {
      return createPlusButton();
    }
    switch (currentEditingMode!) {
      case EditingMode.room:
        return createEditRoomButtons();
      case EditingMode.furniture:
        return shouldHideControls ? null : createEditFurnitureButtons();
    }
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    print('Received scene loaded from unity: ${scene?.name}');
    print('Received scene loaded from unity buildIndex: ${scene?.buildIndex}');
  }
}
