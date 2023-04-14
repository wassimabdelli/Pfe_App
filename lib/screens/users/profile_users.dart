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
                                  return CircularProgressIndicator();
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
                                  return CircularProgressIndicator();
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
                              return CircularProgressIndicator();
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