import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class InfosAssoc extends StatefulWidget {
  const InfosAssoc({Key key}) : super(key: key);

  @override
  State<InfosAssoc> createState() => _InfosAssocState();
}

class _InfosAssocState extends State<InfosAssoc> {
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Informations Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          imgprofileAssoc0(id,75.0),
          SizedBox(height: 10.0),
          FutureBuilder<List<dynamic>>(
            future: Future.wait([
              Associnfos(id, 'name'),
              Associnfos(id, 'email'),
              Associnfos(id, 'numtel'),
              Associnfos(id, 'categorie'),
              Associnfos(id, 'dateFondation')
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String name = snapshot.data[0].toString();
                String email = snapshot.data[1].toString();
                String numtel = snapshot.data[2].toString();
                String categorie = snapshot.data[3].toString();
                String date=  snapshot.data[4].toString();
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.account_circle_sharp,
                            color: appbarBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.email,
                            color: appbarBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Text(
                          "Phone",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$numtel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.phone_android,
                            color: appbarBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Founding date",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: appbarBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$categorie',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.domain,
                            color: appbarBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(this.context,
                                '/setting_assoc',
                                arguments: id);
                          },
                          child: Text('change profil'),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(170, 40),
                            primary: appbarBackgroundColor,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ]
    )
        ) ,
      ),
    );
  }
}
