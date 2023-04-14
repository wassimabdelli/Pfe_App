import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';

class UserDetaisProfile extends StatefulWidget {
  const UserDetaisProfile({Key key}) : super(key: key);

  @override
  State<UserDetaisProfile> createState() => _UserDetaisProfileState();
}

class _UserDetaisProfileState extends State<UserDetaisProfile> {
  @override
  Widget build(BuildContext context) {
    var id =  ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:  Center(child: Text('${id}')),
    );
  }
}
