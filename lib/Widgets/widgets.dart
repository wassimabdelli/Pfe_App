import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/screens/organizations/Register_org.dart';
import 'package:rv_firebase/screens/users/home_users.dart';
import 'package:rv_firebase/screens/users/register.dart';
import 'contants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
const textInputDecoration= InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo,width: 2),
        ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 2),
         ),
    errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64),width: 2),
         ),
);

void nextScreen(context,page){
  Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertRegister(page,UID)
{
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushNamed(page, '/home',arguments: UID);
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("registration"),
    content: Text("your registration is successfully validated."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: page,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertPrincipal(thispage)
{
  Widget okUsers = TextButton(
    child: Text("Users"),
    onPressed: () {
      Navigator.push(
          thispage, MaterialPageRoute(builder: (context) => Register()));
    },
  );
  Widget okOrg = TextButton(
    child: Text("Organisation"),
    onPressed: () {
      Navigator.push(
          thispage, MaterialPageRoute(builder: (context) => Register_org()));
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("Alert!"),
    content: Text("Do you want to register as."),
    actions: [
      okUsers,
      okOrg,
    ],
  );

  // show the dialog
  showDialog(
    context: thispage,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 upload(pathe,iduser,loc)
async {
  var file = File(pathe.path);
  var nimg = basename(pathe.path); // pathe heya _imgFile /// basename yaatina essem tasswira
  String id = iduser;
  var refstorage = FirebaseStorage.instance.ref("$loc/$id/$nimg"); // .ref("images") ==> ipmages sera un dossier dans storage
  await refstorage.putFile(file);
   var url = refstorage.getDownloadURL();
   return url;
  }

//-------------------------------------------------------------------------
Future<String> user_info(String id, String a) async {
  DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(id);
  var value = await doc.get();
  var d = value.data()[a];
  return d.toString();
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------
Future<dynamic> imgprofile(String id) async {
  DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
      id);
  var value = await doc.get();
  var img = value.data()['img'];
  return Image.network(img);
}
//-----------------------------------------------------------------------------------------------
settingsname(fn,ln,sexe,date,img,UID) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(UID);
  docUser.update({
    'fname': fn.text,
    'lname': ln.text,
    'Sexe': sexe,
    'date': date,
    'img': img
  });
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> addNewPublication(String pub, String id) async {
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(id);
    Map<String, dynamic> newPublication = {
      'date': Timestamp.now(),
      'like': 0,
      'dislike': 0,
      'pub': pub,
      'tab1': [],
      'tab2': []
    };
    await userRef.update({
      'publication': FieldValue.arrayUnion([newPublication])
    });
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertPub(thispage,id,erreur)
{
if(erreur == 'ok'){
  Widget ok = TextButton(
    child: Text("ok"),
    onPressed: () {
      Navigator.pushNamed(thispage, '/home_users',arguments: id);
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("Alert!"),
    content: Text("Your post is shared with your network"),
    actions: [
      ok,
    ],
  );

  // show the dialog
  showDialog(
    context: thispage,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
else{
  Widget ok = TextButton(
    child: Text("ok"),
    onPressed: () {
      Navigator.of(thispage).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("Alert!"),
    content: Text("try writing something to share with your network, you can't share an empty message."),
    actions: [
      ok,
    ],
  );

  // show the dialog
  showDialog(
    context: thispage,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<void> addNewFriend(String newfriend, String id) async {
  DocumentReference userRef =
  FirebaseFirestore.instance.collection('users').doc(id);
  await userRef.update({
    'Amis': FieldValue.arrayUnion([newfriend])
  });
}



