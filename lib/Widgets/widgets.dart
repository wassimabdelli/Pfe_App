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
uploadImgPub(pathe, email, loc) async {
  var file = File(pathe.path);
  var nimg = basename(
      pathe.path); // pathe heya _imgFile /// basename yaatina path etasswira
  String e = email;
  var refstorage = FirebaseStorage.instance.ref(
      "$loc/$e/ImgPub/$nimg"); // .ref("images") ==> ipmages sera un dossier dans storage
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


//------------------------------------------------------------------------------------------------------------------------------------------------------------
UpdatePublication(idPub, iduser,date,contenu) async {

  final uri = Uri.parse('http://192.168.1.12:8080/publication');
  var res = await http.put(uri, headers: {'Content-Type': 'application/json'},
      body:  jsonEncode( {
        "id":idPub,
        "idUser": iduser,
        "contenu": contenu,
        "date_pub":date
      })

  );
}
DeletePublication(idPub) async {
  final uri = Uri.parse('http://192.168.1.12:8080/publication/${idPub}');
  var res = await http.delete(uri);

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

imgprofile(id,MyId) {
  return FutureBuilder(
      future: userinfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile_user',arguments:'$id;$MyId');
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
imgprofile0(id,a) {
  return FutureBuilder(
      future: userinfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
            //  Navigator.pushNamed(context, '/profile_user',arguments:id);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data),
              radius: a,
            ),
          );
        } else {
          return CircleAvatar();
        }
      });
}
imgprofile2(id,MyId) {
  return FutureBuilder(
      future: userinfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile_user', arguments:'$id;$MyId');
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(snapshot.data),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: 30.0,
              height: 30.0,
            ),
          );
        } else {
          return Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
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
 return  users = jsonDecode(res.body);
}
//------------------------------------------------------------------------------------------------------------------------------------------------
addReactLike(idUser,idPub,type) async {
  final uri = Uri.parse('http://192.168.1.12:8080/reaction');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode( {
        "idPub": idPub,
        "idUser": idUser,
        "type":  type
      }));

}
//-----------------------------------------------------------------------------------------------------------------------------------------------
Future<String> verifReact( idUser,  idPub) async {
  try {
    final uri = Uri.parse(
        'http://192.168.1.12:8080/reaction/findReact/${idUser}/${idPub}');
    var res = await http.get(uri);

    // Vérification de la réponse HTTP
    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      var type = jsonResponse['type'];

      // Vérification de la présence de la clé "type"
      if (type != null) {
        // Vérification de la valeur de "type"
        if (type == 'Like') {
          return 'Like';
        } else if (type == 'Dislike') {
          return 'Dislike';
        } else {
          return 'Erreur';
        }
      } else {
        return 'Erreur';
      }
    }
  } catch (e) {
    // Gestion des erreurs
   // print('Erreur lors de la requête HTTP ou du décodage JSON : $e');
    return 'Erreur';
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
deleteReactLike(idUser,idPub)
async {
  final uri = Uri.parse('http://192.168.1.12:8080/reaction/${idUser}/${idPub}');
  var res = await http.delete(uri);
}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<int> getIdREaction(idUser,idPub)
async {

  final uri = Uri.parse('http://192.168.1.12:8080/reaction/findReact/${idUser}/${idPub}');
  var res = await http.get(uri);
  var jsonResponse = jsonDecode(res.body);
  var id = jsonResponse['id'];
  return id;

}
PutReactLike(idR,idUser,idPub,type) async {
  final uri = Uri.parse('http://192.168.1.12:8080/reaction');
  var res = await http.put(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode( {
        "id": idR,
        "idPub": idPub,
        "idUser": idUser,
        "type": type
      }));

}
//---------------------------------------------------------------------------------------------------------------------------------------------------
getidR(idUser,idPub) async {
  int idReaction = await getIdREaction(idUser, idPub);
  return  idReaction;
}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<int> CountLike(idPub)async {

    final uri = Uri.parse('http://192.168.1.12:8080/reaction/countLike/${idPub}');
    var res = await http.get(uri);
    var nbLike = jsonDecode(res.body);
    return nbLike;

  }
//---------------------------------------------------------------------------------------------------------------------------------------------------
  getNbLikes (idPub){
  return  FutureBuilder<int>(
    future: CountLike(idPub),
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      if (snapshot.hasData) {

        return Text('${snapshot.data}') ;


      }
    },
  );

  }
