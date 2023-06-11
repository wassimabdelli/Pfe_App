import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/PublicationController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class Publications_vis extends StatefulWidget {
  const Publications_vis({Key key}) : super(key: key);

  @override
  State<Publications_vis> createState() => _Publications_visState();
}

class _Publications_visState extends State<Publications_vis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future: getAleaPubs(),
        builder: (context, snapshot) {
          List<dynamic> publications = snapshot.data;
            if (snapshot.hasData)
            {
              return Container(
              height: 700,
              child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: publications.length,
            itemBuilder: (context, index)
            {
              String contenu = publications[index]['contenu'];
              var idPub = publications[index]['id'];
              var auteur = publications[index]['idUser'];
              String imagePub = publications[index]['img_pub'];
              String type = publications[index]['type'];
              String UID = auteur.toString();
              if (type == "user"){
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
                            imgprofile0(UID,30.0) ,
                            SizedBox(width: 10),
                            FutureBuilder<List<dynamic>>(
                              future: Future.wait([userinfos(auteur, 'lastName'), userinfos(auteur, 'firstName')]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData ) {
                                  return Text(
                                    snapshot.data[1].toString() +" "+ snapshot.data[0].toString() ,
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
                        Text(contenu),

                        FutureBuilder(
                            builder: (context, snapshot) {
                              if (imagePub.length != 0)
                              {
                                return Image.network(imagePub);
                              }else{
                                return Container(width: 0.0, height: 0.0);
                              }
                            }

                        ),

                               ],
                    ),
                  ),
                );
              }else{
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
                imgprofileListAbon(UID,30.0),
              SizedBox(width: 10),
            FutureBuilder(
            future:Associnfos(UID, "name"),
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
            Text(contenu),

            FutureBuilder(
            builder: (context, snapshot) {
            if (imagePub != null)
            {
            return Image.network(imagePub);
            }else{
            return Container(width: 0.0, height: 0.0);
            }
            }

              ),

              SizedBox(height: 10),
                  ]
                )
              )
                );
              }
            }
              )
              );
            }else{
              return Container(width: 0.0, height: 0.0);
            }
        }
      ),
    );
  }
}
