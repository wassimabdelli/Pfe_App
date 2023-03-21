import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class settings_name extends StatefulWidget {
  const settings_name({Key key}) : super(key: key);

  @override
  State<settings_name> createState() => _settings_nameState();
}

class _settings_nameState extends State<settings_name> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String id = ModalRoute.of(context).settings.arguments;
    TextEditingController _ctrfname = TextEditingController();

    user_info(id, 'fname').then((value) {
      _ctrfname.text = value;
    });
    final _ctrlname = TextEditingController();
    user_info(id, 'lname').then((value) {
      _ctrlname.text = value;
    });
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarBackgroundColor,
        title: Text('Let\'s change your Name'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget> [
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text('⛔ This form represents your first and last name, try to modify it then validate it'),

                ),
                SizedBox(
                  height: 30,
                ),
                   TextFormField(
                    controller: _ctrfname,
                    decoration: textInputDecoration.copyWith(
                        labelText: "First Name",
                        prefix: Icon(
                          Icons.account_circle_sharp,
                          color: appbarBackgroundColor,
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please type your first name!!';
                      }
                    },
                    onSaved: (value) => _ctrfname.text = value,
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
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please type your last name!!';
                    }
                  },
                  onSaved: (value) => _ctrfname.text = value,
                ), SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: (){
                    settingsname(_ctrfname, _ctrlname, id);
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

}
