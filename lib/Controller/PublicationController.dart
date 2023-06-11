import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:path/path.dart';
import 'AmisController.dart';
import 'FollowController.dart';

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

getAleaPubs() async {
  final uri = Uri.parse('http://$localhost:8080/publication/randomPubs');
  var res = await http.get(uri);
  var AleaPubs = jsonDecode(res.body);
  return AleaPubs;
}

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