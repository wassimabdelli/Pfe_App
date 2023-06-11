import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
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
    child: Text("Association"),
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



