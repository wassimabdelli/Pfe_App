import 'dart:convert';

import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:http/http.dart' as http;
Future<List<dynamic>> getInvitations(destinataire)async {
  List<dynamic> Invitations;
  final uri = Uri.parse('http://$localhost:8080/invitation/${destinataire}');
  var res = await http.get(uri);

  return Invitations = jsonDecode(res.body);
}
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
deleteAmi(idAmi,idCompte)
async {
  List<dynamic> Amis = [];
  final uri = Uri.parse('http://$localhost:8080/amis/$idAmi/$idCompte');
  var res = await http.get(uri);
  Amis = jsonDecode(res.body);
  for (int i = 0; i < Amis.length; i++) {

    final uri = Uri.parse('http://$localhost:8080/amis/${Amis[i]['id']}');
    var res = await http.delete(uri);}

}