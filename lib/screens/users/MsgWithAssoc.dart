import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/ConversationController.dart';
import 'package:rv_firebase/Controller/FollowController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class MsgWithAssoc extends StatefulWidget {
  const MsgWithAssoc({Key key}) : super(key: key);

  @override
  State<MsgWithAssoc> createState() => _MsgWithAssocState();
}

class _MsgWithAssocState extends State<MsgWithAssoc> {
  int messageClicked = 0;
  int MyId;
  int idM;
  @override
  Widget build(BuildContext context) {
    String msg = '';
    String arguments = ModalRoute.of(context).settings.arguments;
    List<String> values = arguments.split(';');
    String id = values[0];
    int m = int.parse(values[1]);
    List<Map<String, dynamic>> folowersList = [];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamed(context, '/home_users', arguments: id),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: listAbonnement2(id),
              builder: (context, snapshot) {
                var Abonnements = snapshot.data;
                if (snapshot.hasData) {
                  return Container(
                      height: 350,
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Abonnements.length,
                          itemBuilder: (context, index) {
                            int idAssoc = Abonnements[index];
                            return Row(children: [
                              Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                          future: Associnfos(idAssoc, 'img'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              String img = snapshot.data;
                                              return GestureDetector(
                                                onTap: () {
                                                  // Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                                },
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      NetworkImage(img),
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        FutureBuilder(
                                          future: Associnfos(idAssoc, 'name'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              String name = snapshot.data;
                                              return Text(
                                                name,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.message),
                                          onPressed: () {
                                            setState(() {
                                              messageClicked = idAssoc;
                                              MyId = int.parse(id);
                                              idM = idAssoc;
                                            });
                                            print("$MyId");
                                          },
                                          color: appbarBackgroundColor,
                                        ),
                                      ]))
                            ]);
                          }));
                } else {
                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );
                }
              }),
          SizedBox(height: 16.0),
          Container(
            child: FutureBuilder<String>(builder: (context, snapshot) {
              if (messageClicked != 0) {
                return Column(
                    children: [
                      Container(
                    width: 450,
                    height: 300,
                    child: FutureBuilder(
                    future: conversationAssocUser(MyId, messageClicked),
                    builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                       var typeCompte = snapshot.data[index]['typeE'];
                       var idE =  snapshot.data[index]['emetteur'];
                        return Column(
                            children: [
                            Container(
                        margin: EdgeInsets
                            .symmetric(
                        vertical: 10),
                        child: Row(
                          mainAxisAlignment: snapshot
                              .data[index]['emetteur'] ==
                              MyId
                              ? MainAxisAlignment
                              .end
                              : MainAxisAlignment
                              .start,
                          children: [
                            Container(
                              padding: EdgeInsets
                                  .symmetric(
                                  horizontal: 15,
                                  vertical: 10),
                              decoration: BoxDecoration(
                                color: snapshot
                                    .data[index]['emetteur'] ==
                                    MyId
                                    ? Colors.blue
                                    : Colors
                                    .grey[500],
                                borderRadius: BorderRadius
                                    .circular(20),
                              ),
                              child: Text(
                                snapshot
                                    .data[index]['message'],
                                style: TextStyle(
                                  color: snapshot
                                      .data[index]['emetteur'] ==
                                      MyId
                                      ? Colors.white
                                      : Colors
                                      .black,
                                ),
                              ),
                            ),
                        FutureBuilder(
                              builder: (context,
                              snapshot) {
                                if(typeCompte == 'assoc')
                                  {
                                    return FutureBuilder(
                                      future: Associnfos(
                                              idE,
                                          'img'),
                                      builder: (context,
                                          snapshot) {
                                        if (snapshot
                                            .hasData) {
                                          String img = snapshot
                                              .data;
                                          return GestureDetector(
                                            onTap: () {
                                              // Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  img),
                                            ),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    );
                                  }else{
                                  return FutureBuilder(
                                    future: userinfos(
                                        idE,
                                        'img'),
                                    builder: (context,
                                        snapshot) {
                                      if (snapshot
                                          .hasData) {
                                        String img = snapshot
                                            .data;
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: NetworkImage(
                                                img),
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  );
                                }
                              }
                        )

                          ],
                        )
                            )
                            ]

                        );
                      }

                      );
                    }else{
                      return Container(width: 0.0, height: 0.0);// a changer
                    }
                    }
                    )
                      ),
                      TextField(
                        onChanged: (value) {
                          msg = value;
                        },
                        decoration:
                        InputDecoration(
                          hintText:
                          'Add your msg',
                          focusedBorder:
                          OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                appbarBackgroundColor),
                          ),
                          suffixIcon: IconButton(
                            icon:
                            Icon(Icons.send),
                            onPressed: () {
                              addMesg(MyId,idM,msg,"user","assoc");
                              Navigator.pushNamed(
                                  context,'/MsgWithAssoc',
                                  arguments: '$id;$idM'
                              );
                            },
                          ),
                        ),
                      )
                ]);
              }else{
                return
                Column(
                  children: [
                    Container(
                      width: 450,
                      height: 300,
                      child: FutureBuilder(
                          future: conversationAssocUser(id, m),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  reverse: false,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment: snapshot
                                                .data[index]['emetteur'] ==
                                                int.parse(id)
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal: 15,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: snapshot
                                                      .data[index]['emetteur'] ==
                                                      int.parse(id)
                                                      ? Colors.blue
                                                      : Colors.grey[500],
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                ),
                                                child: Text(
                                                  snapshot
                                                      .data[index]['message'],
                                                  style: TextStyle(
                                                    color: snapshot
                                                        .data[index]['emetteur'] ==
                                                        int.parse(id)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: userinfos(snapshot
                                                    .data[index]['emetteur'],
                                                    'img'),
                                                builder: (context,
                                                    snapshot) {
                                                  if (snapshot.hasData) {
                                                    String img = snapshot
                                                        .data;
                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Navigator.pushNamed(context, '/profile_user', arguments: idp.toString());
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage: NetworkImage(
                                                            img),
                                                      ),
                                                    );
                                                  } else {
                                                    return CircularProgressIndicator();
                                                  }
                                                },
                                              ),

                                            ],
                                          ),

                                        );

                                  }
                              );
                            } else {
                              return Container(width: 0.0, height: 0.0);
                            }
                          }
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration:
                      InputDecoration(
                        hintText:
                        'Add your msg',
                        focusedBorder:
                        OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                              appbarBackgroundColor),
                        ),
                        suffixIcon: IconButton(
                          icon:
                          Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              MyId = int.parse(id);
                            });
                            addMesg(MyId,m,msg,"user","assoc");
                            Navigator.pushNamed(
                                context,'/MsgWithAssoc',
                                arguments:  '$MyId;$m'
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
          )

        ],
      ),
    );
  }
}
