import 'dart:io';
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
void alertRegister(page)
{
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          page, MaterialPageRoute(builder: (context) => Home()));
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
Future<void> upload(pathe,iduser)
async {
  var file = File(pathe.path);
  var nimg = basename(pathe.path); // path heya _imgFile /// basename yaatina essem tasswira
  String id = iduser;
  var refstorage = FirebaseStorage.instance.ref("$id/$nimg"); // .ref("images") ==> ipmages sera un dossier dans storage
  await refstorage.putFile(file);
   var url = refstorage.getDownloadURL();

  }

