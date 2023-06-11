import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import '../Widgets/contants.dart';
import 'Visiteurs/Challenges.dart';
import 'Visiteurs/Publications.dart';


class Principal extends StatefulWidget {
  const Principal({Key key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String selectedContent = 'publications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 10,
        title: Text(
          'Uni Connect',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Sign In'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              alertPrincipal2(context);
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
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedContent = 'challenges';
                  });
                },
                child: Text('Challenges'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedContent = 'publications';
                  });
                },
                child: Text('Publications'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: selectedContent == 'challenges'
                ? Challenges_vis()
                :Publications_vis()  ,
          ),
        ],
      ),
    );
  }
}



