import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    String id = ModalRoute.of(context).settings.arguments;
    var users = RandomUser(id);
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
                    return SingleChildScrollView(
                      child: AlertDialog(
                        
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
                            onPressed: () async {
                              if (pub != null) {
                                var erreur = 'ok';
                                //addNewPublication(pub, id);
                              final uri = Uri.parse('http://192.168.1.12:8080/publication');
                              DateTime today = DateTime.now();
                              String formattedDate = DateFormat('yyyy-MM-dd').format(today);
                              var res = await http.post(uri, headers: {'Content-Type': 'application/json'},
                                  body:  jsonEncode( {
                                    "idUser": id,
                                    "contenu": pub,
                                    "date_pub": formattedDate

                                  })

                              );
                                alertPub(context, id, erreur);

                             } else {
                              var erreur;
                                alertPub(context, id, erreur);
                              }
                            },
                          ),
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
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
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/Detail_profil',arguments: snapshot.data[index]['id']);
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(img),
                                      ),
                                    ),

                                    SizedBox(height: 16.0),
                                    Text(
                                      snapshot.data[index]['firstName'] + " "+ snapshot.data[index]['lastName'] ,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed:() {} ,
                                        icon: Icon(Icons.add_circle),
                                      label: Text('Invite'),
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(170, 40),
                                        primary:appbarBackgroundColor,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else   {
                    return Container(width: 0.0, height: 0.0);
                  }

                },
              ),

              // Deuxième conteneur

                  FutureBuilder<List<dynamic>>(

                    future: listpub(id),
                    builder: (context, snapshot)  {
                      if (snapshot.hasData)  {

                        List<dynamic> users = snapshot.data;
                        for (var j = 0; j <= users.length+1; j++) {
                          String contenu = users[j]['contenu'];
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imgprofile(id),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<dynamic>>(
                                        future: Future.wait([userinfos(id, 'lastName'), userinfos(id, 'firstName')]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data[1].toString() + " "+ snapshot.data[0].toString() ,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,),
                                            );
                                          }
                                          // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                          return CircularProgressIndicator();
                                        },
                                      ),

                                    SizedBox(height: 5.0),
                                      Text(
                                        users[j]['contenu'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Container(width: 0.0, height: 0.0);
                      }
                    },
                  ),

            ])));
  }
}
