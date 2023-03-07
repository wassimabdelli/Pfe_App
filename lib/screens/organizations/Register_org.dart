import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';

class Register_org extends StatefulWidget {
  const Register_org({Key key}) : super(key: key);

  @override
  State<Register_org> createState() => _Register_orgState();
}

class _Register_orgState extends State<Register_org> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(child: Text("hello organisation")),
    );
  }
}
