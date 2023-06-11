import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rv_firebase/Controller/ChallengesController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'dart:io';
class ListChallenges extends StatefulWidget {
  const ListChallenges({Key key}) : super(key: key);

  @override
  State<ListChallenges> createState() => _ListChallengesState();
}

class _ListChallengesState extends State<ListChallenges> {
  PickedFile _imgFile;
  final ImagePicker _Picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(
                context,'/home_users',
                arguments:id
            );
          },
        ),
        title: Text(
          'Challenges Space',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: listChallenge_users(id),
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
                                          SizedBox(height: 8.0),
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
                                          SizedBox(height: 8.0),
                                          FutureBuilder(
                                            builder: (context, snapshot) {
                                              if (img != null ) {
                                                return Image.network(img);
                                              }else{
                                              return Container(width: 0.0, height: 0.0);}
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon:  Image.asset("assets/trophy.png"),
                                          onPressed: () {
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
                                                                                          }else{
                                                                                            return Container(
                                                                                                width: 0.0,
                                                                                                height: 0.0);
                                                                                          }

                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Image.network("${reps[index]['img']}")
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
                                                                                              style: const TextStyle(
                                                                                                fontSize: 18.0,
                                                                                                fontWeight: FontWeight
                                                                                                    .bold,),
                                                                                            );
                                                                                          }else{
                                                                                            return Container(
                                                                                                width: 0.0,
                                                                                                height: 0.0);
                                                                                          }

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
                                                                                      width: 500,
                                                                                      height: 150,
                                                                                      fit: BoxFit.cover,
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
                                                                  return Container(width: 0.0, height: 0.0);
                                                                }
                                                              }
                                                          )
                                                      ),

                                                      TextButton(
                                                          onPressed: () async {

                                                            showModalBottomSheet(
                                                                backgroundColor: kBackgroundColor,
                                                                context: context,
                                                                builder: ((builder) => bouttonimage(context,id,idCh))
                                                            );


                                                          }, child: Icon(Icons.add)),
                                                    ],
                                                  ),
                                                );
                                              }
                                          ) ; }
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
              return Container(
                width: 0.0,
                height: 0.0,
              );
            }
          }

      )
    );
  }


  bouttonimage(page,id,idCh) {
    return Container(
        color: kBackgroundColor,
        height: 110.0,
        width: MediaQuery
            .of(page)
            .size
            .width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text("Choose profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takephoto(ImageSource.camera,id,idCh);
                  },
                  label: Text("Camera"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takephoto(ImageSource.gallery,id,idCh);
                  },
                  label: Text("gallery"),
                ),
              ],
            ),
          ],
        )
    );
  }
  void takephoto(ImageSource source,id,idCh) async {
    final pickedFile = await _Picker.getImage(source: source);
    setState(() {
      _imgFile = pickedFile;
    });
    if (_imgFile != null)
    {
      var e = await userinfos(id, 'email') ;
      var imgCh = await upload(_imgFile, e.toString(), "users");
      addRepCh(idCh,id,imgCh,"user");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kBackgroundColor,
            title: Text('Photo Uploaded'),
            content: Text('Your photo has been uploaded successfully.'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  // var imgCh = uploadImgAssoc(_imgFile, e.toString(), "imgCh");

                  Navigator.pushNamed(
                      context,'/ListChallenges',
                      arguments:id
                  );
                },
              ),
            ],
          );
        },
      );


    }

  }

}
