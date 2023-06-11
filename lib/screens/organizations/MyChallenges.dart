import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/ChallengesController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class MyChallenges extends StatefulWidget {
  const MyChallenges({Key key}) : super(key: key);

  @override
  State<MyChallenges> createState() => _MyChallengesState();
}

class _MyChallengesState extends State<MyChallenges> {
  @override
  Widget build(BuildContext context) {
    final String arguments = ModalRoute.of(context).settings.arguments;
    final List<String> values = arguments.split(';');
    final String id = values[0];
    final String MyId = values[1];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(
                context,'/profile_assoc',
                arguments:'$id;$MyId'
            );
          },
        ),
        title: Text(
          'Challenges Space',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: getChallenges(id),
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
                      var img = challenges[index]['img'];
                      var dateCh = challenges[index]['date_challenge'];
                      var idCh = challenges[index]['id'];
                      return Padding(
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
                                          }
                                          return Container(width: 0.0, height: 0.0);
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
                                              if (img != null ) {
                                                return Image.network(img);
                                              }
                                              return Container(width: 0.0, height: 0.0);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon:  Image.asset("assets/trophy.png"),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable:  true,
                                                    backgroundColor: kBackgroundColor,
                                                    title: Text('Challenges'),
                                                    content: Column(
                                                      children: [
                                                        Container(
                                                            width: 500,
                                                            child: FutureBuilder(
                                                                future: getRepCh(idCh),
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    var reps = snapshot.data;
                                                                    if ( reps.length > 0) {
                                                                      return Column(
                                                                        children: List.generate(reps.length, (i) {
                                                                          var idAuteur = reps[i]['idUser'];
                                                                          if (reps[i]['type']=="user")
                                                                          {
                                                                            return Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border
                                                                                      .all(),
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10),),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        imgprofile2(
                                                                                            idAuteur,
                                                                                            id),
                                                                                        SizedBox(
                                                                                            width: 10),
                                                                                        FutureBuilder<
                                                                                            List<
                                                                                                dynamic>>(
                                                                                          future: Future
                                                                                              .wait(
                                                                                              [
                                                                                                userinfos(
                                                                                                    idAuteur,
                                                                                                    'lastName'),
                                                                                                userinfos(
                                                                                                    idAuteur,
                                                                                                    'firstName')
                                                                                              ]),
                                                                                          builder: (
                                                                                              context,
                                                                                              snapshot) {
                                                                                            if (snapshot
                                                                                                .hasData) {
                                                                                              return Text(
                                                                                                snapshot
                                                                                                    .data[1]
                                                                                                    .toString() +
                                                                                                    " " +
                                                                                                    snapshot
                                                                                                        .data[0]
                                                                                                        .toString(),
                                                                                                style: TextStyle(
                                                                                                  fontSize: 18.0,
                                                                                                  fontWeight: FontWeight
                                                                                                      .bold,),
                                                                                              );
                                                                                            }
                                                                                            return Container(
                                                                                                width: 0.0,
                                                                                                height: 0.0);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    //   Image.network("${reps[index]['img']}")
                                                                                  ],
                                                                                )
                                                                            );
                                                                          }else{
                                                                            return Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border
                                                                                      .all(),
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10),),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        imgPubAssoc(
                                                                                            idAuteur,
                                                                                            id),
                                                                                        SizedBox(
                                                                                            width: 10),
                                                                                        FutureBuilder(
                                                                                          future: Associnfos(idAuteur, "name"),
                                                                                          builder: (
                                                                                              context,
                                                                                              snapshot) {
                                                                                            if (snapshot
                                                                                                .hasData) {
                                                                                              return Text(
                                                                                                snapshot
                                                                                                    .data.toString(),
                                                                                                style: TextStyle(
                                                                                                  fontSize: 18.0,
                                                                                                  fontWeight: FontWeight
                                                                                                      .bold,),
                                                                                              );
                                                                                            }
                                                                                            return Container(
                                                                                                width: 0.0,
                                                                                                height: 0.0);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Container(
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(
                                                                                          color: Colors.black,
                                                                                          width: 2.0,
                                                                                        ),
                                                                                      ),
                                                                                      child: Image.network(
                                                                                        "${reps[index]['img']}",
                                                                                        width: 500, // Largeur souhaitée de l'image
                                                                                        height: 150, // Hauteur souhaitée de l'image
                                                                                        fit: BoxFit.cover, // Optionnel : ajuste l'image pour remplir les dimensions spécifiées
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                )
                                                                            );
                                                                          }
                                                                        }),
                                                                      );
                                                                    }

                                                                  }else{
                                                                    return Text('$idCh');
                                                                  }
                                                                }
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ) ;
                                          }
                                      ),


                                    ],
                                  )
                                ]
                            )
                        ),
                      );
                    }
                ),
              );
            }else{
              return Text("no data");
            }
          }
      ),
    );
  }
}
