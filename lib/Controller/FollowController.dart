import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rv_firebase/Widgets/widgets.dart';

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
//-------------------------------------------------------------------
Future<List<dynamic>> listFollow(id) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  return  Followers = jsonDecode(res.body);
}
//-------------------------------------------------------------------
Future listFollowFiltrer(id,filtrage) async {
  List<dynamic> Followers;
  final uri = Uri.parse('http://$localhost:8080/follow/listFollow/${id}');
  var res = await http.get(uri);
  Followers = jsonDecode(res.body);
  Followers.removeWhere((item) => item['type'] == filtrage );
  return Followers ;
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