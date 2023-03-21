  import 'dart:io';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:rv_firebase/Repository/user.repo.dart';
  import 'package:rv_firebase/screens/login.dart';
  import 'package:rv_firebase/screens/users/profile_users.dart';

  import '../../Widgets/contants.dart';

  class Home extends StatefulWidget {
    const Home({Key key}) : super(key: key);

    @override
    State<Home> createState() => _HomeState();
  }

  class _HomeState extends State<Home> {

    @override
    Widget build(BuildContext context) {
     String id = ModalRoute.of(context).settings.arguments;
      return Scaffold(
        appBar:AppBar(
          backgroundColor: appbarBackgroundColor,
          elevation: 0,
          leading:  IconButton(
            icon: Icon(
              Icons.search,size: 30,
              color: Colors.black,
            ),
            onPressed: (){},
          ),
          actions: <Widget>[
              FutureBuilder<dynamic>(
                future: imgprofile(id),
                builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                      Navigator.pushNamed(this.context,'/profile_user',arguments: id);
                    },

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: snapshot.data.image,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),

                    );
                },
              ),
          ],
        ) ,
        backgroundColor: kBackgroundColor,

      //  body:
      );
    }
    Future<dynamic> imgprofile(String id) async {
       DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
           id);
       var value = await doc.get();
       var img = value.data()['img'];
       return Image.network(img);
     }
   }

