import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/screens/login.dart';
import 'package:rv_firebase/screens/organizations/Register_org.dart';
import 'package:rv_firebase/screens/users/register.dart';
import 'contants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertRegister(page) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          page, MaterialPageRoute(builder: (context) => Login()));
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("registration"),
    content: Text("your registration is successfully validated. You can connect now"),
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
void alertPrincipal(thispage) {
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
upload(pathe, email, loc) async {
  var file = File(pathe.path);
  var nimg = basename(
      pathe.path); // pathe heya _imgFile /// basename yaatina essem tasswira
  String e = email;
  var refstorage = FirebaseStorage.instance.ref(
      "$loc/$e/$nimg"); // .ref("images") ==> ipmages sera un dossier dans storage
  await refstorage.putFile(file);
  var url = refstorage.getDownloadURL();
  return url;
}
//-----------------------------------------------------------------------------------------------
settingsname(fn, ln, sexe, date, img, UID) async {
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
addNewPublication(String pub, String iduser) async {

  final uri = Uri.parse('http://192.168.1.12:8080/publicaton');
  DateTime today = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(today);
  var res = await http.post(uri, headers: {'Content-Type': 'application/json'},
      body:  jsonEncode( {
        "idUser": "iduser",
        "contenu": "pub",
        "date_pub": "2023-05-05"
      })

  );
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertPub(thispage, id, erreur) {
  if (erreur == 'ok') {
    Widget ok = TextButton(
      child: Text("ok"),
      onPressed: () {
        Navigator.pushNamed(thispage, '/home_users', arguments: id);
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
  } else {
    Widget ok = TextButton(
      child: Text("ok"),
      onPressed: () {
        Navigator.of(thispage).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: kBackgroundColor,
      title: Text("Alert!"),
      content: Text(
          "try writing something to share with your network, you can't share an empty message."),
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
//------------------------------------------------------------------------------------------------------------------------------------------------------------

Future<List<String>> getAmisIds(String id) async {
  final currentUserSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  final amisIds = List<String>.from(currentUserSnapshot.data()['Amis'] ?? []);

  return amisIds;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<String>> getPublicationTexts(String id) async {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(id);
  DocumentSnapshot userSnapshot = await userRef.get();
  if (userSnapshot.exists) {
    List<dynamic> publications = userSnapshot.data()['publication'];
    List<String> publicationTexts = publications
        .map((publication) => publication['pub'].toString())
        .toList();

    return publicationTexts;
  }
}

//------------------------------------------------------------------------------------------
String hashPassword(String password) {
  String salt = "MyConstantSaltValue";

  String saltedPassword = password + salt;

  var bytes = utf8.encode(saltedPassword);
  var hash = md5.convert(bytes);

  return hash.toString();
}
//------------------------------------------------------------------------------------------

 userinfos(id, info) async {
  final uri = Uri.parse('http://192.168.1.12:8080/utilisateur/${id}');
  var response = await http.get(uri);
  var jsonResponse = jsonDecode(response.body);
  var i = jsonResponse[info];

  return i;
}
//------------------------------------------------------------------------------------------

imgprofile(id) {
  return FutureBuilder(
      future: userinfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile_user',arguments:id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data),
              radius: 35,
            ),
          );
        } else {
          return CircleAvatar();
        }
      });
}
//------------------------------------------------------------------------------------------
Future<List<Map<String, dynamic>>> RandomUser(id) async {

  final uri = Uri.parse("http://192.168.1.12:8080/utilisateur/random/${id}");
  var res = await http.get(uri);

  List<Map<String, dynamic>> utilisateurs = [];

  var jsonData = json.decode(res.body);

  for (var item in jsonData) {
    utilisateurs.add(item);
  }
  return utilisateurs;
}

Future<List<dynamic>> listpub(String id) async {
  List<dynamic> users;
  final uri = Uri.parse('http://192.168.1.12:8080/publication/findbyIdUser/${id}');
  var res = await http.get(uri);
  print(res.body);
 return  users = jsonDecode(res.body);
}
//*************************************
