import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:todo_app/components/roundedButton.dart';
import 'package:todo_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _textController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  FirebaseUser user;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    user = authResult.user;
    return 'sucess';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text('T',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.2)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  email = value;
                },
                cursorColor: Colors.red,
                decoration: kInputDecoration.copyWith(hintText: 'Email'),
              ),
              SizedBox(height: 13),
              TextField(
                style: TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                cursorColor: Colors.red,
                controller: _textController,
                decoration: kInputDecoration.copyWith(hintText: 'Password'),
              ),
              SizedBox(height: 16),
              RoundedButton(
                title: 'Register',
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    setState(() {
                      showSpinner = false;
                    });
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Already have account? ',
                          style: TextStyle(color: Colors.white)),
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.grey, height: 5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MaterialButton(
                      minWidth: 90,
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('Google',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      color: Colors.red),
                  MaterialButton(
                      minWidth: 90,
                      onPressed: () {},
                      child: Text('Facebook',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      color: Colors.blue)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
