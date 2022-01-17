import 'package:authpage_app/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum AuthUser {
  show_mobile_form_state,
  show_opt_form_state,
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneno = TextEditingController();
  final optno = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  AuthUser currState = AuthUser.show_mobile_form_state;
  PhoneForm(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        TextFormField(
          key: _formKey,
          controller: phoneno,
          // cursorColor: Colors.white,

          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 18.0),
              labelText: 'Enter your Phone Number',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  )),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0))),
        ),
        Spacer(),
        FlatButton(
          onPressed: () async {
            await _auth.verifyPhoneNumber(
                phoneNumber: phoneno.text,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  // ANDROID ONLY!

                  // Sign the user in (or link) with the auto-generated credential
                  await _auth.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    print('The provided phone number is not valid.');
                  }

                  // Handle other errors
                },
                codeSent: (String verificationId, int? resendToken) async {
                  // Update the UI - wait for the user to enter the SMS code
                  // getting opt from user
                  setState(() {
                    debugPrint("OPT send to no. ${phoneno.text}");
                    this.verificationId = verificationId;
                    currState = AuthUser.show_opt_form_state;
                  });
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  // Auto-resolution timed out...
                });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.black87,
                  content: Text("OPT send to Phone number: ${phoneno.text}")),
            );
          },
          color: Colors.blue,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("Next"))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  OTPForm(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        TextFormField(
          key: _formKey,
          controller: optno,
          // cursorColor: Colors.white,
          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 18.0),
              labelText: 'Enter OPT here',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  )),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0))),
        ),
        Spacer(),
        FlatButton(
          onPressed: () async {
            try {
              String smsCode = optno.text;

              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

              // Sign the user in (or link) with the credential
              await _auth.signInWithCredential(credential);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.black87,
                    content: Text("${phoneno.text} is verifyed")),
              );
              debugPrint("${phoneno.text} is verifyed");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
              setState(() {
                currState = AuthUser.show_mobile_form_state;
              });
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.black87,
                    content: Text("${e.message}")),
              );
            }
          },
          color: Colors.blue,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("Submit"))),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // color: Colors.red,
          margin: EdgeInsets.all(15),
          child: currState == AuthUser.show_mobile_form_state
              ? PhoneForm(context)
              : OTPForm(context),
        ),
      ),
    );
    // PhoneForm(context);
  }
}