//---------------------------------------------------------------------------------------------------------------------------------------------------


Future<int> CountDislike(idPub)async {

  final uri = Uri.parse('http://192.168.1.12:8080/reaction/countDislike/${idPub}');
  var res = await http.get(uri);
  var nbLike = jsonDecode(res.body);
  return nbLike;

}
//---------------------------------------------------------------------------------------------------------------------------------------------------
getNbDislike (idPub){
  return  FutureBuilder<int>(
    future: CountDislike(idPub),
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      if (snapshot.hasData) {

        return Text('${  snapshot.data}') ;


      }
    },
  );

}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> getComments(idPub)async {

  final uri = Uri.parse('http://192.168.1.12:8080/comment/${idPub}');
  var res = await http.get(uri);
  var Comments = jsonDecode(res.body);
  return Comments;

}

//--------------------------------------------------------------------------------------------------------------------------
Invitation(emutteur,destinataire) async{
final uri = Uri.parse('http://192.168.1.12:8080/invitation');
var res = await http.post(uri,
headers: {
'Content-Type': 'application/json'
},
body: jsonEncode( {
  "emetteur": emutteur,
  "destinataire": destinataire
}));

}
//-----------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> getInvitations(destinataire)async {
  List<dynamic> Invitations;
  final uri = Uri.parse('http://192.168.1.12:8080/invitation/${destinataire}');
  var res = await http.get(uri);

  return Invitations = jsonDecode(res.body);
}
//----------------------------------------------------------------------------------------------------------------------------
DeleteInvit(id) async {
  final uri = Uri.parse('http://192.168.1.12:8080/invitation/${id}');
  var res = await http.delete(uri);
}
//----------------------------------------------------------------------------------------------------------------------------
  addAmis(id , idAmi ) async {
  final uri = Uri.parse('http://192.168.1.12:8080/amis');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(  {
        "idCompte": id,
        "idAmi": idAmi
      }));

}
Future<List<dynamic>> listAmi(String id) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://192.168.1.12:8080/amis/chercher/${id}');
  var res = await http.get(uri);
  return  Amis = jsonDecode(res.body);
}
//----------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> listpub2(id) async {
  List<dynamic> acceuil = [];
  List<dynamic> Amis = await listAmi(id);

  for (int i = 0; i < Amis.length; i++) {
    List<dynamic> pub = await listpub(Amis[i].toString());
    acceuil.addAll(pub);
  }
  acceuil.sort((a, b) => DateTime.parse(b['date_pub']).compareTo(DateTime.parse(a['date_pub'])));
  return acceuil;
}
//----------------------------------------------------------------------------------------------------------------------------
addComments(idPub,idUser,contenu) async {
  final uri = Uri.parse('http://192.168.1.12:8080/comment');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
          "idPub": idPub,
          "idUser": idUser,
          "date": DateTime.now().toString().substring(0, 10),
          "contenu": contenu
      }));
}
//-------------------------------------------------------------------------------------------------------------------------------
UpdateComment(idComment,idPub,idUser,contenu)async
{
  final uri = Uri.parse('http://192.168.1.12:8080/comment');
  var res = await http.put(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "id": idComment,
        "idPub": idPub,
        "idUser": idUser,
        "date": DateTime.now().toString().substring(0, 10),
        "contenu": contenu
      }));
}
//--------------------------------------------------------------------------------------------------------------------------------
DeleteComment(idComment) async {
  final uri = Uri.parse('http://192.168.1.12:8080/comment/${idComment}');
  var res = await http.delete(uri);
}
//------------------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>>listFriend(String id) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://192.168.1.12:8080/amis/${id}');
  var res = await http.get(uri);
  return  Amis = jsonDecode(res.body);
}

Future<bool> VerifIsFriend(int id ,int idCompte) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://192.168.1.12:8080/amis/chercher/${id}');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  return Amis.contains(idCompte);
}
conversation( id , idAmi ) async {
  List<dynamic> Conversation;
  final uri = Uri.parse('http://192.168.1.12:8080/amis/chercher/${id}');
  var res = await http.get(uri);
  Conversation = jsonDecode(res.body);
  return Conversation = jsonDecode(res.body);
}
