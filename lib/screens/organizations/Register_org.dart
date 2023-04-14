import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'dart:io';
import '../login.dart';

class Register_org extends StatefulWidget {
  const Register_org({Key key}) : super(key: key);

  @override
  State<Register_org> createState() => _Register_orgState();
}

class _Register_orgState extends State<Register_org> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  PickedFile _imgFile;
  final ImagePicker _Picker = ImagePicker();
  final _ctrname = TextEditingController();
  final _ctrdate = TextEditingController();
  final _ctr = TextEditingController();
  String categorie = 'select your categorie';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0.0,
        title: Text(
          'Organization space',
          style: TextStyle(color: Colors.black),
        ),
      ),
    body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
         child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Holistic Winter ",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Create your account now to chat and explore",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            Image.asset("assets/login.png"),
            imageProfile(context),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: "First Name",
                  prefix: Icon(
                    Icons.account_circle_sharp,
                    color: Colors.indigo,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'please type the name of your organization!!';
                }
              },
              onSaved: (value) => _ctrname.text = value,
            ),

            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefix: Icon(
                    Icons.email,
                    color: Colors.indigo,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'please type an email!!';
                }
              },
              onSaved: (value) => _email = value,
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        1940),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  print(pickedDate);
                  DateTime formattedDate = new DateTime(
                      pickedDate.year, pickedDate.month, pickedDate.day);
                  print(formattedDate);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Text('SEXE'),

                DropdownButton(
                  elevation: 0,
                  items: ['select your categorie','cat1', 'cat2']
                      .map((e) =>
                      DropdownMenuItem(
                        child: Text('$e'),
                        value: e,
                      )).toList(),
                  onChanged: (val) {
                    setState(() {
                      categorie = val.toString();
                    });
                  },
                  value: categorie,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: "Password",
                  prefix: Icon(
                    Icons.lock,
                    color: Colors.indigo,
                  )),
              validator: (value) {
                if (value.length < 6) {
                  return 'your password needs to be atleast 6 characters';
                }
              },
              onSaved: (value) => _password = value,
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: signup,
              child: Text('Sign up'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(170, 40),
                primary: Colors.indigo,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(TextSpan(
              text: "you already have an account ?",
              style: TextStyle(fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: "Log in here",
                    style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        nextScreen(context, const Login());
                      }),
              ],
            )),
          ],
        ),

    ),
    ),
    ),

    );
  }
  void signup() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        final currentUSER = FirebaseAuth.instance.currentUser;

        final UID = currentUSER.uid; // id user
        final docUser = FirebaseFirestore.instance.collection('organisation').doc(UID);
        final json = {
          'name': _ctrname.text,
          'date': _ctrdate.text,
          'categorie': categorie,
        };
        await docUser.set(json);
        String loc = 'organisations';
        upload(_imgFile,UID,loc);
        //alertRegister(this.context,UID);


      } catch (e) {
        print(e);
      }
    }
  }
  Widget imageProfile(page) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imgFile == null
              ? AssetImage("assets/avatar.png")
              : FileImage(File(_imgFile.path)),
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
}

