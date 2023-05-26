import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class ListAssoc extends StatefulWidget {
  const ListAssoc({Key key}) : super(key: key);

  @override
  State<ListAssoc> createState() => _ListAssocState();
}

class _ListAssocState extends State<ListAssoc> {
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
          onPressed: () =>   Navigator.pushNamed(
              context,'/profile_user',
              arguments:'$id;$id'
          ),
        ),
        title: Text(
          'Friends',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:FutureBuilder<List<dynamic>>(
          future: listAbonnement(id),
          builder: (context, snapshot) {
            if (snapshot.hasData ) {
              List<dynamic> friends = snapshot.data;
              return Container(
                  height: 655,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        int idAssoc = friends[index]['idAssoc'];
                        var idAbonn = friends[index]['id'];
                        return Column(
                          children: [
                            FutureBuilder(
                                future:Associnfos(idAssoc, "name"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final name = snapshot.data.toString();

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imgprofileListAbon(idAssoc, 30.0),
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
                                                    context,'/MsgWithAssoc',
                                                    arguments:'$id;$idAssoc'
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
                                                              deleteAbonn(idAbonn);
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
                  )
              );
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}
