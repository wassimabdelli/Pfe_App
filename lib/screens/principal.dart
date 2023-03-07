import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:rv_firebase/screens/login.dart';
import 'package:rv_firebase/screens/users/register.dart';

import '../Widgets/contants.dart';
import 'organizations/Register_org.dart';

class Principal extends StatefulWidget {
  const Principal({Key key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(

        backgroundColor: kBackgroundColor,

        elevation: 0.0,
        title: Text('Holistic Wenter',
          style: TextStyle(color: Colors.black),
        ),
        actions:  <Widget>[
          TextButton(
            child: Text('Sign In'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },

          ),
          TextButton(
            child: Text('Register'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              alertPrincipal(context);

            },

          )
        ],
      ),
      body:  Center(
          child: Text("fsdfs"),

      ),





    );
  }
}

