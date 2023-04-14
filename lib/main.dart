import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/screens/login.dart';
import 'package:rv_firebase/screens/principal.dart';
import 'package:rv_firebase/screens/users/UserDetailsProfile.dart';
import 'package:rv_firebase/screens/users/home_users.dart';
import 'package:rv_firebase/screens/users/profile_users.dart';
import 'package:rv_firebase/screens/users/settings_users/settings_all.dart';
import 'package:rv_firebase/screens/users/test.dart';
import 'package:rv_firebase/test.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home':(context) => Home(),
        '/profile_user':(context) => Profile_user(),
        '/settings_user_profile': (context) => settings_all(),
        '/home_users': (context) => Home(),
        '/Detail_profil': (context) => UserDetaisProfile(),
        'login' : (context) => Login(),
      },
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}
