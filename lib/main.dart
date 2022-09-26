import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:home_improvement/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
      home: (FirebaseAuth.instance.currentUser != null)
          ? UnityDemoScreen()
          : UnityDemoScreen())); //(FirebaseAuth.instance.currentUser != null) ? LoginPage() : UnityDemoScreen())
}

class UnityDemoScreen extends StatefulWidget {
  UnityDemoScreen({super.key});

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
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
    print('Received message from unity: ${message.toString()}');
  }

  //Set is editing, add 'Add' button
  void setIsEditing() {
    bool editing = !this.isEditing;
    _unityWidgetController.postMessage(
        'EditSwitcher', 'changeEditingStatus', '$editing');

    setState(() {
      this.isEditing = !this.isEditing;
    });
  }

  //Get widgets
  List<Widget> setUpEditingWindow() {
    Widget unity = returnUnityWidget();
    return [
      unity,
      Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          bottom: true,
          child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                ),
                child: Icon(Icons.add),
              )),
        ),
      )
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
