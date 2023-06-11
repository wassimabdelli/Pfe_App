import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/AmisController.dart';
import 'package:rv_firebase/Controller/FollowController.dart';
import 'package:rv_firebase/Controller/PublicationController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class Invitations extends StatefulWidget {
  const Invitations({Key key}) : super(key: key);

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    List<Map<String, dynamic>> usersList = [];
    List<Map<String, dynamic>> assocList = [];
    return Scaffold(
      backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          title: Text('Invitations', style: TextStyle(color: Colors.white)),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      body:
      ListView(
        children: [
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future:RandomUser(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      usersList = snapshot.data;
                      return Container(
                        height: 260,
                        padding: EdgeInsets.all(16.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            String img = usersList[index]['img'];
                            var idp = usersList[index]['id'];
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(img),
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        usersList[index]['firstName'] +
                                            " " +
                                            usersList[index]['lastName'],
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Invitation(id,usersList[index]['id']);
                                          setState(() {
                                            usersList.removeAt(index);
                                          });

                                        },
                                        icon: Icon(Icons.add_circle),
                                        label: Text('Invite'),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(170, 40),
                                          primary: appbarBackgroundColor,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
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
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future:RandomAssoc(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      assocList = snapshot.data;
                      return Container(
                        height: 260,
                        padding: EdgeInsets.all(16.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            String img = assocList[index]['img'];
                            var idp = assocList[index]['id'];
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(img),
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        assocList[index]['name'] ,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Abonnement(id,assocList[index]['id']);
                                          Follow(id,assocList[index]['id'],"users");
                                          setState(() {
                                            assocList.removeAt(index);
                                          });

                                        },
                                        icon: Icon(Icons.add_circle),
                                        label: Text('Follow'),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(170, 40),
                                          primary: appbarBackgroundColor,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
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
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  },
                ),

                FutureBuilder<List<dynamic>>(
                  future: getInvitations(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> Invitations = snapshot.data;

                      return Container(
                        height: 350,
                        width: 1000,

                        child: ListView.builder(

                          scrollDirection: Axis.vertical,
                          itemCount: Invitations.length,
                          itemBuilder: (context, index) {
                            int UID = int.parse(id);
                            if (Invitations[index]['destinataire'] == UID) {
                              var idEmutteur = Invitations[index]['emetteur'];
                              var idInv = Invitations[index]['id'];
                              return
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child:
                                      Column(
                                        children: [

                                          Row(
                                              children: [
                                                imgprofile(idEmutteur.toString(),id),
                                                SizedBox(width: 10),
                                                FutureBuilder<List<dynamic>>(
                                                  future: Future.wait([
                                                    userinfos(idEmutteur, 'lastName'),
                                                    userinfos(idEmutteur, 'firstName')
                                                  ]),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return
                                                        Row(
                                                            children: [
                                                              Text(
                                                                snapshot.data[1].toString() +
                                                                    " " +
                                                                    snapshot.data[0].toString(),
                                                                style: TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text( ' '+'sent you an invitation'),
                                                              SizedBox(width:10),
                                                            ]
                                                        );
                                                    }
                                                    return Container(
                                                      width: 0.0,
                                                      height: 0.0,
                                                    );
                                                  },
                                                ),
                                              ]
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            children: [
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center, // Centrer les boutons horizontalement
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.green,
                                                        onPrimary: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        addAmis(id , idEmutteur );
                                                        addAmis(idEmutteur , id );
                                                        DeleteInvit(idInv);
                                                        Navigator.pushNamed(
                                                            context,  '/invitatios',
                                                            arguments: id
                                                        );
                                                      },
                                                      child: Text('Accept'),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        onPrimary: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      onPressed: ()  async {
                                                        DeleteInvit(idInv);
                                                        Navigator.pushNamed(
                                                            context,  '/invitatios',
                                                            arguments: id
                                                        );
                                                      },
                                                      child: Text('Refuse'),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                );
                            } else {
                              // Return a placeholder widget or an empty container when condition is not met
                              return Container(
                                child: Center(
                                  child: Text('No invitations'),
                                ),
                              );

                            }

                          },
                        ),

                      );
                    }
                  },
                ),

              ],
            ),
          ),

        ],
      )



    );

  }
}
