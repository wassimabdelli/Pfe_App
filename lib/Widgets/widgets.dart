import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/screens/login.dart';
import 'package:rv_firebase/screens/organizations/Login_Assoc.dart';
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
String localhost = "172.23.48.1";

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
  showDialog(
    context: thispage,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------

void alertPrincipal2(thispage) {
  Widget okUsers = TextButton(
    child: Text("Users"),
    onPressed: () {
      Navigator.push(
          thispage, MaterialPageRoute(builder: (context) => Login()));
    },
  );
  Widget okOrg = TextButton(
    child: Text("Association"),
    onPressed: () {
      Navigator.push(
          thispage, MaterialPageRoute(builder: (context) => Login_assoc()));
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("Alert!"),
    content: Text("Do you want to Sign in as."),
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
  uploadImgAssoc(pathe, email, test) async {
  var file = File(pathe.path);
  var loc = "Association";
  var nimg = basename(
      pathe.path); // pathe heya _imgFile /// basename yaatina essem tasswira
  String e = email;
  var refstorage = FirebaseStorage.instance.ref(
      "$loc/$e/$test/$nimg"); // .ref("images") ==> ipmages sera un dossier dans storage
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


//------------------------------------------------------------------------------------------------------------------------------------------------------------
UpdatePublication(idPub, iduser,date,contenu) async {

  final uri = Uri.parse('http://$localhost:8080/publication');
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
  final uri = Uri.parse('http://$localhost:8080/publication/${idPub}');
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
  final uri = Uri.parse('http://$localhost:8080/utilisateur/${id}');
  var response = await http.get(uri);
  var jsonResponse = jsonDecode(response.body);
  var i = jsonResponse[info];

  return i;
}
//-----------------------------------------------------------------------
Associnfos(id, info) async {
  final uri = Uri.parse('http://$localhost:8080/association/${id}');
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

/////////////////////////

imgprofileAssoc(id,MyId,type) {
  return FutureBuilder(
      future: Associnfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
             Navigator.pushNamed(context, '/profile_assoc',arguments:'$id;$MyId;$type');
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
imgprofileAssoc0(id,a) {
  return FutureBuilder(
      future: Associnfos(id, "img"),
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

imgPubAssoc(id,MyId) {
  return FutureBuilder(
      future: Associnfos(id, "img"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile_assoc', arguments:'$id;$MyId');
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
////////////////////////////////
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
imgprofileListAbon(id,a) {
  return FutureBuilder(
      future: Associnfos(id, "img"),
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

  final uri = Uri.parse("http://$localhost:8080/utilisateur/random/${id}");
  var res = await http.get(uri);

  List<Map<String, dynamic>> utilisateurs = [];

  var jsonData = json.decode(res.body);

  for (var item in jsonData) {
    utilisateurs.add(item);
  }
  return utilisateurs;
}
Future<List<dynamic>> listpub(id,type) async {
  List<dynamic> users = [];
  final uri = Uri.parse('http://$localhost:8080/publication/findbyIdUser/$id/$type');
  var res = await http.get(uri);

  if (res.statusCode == 200) {
    var jsonData = jsonDecode(res.body);
    if (jsonData != null ) {
      users = jsonData;
    }
  }

  return users;
}

//------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<Map<String, dynamic>>> RandomAssoc(id) async {

  final uri = Uri.parse("http://$localhost:8080/association/aleatoire/${id}");
  var res = await http.get(uri);

  List<Map<String, dynamic>> association = [];

  var jsonData = json.decode(res.body);

  for (var item in jsonData) {
    association.add(item);
  }
  return association;
}
//------------------------------------------------------------------------------------------------------------------------------------------------

addReactLike(idUser,idPub,type,CT) async {
  final uri = Uri.parse('http://$localhost:8080/reaction');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode( {
        "idPub": idPub,
        "idUser": idUser,
        "type":  type,
        "compteType" : CT
      }));

}
//-----------------------------------------------------------------------------------------------------------------------------------------------
Future<String> verifReact( idUser,  idPub,CT) async {
  try {
    final uri = Uri.parse(
        'http://$localhost:8080/reaction/findReact/${idUser}/${idPub}');
    var res = await http.get(uri);

    if (res.statusCode == 200  ) {
      var jsonResponse = jsonDecode(res.body);
      var type = jsonResponse['type'];
      var compteType = jsonResponse['compteType'];
      if (type != null) {
        if (type == 'Like' && compteType == CT ) {
          return 'Like';
        } else if (type == 'Dislike' && compteType == CT) {
          return 'Dislike';
        } else {
          return 'Erreur';
        }
      } else {
        return 'Erreur';
      }
    }
  } catch (e) {
    return 'Erreur';
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
deleteReactLike(idUser,idPub)
async {
  final uri = Uri.parse('http://$localhost:8080/reaction/${idUser}/${idPub}');
  var res = await http.delete(uri);
}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<int> getIdREaction(idUser,idPub)
async {

  final uri = Uri.parse('http://$localhost:8080/reaction/findReact/${idUser}/${idPub}');
  var res = await http.get(uri);
  var jsonResponse = jsonDecode(res.body);
  var id = jsonResponse['id'];
  return id;

}
PutReactLike(idR,idUser,idPub,type,CT) async {
  final uri = Uri.parse('http://$localhost:8080/reaction');
  var res = await http.put(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode( {
        "id": idR,
        "idPub": idPub,
        "idUser": idUser,
        "type": type,
        "compteType" : CT
      }));

}
//---------------------------------------------------------------------------------------------------------------------------------------------------
getidR(idUser,idPub) async {
  int idReaction = await getIdREaction(idUser, idPub);
  return  idReaction;
}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<int> CountLike(idPub)async {

    final uri = Uri.parse('http://$localhost:8080/reaction/countLike/${idPub}');
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


      }else{
        return Container(width: 0.0, height: 0.0);
      }
    },
  );

  }
//---------------------------------------------------------------------------------------------------------------------------------------------------


Future<int> CountDislike(idPub)async {

  final uri = Uri.parse('http://$localhost:8080/reaction/countDislike/${idPub}');
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
        return Text('${ snapshot.data}') ;
      }else{
        return Container(width: 0.0, height: 0.0);
      }
    },
  );

}
//---------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> getComments(idPub)async {

  final uri = Uri.parse('http://$localhost:8080/comment/${idPub}');
  var res = await http.get(uri);
  var Comments = jsonDecode(res.body);
  return Comments;

}

//--------------------------------------------------------------------------------------------------------------------------
Invitation(emutteur,destinataire) async{
final uri = Uri.parse('http://$localhost:8080/invitation');
var res = await http.post(uri,
headers: {
'Content-Type': 'application/json'
},
body: jsonEncode( {
  "emetteur": emutteur,
  "destinataire": destinataire
}));

}
//---------------------------------------------------------------------------------------------------------------------------------
Abonnement(idUser,idAssoc) async{
  final uri = Uri.parse('http://$localhost:8080/abonnement');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "idUser": idUser,
        "idAssoc": idAssoc
      }));
}

Future<List<dynamic>> listAbonnement(id) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/abonnement/listeAbonnementV2/${id}');
  var res = await http.get(uri);
  return  Followers = jsonDecode(res.body);
}
Future<List<dynamic>> listAbonnement2(id) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/abonnement/listeAbonnementV1/${id}');
  var res = await http.get(uri);
  return  Followers = jsonDecode(res.body);
}
deleteAbonn(id) async {
  final uri = Uri.parse('http://$localhost:8080/abonnement/${id}');
  var res = await http.delete(uri);
}
//------------------------------------------------------------------------------------------------------------------------------------
Follow(idUser,idAssoc,type) async{
  final uri = Uri.parse('http://$localhost:8080/follow');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "idUser": idUser,
        "idAssoc": idAssoc,
        "type":type
      }));

}
//-----------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> getInvitations(destinataire)async {
  List<dynamic> Invitations;
  final uri = Uri.parse('http://$localhost:8080/invitation/${destinataire}');
  var res = await http.get(uri);

  return Invitations = jsonDecode(res.body);
}
//----------------------------------------------------------------------------------------------------------------------------
DeleteInvit(id) async {
  final uri = Uri.parse('http://$localhost:8080/invitation/${id}');
  var res = await http.delete(uri);
}
//----------------------------------------------------------------------------------------------------------------------------
  addAmis(id , idAmi ) async {
  final uri = Uri.parse('http://$localhost:8080/amis');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(  {
        "idCompte": id,
        "idAmi": idAmi
      }));

}
Future<List<dynamic>> listAmi(id) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://$localhost:8080/amis/chercher/${id}');
  var res = await http.get(uri);
  return  Amis = jsonDecode(res.body);
}
//------------------------------------------------------------------------------------------
Future<List<dynamic>> listFollow(id) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  return  Followers = jsonDecode(res.body);
}

