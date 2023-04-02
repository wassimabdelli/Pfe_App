TextFormField(
decoration: textInputDecoration.copyWith(
labelText: "First Name",
prefix: Icon(
Icons.account_circle_sharp,
color: Colors.indigo,
)),
validator: (value) {
if (value.isEmpty) {
return 'please type your first name!!';
}
},
onSaved: (value) => _ctrfname.text = value,
),