import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/ChallengesController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class Challenges_vis extends StatefulWidget {
  const Challenges_vis({Key key}) : super(key: key);

  @override
  State<Challenges_vis> createState() => _Challenges_visState();
}

class _Challenges_visState extends State<Challenges_vis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future:getAleaChallenges(),
        builder: (context, snapshot) {
          List<dynamic> challenges = snapshot.data;
          if (snapshot.hasData)
          {
            return Container(
            height: 700,
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: challenges.length,
          itemBuilder: (context, index)
            {
              var idAssoc = challenges[index]['idAssoc'];
              var title = challenges[index]['title'];
              var desc = challenges[index]['descr'];
              String img = challenges[index]['img'];
              var dateCh = challenges[index]['date_challenge'];
              var idCh = challenges[index]['id'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
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
                      imgPubAssoc(idAssoc,idAssoc),
                  SizedBox(width: 10),
                  FutureBuilder(
                    future:Associnfos(idAssoc, "name"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData ) {
                        return Text(
                          snapshot.data.toString()  ,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,),
                        );
                      }else{
                        return Container(width: 0.0, height: 0.0);}
                    },
                  ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title : ",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8.0), // Espacement entre le titre et le texte
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description : ",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8.0), // Espacement entre le titre et le texte
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Picture : ",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0), // Espacement entre le titre et le texte
                        FutureBuilder(
                          builder: (context, snapshot) {
                            if (img.length != 0 ) {
                              return Image.network(img);
                            }else{
                              return Container(width: 0.0, height: 0.0);}
                          },
                        ),
                      ],
                    )
                  ],
                ),
                ]
              )
              )
              );
            }

            )
        );
      }else{
        return Container(width: 0.0,height: 0.0,);
      }
        }
      )  ,

    );
  }
}
