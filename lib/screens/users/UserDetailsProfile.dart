import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';

class UserDetaisProfile extends StatefulWidget {
  final String userId;

  const UserDetaisProfile({Key key, @required this.userId}) : super(key: key);

  @override
  State<UserDetaisProfile> createState() => _UserDetaisProfileState();
}

class _UserDetaisProfileState extends State<UserDetaisProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:  Center(child: Text(widget.userId)),
    );
  }
}
