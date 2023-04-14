import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class test extends StatefulWidget {
  const test({Key key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    String pub;
    return Scaffold(
      body:
      Column(
        children: [
          ElevatedButton(
            onPressed: () async {

              final uri = Uri.parse('http://192.168.1.12:8080/publication/findbyIdUser/10');
              DateTime today = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(today);
              var res = await http.get(uri);
              List<dynamic> users = jsonDecode(res.body);
              print(users[0]['contenu']);
            //  for (var user in users) {
                // Do something with each user object, e.g. print the user's name

            //  }
            },
            child: Text('test'),
          ),
        ],
      )


         ) ;



  }
 Future signup() async {
   final uri = Uri.parse('http://192.168.1.12:8080/utilisateur');
   var res = await http.get(uri);
   print(res.body);

    /*
    final uri = Uri.parse('http://192.168.1.12:8080/utilisateur');
 var res = await http.post(uri, headers: {'Content-Type': 'application/json'},
   body:  jsonEncode({
     "firstName": "flutter",
     "lastName": "flutter",
     "email": "user@gmail.com",
     "password": "user123",
     "active": true,
     "numtel": 264,
     "dnaissance": "2023-04-11",
     "amis": null
   })

 );
 print(res.body);
*/


    }
  }

