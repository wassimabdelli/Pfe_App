import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Model/users.dart';
import 'package:rv_firebase/Repository/user.repo.dart';

import 'package:rv_firebase/Widgets/widgets.dart';

import '../contants.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email, _password;
  final  _ctrfname = TextEditingController();
  final  _ctrlname = TextEditingController();
  final  _ctrage = TextEditingController();
  final  _ctrtel = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,

        elevation: 0.0,
        title: Text('Sign up',
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
                  "Create your account now to chat and explore",
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
                      labelText: "First Name",
                      prefix : Icon(
                        Icons.email,
                        color: Colors.indigo,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your first name!!';
                    }
                  },
                  onSaved: (value) => _ctrfname.text = value,
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
                  onPressed: signup,
                  child: Text('Sign up'),
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

  void signup() async {
    final fn = _ctrfname.text.toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,

        );
        final currentUSER =  FirebaseAuth.instance.currentUser;
        final UID = currentUSER.uid;
       // final u = Users(id: UID , fname: _ctrtel.text);
        final docUser = FirebaseFirestore.instance.collection('users').doc(UID);
        final json = {
          'fname' : fn,
        };
        await docUser.set(json);
  } catch (e) {
        print(e.message);
      }
    }
  }
}
