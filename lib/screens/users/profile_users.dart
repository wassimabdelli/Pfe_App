import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:flutter_animations/flutter_animations.dart';
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
          backgroundColor: kBackgroundColor,
          elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('User Profile', style: TextStyle(color: Colors.black),
      ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<dynamic>(
                future: imgprofile(id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            this.context, '/profile_user', arguments: id);
                      },

                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: snapshot.data.image,
                      ),

                    );
                  }
                },
              ),
              SizedBox(height: 10.0),
              FutureBuilder<List<String>>(
                future: Future.wait([user_info(id, 'lname'), user_info(id, 'fname')]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final lname = snapshot.data[0];
                    final fname = snapshot.data[1];
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
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  // Ajoutez ici l'action à effectuer lorsque l'icône de réglages est pressée.
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                FirebaseAuth.instance.currentUser.email,
                                style: TextStyle(
                                  fontSize: 18.0,
                                    fontWeight: FontWeight.bold,                          ),
                              ),
                              IconButton(
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  // Ajoutez ici l'action à effectuer lorsque l'icône de réglages est pressée.
                                },
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
                              FutureBuilder<String>(
                                future: user_info(id, 'date'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,                             ),
                                    );
                                  }
                                  // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                  return CircularProgressIndicator();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  // Ajoutez ici l'action à effectuer lorsque l'icône de réglages est pressée.
                                },
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
                              FutureBuilder<String>(
                                future: user_info(id, 'Sexe'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  // On peut retourner un widget de chargement ou un texte "Chargement en cours"
                                  return CircularProgressIndicator();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  // Ajoutez ici l'action à effectuer lorsque l'icône de réglages est pressée.
                                },
                              ),

                            ],

                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Action à effectuer lorsque le bouton est pressé
                                },
                                child: Text('Modifier le profil'),
                              ),
                            ],
                          ),
                        ],
                      );
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