Future listFollowFiltrer(id,filtrage) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  Followers = jsonDecode(res.body);
  Followers.removeWhere((item) => item['type'] == filtrage );
  return Followers ;
}
//----------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>> acceuilUSer(id,type) async {
  List<dynamic> acceuil = [];
  List<dynamic> Amis = await listAmi(id);
  List<dynamic> Abonn = await listAbonnement(id);
  for (int i = 0; i < Amis.length; i++) {
    List<dynamic> pub = await listpub(Amis[i].toString(),type);
    acceuil.addAll(pub);
  }
  for (int k = 0 ; k<Abonn.length ; k++ )
    {
      List<dynamic> pub = await listpub(Abonn[k]['idAssoc'].toString(),"assoc");
      acceuil.addAll(pub);
    }
  return acceuil;
}
Future<List<dynamic>> Acceuil_assoc(id) async {
  List<dynamic> acceuil = [];
  List<int> Followres = [];
  List<String> types = [];
  List<dynamic> Amis = await listFollow(id);
  int k = 0;
  while (k < Amis.length) {
    int idFollow = Amis[k]['idUser'];
    String type = Amis[k]['type'];
    Followres.add(idFollow);
    types.add(type);
    k++;
  }
  for (int i = 0; i < Amis.length; i++) {
    List<dynamic> pub = await listpub(Followres[i].toString(),types[i]);
    acceuil.addAll(pub);
  }
  //acceuil.sort((a, b) => DateTime.parse(b['date_pub']).compareTo(DateTime.parse(a['date_pub'])));
  return acceuil;
}

