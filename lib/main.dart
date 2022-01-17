import 'package:authpage_app/screen/authPage.dart';
import 'package:authpage_app/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Initializer()
        //  const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  late FirebaseAuth _auth;
  User? _user;
  bool loading_user = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    // _user = _auth.currentUser();
    _user = _auth.currentUser;
    debugPrint("User: $_user");
    loading_user = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading_user == true
            ? Center(child: CircularProgressIndicator())
            : _user == null
                ? AuthPage()
                : Home());
  }

  wid() {
    if (loading_user == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return FirebaseAuth.instance.idTokenChanges().listen((User? user) {
        if (user == null) {
          AuthPage();
        } else {
          print('User is signed in!');
          Home();
        }
      });
    }
  }
}
