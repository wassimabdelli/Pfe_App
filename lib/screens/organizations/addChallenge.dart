import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'dart:io';
class AddChallenge extends StatefulWidget {
  const AddChallenge({Key key}) : super(key: key);

  @override
  State<AddChallenge> createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title, _descr;
  String img ;
  PickedFile _imgFile;
  final ImagePicker _Picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 0.0,
        title: Text(
          'Let\'s add a challenge',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:SingleChildScrollView(
        child:Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    Center(child: Image.asset("assets/trophy.png",width: 150,height: 150,)),
      SizedBox(
        height: 30
      ),
      TextFormField(
        decoration: textInputDecoration.copyWith(
            labelText: "Title",
            prefix: Icon(
              Icons.title,
              color: Colors.indigo,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'please enter a title!!';
          }
        },
        onSaved: (value) => _title = value,
      ),
      SizedBox(
          height: 30
      ),
      TextFormField(
        decoration: textInputDecoration.copyWith(
            labelText: "Description",
            prefix: Icon(
              Icons.description,
              color: Colors.indigo,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'please enter a Description!!';
          }
        },
        onSaved: (value) => _descr = value,
      ),
      IconButton(
        icon: Icon(Icons.photo_library),
        color: appbarBackgroundColor,
        onPressed: () async {
          showModalBottomSheet(
              backgroundColor: kBackgroundColor,
              context: context,
              builder: ((builder) => bouttonimage(context))
          );
        },
      ),
      SizedBox(
          height: 30
      ),
      FutureBuilder(
        builder: (context, snapshot) {
          if (_imgFile != null ) {
            return Image(
              width: 160.0,
              height: 200.0,
              fit: BoxFit.cover,
              image: _imgFile == null
                  ? AssetImage("assets/avatar.png")
                  : FileImage(File(_imgFile.path)),
            );
          }
          return Container(width: 0.0, height: 0.0);
        },
      ),
      ElevatedButton(
        onPressed:() async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          var e = userinfos(id, 'email');
          if (_imgFile!= null) {
            img = await upload(_imgFile, e.toString(), "Association");
            uploadImgPub(_imgFile, e.toString(), "Association");
          }else{
            img="";
          }
          addChallenges(id,_title,_descr,img);
          Navigator.pushNamed(
              context,'/MyChallenges',
              arguments:'$id;$id'
          );
        }


        } ,
        child: Text('Share the Challenge'),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(170, 40),
          primary:appbarBackgroundColor,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      SizedBox(
          height: 30
      ),

    ]
    )
        ) ,
      ) ,
      )
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