//----------------------------------------------------------------------------------------------------------------------------
addComments(idPub,idUser,contenu,type) async {
  final uri = Uri.parse('http://$localhost:8080/comment');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
          "idPub": idPub,
          "idUser": idUser,
          "date": DateTime.now().toString().substring(0, 10),
          "contenu": contenu,
          "type":type
      }));
}
//-------------------------------------------------------------------------------------------------------------------------------
UpdateComment(idComment,idPub,idUser,contenu)async
{
  final uri = Uri.parse('http://$localhost:8080/comment');
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
  final uri = Uri.parse('http://$localhost:8080/comment/${idComment}');
  var res = await http.delete(uri);
}
//------------------------------------------------------------------------------------------------------------------------------------
Future<List<dynamic>>listFriend(String id) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://$localhost:8080/amis/${id}');
  var res = await http.get(uri);
  return  Amis = jsonDecode(res.body);
}

Future<bool> VerifIsFriend(int id ,int idCompte) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://$localhost:8080/amis/chercher/${id}');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  return Amis.contains(idCompte);
}

//--------------------------------------------------------------------------------------------------
Future<bool> VerifIsFollow(int id ,int idCompte) async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  bool ok = false;
  int i =-1;
  while (ok == false && i< Amis.length ){
    i++;
    if (Amis[i]['idUser'] == idCompte)
      {
          ok = true;
      }
  }
  return ok;
}

 void deleteFollow(id,idCompte)
async {
  List<dynamic> Amis;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  int ok = 0;
  int i =-1;
  while (ok == 0 && i< Amis.length ){
    i++;
    if (Amis[i]['idUser'] == idCompte)
    {
      ok = Amis[i]['id'];
    }
  }
  final uri2 = Uri.parse('http://$localhost:8080/follow/${ok}');
  var res2 = await http.delete(uri2);
}
//------------------------------------------------------------------------------------------------------------------------------------

