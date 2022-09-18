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
          ? LoginPage()
          : UnityDemoScreen()));
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

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Home improvement"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            return Future<bool>.value(true);
            // Pop the category page if Android back button is pressed.
          },
          child: Container(
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
