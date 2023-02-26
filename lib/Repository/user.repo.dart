import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rv_firebase/Model/users.dart';


Future addUser (Users u) async{
  final docUser = FirebaseFirestore.instance.collection("users").doc();
  u.id = docUser.id;
  await docUser.set(u.toJson());
}
//-------------------------------
Future updateUser(Users user) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  await docUser.update(user.toJson());


}
//-------------------------------
Future deleteUser(String id) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(id);
  await docUser.delete();
}


Future get(Users user) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);}