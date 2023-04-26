import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import '../../Widgets/contants.dart';
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context,  '/invitatios',
                    arguments: id
                   );
              },
              child: CircleAvatar(
                backgroundColor: appbarBackgroundColor,
                radius: 25.0,
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
              ),
            ),
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
                                final uri = Uri.parse(
                                    'http://192.168.1.12:8080/publication');
                                DateTime today = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(today);
                                var res = await http.post(uri,
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    body: jsonEncode({
                                      "idUser": id,
                                      "contenu": pub,
                                      "date_pub": formattedDate
                                    }));

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
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Text(
                'What\'s new',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Premier conteneur avec son enfant (child) FutureBuilder


              // Deuxième conteneur
                      SizedBox(height: 25),
              FutureBuilder<List<dynamic>>(
                future: listpub(id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> publications = snapshot.data;

                    return Container(
                      height: 655,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: publications.length,
                        itemBuilder: (context, index) {
                          String contenu = publications[index]['contenu'];
                          var idPub = publications[index]['id'];
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(

                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      imgprofile2(id),
                                      SizedBox(width: 10),
                                      FutureBuilder<List<dynamic>>(
                                        future: Future.wait([userinfos(id, 'lastName'), userinfos(id, 'firstName')]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData ) {
                                            return Text(
                                              snapshot.data[1].toString() +" "+ snapshot.data[0].toString() ,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,),
                                            );
                                          }
                                          // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                          return Container(width: 0.0, height: 0.0);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(contenu),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      getNbLikes (idPub),
                                    FutureBuilder<String>(
                                    future: verifReact(id,idPub),
                                    builder: (BuildContext context, snapshot) {
                                   if (snapshot.hasData) {
                                   var ok = snapshot.data;
                                    return IconButton(
                                  icon: snapshot.data == 'Like'?Icon(Icons.thumb_up, color:  Colors.green):Icon(Icons.thumb_up_alt),
                                    onPressed: () async {

                                      if (ok == 'Like' ) {
                                        deleteReactLike(id, idPub);
                                        setState(() {
                                          ok = 'Erreur';
                                        });
                                      } else if (ok == 'Dislike' ) {
                                        int idReaction = await getidR(id,idPub);
                                        PutReactLike(idReaction,id,idPub,'Like');
                                        setState(() {
                                          ok = 'Like';
                                        });
                                      }else{
                                      addReactLike(id,idPub,'Like');
                                      setState(() {
                                        ok = 'Like';
                                      });
                                      }
                                    },
                                    );
                                    }else{
                                      return Container(width: 0.0,height: 0.0,);
                                    }
                                    },
                                    ),
                                      FutureBuilder<String>(
                                        future: verifReact(id,idPub),
                                        builder: (BuildContext context, snapshot) {

                                          if (snapshot.hasData) {
                                            var ok = snapshot.data;
                                            return IconButton(
                                              icon: ok == 'Dislike'
                                                  ? Icon(Icons.thumb_down, color:  Colors.red)
                                                  : Icon(Icons.thumb_down),
                                              onPressed: () async {

                                                if (ok == 'Dislike') {
                                                  deleteReactLike(id, idPub);
                                                  setState(() {
                                                    ok = 'Erreur';
                                                  });
                                                } else if (ok == 'Like') {
                                                  int idReaction = await getidR(id,idPub);
                                                  PutReactLike(idReaction,id,idPub,'Dislike');
                                                  setState(() {
                                                    ok = 'Dislike';
                                                  });
                                                }else{
                                                  addReactLike(id, idPub,'Dislike');
                                                  setState(() {
                                                    ok = 'Dislike';
                                                  });
                                                }
                                              },
                                            );

                                          }else{
                                            return Container(width: 0.0, height: 0.0);
                                          }
                                        },
                                      ),
                                      getNbDislike (idPub),
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                scrollable:  true,
                                                backgroundColor: kBackgroundColor,
                                                title: Text('Comments'),
                                                content:   Column(
                                                  children: [
                                                    Container(
                                                    width: 500,
                                                      child: FutureBuilder(
                                                        future: getComments(idPub),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.hasData) {
                                                            var comments = snapshot.data;
                                                            if (comments.length > 0) {
                                                              return Column(
                                                                children: List.generate(comments.length, (index) {
                                                                  var idAuteur = comments[index]['idUser'];
                                                                  return Container(
                                                                  decoration: BoxDecoration(
                                                                  border: Border.all(),
                                                                  borderRadius: BorderRadius.circular(10),),
                                                                  child:Column(
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          imgprofile2(idAuteur),
                                                                          SizedBox(width: 10),
                                                                          FutureBuilder<List<dynamic>>(
                                                                            future: Future.wait([userinfos(idAuteur, 'lastName'), userinfos(idAuteur, 'firstName')]),
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.hasData ) {
                                                                                return Text(
                                                                                  snapshot.data[1].toString() +" "+ snapshot.data[0].toString() ,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18.0,
                                                                                    fontWeight: FontWeight.bold,),
                                                                                );
                                                                              }
                                                                              return Container(width: 0.0, height: 0.0);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 10),
                                                                      Text('${comments[index]['contenu']}'),
                                                                      SizedBox(height: 10),

                                                                    ]
                                                                  ) ,                                                       //Text('${comments[index]['contenu']}')
                                                                  );
                                                                }),
                                                              );
                                                            } else {
                                                              return Text('No comments');
                                                            }
                                                          } else {
                                                            return Container(width: 0.0, height: 0.0);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 8.0),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'Add your comment',
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: appbarBackgroundColor), // Couleur du bord lorsqu'il est activé
                                                        ),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons.send),
                                                          onPressed: () {

                                                            print('Send button pressed!');
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                                   Row(
                                                     children: [

                                                       Expanded(
                                                         child: TextButton(
                                                         child: Text('OK'),
                                                         onPressed: () {
                                                           Navigator.of(context).pop();
                                                         },
                                                       ),

                                                       ),
                                                     ],
                                                   ),
                                                ],

                                              );
                                            },
                                          );
                                        },
                                      ),
                                      /* Compteur des Comments */

                                    ],
                                  ),
                                //  SizedBox(height: 30,)
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    );

                  } else {
                    return Container(width: 0.0, height: 0.0);
                  }
                },
              ),
            ]
                )
        )
    );

  }

}
