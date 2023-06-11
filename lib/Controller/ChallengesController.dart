import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:rv_firebase/Widgets/widgets.dart';

import 'FollowController.dart';

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
getAleaChallenges() async {
  final uri = Uri.parse('http://$localhost:8080/challenge/randomCh');
  var res = await http.get(uri);
  var AleaCh = jsonDecode(res.body);
  return AleaCh;
}