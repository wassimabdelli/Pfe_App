import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
class Profile_user extends StatefulWidget {
  const Profile_user({Key key}) : super(key: key);

  @override
  State<Profile_user> createState() => _Profile_userState();
}

class _Profile_userState extends State<Profile_user> {
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
          backgroundColor:  appbarBackgroundColor,
          elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('User Profile', style: TextStyle(color: Colors.white),
      ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              imgprofile(id),
              SizedBox(height: 10.0),
              FutureBuilder<List<dynamic>>(
                future: Future.wait([userinfos(id, 'lastName'), userinfos(id, 'firstName')]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final lname = snapshot.data[0].toString();
                    final fname = snapshot.data[1].toString();
                    return
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  '$lname $fname',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.account_circle_sharp,color: appbarBackgroundColor,),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "email",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder<dynamic>(
                                future: userinfos(id,'email'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                  return Container(width: 0.0, height: 0.0);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.email,color: appbarBackgroundColor,),
                              ),

                            ],

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date of Brith",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder<dynamic>(
                                future: userinfos(id, 'dnaissance'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,),
                                    );
                                  }
                                  // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                  return Container(width: 0.0, height: 0.0);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today,color: appbarBackgroundColor,),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sexe",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder<dynamic>(
                              future: userinfos(id,'sexe'),
                              builder: (context, snapshot) {
                              if (snapshot.hasData) {
                              return Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              ),
                              );
                              }
                              // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                              return Container(width: 0.0, height: 0.0);
                              },
                              ),
                              IconButton(
                                icon: Icon(Icons.male,color: appbarBackgroundColor,),
                              ),

                            ],

                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      this.context, '/settings_user_profile', arguments: id);
                                },
                                child: Text('change profil'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(170, 40),
                                  primary:appbarBackgroundColor ,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                              ),
                              ),
                              ),
                            ],
                          ),
                        ],
                      );
                  }else{
                    return Container(width: 0.0, height: 0.0);
                  }
                },
              ),
              SizedBox(height: 25),
              FutureBuilder<List<dynamic>>(
                future: listpub(id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> publications = snapshot.data;

                    return Container(
                      height: 290,
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
            ],
          ),
        ),
      ),
    );
  }

}