  import 'dart:io';
import 'dart:math';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:rv_firebase/Widgets/contants.dart';
  import 'package:rv_firebase/Widgets/widgets.dart';
  import '../../Widgets/contants.dart';
import 'UserDetailsProfile.dart';

  class Home extends StatefulWidget {
    const Home({Key key}) : super(key: key);

    @override
    State<Home> createState() => _HomeState();
  }

  class _HomeState extends State<Home> {
    @override
    Widget build(BuildContext context) {
      final random = Random();
     String id = ModalRoute.of(context).settings.arguments;
     String pub ;
      return Scaffold(
        // background
        appBar:AppBar(
          backgroundColor: appbarBackgroundColor,
          elevation: 0,
          leading:  IconButton(
            icon: Icon(
              Icons.search,size: 30,
              color: Colors.white,
            ),
            onPressed: (){},
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context)
                  {
                        return AlertDialog(
                          backgroundColor: kBackgroundColor,
                          title: Text('Say something to your community 👋'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.photo_library),
                                    color: appbarBackgroundColor,
                                    onPressed: () async {

                                    },
                                  ),
                                  SizedBox(width: 8.0),
                                  //Text('Ajouter une photo'),
                                ],
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter your status here...',
                                ),
                                maxLines: 10,
                                onChanged: (value) {
                                  pub = value ;
                                //  print('Nouveau texte: $pub');
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('publish'),
                              onPressed: () {
                                if (pub != null) {
                                 var erreur = 'ok';
                                  addNewPublication(pub, id);
                                  alertPub(context,id,erreur);
                                }else {
                                  var erreur ;
                                  alertPub(context,id,erreur);
                                }

                              },
                            ),
                            TextButton(
                              child: Text('Fermer'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                  },
              );
              },
              child: CircleAvatar(
                backgroundColor: appbarBackgroundColor ,
                radius: 25.0,
                child: Icon(
                  Icons.publish,
                  color: Colors.white,
                ),
              ),
            ),
            FutureBuilder<dynamic> (
            future: imgprofile(id),
            builder: (thispage, snapshot) {
            return GestureDetector(
            onTap: () {
            Navigator.pushNamed(thispage,'/profile_user',arguments: id);
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

      body:
      Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'Get to know other people',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
            Text(
              'Click the image to see profile',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
         FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data.docs;
              final randomUsers = List.from(users)..shuffle(random);
              final selectedUsers = randomUsers.where((user) => user.id != id).take(4).toList();
              return Container(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedUsers.length,
                  itemBuilder: (context, index) {
                    final user = selectedUsers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetaisProfile(userId: user.id),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.data()['img']),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            ' ${user.data()['fname']} ${user.data()['lname']} ',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: (){
                              addNewFriend(user.id, id);
                            },
                            child: Text('add as new friend'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(appbarBackgroundColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Une erreur est survenue.'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        ]
      ),
      ),
      );
      
    }
  }


