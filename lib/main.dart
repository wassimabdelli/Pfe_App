import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/screens/login.dart';
import 'package:rv_firebase/screens/organizations/Challenges.dart';
import 'package:rv_firebase/screens/organizations/ChatWithAssoc.dart';
import 'package:rv_firebase/screens/organizations/ChatWithUser.dart';
import 'package:rv_firebase/screens/organizations/Login_Assoc.dart';
import 'package:rv_firebase/screens/organizations/MyChallenges.dart';
import 'package:rv_firebase/screens/organizations/Setting_assoc/ListFollowers.dart';
import 'package:rv_firebase/screens/organizations/Setting_assoc/Setting_assoc.dart';
import 'package:rv_firebase/screens/organizations/Setting_assoc/infos_assoc.dart';
import 'package:rv_firebase/screens/organizations/addChallenge.dart';
import 'package:rv_firebase/screens/organizations/home_assoc.dart';
import 'package:rv_firebase/screens/organizations/profile_assoc.dart';
import 'package:rv_firebase/screens/principal.dart';
import 'package:rv_firebase/screens/users/ListeChallenges.dart';
import 'package:rv_firebase/screens/users/Messages.dart';
import 'package:rv_firebase/screens/users/MsgWithAssoc.dart';
import 'package:rv_firebase/screens/users/UserDetailsProfile.dart';
import 'package:rv_firebase/screens/users/home_users.dart';
import 'package:rv_firebase/screens/users/profile_users.dart';
import 'package:rv_firebase/screens/users/settings_users/ListAssoc.dart';
import 'package:rv_firebase/screens/users/settings_users/ListFriend.dart';
import 'package:rv_firebase/screens/users/settings_users/MyInvitations.dart';
import 'package:rv_firebase/screens/users/settings_users/SettingAcount.dart';
import 'package:rv_firebase/screens/users/settings_users/settings_all.dart';
import 'package:rv_firebase/screens/users/test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Principal':(context) =>Principal(),
        // Route interface user
        '/home':(context) => Home(),
        '/profile_user':(context) => Profile_user(),
        '/settings_user_profile': (context) => settings_all(),
        '/home_users': (context) => Home(),
        '/Detail_profil': (context) => UserDetaisProfile(),
        'login' : (context) => Login(),
        '/invitatios': (context) => Invitations(),
        '/SettingAcount': (context) => SettingAcount(),
        '/ListFriend': (context) => ListFriend(),
        '/ListAssoc': (context) => ListAssoc(),
        '/Messages': (context) => Messages(),
        '/MsgWithAssoc': (context) => MsgWithAssoc(),
        '/ListChallenges':(context) => ListChallenges(),
        //Route interface Association
        '/Login_assoc':(context) => Login_assoc(),
        '/home_assoc':(context) => Home_assoc(),
        '/ChatWithAssoc':(context) =>ChatWithAssoc(),
        '/ChatWithUser':(context) =>ChatWithUser(),
        '/profile_assoc':(context) => Profile_assoc(),
        '/InfosAssoc':(context) => InfosAssoc(),
        '/setting_assoc':(context) => setting_assoc(),
        '/Challenges':(context) => Challenges(),
        '/MyChallenges': (context) => MyChallenges(),
        '/addChallenge':(context) => AddChallenge(),
        '/ListFollowers':(context) => ListFollwers(),
      },
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}
