import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String gender = 'female';
  TextEditingController _ctrfname;
  TextEditingController _ctrlname;

  @override
  void initState() {
    super.initState();
    _ctrfname = TextEditingController();
    _ctrlname = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      id = ModalRoute.of(context).settings.arguments;

      user_info(id, 'fname').then((value) {
        setState(() {
          firstName = value;
          _ctrfname.text = firstName;
        });
      });

      user_info(id, 'lname').then((value) {
        setState(() {
          lastName = value;
          _ctrlname.text = lastName;
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
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text(
                    '⛔ This form represents your first and last name, try to modify it then validate it',
                  ),
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
                DropdownButton<String>(
                  value: gender,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  items: <String>['male', 'female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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