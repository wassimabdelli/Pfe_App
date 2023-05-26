import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';
import 'package:rv_firebase/screens/users/register.dart';
import 'package:http/http.dart' as http;
class Login_assoc extends StatefulWidget {
  const Login_assoc({Key key}) : super(key: key);

  @override
  State<Login_assoc> createState() => _Login_assocState();
}

class _Login_assocState extends State<Login_assoc> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 5,
        title: Text('Association space',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Holistic Winter ",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                const Text(
                  "Login now to see what they are talking !",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Image.asset("assets/login.png"),
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
                  decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefix: Icon(
                        Icons.person,
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
                 onPressed: (){ sign();},
                  child: Text('Sign in'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(170, 40),
                    primary: appbarBackgroundColor,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                      text: "Don't have an acount ?",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Register here",
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const Register());
                              }
                        ),
                      ],
                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void sign() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    //  var test =  hashPassword(_password);
      final uri = Uri.parse(
          'http://$localhost:8080/association/login/$_email/$_password');
      var res = await http.get(uri);
      if (res.statusCode == 500)
      {
        var text = 'verify adress';
        alertLogin(context,text);
      }else if (res.contentLength < 1){
        var text = 'verify password';
        alertLogin(context,text);
      }else {

        var UID = res.body;
       Navigator.pushNamed(context, '/home_assoc',arguments: UID);


      }
    }
  }
  void alertLogin(page,text)
  {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        if (text == 'verify adress')
        {
          Navigator.of(context).pop();
        }
        else if (text == 'verify password'){
          Navigator.of(context).pop();
        }else {

          print ("ok");
        }

      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: kBackgroundColor,
      title: Row(
        children: [
          Icon(Icons.sms_failed_outlined, color: Colors.redAccent), // icône d'arrêt
          SizedBox(width: 10), // espace entre l'icône et le texte
          Text("Sign In"), // texte du titre
        ],
      ),
      content: Text(text),
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
}
