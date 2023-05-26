import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class ListFollwers extends StatefulWidget {
  const ListFollwers({Key key}) : super(key: key);

  @override
  State<ListFollwers> createState() => _ListFollwersState();
}

class _ListFollwersState extends State<ListFollwers> {
  @override
  Widget build(BuildContext context) {
    final String arguments = ModalRoute.of(context).settings.arguments;
    final List<String> values = arguments.split(';');
    String id = values[0];
    String MyId = values[1];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>  Navigator.pushNamed(
              context,'/profile_assoc',
              arguments:'$id;$id'
          ),
        ),
        title: Text(
          'Friends',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future:listFollow(id) ,
        builder: (context, snapshot) {
         if (snapshot.hasData ) {
           List<dynamic> friends = snapshot.data;
           return Container(
               height: 655,
           child:ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              int idUser = friends[index]['idUser'];
              String type = friends[index]['type'];
              if(type == "user"){
                return Column(
                  children: [
                    FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          userinfos(idUser, 'lastName'),
                          userinfos(idUser, 'firstName')
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final lname = snapshot.data[0].toString();
                            final fname = snapshot.data[1].toString();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                imgprofile0(idUser, 30.0),
                                Text(
                                  '$fname $lname',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushNamed(
                                            context,'/ChatWithUser',
                                            arguments:'$id;$idUser'
                                        );
                                      },
                                      child: Icon(Icons.message_outlined),
                                      style:  ElevatedButton.styleFrom(
                                        primary: appbarBackgroundColor,
                                        onPrimary: Colors.white,
                                      ),

                                    ),
                                    ElevatedButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder:  (BuildContext context)
                                            {
                                              return AlertDialog(
                                                backgroundColor:
                                                kBackgroundColor,
                                                title: Text(
                                                    'Remove from the list of follwres?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                          context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                    Text('Yes'),
                                                    onPressed: () {
                                                      deleteFollow(id,idUser);
                                                      Navigator.pushNamed(
                                                          context,'/ListFriend',
                                                          arguments:'$id;$id'
                                                      );
                                                    },

                                                  ),
                                                ],
                                              );
                                            }

                                        );
                                      },
                                      child: Icon(Icons.delete),
                                      style:  ElevatedButton.styleFrom(
                                        primary: appbarBackgroundColor,
                                        onPrimary: Colors.white,
                                      ),

                                    ),
                                  ],)

                              ],

                            )
                            ;
                          }}
                    ),
                    SizedBox(height: 30,),
                  ],
                );

              }else{
                return Column(
                  children: [
                    FutureBuilder(
                        future:Associnfos(idUser, "name"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final name = snapshot.data.toString();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                imgprofileListAbon(idUser, 30.0),
                                Text(
                                  '$name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushNamed(
                                            context,'/ChatWithAssoc',
                                            arguments:'$id;$idUser'
                                        );
                                      },
                                      child: Icon(Icons.message_outlined),
                                      style:  ElevatedButton.styleFrom(
                                        primary: appbarBackgroundColor,
                                        onPrimary: Colors.white,
                                      ),

                                    ),
                                    ElevatedButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder:  (BuildContext context)
                                            {
                                              return AlertDialog(
                                                backgroundColor:
                                                kBackgroundColor,
                                                title: Text(
                                                    'Remove this association from your list?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                          context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                    Text('Yes'),
                                                    onPressed: () {
                                                      deleteFollow(id,idUser);
                                                      Navigator.pushNamed(
                                                          context,'/ListAssoc',
                                                          arguments:'$id;$id'
                                                      );
                                                    },

                                                  ),
                                                ],
                                              );
                                            }

                                        );
                                      },
                                      child: Icon(Icons.delete),
                                      style:  ElevatedButton.styleFrom(
                                        primary: appbarBackgroundColor,
                                        onPrimary: Colors.white,
                                      ),

                                    ),
                                  ],)

                              ],

                            )
                            ;
                          }}
                    ),
                    SizedBox(height: 30,),
                  ],
                );
              }
            }
            ),
           );
         }else{
           return Container(height: 0.0,width: 0.0,);
         }
        }
      ),
    );
  }
}
