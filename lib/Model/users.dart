import 'dart:ffi';

class Users {
  String id;
  String fname;


  Users({
    this.id = '',
    this.fname,


  });
//----------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,

    };
  }
  //----------------------------------------------------
factory Users.fromJson(Map<String,dynamic> json){
    return Users(
        id: json['id'],
        fname:json['fname']


    );
}
}
