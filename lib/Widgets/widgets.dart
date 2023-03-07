import 'package:flutter/material.dart';
import 'package:rv_firebase/screens/organizations/Register_org.dart';
import 'package:rv_firebase/screens/users/home_users.dart';
import 'package:rv_firebase/screens/users/register.dart';
import 'package:image_picker/image_picker.dart';
import 'contants.dart';
const textInputDecoration= InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo,width: 2),
        ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 2),
         ),
    errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFee7b64),width: 2),
         ),
);



void nextScreen(context,page){
  Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
void alertRegister(page)
{
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          page, MaterialPageRoute(builder: (context) => Home()));
    },
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: kBackgroundColor,
    title: Text("registration"),
    content: Text("your registration is successfully validated."),
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
void alertPrincipal(thispage)
{
  Widget okUsers = TextButton(
    child: Text("Users"),
    onPressed: () {
      Navigator.push(
          thispage, MaterialPageRoute(builder: (context) => Register()));
    },
  );
  Widget okOrg = TextButton(
    child: Text("Organisation"),
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

  // show the dialog
  showDialog(
    context: thispage,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*bouttonimage(page)
{
  return Container(
    color: kBackgroundColor,
    height: 110.0,
    width: MediaQuery.of(page).size.width,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children:<Widget>[
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
          children:<Widget> [
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: (){
                takephoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: (){
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

PickedFile _imgFile;
final ImagePicker _Picker = ImagePicker();
void takephoto(ImageSource source) async {
  final pickedFile = await _Picker.getImage(source: source);
  setState()
  {
    _imgFile = pickedFile ;
  }
}
 Widget imageProfile(page){
  return Center(
    child: Stack(children: <Widget> [
    CircleAvatar(
      radius: 80.0,
      backgroundImage: AssetImage("assets/avatar.png"),
    ),
      Positioned(
        bottom: 20.0,
        right: 20.0,
        child: InkWell(
          onTap:(){
            showModalBottomSheet(
              backgroundColor: kBackgroundColor,
                context: page,
                builder: ( (builder) => bouttonimage(page) )
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
}*/