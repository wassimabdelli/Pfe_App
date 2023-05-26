import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import '../../Widgets/contants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PickedFile _imgFile;
  final ImagePicker _Picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    String pub;
    String Comment = '';
    int m = 0;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context,'/ListChallenges',
                    arguments:id
                );
              },
              child: Icon(
                Icons.star,
                size: 32.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {

                      final RenderBox button =
                      context.findRenderObject();
                      final RenderBox overlay =
                      Overlay.of(context)
                          .context
                          .findRenderObject();
                      final RelativeRect position =
                      RelativeRect.fromRect(
                      Rect.fromPoints(
                      button.localToGlobal(
                      Offset.zero,
                      ancestor: overlay),
                      button.localToGlobal(
                      button.size.bottomRight(
                      Offset.zero),
                      ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                      );
                      showMenu(
                      context: context,
                      position: position,
                      items: <
                      PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                      value: 'association',
                      child: Row(
                      children: [
                      Icon(
                      Icons.domain,
                      color: Colors.green,
                      ),
                      SizedBox(
                      width: 5,
                      ),
                      Text('Association'),
                      ],
                      ),
                      ),
                      PopupMenuItem<String>(
                      value: 'friends',
                      child: Row(
                      children: [
                      Icon(
                      Icons.group,
                      color: Colors.red,
                      ),
                      SizedBox(
                      width: 5,
                      ),
                      Text('Friends'),
                      ],
                      ),
                      ),
                      ],
                      color: kBackgroundColor,
                      ).then((value) {
                      if (value == 'association') {
                        Navigator.pushNamed(
                            context,'/MsgWithAssoc',
                            arguments: '$id;$m'
                        );
                      } else {
                         Navigator.pushNamed(
                    context,'/Messages',
                    arguments: '$id;$m'
                );
                      }
                      });
              },
              child: CircleAvatar(
                backgroundColor: appbarBackgroundColor,
                radius: 25.0,
                child: Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context,  '/invitatios',
                    arguments: id
                   );
              },
              child: CircleAvatar(
                backgroundColor: appbarBackgroundColor,
                radius: 25.0,
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: AlertDialog(

                        backgroundColor: kBackgroundColor,
                        title: Text('Say something to your community 👋'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.photo_library),
                                  color: appbarBackgroundColor,
                                  onPressed: () async {
                                    showModalBottomSheet(
                                        backgroundColor: kBackgroundColor,
                                        context: context,
                                        builder: ((builder) => bouttonimage(context))
                                    );
                                  },
                                ),
                                SizedBox(width: 8.0),
                                //Text('Ajouter une photo'),
                              ],
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Enter your status here...',
                              ),
                              maxLines: 10,
                              onChanged: (value) {
                                pub = value;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('publish'),
                            onPressed: () async {
                              if (pub != null) {
                                var erreur = 'ok';
                                final uri = Uri.parse(
                                    'http://$localhost:8080/publication');
                                DateTime today = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(today);
                                var e = userinfos(id, 'email');
                                uploadImgPub(_imgFile, e.toString(), "users");
                                var img = await upload(_imgFile,e.toString(),"users");
                                var res = await http.post(uri,
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    body: jsonEncode({
                                      "idUser": id,
                                      "contenu": pub,
                                      "date_pub": formattedDate,
                                      "img_pub":img
                                    }));
                                alertPub(context, id, erreur);
                              } else {
                                var erreur;
                                alertPub(context, id, erreur);
                              }
                            },
                          ),
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                backgroundColor: appbarBackgroundColor,
                radius: 25.0,
                child: Icon(
                  Icons.publish,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            imgprofile(id,id),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(16.0),
              child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'What\'s new',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.power_settings_new, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder:  (BuildContext context)
                                    {
                                      return AlertDialog(
                                        backgroundColor:
                                        kBackgroundColor,
                                        title: Text(
                                            'Do you really want to disconnect?'),
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
                                              Navigator.pushNamed(
                                                  context,'/Principal',
                                              );
                                            },

                                          ),
                                        ],
                                      );
                                    }

                                );
                              },
                            )

                          ],
                        ),
                        SizedBox(height: 25),
                        FutureBuilder<List<dynamic>>(
                          future: acceuilUSer(id,"user"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> publications = snapshot.data;
                              return Container(
                                height: 655,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: publications.length,
                                  itemBuilder: (context, index) {
                                    String contenu = publications[index]['contenu'];
                                    var idPub = publications[index]['id'];
                                    var auteur = publications[index]['idUser'];
                                    String imagePub = publications[index]['img_pub'];
                                    String UID = auteur.toString();
                                    String type = publications[index]['type'];
                                    if (type == "user") {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(

                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  imgprofile2(UID, id),
                                                  SizedBox(width: 10),
                                                  FutureBuilder<List<dynamic>>(
                                                    future: Future.wait([
                                                      userinfos(
                                                          auteur, 'lastName'),
                                                      userinfos(
                                                          auteur, 'firstName')
                                                    ]),
                                                    builder: (context,
                                                        snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          snapshot.data[1]
                                                              .toString() +
                                                              " " +
                                                              snapshot.data[0]
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
                                              SizedBox(height: 10),
                                              Text(contenu),

                                              FutureBuilder(
                                                  builder: (context, snapshot) {
                                                    if (imagePub.length != 0) {
                                                      return Image.network(
                                                          imagePub);
                                                    } else {
                                                      return Container(
                                                          width: 0.0,
                                                          height: 0.0);
                                                    }
                                                  }

                                              ),

                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  getNbLikes(idPub),
                                                  FutureBuilder<String>(
                                                    future: verifReact(
                                                        id, idPub, "user"),
                                                    builder: (
                                                        BuildContext context,
                                                        snapshot) {
                                                      if (snapshot.hasData) {
                                                        var ok = snapshot.data;
                                                        return IconButton(
                                                          icon: snapshot.data ==
                                                              'Like'
                                                              ? Icon(
                                                              Icons.thumb_up,
                                                              color: Colors
                                                                  .green)
                                                              : Icon(Icons
                                                              .thumb_up_alt),
                                                          onPressed: () async {
                                                            if (ok == 'Like') {
                                                              deleteReactLike(
                                                                  id, idPub);
                                                              setState(() {
                                                                ok = 'Erreur';
                                                              });
                                                            } else if (ok ==
                                                                'Dislike') {
                                                              int idReaction = await getidR(
                                                                  id, idPub);
                                                              PutReactLike(
                                                                  idReaction,
                                                                  id, idPub,
                                                                  'Like',
                                                                  "user");
                                                              setState(() {
                                                                ok = 'Like';
                                                              });
                                                            } else {
                                                              addReactLike(
                                                                  id, idPub,
                                                                  'Like',
                                                                  "user");
                                                              setState(() {
                                                                ok = 'Like';
                                                              });
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        return Container(
                                                          width: 0.0,
                                                          height: 0.0,);
                                                      }
                                                    },
                                                  ),
                                                  FutureBuilder<String>(
                                                    future: verifReact(
                                                        id, idPub, "user"),
                                                    builder: (
                                                        BuildContext context,
                                                        snapshot) {
                                                      if (snapshot.hasData) {
                                                        var ok = snapshot.data;
                                                        return IconButton(
                                                          icon: ok == 'Dislike'
                                                              ? Icon(
                                                              Icons.thumb_down,
                                                              color: Colors.red)
                                                              : Icon(
                                                              Icons.thumb_down),
                                                          onPressed: () async {
                                                            if (ok ==
                                                                'Dislike') {
                                                              deleteReactLike(
                                                                  id, idPub);
                                                              setState(() {
                                                                ok = 'Erreur';
                                                              });
                                                            } else
                                                            if (ok == 'Like') {
                                                              int idReaction = await getidR(
                                                                  id, idPub);
                                                              PutReactLike(
                                                                  idReaction,
                                                                  id, idPub,
                                                                  'Dislike',
                                                                  'user');
                                                              setState(() {
                                                                ok = 'Dislike';
                                                              });
                                                            } else {
                                                              addReactLike(
                                                                  id, idPub,
                                                                  'Dislike',
                                                                  'user');
                                                              setState(() {
                                                                ok = 'Dislike';
                                                              });
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        return Container(
                                                            width: 0.0,
                                                            height: 0.0);
                                                      }
                                                    },
                                                  ),
                                                  getNbDislike(idPub),
                                                  IconButton(
                                                    icon: Icon(Icons.comment),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            backgroundColor: kBackgroundColor,
                                                            title: Text(
                                                                'Comments'),
                                                            content: Column(
                                                              children: [
                                                                Container(
                                                                  width: 500,
                                                                  child: FutureBuilder(
                                                                    future: getComments(
                                                                        idPub),
                                                                    builder: (
                                                                        context,
                                                                        snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        var comments = snapshot
                                                                            .data;
                                                                        if (comments
                                                                            .length >
                                                                            0) {
                                                                          return Column(
                                                                            children: List
                                                                                .generate(
                                                                                comments
                                                                                    .length, (
                                                                                index) {
                                                                              var idAuteur = comments[index]['idUser'];
                                                                              if (comments[index]['type'] ==
                                                                                  "user") {
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
                                                                                        SizedBox(
                                                                                            height: 10),
                                                                                        Text(
                                                                                            '${comments[index]['contenu']}'),
                                                                                        SizedBox(
                                                                                            height: 10),

                                                                                      ]
                                                                                  ), //Text('${comments[index]['contenu']}')
                                                                                );
                                                                              } else
                                                                              if (comments[index]['type' ] ==
                                                                                  "assoc") {
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
                                                                                              future: Associnfos(
                                                                                                  idAuteur,
                                                                                                  'name'),
                                                                                              builder: (
                                                                                                  context,
                                                                                                  snapshot) {
                                                                                                if (snapshot
                                                                                                    .hasData) {
                                                                                                  return Text(
                                                                                                    snapshot
                                                                                                        .data
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
                                                                                        SizedBox(
                                                                                            height: 10),
                                                                                        Text(
                                                                                            '${comments[index]['contenu']}'),
                                                                                        SizedBox(
                                                                                            height: 10),

                                                                                      ]
                                                                                  ), //Text('${comments[index]['contenu']}')
                                                                                );
                                                                              }
                                                                            }),
                                                                          );
                                                                        } else {
                                                                          return Text(
                                                                              'No comments');
                                                                        }
                                                                      } else {
                                                                        return Container(
                                                                            width: 0.0,
                                                                            height: 0.0);
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                                child: TextField(
                                                                  decoration: InputDecoration(
                                                                    hintText: 'Add your comment',
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: appbarBackgroundColor), // Couleur du bord lorsqu'il est activé
                                                                    ),
                                                                    suffixIcon: IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .send),
                                                                      onPressed: () {
                                                                        addComments(
                                                                            idPub,
                                                                            id,
                                                                            Comment,
                                                                            "user");
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (
                                                                              BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text(
                                                                                  "Comment added"),
                                                                              content: Text(
                                                                                  "Your comment has been added successfully."),
                                                                              backgroundColor: kBackgroundColor,
                                                                              actions: [
                                                                                ElevatedButton(
                                                                                  child: Text(
                                                                                      "OK"),
                                                                                  onPressed: () {
                                                                                    Navigator
                                                                                        .pushNamed(
                                                                                        context,
                                                                                        '/home_users',
                                                                                        arguments: id
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),

                                                                  ),
                                                                  onChanged: (
                                                                      value) =>
                                                                  Comment =
                                                                      value,
                                                                ),
                                                              ),


                                                              Row(
                                                                children: [

                                                                  Expanded(
                                                                    child: TextButton(
                                                                      child: Text(
                                                                          'OK'),
                                                                      onPressed: () {
                                                                        Navigator
                                                                            .of(
                                                                            context)
                                                                            .pop();
                                                                      },
                                                                    ),

                                                                  ),
                                                                ],
                                                              ),
                                                            ],

                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  /* Compteur des Comments */

                                                ],
                                              ),
                                              //  SizedBox(height: 30,)
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
                                                  imgPubAssoc(UID,id),
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
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  getNbLikes (idPub),
                                                  FutureBuilder<String>(
                                                    future: verifReact(id,idPub,"assoc"),
                                                    builder: (BuildContext context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var ok = snapshot.data;
                                                        return IconButton(
                                                          icon: snapshot.data == 'Like'?Icon(Icons.thumb_up, color:  Colors.green):Icon(Icons.thumb_up_alt),
                                                          onPressed: () async {

                                                            if (ok == 'Like' ) {
                                                              deleteReactLike(id, idPub);
                                                              setState(() {
                                                                ok = 'Erreur';
                                                              });
                                                            } else if (ok == 'Dislike' ) {
                                                              int idReaction = await getidR(id,idPub);
                                                              PutReactLike(idReaction,id,idPub,'Like','assoc');
                                                              setState(() {
                                                                ok = 'Like';
                                                              });
                                                            }else{
                                                              addReactLike(id,idPub,'Like','assoc');
                                                              setState(() {
                                                                ok = 'Like';
                                                              });
                                                            }
                                                          },
                                                        );
                                                      }else{
                                                        return Container(width: 0.0,height: 0.0,);
                                                      }
                                                    },
                                                  ),
                                                  FutureBuilder<String>(
                                                    future: verifReact(id,idPub,"user"),
                                                    builder: (BuildContext context, snapshot) {

                                                      if (snapshot.hasData) {
                                                        var ok = snapshot.data;
                                                        return IconButton(
                                                          icon: ok == 'Dislike'
                                                              ? Icon(Icons.thumb_down, color:  Colors.red)
                                                              : Icon(Icons.thumb_down),
                                                          onPressed: () async {

                                                            if (ok == 'Dislike') {
                                                              deleteReactLike(id, idPub);
                                                              setState(() {
                                                                ok = 'Erreur';
                                                              });
                                                            } else if (ok == 'Like') {
                                                              int idReaction = await getidR(id,idPub);
                                                              PutReactLike(idReaction,id,idPub,'Dislike','assoc');
                                                              setState(() {
                                                                ok = 'Dislike';
                                                              });
                                                            }else{
                                                              addReactLike(id, idPub,'Dislike','assoc');
                                                              setState(() {
                                                                ok = 'Dislike';
                                                              });
                                                            }
                                                          },
                                                        );

                                                      }else{
                                                        return Container(width: 0.0, height: 0.0);
                                                      }
                                                    },
                                                  ),
                                                  getNbDislike (idPub),
                                                  IconButton(
                                                    icon: Icon(Icons.comment),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            scrollable:  true,
                                                            backgroundColor: kBackgroundColor,
                                                            title: Text('Comments'),
                                                            content:   Column(
                                                              children: [
                                                                Container(
                                                                  width: 500,
                                                                  child: FutureBuilder(
                                                                    future: getComments(idPub),
                                                                    builder: (context, snapshot) {
                                                                      if (snapshot.hasData) {
                                                                        var comments = snapshot.data;
                                                                        if (comments.length > 0) {
                                                                          return Column(
                                                                            children: List.generate(comments.length, (index) {
                                                                              var idAuteur = comments[index]['idUser'];
                                                                              if (comments[index]['type']=="user")
                                                                              {
                                                                                return Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(),
                                                                                    borderRadius: BorderRadius.circular(10),),
                                                                                  child:Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            imgprofile2(idAuteur,id),
                                                                                            SizedBox(width: 10),
                                                                                            FutureBuilder<List<dynamic>>(
                                                                                              future: Future.wait([userinfos(idAuteur, 'lastName'), userinfos(idAuteur, 'firstName')]),
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
                                                                                        Text('${comments[index]['contenu']}'),
                                                                                        SizedBox(height: 10),

                                                                                      ]
                                                                                  ) ,                                                       //Text('${comments[index]['contenu']}')
                                                                                );
                                                                              }else if (comments[index]['type' ] == "assoc") {
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
                                                                                              future: Associnfos(
                                                                                                  idAuteur,
                                                                                                  'name'),
                                                                                              builder: (
                                                                                                  context,
                                                                                                  snapshot) {
                                                                                                if (snapshot
                                                                                                    .hasData) {
                                                                                                  return Text(
                                                                                                    snapshot
                                                                                                        .data
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
                                                                                        SizedBox(
                                                                                            height: 10),
                                                                                        Text(
                                                                                            '${comments[index]['contenu']}'),
                                                                                        SizedBox(
                                                                                            height: 10),

                                                                                      ]
                                                                                  ), //Text('${comments[index]['contenu']}')
                                                                                );
                                                                              }
                                                                            }),
                                                                          );
                                                                        } else {
                                                                          return Text('No comments');
                                                                        }
                                                                      } else {
                                                                        return Container(width: 0.0, height: 0.0);
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 8.0),
                                                                child: TextField(
                                                                  decoration: InputDecoration(
                                                                    hintText: 'Add your comment',
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: appbarBackgroundColor), // Couleur du bord lorsqu'il est activé
                                                                    ),
                                                                    suffixIcon: IconButton(
                                                                      icon: Icon(Icons.send),
                                                                      onPressed: () {
                                                                        addComments(idPub,id,Comment,"assoc");
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text("Comment added"),
                                                                              content: Text("Your comment has been added successfully."),
                                                                              backgroundColor: kBackgroundColor,
                                                                              actions: [
                                                                                ElevatedButton(
                                                                                  child: Text("OK"),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),

                                                                  ),
                                                                  onChanged: (value)=> Comment = value ,
                                                                ),
                                                              ),


                                                              Row(
                                                                children: [

                                                                  Expanded(
                                                                    child: TextButton(
                                                                      child: Text('OK'),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),

                                                                  ),
                                                                ],
                                                              ),
                                                            ],

                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  /* Compteur des Comments */

                                                ],
                                              ),
                                              //  SizedBox(height: 30,)
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),

                              );

                            } else {
                              return Container(width: 0.0, height: 0.0);
                            }
                          },
                        ),
                      ]
                  )
          ),
        )
    );

  }
  bouttonimage(page) {
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
                    takephoto(ImageSource.camera);
                  },
                  label: Text("Camera"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  label: Text("gallery"),
                ),
              ],
            ),
          ],
        )
    );
  }

  void takephoto(ImageSource source) async {
    final pickedFile = await _Picker.getImage(source: source);
    setState(() {
      _imgFile = pickedFile;
    });
  }
}