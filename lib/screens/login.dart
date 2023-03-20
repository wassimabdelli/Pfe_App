
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:rv_firebase/screens/users/home_users.dart';
import 'package:rv_firebase/screens/users/register.dart';
import 'package:rv_firebase/screens/users/register.dart';

import '../Widgets/contants.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,

        elevation: 0.0,
        title: Text('Sign in',
        style: TextStyle(color: Colors.black),
        ),
      ),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Holistic Winter ",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                const Text(
                  "Login now to see what they are talking !",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefix : Icon(
                        Icons.email,
                        color: Colors.indigo,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type an email!!';
                    }
                  },
                  onSaved: (value) => _email = value,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefix : Icon(
                        Icons.person,
                        color: Colors.indigo,
                      )),
                  validator: (value) {
                    if (value.length < 6) {
                      return 'your password needs to be atleast 6 characters';
                    }
                  },
                  onSaved: (value) => _password = value,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: sign,
                  child: Text('Sign in'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(170, 40),
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const  SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                      text:"Don't have an acount ?",
                      style: TextStyle(fontSize: 14,color: Colors.black),
                      children:<TextSpan>[
                        TextSpan(
                            text: "Register here",
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              nextScreen(context, const Register() );
                            }
                        ) ,
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void sign() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        final currentUSER = FirebaseAuth.instance.currentUser;
        final UID = currentUSER.uid;
      /*  Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));*/
        Navigator.pushNamed(context, '/home',arguments: UID);
      } catch (e) {
        print(e.code);
      }
    }
  }
}
