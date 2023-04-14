import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Widgets/widgets.dart';
class teste extends StatefulWidget {
  const teste({Key key}) : super(key: key);

  @override
  State<teste> createState() => _testeState();
}

class _testeState extends State<teste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

}
/*



import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import '../../Widgets/contants.dart';
import 'UserDetailsProfile.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var users = testing();
    String id = ModalRoute.of(context).settings.arguments;
    String pub;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                                onPressed: () async {},
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
                              pub = value;
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
                              alertPub(context, id, erreur);
                            } else {
                              var erreur;
                              alertPub(context, id, erreur);
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
                backgroundColor: appbarBackgroundColor,
                radius: 25.0,
                child: Icon(
                  Icons.publish,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            imgprofile(id),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        backgroundColor: kBackgroundColor,
        body: Container(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              // Premier conteneur avec son enfant (child) FutureBuilder
              FutureBuilder<List<Map<String, dynamic>>>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 300,
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          String img = snapshot.data[index]['img'];
                          return Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(img),
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      snapshot.data[index]['firstName'] + " "+ snapshot.data[index]['lastName'] ,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // affichez un indicateur de chargement par défaut ici
                  return CircularProgressIndicator();
                },
              ),

              // Deuxième conteneur
              Container(
                child: Center(
                  child: Text('deusieme container'),
                ),
              )
            ])));
  }
}

 */