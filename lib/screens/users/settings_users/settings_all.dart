import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class settings_all extends StatefulWidget {
  const settings_all({Key key}) : super(key: key);

  @override
  State<settings_all> createState() => _settings_allState();
}

class _settings_allState extends State<settings_all> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String id;
  String firstName = '';
  String lastName = '';
  String p = '';
  String gender = '';
  String email = '';
  int numtel ;
  DateTime datee ;
  TextEditingController _ctrfname;
  TextEditingController _ctremail;
  TextEditingController _ctrlname;
  TextEditingController _ctrdate;
  TextEditingController _ctrnumtel;
  TextEditingController _ctrmdp;
  PickedFile _imgFile;
  String img ="" ;
  final ImagePicker _Picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _ctrfname = TextEditingController();
    _ctrlname = TextEditingController();
    _ctrdate = TextEditingController();
    _ctremail = TextEditingController();
    _ctrnumtel =  TextEditingController();
    _ctrmdp = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      id = ModalRoute.of(context).settings.arguments;

      userinfos(id, 'password').then((value) {
        setState(() {
          p = value;
          _ctrmdp.text = p;
        });
      });


      userinfos(id, 'firstName').then((value) {
        setState(() {
          firstName = value;
          _ctrfname.text = firstName;
        });
      });

      userinfos(id, 'lastName').then((value) {
        setState(() {
          lastName = value;
          _ctrlname.text = lastName;
        });
      });

      userinfos(id, 'sexe').then((value) {
        setState(() {
          gender = value;
        });
      });
      userinfos(id, 'dnaissance').then((value) {
        setState(() {
          datee = DateTime.parse(value);
          _ctrdate.text = value;
        });
      });
      userinfos(id, 'img').then((value) {
        setState(() {
          img = value;
        });
      });
      userinfos(id, 'numtel').then((value) {
        setState(() {
          numtel = value;
          _ctrnumtel.text = value.toString();
        });
      });
      userinfos(id, 'email').then((value) {
        setState(() {
          email = value;
          _ctremail.text = email ;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarBackgroundColor,
        title: Text('Let\'s change your informations'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text(
                    '⛔ This form represents your informations, try to modify it then validate it',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                imageProfile(context,img),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _ctrfname,
                  decoration: textInputDecoration.copyWith(
                    labelText: "First Name",
                    prefix: Icon(
                      Icons.account_circle_sharp,
                      color: appbarBackgroundColor,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your first name!!';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _ctrlname,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Last Name",
                    prefix: Icon(
                      Icons.account_circle_sharp,
                      color: appbarBackgroundColor,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your last name!!';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _ctremail,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefix: Icon(
                      Icons.email,
                      color: appbarBackgroundColor,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your email !!';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),

                TextFormField(
                  controller: _ctrdate,
                  decoration: textInputDecoration.copyWith(
                      labelText: "enter date",
                      prefix: Icon(
                        Icons.calendar_today,
                        color: Colors.indigo,
                      )),
                  readOnly: true,
                  onTap: () async {
                    DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: datee = DateTime.parse(_ctrdate.text),
                        firstDate: DateTime(
                            1950),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      print(pickedDate);
                      DateTime formattedDate = new DateTime(
                          pickedDate.year, pickedDate.month, pickedDate.day);

                      setState(() {
                        _ctrdate.text = DateFormat('yyyy-MM-dd').format(
                            formattedDate);

                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _ctrnumtel,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Phone Number",
                    prefix: Icon(
                      Icons.account_circle_sharp,
                      color: appbarBackgroundColor,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your phone number !!';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      numtel =int.parse(value) ;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text('Sexe'),

                    DropdownButton(
                      elevation: 0,
                      items: ['male', 'female']
                          .map((e) =>
                          DropdownMenuItem(
                            child: Text('$e'),
                            value: e,
                          )).toList(),
                      onChanged: (val) {
                        setState(() {
                          gender = val.toString();
                        });
                      },
                      value: gender,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // upload(_imgFile,email,'users');
                    putUser();
                  },
                  child: Text('Validate'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(170, 40),
                    primary:appbarBackgroundColor ,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget imageProfile(page,img) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage:  _imgFile == null
              ? NetworkImage(img)
              : FileImage(File(_imgFile.path)),
          //NetworkImage(img),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: kBackgroundColor,
                  context: page,
                  builder: ((builder) => bouttonimage(page))
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        )
      ],),
    );
  }

  bouttonimage(page) {
    return Container(
        color: kBackgroundColor,
        height: 110.0,
        width: MediaQuery
            .of(page)
            .size
            .width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text("Choose profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  label: Text("Camera"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  label: Text("gallery"),
                ),
              ],
            ),
          ],
        )
    );
  }

  void takephoto(ImageSource source) async {
    final pickedFile = await _Picker.getImage(source: source);
    setState(() {
      _imgFile = pickedFile;
    });
  }
  void putUser() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String loc ='users';
      var img = await upload(_imgFile, email,loc);
      upload(_imgFile,email,loc);
      final uri = Uri.parse('http://$localhost:8080/utilisateur');
      var res = await http.post(uri, headers: {'Content-Type': 'application/json'},

          body:  jsonEncode( {
            "id": 1,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": p,
            "active": true,
            "numtel": numtel ,
            "sexe": "male",
            "img": img,
            "dnaissance": _ctrdate.text
          })

      );
    }
  }
}