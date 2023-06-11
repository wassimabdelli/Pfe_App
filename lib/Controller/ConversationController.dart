import 'dart:convert';

import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:http/http.dart' as http;


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