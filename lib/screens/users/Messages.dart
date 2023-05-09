import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class Messages extends StatefulWidget {
  const Messages({Key key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool messageClicked = false ;
    int MyId;
  int idM;
  @override
  Widget build(BuildContext context) {

    String id = ModalRoute.of(context).settings.arguments;
    List<Map<String, dynamic>> usersList = [];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar:  AppBar(
        backgroundColor: appbarBackgroundColor,
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: listFriend(id).then((data) => data.cast<Map<String, dynamic>>().toList()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    usersList = snapshot.data;
                    return Container(
                      height: 350,
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          var idAmi = usersList[index]['idAmi'];
                          return Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FutureBuilder(
                                      future: userinfos(idAmi, 'img'),
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
                                      future: userinfos(idAmi, 'firstName'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String fname = snapshot.data;
                                          return FutureBuilder(
                                            future: userinfos(idAmi, 'lastName'),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                String lname = snapshot.data;
                                                return Text(
                                                  fname + " " + lname,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
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
                                          messageClicked = true;
                                          MyId = int.parse(id);
                                          idM = idAmi;
                                          print(messageClicked);
                                        });
                                      },
                                      color: appbarBackgroundColor,
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
              SizedBox(height: 16.0),
              Container(
                child:
                FutureBuilder<String>(
                  //future:messageClicked,
                  builder: (context, snapshot) {
                    if (messageClicked ) {
                    return FutureBuilder(
                          future: conversation(id, idM),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text("$idM");
                            } else {
                              return Container(width: 0.0, height: 0.0);
                            }
                          }
                      );
                    }else{
                      return Container(width: 0.0, height: 0.0);
                    }
                  }
                )

              ),
            ],
          ),
    ]

      ),

    );
  }
}
