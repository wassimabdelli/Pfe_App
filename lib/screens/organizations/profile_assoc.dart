import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Controller/FollowController.dart';
import 'package:rv_firebase/Controller/PublicationController.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class Profile_assoc extends StatefulWidget {
  const Profile_assoc({Key key}) : super(key: key);

  @override
  State<Profile_assoc> createState() => _Profile_assocState();
}

class _Profile_assocState extends State<Profile_assoc> {
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
          onPressed: () =>
              Navigator.pushNamed(context, '/home_assoc', arguments: MyId),
        ),
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
              margin: EdgeInsets.only(top: 30.0),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    imgprofileAssoc0(id,75.0),
                    FutureBuilder(
                      future: Associnfos(id , 'name'),
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
                    FutureBuilder(
                     builder: (context, snapshot) {
                       int ID = int.parse(id);
                       int MYID = int.parse(MyId);
                       if (ID == MYID) {
                         return IconButton(
                             onPressed: () {
                               final RenderBox button = context
                                   .findRenderObject();
                               final RenderBox overlay = Overlay
                                   .of(context)
                                   .context
                                   .findRenderObject();
                               final RelativeRect position = RelativeRect
                                   .fromRect(
                                 Rect.fromPoints(
                                   button.localToGlobal(
                                       Offset.zero, ancestor: overlay),
                                   button.localToGlobal(
                                       button.size.bottomRight(Offset.zero),
                                       ancestor: overlay) + Offset(40, 0),
                                 ),
                                 Offset.zero & overlay.size,
                               );
                               showMenu(
                                 context: context,
                                 position: position,
                                 items: <PopupMenuEntry<String>>[
                                   PopupMenuItem<String>(
                                     value: 'friends',
                                     child: Row(
                                       children: [
                                         Icon(
                                           Icons.groups,
                                           color: Colors.green,
                                         ),
                                         SizedBox(
                                           width: 5,
                                         ),
                                         Text('Followers'),
                                       ],
                                     ),
                                   ),
                                   PopupMenuItem<String>(
                                     value: 'settings',
                                     child: Row(
                                       children: [
                                         Icon(
                                           Icons.settings,
                                           color: Colors.red,
                                         ),
                                         SizedBox(
                                           width: 5,
                                         ),
                                         Text('Settings'),
                                       ],
                                     ),
                                   ),
                                   PopupMenuItem<String>(
                                     value: 'challenges',
                                     child: Row(
                                       children: [
                                         Icon(
                                           Icons.star,
                                           color: Colors.yellow,
                                         ),
                                         SizedBox(
                                           width: 5,
                                         ),
                                         Text('Challenges'),
                                       ],
                                     ),
                                   ),
                                 ],
                                 color: kBackgroundColor,
                               ).then((value) {
                                 if (value == 'settings') {
                                   Navigator.pushNamed(
                                       context, '/InfosAssoc',
                                       arguments: id);
                                 } else if (value == 'friends') {
                                   Navigator.pushNamed(context, '/ListFollowers',
                                       arguments: '$id;$MyId');
                                 }else{
                                   Navigator.pushNamed(context, '/MyChallenges',
                                       arguments: '$id;$MyId');
                                 }
                               });
                             },
                             icon: Icon(Icons.perm_device_information,
                               color: appbarBackgroundColor,)
                         );
                       } else {
                         return FutureBuilder(
                             future: VerifIsFollow(MYID, ID),
                             builder: (context, snapshot) {
                               if (snapshot.data == true) {
                                 return Row(
                                   mainAxisAlignment: MainAxisAlignment
                                       .center,
                                   children: [
                                     IconButton(
                                       icon: Icon(
                                         Icons.message,
                                         color: appbarBackgroundColor,
                                       ),
                                       onPressed: () {
                                         Navigator.pushNamed(
                                             context, '/ChatWithAssoc',
                                             arguments: '$MYID;$ID'
                                         );
                                       },
                                     ),
                                     IconButton(
                                       icon: Icon(
                                         Icons.star,
                                         color: appbarBackgroundColor,
                                       ),
                                       onPressed: () {
                                         Navigator.pushNamed(context, '/MyChallenges',
                                             arguments: '$id;$MyId');
                                       },
                                     ),
                                     SizedBox(width: 10,),
                                     ElevatedButton(
                                       onPressed: () {
                                         deleteFollow(MYID, ID);
                                       },
                                       child: Text('Unfollow'),
                                       style: ElevatedButton.styleFrom(
                                         primary: appbarBackgroundColor,
                                         onPrimary: Colors.white,
                                       ),
                                     ),
                                   ],
                                 );
                               } else {
                                 return  ElevatedButton.icon(
                                   onPressed: () {


                                   },
                                   icon: Icon(Icons.add_circle),
                                   label: Text('Follow'),
                                   style: ElevatedButton.styleFrom(
                                     fixedSize: Size(170, 40),
                                     primary: appbarBackgroundColor,
                                     onPrimary: Colors.white,
                                     shape: RoundedRectangleBorder(
                                       borderRadius:
                                       BorderRadius.circular(20.0),
                                     ),
                                   ),
                                 );
                               }
                             }
                         );
                       }
                     }
                    ),
                    SizedBox(height: 15),
                    FutureBuilder<List<dynamic>>(
                    future: listpub(id,"assoc"),
                    builder: (context, snapshot) {
                      List<dynamic> publications = snapshot.data;
                      if (publications.isNotEmpty) {
                        return Container(
                            height: 430,
                            child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: publications.length,
                            itemBuilder: (context, index) {
                              String contenu = publications[index]['contenu'];
                              var idPub = publications[index]['id'];
                              var idUser = publications[index]['idUser'];
                              var date_pub = publications[index]['date_pub'];
                              var imgPub =  publications[index]['img_pub'];
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
                                              imgPubAssoc(MyId,id),
                                              SizedBox(width: 10),
                                              FutureBuilder(
                                                future:Associnfos(id, "name"),
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
                                               Spacer(),
                                               FutureBuilder(
                                                future: Future.value(id == MyId),
                                                builder: (context, snapshot) {
                                                 if (snapshot.data) {
                                                   return IconButton(
                                                     icon: Icon(Icons.more_horiz),
                                                     onPressed: () {
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
                                                             value: 'update',
                                                             child: Row(
                                                               children: [
                                                                 Icon(
                                                                   Icons.update,
                                                                   color: Colors.green,
                                                                 ),
                                                                 SizedBox(
                                                                   width: 5,
                                                                 ),
                                                                 Text('Update'),
                                                               ],
                                                             ),
                                                           ),
                                                           PopupMenuItem<String>(
                                                             value: 'delete',
                                                             child: Row(
                                                               children: [
                                                                 Icon(
                                                                   Icons.delete,
                                                                   color: Colors.red,
                                                                 ),
                                                                 SizedBox(
                                                                   width: 5,
                                                                 ),
                                                                 Text('Delete'),
                                                               ],
                                                             ),
                                                           ),
                                                         ],
                                                         color: kBackgroundColor,
                                                       ).then((value) {
                                                         if (value == 'update') {
                                                           showDialog(
                                                             context: context,
                                                             builder: (BuildContext
                                                             context) {
                                                               String pubUpdate;
                                                               return AlertDialog(
                                                                 backgroundColor:
                                                                 kBackgroundColor,
                                                                 title: Text(
                                                                     'Update Your post here'),
                                                                 content: TextField(
                                                                   onChanged: (value) {
                                                                     pubUpdate = value;
                                                                   },
                                                                   decoration:
                                                                   InputDecoration(
                                                                     hintText:
                                                                     '$contenu',
                                                                   ),
                                                                 ),
                                                                 actions: <Widget>[
                                                                   TextButton(
                                                                     child: Text(
                                                                         'Cancel'),
                                                                     onPressed: () {
                                                                       Navigator.of(
                                                                           context)
                                                                           .pop();
                                                                     },
                                                                   ),
                                                                   TextButton(
                                                                     child: Text('OK'),
                                                                     onPressed: () {
                                                                       UpdatePublication(
                                                                           idPub,
                                                                           id,
                                                                           date_pub,
                                                                           pubUpdate);
                                                                       Navigator.pushNamed(
                                                                           context,
                                                                           '/profile_user',
                                                                           arguments:
                                                                           id);
                                                                     },
                                                                   ),
                                                                 ],
                                                               );
                                                             },
                                                           );
                                                         } else {
                                                           showDialog(
                                                             context: context,
                                                             builder: (BuildContext
                                                             context) {
                                                               return AlertDialog(
                                                                 backgroundColor:
                                                                 kBackgroundColor,
                                                                 title: Text(
                                                                     'You are sure to delete this post'),
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
                                                                       DeletePublication(
                                                                           idPub);
                                                                       Navigator.pushNamed(
                                                                           context,
                                                                           '/profile_user',
                                                                           arguments:
                                                                           id);
                                                                     },
                                                                   ),
                                                                 ],
                                                               );
                                                             },
                                                           );
                                                         }
                                                       });
                                                     },
                                                   );
                                                 }else{
                                                   return Container(
                                                     width: 0.0,
                                                     height: 0.0,
                                                   );
                                                 }
                                                }
                                               )
                                            ],
                                          ),
                                         SizedBox(height: 10),
                                         Text('$contenu'),
                                         FutureBuilder(
                                             builder: (context, snapshot) {
                                               if (imgPub != null)
                                               {
                                                 return Image.network(imgPub);
                                               }else{
                                                 return Container(width: 0.0, height: 0.0);
                                               }
                                             }

                                         ),
                                         SizedBox(height: 10),
                                         Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             getNbLikes(idPub),
                                             FutureBuilder<String>(
                                               future: verifReact(MyId, idPub,"assoc"),
                                               builder:
                                                   (BuildContext context, snapshot) {
                                                 if (snapshot.hasData) {
                                                   var ok = snapshot.data;
                                                   return IconButton(
                                                     icon: snapshot.data == 'Like'
                                                         ? Icon(Icons.thumb_up,
                                                         color: Colors.green)
                                                         : Icon(Icons.thumb_up_alt),
                                                     onPressed: () async {
                                                       if (ok == 'Like') {
                                                         deleteReactLike(id, idPub);
                                                         setState(() {
                                                           ok = 'Erreur';
                                                         });
                                                       } else if (ok == 'Dislike') {
                                                         int idReaction =
                                                         await getidR(MyId, idPub);
                                                         PutReactLike(idReaction, MyId,
                                                             idPub, 'Like','assoc');
                                                         setState(() {
                                                           ok = 'Like';
                                                         });
                                                       } else {
                                                         addReactLike(
                                                             MyId, idPub, 'Like','assoc');
                                                         setState(() {
                                                           ok = 'Like';
                                                         });
                                                       }
                                                     },
                                                   );
                                                 } else {
                                                   return Container(
                                                     width: 0.0,
                                                     height: 0.0,
                                                   );
                                                 }
                                               },
                                             ),
                                             FutureBuilder<String>(
                                               future: verifReact(id, idPub,"assoc"),
                                               builder:
                                                   (BuildContext context, snapshot) {
                                                 if (snapshot.hasData) {
                                                   var ok = snapshot.data;
                                                   return IconButton(
                                                     icon: ok == 'Dislike'
                                                         ? Icon(Icons.thumb_down,
                                                         color: Colors.red)
                                                         : Icon(Icons.thumb_down),
                                                     onPressed: () async {
                                                       if (ok == 'Dislike') {
                                                         deleteReactLike(id, idPub);
                                                         setState(() {
                                                           ok = 'Erreur';
                                                         });
                                                       } else if (ok == 'Like') {
                                                         int idReaction =
                                                         await getidR(id, idPub);
                                                         PutReactLike(idReaction, id,
                                                             idPub, 'Dislike','user');
                                                         setState(() {
                                                           ok = 'Dislike';
                                                         });
                                                       } else {
                                                         addReactLike(
                                                             id, idPub, 'Dislike','user');
                                                         setState(() {
                                                           ok = 'Dislike';
                                                         });
                                                       }
                                                     },
                                                   );
                                                 } else {
                                                   return Container(
                                                       width: 0.0, height: 0.0);
                                                 }
                                               },
                                             ),
                                             getNbDislike(idPub),
                                             IconButton(
                                               icon: Icon(Icons.comment),
                                               onPressed: () async {
                                                 showDialog(
                                                   context: context,
                                                   builder: (BuildContext context) {
                                                     return AlertDialog(
                                                       scrollable: true,
                                                       backgroundColor:
                                                       kBackgroundColor,
                                                       title: Text('Comments'),
                                                       content: Column(
                                                         children: [
                                                           Container(
                                                             width: 500,
                                                             child: FutureBuilder(
                                                               future:
                                                               getComments(idPub),
                                                               builder: (context,
                                                                   snapshot) {
                                                                 if (snapshot
                                                                     .hasData) {
                                                                   var comments =
                                                                       snapshot.data;
                                                                   if (comments
                                                                       .length >
                                                                       0) {
                                                                     return Column(
                                                                       children: List
                                                                           .generate(
                                                                           comments
                                                                               .length,
                                                                               (index) {
                                                                             var idAuteur =
                                                                             comments[
                                                                             index]
                                                                             [
                                                                             'idUser'];
                                                                             var idComment =
                                                                             comments[
                                                                             index]
                                                                             [
                                                                             'id'];
                                                                             var textComment =
                                                                             comments[
                                                                             index]
                                                                             [
                                                                             'contenu'];
                                                                              if (comments[index]['type']=="user")
                                                                              {
                                                                             return Container(
                                                                               decoration:
                                                                               BoxDecoration(
                                                                                 border: Border
                                                                                     .all(),
                                                                                 borderRadius:
                                                                                 BorderRadius.circular(
                                                                                     10),
                                                                               ),
                                                                               child: Column(
                                                                                   crossAxisAlignment:
                                                                                   CrossAxisAlignment.start,
                                                                                   children: [
                                                                                     Row(
                                                                                       children: [
                                                                                         imgprofile2(idAuteur,id),
                                                                                         SizedBox(width: 10),
                                                                                         FutureBuilder<List<dynamic>>(
                                                                                           future: Future.wait([
                                                                                             userinfos(idAuteur, 'lastName'),
                                                                                             userinfos(idAuteur, 'firstName')
                                                                                           ]),
                                                                                           builder: (context, snapshot) {
                                                                                             if (snapshot.hasData) {
                                                                                               return Text(
                                                                                                 snapshot.data[1].toString() + " " + snapshot.data[0].toString(),
                                                                                                 style: TextStyle(
                                                                                                   fontSize: 18.0,
                                                                                                   fontWeight: FontWeight.bold,
                                                                                                 ),
                                                                                               );
                                                                                             }
                                                                                             return Container(width: 0.0, height: 0.0);
                                                                                           },
                                                                                         ),
                                                                                         Spacer(),
                                                                                         FutureBuilder(
                                                                                           builder: (context, snapshot) {
                                                                                             int idCompte = int.parse(id);
                                                                                             if (idAuteur == idCompte) {
                                                                                               return IconButton(
                                                                                                 icon: Icon(Icons.more_horiz),
                                                                                                 onPressed: () {
                                                                                                   final RenderBox button = context.findRenderObject();
                                                                                                   final RenderBox overlay = Overlay.of(context).context.findRenderObject();
                                                                                                   final RelativeRect position = RelativeRect.fromRect(
                                                                                                     Rect.fromPoints(
                                                                                                       button.localToGlobal(Offset.zero, ancestor: overlay),
                                                                                                       button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                                                                                     ),
                                                                                                     Offset.zero & overlay.size,
                                                                                                   );
                                                                                                   showMenu(
                                                                                                     context: context,
                                                                                                     position: position,
                                                                                                     items: <PopupMenuEntry<String>>[
                                                                                                       PopupMenuItem<String>(
                                                                                                         value: 'update',
                                                                                                         child: Row(
                                                                                                           children: [
                                                                                                             Icon(
                                                                                                               Icons.update,
                                                                                                               color: Colors.green,
                                                                                                             ),
                                                                                                             SizedBox(
                                                                                                               width: 5,
                                                                                                             ),
                                                                                                             Text('Update'),
                                                                                                           ],
                                                                                                         ),
                                                                                                       ),
                                                                                                       PopupMenuItem<String>(
                                                                                                         value: 'delete',
                                                                                                         child: Row(
                                                                                                           children: [
                                                                                                             Icon(
                                                                                                               Icons.delete,
                                                                                                               color: Colors.red,
                                                                                                             ),
                                                                                                             SizedBox(
                                                                                                               width: 5,
                                                                                                             ),
                                                                                                             Text('Delete'),
                                                                                                           ],
                                                                                                         ),
                                                                                                       ),
                                                                                                     ],
                                                                                                     color: kBackgroundColor,
                                                                                                   ).then((value) {
                                                                                                     if (value == 'update') {
                                                                                                       showDialog(
                                                                                                         context: context,
                                                                                                         builder: (BuildContext context) {
                                                                                                           String pubUpdate;
                                                                                                           return AlertDialog(
                                                                                                             backgroundColor: kBackgroundColor,
                                                                                                             title: Text('Update Your comment here'),
                                                                                                             content: TextField(
                                                                                                               onChanged: (value) {
                                                                                                                 pubUpdate = value;
                                                                                                               },
                                                                                                               decoration: InputDecoration(
                                                                                                                 hintText: '$textComment',
                                                                                                               ),
                                                                                                             ),
                                                                                                             actions: <Widget>[
                                                                                                               TextButton(
                                                                                                                 child: Text('Cancel'),
                                                                                                                 onPressed: () {
                                                                                                                   Navigator.of(context).pop();
                                                                                                                 },
                                                                                                               ),
                                                                                                               TextButton(
                                                                                                                 child: Text('OK'),
                                                                                                                 onPressed: () {
                                                                                                                   UpdateComment(idComment, idPub, id, pubUpdate);
                                                                                                                   Navigator.pushNamed(context, '/profile_user', arguments: '$id;$id');
                                                                                                                 },
                                                                                                               ),
                                                                                                             ],
                                                                                                           );
                                                                                                         },
                                                                                                       );
                                                                                                     } else {
                                                                                                       showDialog(
                                                                                                         context: context,
                                                                                                         builder: (BuildContext context) {
                                                                                                           return AlertDialog(
                                                                                                             backgroundColor: kBackgroundColor,
                                                                                                             title: Text('You are sure to delete this post'),
                                                                                                             actions: <Widget>[
                                                                                                               TextButton(
                                                                                                                 child: Text('No'),
                                                                                                                 onPressed: () {
                                                                                                                   Navigator.of(context).pop();
                                                                                                                 },
                                                                                                               ),
                                                                                                               TextButton(
                                                                                                                 child: Text('Yes'),
                                                                                                                 onPressed: () {
                                                                                                                   DeleteComment(idComment);
                                                                                                                   Navigator.pushNamed(context, '/profile_user', arguments: '$id;$id');
                                                                                                                 },
                                                                                                               ),
                                                                                                             ],
                                                                                                           );
                                                                                                         },
                                                                                                       );
                                                                                                     }
                                                                                                   });
                                                                                                 },
                                                                                               );
                                                                                             } else {
                                                                                               return IconButton(
                                                                                                   onPressed: () {
                                                                                                     showDialog(
                                                                                                       context: context,
                                                                                                       builder: (BuildContext context) {
                                                                                                         return AlertDialog(
                                                                                                           backgroundColor: kBackgroundColor,
                                                                                                           title: Text('You are sure to delete this comment'),
                                                                                                           actions: <Widget>[
                                                                                                             TextButton(
                                                                                                               child: Text('No'),
                                                                                                               onPressed: () {
                                                                                                                 Navigator.of(context).pop();
                                                                                                               },
                                                                                                             ),
                                                                                                             TextButton(
                                                                                                               child: Text('Yes'),
                                                                                                               onPressed: () {
                                                                                                                 DeleteComment(idComment);
                                                                                                                 Navigator.of(context).pop();
                                                                                                               },
                                                                                                             ),
                                                                                                           ],
                                                                                                         );
                                                                                                       },
                                                                                                     );

                                                                                                   },
                                                                                                   icon: Icon(Icons.delete, color: Colors.red));
                                                                                             }
                                                                                           },
                                                                                         ),
                                                                                       ],
                                                                                     ),
                                                                                     SizedBox(
                                                                                         height: 10),
                                                                                     Text(
                                                                                         textComment),
                                                                                     SizedBox(
                                                                                         height: 10),
                                                                                   ]),
                                                                             );
                                                                           }else{
                                                                                return Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(),
                                                                                    borderRadius: BorderRadius.circular(10),),
                                                                                  child:Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            imgPubAssoc(idAuteur,id),
                                                                                            SizedBox(width: 10),
                                                                                            FutureBuilder(
                                                                                              future: Associnfos(idAuteur, 'name'),
                                                                                              builder: (context, snapshot) {
                                                                                                if (snapshot.hasData ) {
                                                                                                  return Text(
                                                                                                    snapshot.data.toString() ,
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
                                                           padding: EdgeInsets.only(
                                                               top: 8.0),
                                                           child: TextField(
                                                             onChanged: (value) {
                                                               contenu = value;
                                                             },
                                                             decoration:
                                                             InputDecoration(
                                                               hintText:
                                                               'Add your comment',
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
                                                                   addComments(idPub,
                                                                       id, contenu,"assuc");
                                                                   Navigator.of(
                                                                       context)
                                                                       .pop();
                                                                 },
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                         Row(
                                                           children: [
                                                             Expanded(
                                                               child: TextButton(
                                                                 child: Text('OK'),
                                                                 onPressed: () {
                                                                   Navigator.of(
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
                                       ],
                                     ),
                                   )
                              );
                            }
                            )
                        );
                      }else{
                        return Container(width: 0.0, height: 0.0);
                      }
                    }
                    )
                  ],
              )
          )
      ),
    );
  }
}
