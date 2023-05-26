import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class setting_assoc extends StatefulWidget {
  const setting_assoc({Key key}) : super(key: key);

  @override
  State<setting_assoc> createState() => _setting_assocState();
}

class _setting_assocState extends State<setting_assoc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String id;
  String name = '';
  String p = '';
  String category = '';
  String email = '';
  int numtel ;
  DateTime datee ;
  TextEditingController _ctrname;
  TextEditingController _ctremail;
  TextEditingController _ctrdate;
  TextEditingController _ctrnumtel;
  TextEditingController _ctrmdp;
  PickedFile _imgFile;
  String img ="" ;
  final ImagePicker _Picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _ctrname = TextEditingController();
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


      Associnfos(id, 'name').then((value) {
        setState(() {
          name = value;
          _ctrname.text = name;
        });
      });


      Associnfos(id, 'categorie').then((value) {
        setState(() {
          category = value;
        });
      });
      Associnfos(id, 'dateFondation').then((value) {
        setState(() {
          datee = DateTime.parse(value);
          _ctrdate.text = value;
        });
      });
      Associnfos(id, 'img').then((value) {
        setState(() {
          img = value;
        });
      });
      Associnfos(id, 'numtel').then((value) {
        setState(() {
          numtel = value;
          _ctrnumtel.text = value.toString();
        });
      });
      Associnfos(id, 'email').then((value) {
        setState(() {
          email = value;
          _ctremail.text = email ;
        });
      });
    });

  }
  Widget build(BuildContext context) {
    List<String> result;
    result = listseroulante(category);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarBackgroundColor,
        title: Text('Let\'s change your informations '),
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
                  controller: _ctrname,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Name",
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
                      name = value;
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
                        color: appbarBackgroundColor,
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

                    Text('Category :'),
                    SizedBox(
                      width: 15,
                    ),
                    DropdownButton(
                      elevation: 0,
                      items:result
                          .map((e) =>
                          DropdownMenuItem(
                            child: Text('$e'),
                            value: e,
                          )).toList(),
                      onChanged: (val) {
                        setState(() {
                          category = val.toString();
                        });
                      },
                      value: category,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // upload(_imgFile,email,'users');
                    putAssoc();
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
              ]
          )
          )
        ),
      ),
    );
  }
  void putAssoc() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if ( _imgFile != null )
        {
          var img = await upload(_imgFile, email,'Association');
          upload(_imgFile,email,'Association');
          print('ici');
        }
      final uri = Uri.parse('http://$localhost:8080/association');
      var res = await http.post(uri, headers: {'Content-Type': 'application/json'},

          body:  jsonEncode( {
            "id": id,
            "name": name,
            "email": email,
            "password": p,
            "numtel": numtel,
            "categorie": category,
            "img": img,
            "dateFondation":  _ctrdate.text
          })

      );
    }
    Navigator.pushNamed(this.context,
        '/InfosAssoc',
        arguments: id);
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
}
