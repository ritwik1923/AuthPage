import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("Home Screen"),
              FlatButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
                color: Colors.blue,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("SignOut"))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
