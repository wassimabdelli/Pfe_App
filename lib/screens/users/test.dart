import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rv_firebase/Widgets/contants.dart';
import 'package:rv_firebase/Widgets/widgets.dart';

class test extends StatefulWidget {
  const test({Key key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('press') ,
          onPressed: () async {
            var test = await listpub2('1');
            print('${test}');

          },
        )
      ),

      );
  }
}
/*
TextFormField(
                                                    decoration: textInputDecoration.copyWith(
                                                      hintText: 'Add an comment here...',
                                                    ),
                                                    maxLines: 3,
                                                    onChanged: (value) {
                                                      MyComment = value;
                                                    },
                                                  ),
                                                  SizedBox(height: 30),
 */