Future<List<dynamic>> conversation(id, idAmi,test) async {
  List<dynamic> conversation;
  final uri = Uri.parse('http://$localhost:8080/Conversation/$id/$idAmi');
  var res = await http.get(uri);
  conversation = jsonDecode(res.body);

  conversation.removeWhere((item) => item['typeD'] != test || item['typeE'] != test);

  return conversation;
}

Future<List<dynamic>> conversationAssocUser(id, idAmi) async {
  List<dynamic> conversation;
  final uri = Uri.parse('http://$localhost:8080/Conversation/$id/$idAmi');
  var res = await http.get(uri);
  conversation = jsonDecode(res.body);

  conversation.removeWhere((item) => item['typeD'] == item['typeE'] );
print(conversation);
  return conversation;
}
//------------------------------------------------------------------------------------------------------------------------------------
addMesg(int emetteur,int destinataire,msg,typeE,typeD) async{
  final uri = Uri.parse('http://$localhost:8080/Conversation');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "emetteur": emetteur,
        "destinataire": destinataire,
        "message": msg,
        "date": DateTime.now().toString().substring(0, 10),
        "typeE":typeE,
        "typeD":typeD,
      }));

}

listseroulante(test){
  List<String> items = [
    'Associations culturelles',
    'Associations sportives',
    'Associations professionnelles',
    'Associations de protection des droits',
    'Associations de volontariat',
    'Associations d\'éducation',
    'Associations de santé',
    'Associations politiques',
  ];
  List<String> res=[];
  if (items.contains(test)) {
    items.remove(test);
    res.add(test);
    res.addAll(items);
  }
return res;
}
Future<List<dynamic>> getChallenges(idAssoc) async {
  List<dynamic> challenges = [];
  final uri = Uri.parse('http://$localhost:8080/challenge/findbyIdAssoc/$idAssoc');
  var res = await http.get(uri);

  if (res.statusCode == 200) {
    var jsonData = jsonDecode(res.body);
    if (jsonData != null && jsonData is List<dynamic>) {
      challenges = jsonData;
    }
  }

  return challenges;
}

Future<List<dynamic>> listChallenge(id) async {
  List<dynamic> followers = [];
  List<dynamic> challenges = [];
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  followers = jsonDecode(res.body);
  for (int i = 0; i < followers.length; i++) {
    var type = followers[i]['type'];
    var idAssoc = followers[i]['idUser'];
    if (type == "assoc") {
      List<dynamic> ch = await getChallenges(idAssoc);
      challenges.addAll(ch);
    }
  }
 return challenges;
}

addChallenges(idAssoc,title,descr,img) async{
  final uri = Uri.parse('http://$localhost:8080/challenge');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode( {
        "idAssoc": idAssoc,
        "title": title,
        "descr": descr,
        "img": img,
        "date_challenge":DateTime.now().toString().substring(0, 10)
      }));

}
Future<List<dynamic>> listChallenge_users(id) async {
  List<dynamic> challenges = [];
  List<dynamic> assocs = await listAbonnement(id) ;
  for (int i = 0; i < assocs.length; i++) {
      List<dynamic> ch = await getChallenges(assocs[i]);
      challenges.addAll(ch);

  }
  return challenges;
}
deleteAmi(idAmi,idCompte)
async {
  List<dynamic> Amis = [];
  final uri = Uri.parse('http://$localhost:8080/amis/$idAmi/$idCompte');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  for (int i = 0; i < Amis.length; i++) {

  final uri = Uri.parse('http://$localhost:8080/amis/${Amis[i]['id']}');
  var res = await http.delete(uri);}
  // /print(Amis);
}
getRepCh(idCh) async {
  final uri = Uri.parse('http://$localhost:8080/repch/${idCh}');
  var res = await http.get(uri);
  var reps = jsonDecode(res.body);
  return reps;
}
addRepCh(idCh,idUser,img,type) async {
  final uri = Uri.parse('http://$localhost:8080/repch');
  var res = await http.post(uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "idCh": idCh,
        "idUser": idUser,
        "date":DateTime.now().toString().substring(0, 10),
        "img": img,
        "type": type
      }));
}