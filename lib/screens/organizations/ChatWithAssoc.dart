import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/ConversationController.dart';
import 'package:rv_firebase/Controller/FollowController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class ChatWithAssoc extends StatefulWidget {
  const ChatWithAssoc({Key key}) : super(key: key);

  @override
  State<ChatWithAssoc> createState() => _ChatWithAssocState();
}

class _ChatWithAssocState extends State<ChatWithAssoc> {
  int messageClicked = 0 ;
  int MyId;
  int idM;
  @override
  Widget build(BuildContext context) {
    String msg = '';
    String arguments = ModalRoute.of(context).settings.arguments;
    List<String> values = arguments.split(';');
    String id = values[0];
    int m = int.parse(values[1]);
    List<Map<String, dynamic>> FollowList = [];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar:  AppBar(
        backgroundColor: appbarBackgroundColor,
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () =>  Navigator.pushNamed(
              context,'/home_assoc',
              arguments: id
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
            FutureBuilder(
             future: listFollowFiltrer(id,"user").then((data) => data.cast<Map<String, dynamic>>().toList()),
             builder: (context, snapshot) {
                if (snapshot.hasData) {
                  FollowList = snapshot.data;
                  return Container(
                      height: 350,
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: FollowList.length,
                        itemBuilder: (context, index) {
                          var idAssoc = FollowList[index]['idUser'];
                          return Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                              backgroundImage: NetworkImage(img),
                                            ),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                      ),
                                  SizedBox(height: 16.0),
                                  FutureBuilder(
                                    future: Associnfos(idAssoc , 'name'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        String name = snapshot.data;
                                        return Text(
                                          name ,
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
                                        print("mon id: "+"$MyId");
                                        print("son id : "+"$messageClicked");
                                      },
                                      color: appbarBackgroundColor,
                                    ),
                                  ],
                                )
                              )
                            ],
                          );
                        }
                      )
                  );
                }else{
                  return Container(width: 0.0, height: 0.0);   // Container(width: 0.0, height: 0.0);
                }
             }
            ),
              SizedBox(height: 16.0),
              Container(
              child:
              FutureBuilder<String>(
                builder: (context, snapshot) {
                  if (messageClicked != 0 ) {
                    return Column(
                      children: [
                        Container(
                          width: 450,
                          height: 300,
                          child: FutureBuilder(
                            future: conversation(MyId, messageClicked,"assoc"),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                  List l = snapshot.data;
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      if (snapshot.data[index]['typeD'] ==
                                      "assoc" &&
                                      snapshot.data[index]['typeE'] ==
                                      "assoc") {
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
                                            future: Associnfos(
                                                snapshot
                                                    .data[index]['emetteur'],
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
                                          ),
                                        ],
                                      )
                                        )
                                          ],
                                        );
                                      }
                                    }
                                  );
                              }else{
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
                                addMesg(MyId,idM,msg,"assoc","assoc");
                                Navigator.pushNamed(
                                    context,'/ChatWithAssoc',
                                    arguments: '$id;$idM'
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }else{
                    return Column(
                      children: [
                        Container(
                      width: 450,
                      height: 300,
                      child: FutureBuilder(
                        future: conversation(id, m,"assoc"),
                        builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                  if (snapshot.data[index]['typeD'] ==
                                  "assoc" &&
                                  snapshot.data[index]['typeE'] ==
                                  "assoc") {
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
                                      future: Associnfos(snapshot
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
                                )
                                       );
                                  }
                              }
                              );
                            }else{
                              return Container(width: 0.0, height: 0.0);
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
                                setState(() {
                                  MyId = int.parse(id);
                                });
                                addMesg(MyId,m,msg,"assoc","assoc");
                                Navigator.pushNamed(
                                    context,'/ChatWithAssoc',
                                    arguments:  '$MyId;$m'
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }
              )
              ),

            ],

          )

        ],
      ),
    );
  }
}
